From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: Re: e2fsprogs-1.41.0 - error opening fs with badblocks.
Date: Tue, 2 Sep 2008 18:18:46 +0530
Message-ID: <ea11fea30809020548s45fccd4ena4a93a237b74d623@mail.gmail.com>
References: <ea11fea30809020508i6b6ad758x207959471e289a0a@mail.gmail.com>
	 <20080902123050.GN13069@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.184]:30701 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbYIBMss (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Sep 2008 08:48:48 -0400
Received: by ti-out-0910.google.com with SMTP id b6so1384437tic.23
        for <linux-ext4@vger.kernel.org>; Tue, 02 Sep 2008 05:48:46 -0700 (PDT)
In-Reply-To: <20080902123050.GN13069@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 2, 2008 at 6:00 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Tue, Sep 02, 2008 at 05:38:25PM +0530, Manish Katiyar wrote:
>>
>> I have created a test ext4 FS of 2.3GB. While running badblocks on it,
>> I get the below error.
>>
>> /home/mkatiyar/e2fs-git/e2fsprogs_work/sbin> ./badblocks myfs
>> ./badblocks: Value too large for defined data type while trying to open myfs
>>
>> /home/mkatiyar/e2fs-git/e2fsprogs_work/sbin> ls -lh myfs
>> -rw-r--r-- 1 mkatiyar mkatiyar 2.3G 2008-09-02 10:13 myfs
>>
>> This is due to open returning EOVERFLOW , but as per man page it
>> should happen if the size of the file cannot be represented correctly
>> in off_t which I don't think
>> is the case here.
>
> That's the problem, actually.  off_t is a signed type (it has to be,
> because lseek needs to be able to represent negative offsets), so if
> you open files greater than 2GB, you have to use the Large File
> Support ABI extensions (also known as LFS)[1].  Specifically, this
> means you have to either open the file using open64(), or if you use
> open, you need to pass in the O_LARGEFILE flag.
>
> [1] http://www.suse.de/~aj/linux_lfs.html
>
> Linux doesn't enforce this for block devices (only files), and no one
> I know has ever tried to run badblocks on a local file (since there's
> generally not much point), and so that's why you're the first person
> to report this.
>
> The attached patch should address your problem (although I'm not sure
> why you would want to run badblocks on a normal file.  :-)

Thanks a lot Ted ... its just due to lack of resources :-) that I have
to do my testing on local files


Thanks -
Manish


>
>                                         - Ted
>
> commit 22301afb01f3059a2b1baf68abff26aaf6db7c9e
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Tue Sep 2 08:29:20 2008 -0400
>
>    badblocks: Open the device with O_LARGEFILE
>
>    Linux doesn't enforce the Large File Support API requirements on block
>    devices, but in case someone wants to run badblocks on a normal file,
>    open the device file with O_LARGEFILE.
>
>    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>
> diff --git a/misc/badblocks.c b/misc/badblocks.c
> index 6261cbe..1d0f95a 100644
> --- a/misc/badblocks.c
> +++ b/misc/badblocks.c
> @@ -31,6 +31,10 @@
>
>  #define _GNU_SOURCE /* for O_DIRECT */
>
> +#ifndef O_LARGEFILE
> +#define O_LARGEFILE 0
> +#endif
> +
>  #include <errno.h>
>  #include <fcntl.h>
>  #ifdef HAVE_GETOPT_H
> @@ -933,7 +937,7 @@ int main (int argc, char ** argv)
>        unsigned int (*test_func)(int, blk_t,
>                                  int, blk_t,
>                                  unsigned int);
> -       int open_flag = 0;
> +       int open_flag;
>        long sysval;
>
>        setbuf(stdout, NULL);
> @@ -1096,7 +1100,7 @@ int main (int argc, char ** argv)
>        if (w_flag)
>                check_mount(device_name);
>
> -       open_flag = w_flag ? O_RDWR : O_RDONLY;
> +       open_flag = O_LARGEFILE | (w_flag ? O_RDWR : O_RDONLY);
>        dev = open (device_name, open_flag);
>        if (dev == -1) {
>                com_err (program_name, errno, _("while trying to open %s"),
>
>
