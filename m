From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH] e2fsprogs: Fix the overflow in e4defrag with 2GB over
 file
Date: Fri, 17 Dec 2010 17:35:07 +0900
Message-ID: <4D0B20BB.4070808@rs.jp.nec.com>
References: <4BB19BBB.9010509@rs.jp.nec.com> <20101217041348.GG4455@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:63944 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab0LQIfb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Dec 2010 03:35:31 -0500
In-Reply-To: <20101217041348.GG4455@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

(2010/12/17 13:13), Ted Ts'o wrote:
> On Tue, Mar 30, 2010 at 03:35:39PM +0900, Akira Fujita wrote:
>> e2fsprogs: Fix the overflow in e4defrag with 2GB over file
>>
>> From: Akira Fujita<a-fujita@rs.jp.nec.com>
>>
>> In e4defrag, we use locally defined posix_fallocate interface.
>> And its "offset" and "len" are defined as off_t (long) type,
>> their upper limit is 2GB -1 byte.
>> Thus if we run e4defrag to the file whose size is 2GB over,
>> the overflow occurs at calling fallocate syscall.
>>
>> To fix this issue, I add new define _FILE_OFFSET_BITS 64 to use
>> 64bit offset for filesystem related syscalls in e4defrag.c.
>> (Also this patch includes open mode fix which has been
>> released but not been merged e2fsprogs git tree yet.
>> http://lists.openwall.net/linux-ext4/2010/01/19/3)
> 
> My apologies for the delay in looking at this patch.  The following is
> a much smaller patch which fixes the problem, without having to use
> the _FILE_OFFSET_BITS 64 kludge.  I've checked this into e2fsprogs.
> 
> 							- Ted

Thank you for your work.
I almost forgot my patch, time flies. :)

Regards,
Akira Fujita


> commit 30c0529d27edca148a6e5e52bcdd7b38d6cb28b2
> Author: Theodore Ts'o<tytso@mit.edu>
> Date:   Thu Dec 16 22:53:34 2010 -0500
> 
>      e4defrag: Fix the overflow in e4defrag with>  2GB files
> 
>      The fallocate() interface on 32-bit machines is defined to use off_t,
>      not loff_t (even though the system call interface is 64-bit clean).
>      This causes e4defrag to fail on files greater than 2GB.  Fix this by
>      trying to use fallocate64(), and using the hard-coded syscall if it
>      does not exist.
> 
>      Signed-off-by: "Theodore Ts'o"<tytso@mit.edu>
> 
> diff --git a/configure b/configure
> index 14d9652..2f5515a 100755
> --- a/configure
> +++ b/configure
> @@ -10699,7 +10699,7 @@ if test "$ac_res" != no; then :
>   fi
> 
>   fi
> -for ac_func in chflags getrusage llseek lseek64 open64 fstat64 ftruncate64 getmntinfo strtoull strcasecmp srandom jrand48 fchown mallinfo fdatasync strnlen strptime strdup sysconf pathconf posix_memalign memalign valloc __secure_getenv prctl mmap utime setresuid setresgid usleep nanosleep getdtablesize getrlimit sync_file_range posix_fadvise fallocate blkid_probe_get_topology mbstowcs
> +for ac_func in chflags getrusage llseek lseek64 open64 fstat64 ftruncate64 getmntinfo strtoull strcasecmp srandom jrand48 fchown mallinfo fdatasync strnlen strptime strdup sysconf pathconf posix_memalign memalign valloc __secure_getenv prctl mmap utime setresuid setresgid usleep nanosleep getdtablesize getrlimit sync_file_range posix_fadvise fallocate fallocate64 blkid_probe_get_topology mbstowcs
>   do :
>     as_ac_var=`$as_echo "ac_cv_func_$ac_func" | $as_tr_sh`
>   ac_fn_c_check_func "$LINENO" "$ac_func" "$as_ac_var"
> diff --git a/configure.in b/configure.in
> index 5e67688..f9fffc1 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -853,7 +853,7 @@ if test -n "$BLKID_CMT"; then
>     AC_SEARCH_LIBS([blkid_probe_all], [blkid])
>   fi
>   dnl
> -AC_CHECK_FUNCS(chflags getrusage llseek lseek64 open64 fstat64 ftruncate64 getmntinfo strtoull strcasecmp srandom jrand48 fchown mallinfo fdatasync strnlen strptime strdup sysconf pathconf posix_memalign memalign valloc __secure_getenv prctl mmap utime setresuid setresgid usleep nanosleep getdtablesize getrlimit sync_file_range posix_fadvise fallocate blkid_probe_get_topology mbstowcs)
> +AC_CHECK_FUNCS(chflags getrusage llseek lseek64 open64 fstat64 ftruncate64 getmntinfo strtoull strcasecmp srandom jrand48 fchown mallinfo fdatasync strnlen strptime strdup sysconf pathconf posix_memalign memalign valloc __secure_getenv prctl mmap utime setresuid setresgid usleep nanosleep getdtablesize getrlimit sync_file_range posix_fadvise fallocate fallocate64 blkid_probe_get_topology mbstowcs)
>   dnl
>   dnl Check to see if -lsocket is required (solaris) to make something
>   dnl that uses socket() to compile; this is needed for the UUID library
> diff --git a/misc/e4defrag.c b/misc/e4defrag.c
> index 83625fc..e795987 100644
> --- a/misc/e4defrag.c
> +++ b/misc/e4defrag.c
> @@ -327,7 +327,7 @@ int sync_file_range(int fd, loff_t offset, loff_t length, unsigned int flag)
>   }
>   #endif /* ! HAVE_SYNC_FILE_RANGE */
> 
> -#ifndef HAVE_FALLOCATE
> +#ifndef HAVE_FALLOCATE64
>   #warning Using locally defined fallocate syscall interface.
> 
>   #ifndef __NR_fallocate
> @@ -335,14 +335,14 @@ int sync_file_range(int fd, loff_t offset, loff_t length, unsigned int flag)
>   #endif
> 
>   /*
> - * fallocate() -	Manipulate file space.
> + * fallocate64() -	Manipulate file space.
>    *
>    * @fd:			defrag target file's descriptor.
>    * @mode:		process flag.
>    * @offset:		file offset.
>    * @len:		file size.
>    */
> -static int fallocate(int fd, int mode, loff_t offset, loff_t len)
> +static int fallocate64(int fd, int mode, loff_t offset, loff_t len)
>   {
>   	return syscall(__NR_fallocate, fd, mode, offset, len);
>   }
> @@ -1738,7 +1738,7 @@ static int file_defrag(const char *file, const struct stat64 *buf,
>   	/* Allocate space for donor inode */
>   	orig_group_tmp = orig_group_head;
>   	do {
> -		ret = fallocate(donor_fd, 0,
> +		ret = fallocate64(donor_fd, 0,
>   		  (loff_t)orig_group_tmp->start->data.logical * block_size,
>   		  (loff_t)orig_group_tmp->len * block_size);
>   		if (ret<  0) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Akira Fujita <a-fujita@rs.jp.nec.com>

The First Fundamental Software Development Group,
Software Development Division,
NEC Software Tohoku, Ltd.

