/* Header file for Error and Logging functions
 *
 * Purpose: Keep error handling activity
 *          to one line in programs.
 *
 * Note: To be included after all standard
 *       system header files.
 *
 */

#ifndef __MY_ERROR_HANDLERS_H
#define __MY_ERROR_HANDLERS_H

#define MAXLINE 4096

void err_dump(const char *, ...);
void err_msg(const char *, ...);
void err_quit(const char *, ...);
void err_ret(const char *, ...);
void err_sys(const char *, ...);

#endif /* __MYERROR_HANDLERS_H  */
