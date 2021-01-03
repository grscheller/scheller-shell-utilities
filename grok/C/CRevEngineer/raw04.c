/*
 * raw04.c
 *
 * Disable raw mode at exit.
 *
 */

#include <stdlib.h>
#include <termios.h>
#include <unistd.h>

struct termios orig_termios;

void disableRawMode()
{
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &orig_termios);
}

void enableRawMode()
{
    tcgetattr(STDIN_FILENO, &orig_termios);
    atexit(disableRawMode);

    struct termios raw = orig_termios;
    raw.c_lflag &= ~(ECHO);
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw);
}

int main()
{
    enableRawMode();

    char c;
    while (read(STDIN_FILENO, &c, 1) == 1 && c != 'q');
    return 0;
}

/* This program will accept input until the user presses
 * either ^C or ^D or types the character 'q'.
 *
 * The second argument to tcsetattr specifies when to apply
 * changes to the terminal.  TCSAFLUSH causes the changes
 * to occurs after all output has been written to stdout.
 * All input that has been received but not read will be
 * discarded before the change is made.
 *
 * The shell no longer receives any unread output because
 * of TCSAFLUSH in the tcsetattr function in disableRawMode
 * callback registered via the stddef atexit function.
 *
 * See:  man -s3 termios
 *
 */
