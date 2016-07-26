#include <stdio.h>
#include <fcntl.h>
#include <errno.h>
#include <termios.h>
#include <unistd.h>

    unsigned char data_out[8] = {0xaa, 0x01, 0x80, 0x02, 0x01, 0x00, 0x00, 0x00};
    unsigned char data_in[8] = {0, 0, 0, 0, 0, 0, 0, 0};
    unsigned char byte_in;
    unsigned char crc;
    int i, fd;


int set_interface_attribs (int fd, int speed, int parity)
{
    struct termios tty;

    memset (&tty, 0, sizeof tty);
    if (tcgetattr (fd, &tty) != 0)
    {
            printf("error %d from tcgetattr", errno);
            return -1;
    }

    cfsetospeed (&tty, speed);
    cfsetispeed (&tty, speed);

    tty.c_cflag = (tty.c_cflag & ~CSIZE) | CS8;     // 8-bit chars
    // disable IGNBRK for mismatched speed tests; otherwise receive break
    // as \000 chars
    tty.c_iflag &= ~IGNBRK;         // disable break processing
    tty.c_lflag = 0;                // no signaling chars, no echo,
                                    // no canonical processing
    tty.c_oflag = 0;                // no remapping, no delays
    tty.c_cc[VMIN]  = 0;            // read doesn't block
    tty.c_cc[VTIME] = 5;            // 0.5 seconds read timeout

    tty.c_iflag &= ~(IXON | IXOFF | IXANY); // shut off xon/xoff ctrl

    tty.c_cflag |= (CLOCAL | CREAD);// ignore modem controls,
                                    // enable reading
    tty.c_cflag &= ~(PARENB | PARODD);      // shut off parity
    tty.c_cflag |= parity;
    tty.c_cflag &= ~CSTOPB;
    tty.c_cflag &= ~CRTSCTS;

    if (tcsetattr (fd, TCSANOW, &tty) != 0)
    {
        printf("error %d from tcsetattr", errno);
        return -1;
    }
    return 0;
}

void set_blocking (int fd, int should_block)
{
    struct termios tty;
    memset (&tty, 0, sizeof tty);
    if (tcgetattr (fd, &tty) != 0)
    {
        printf("error %d from tggetattr", errno);
        return;
    }

    tty.c_cc[VMIN]  = should_block ? 1 : 0;
    tty.c_cc[VTIME] = 5;            // 0.5 seconds read timeout

    if (tcsetattr (fd, TCSANOW, &tty) != 0)
        printf("error %d setting term attributes", errno);
}

void capture()
{

    usleep(1000);

    // Capture entire frame
    for (i = 0; i < 8; ++i) {
        read (fd, &byte_in, 1);  // read up to 100 characters if ready to read
        data_in[i] = byte_in & 0xff;
    }

    // Display result

    // First display the hex values
    for (i = 0; i < 8; ++i) {
        printf("0x%02X ", data_in[i]);
    }
    printf("    ");
    // Now display the ASCII (if applicable)
    for (i = 0; i < 8; ++i) {
        if (data_in[i] >= 32 && data_in[i] <= 126) {
            printf("%c", data_in[i]);
        } else {
            printf(".");
        }
    }
    printf("\n");

}

void calc_crc()
{
    crc = data_out[0] + data_out[1] + data_out[2] + data_out[3] + data_out[4] + data_out[5] + data_out[6];
    crc = ~crc + 1;
    data_out[7] = crc;

    printf("crc is 0x%02X\n", crc);
}

int main(int argc, char *argv[])
{
    fd = open (argv[1], O_RDWR | O_NOCTTY | O_SYNC);
    printf("Using %s\n", argv[1]);
    if (fd < 0)
    {
        printf("error %d opening %s: %s", errno, argv[1], strerror (errno));
        return;
    }

    set_interface_attribs (fd, B9600, 0);  // set speed to 9,600 bps, 8n1 (no parity)
    set_blocking (fd, 1);

    calc_crc();
    write (fd, data_out, 8);
}

