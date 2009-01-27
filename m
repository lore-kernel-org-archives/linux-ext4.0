From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: ext 4 online defragment bug report+patch
Date: Tue, 27 Jan 2009 17:32:45 +0900
Message-ID: <497EC6AD.9050604@rs.jp.nec.com>
References: <497E6389.40302@simpson.demon.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Duncan Simpson <dps@simpson.demon.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:65292 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbZA0Idb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2009 03:33:31 -0500
In-Reply-To: <497E6389.40302@simpson.demon.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Duncan,

Thanks for looking at the e4defrag.

Duncan Simpson wrote:
> The version of the ext 4 defragment command linked to by wikipedia has a
> serious bug: it opens named pipes and sockets even when somebody is not
> listening to them.
> 
> This causes blocking the until the defragment process is killed. It never
> gets to the code which discovers the object is not a regular file and
> should not be defragemented. The patch below fixes this by checking that 
> the
> object is a regular file *before* openning it, thereby avoiding the 
> problem.

You are right, open for non support file is waste and harmful.
But the e4defrag has already checked the target file type
before open it in the main function as follows.

int main(int argc, char *argv[])
{
<snip>
                 if (lstat64(argv[i], &buf) < 0) {
                         perror(NGMSG_FILE_INFO);
                         PRINT_FILE_NAME(argv[i]);
                         continue;
                 }

                 /* Only regular file is acceptalbe with force defrag mode */
                 if (force_flag && !S_ISREG(buf.st_mode)) {
                         printf("Inappropriate file type\n");
                         goto out;
                 }

                 if (S_ISBLK(buf.st_mode)) {
                         /* Block device */
                         if (get_mount_point(argv[i], dir_name, PATH_MAX)
                                                         == RETURN_NG)
                                 continue;
                         arg_type = DEVNAME;
                         printf("ext4 defragmentation for device(%s)\n",
                                 argv[i]);
                 } else if (S_ISDIR(buf.st_mode)) {
                         /* Directory */
                         if (access(argv[i], R_OK) < 0) {
                                 perror(argv[i]);
                                 continue;
                         }
                         arg_type = DIRNAME;
                         strcpy(dir_name, argv[i]);
                 } else if (S_ISREG(buf.st_mode)) {
                         /* Regular file */
                         arg_type = FILENAME;
*               } else {
*                       /* Irregular file */
*                       PRINT_ERR_MSG(NGMSG_FILE_UNREG);
*                       PRINT_FILE_NAME(argv[i]);
*                       continue;
                 }

<snip>

Te above "else" handles non support files (e.g. socket and pipe) correctly.
Therefore e4defrag will print error message and skip them without file open.

Thanks,
Akira Fujita


> You may want to leave the check after the object has been opened in place
> to avoid problems due to race conditions.
> 
> Duncan (-:
> 
> --- e4defrag.c.dist     2009-01-27 01:19:07.605937764 +0000
> +++ e4defrag.c  2009-01-27 01:18:32.505937083 +0000
> @@ -631,6 +633,16 @@
>                 return FTW_CONT;
>         }
> 
> +       /* Openning a pipe or socket can block, so bypass non-regular files
> +        * before openning them. */
> +       if (S_ISREG(buf->st_mode)==0) {
> +               if (detail_flag) {
> +                       PRINT_FILE_NAME(file);
> +                       IN_FTW_PRINT_ERR_MSG(NGMSG_FILE_UNREG);
> +               }
> +               goto out;
> +       }
> +
>         fd = open64(file, O_RDONLY);
>         if (fd < 0) {
>                 if (detail_flag) {
> 


