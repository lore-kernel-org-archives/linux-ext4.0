From: Robert Yang <liezhi.yang@windriver.com>
Subject: Re: [PATCH 2/2] debugfs.c: do sparse copy when src is a sparse file
Date: Mon, 29 Jul 2013 15:11:45 +0800
Message-ID: <51F615B1.2010204@windriver.com>
References: <1374834657-17091-1-git-send-email-liezhi.yang@windriver.com> <1374834657-17091-3-git-send-email-liezhi.yang@windriver.com> <20130726160254.GA6033@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>,
	<dvhart@linux.intel.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:63724 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab3G2HMP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Jul 2013 03:12:15 -0400
In-Reply-To: <20130726160254.GA6033@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 07/27/2013 12:02 AM, Darrick J. Wong wrote:
> On Fri, Jul 26, 2013 at 06:30:57PM +0800, Robert Yang wrote:
>> Let debugfs do sparse copy when src is a sparse file, just like
>> "cp --sparse=auto"
>>
>> * For the:
>>    #define IO_BUFSIZE 64*1024
>>    this is a suggested value from gnu coreutils:
>>    http://git.savannah.gnu.org/gitweb/?p=coreutils.git;a=blob;f=src/ioblksize.h;h=1ae93255e7d0ccf0855208c7ae5888209997bf16;hb=HEAD
>>
>> * Use malloc() to allocate memory for the buffer since put 64K (or
>>    more) on the stack seems not a good idea.
>>
>> Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
>> Acked-by: Darren Hart <dvhart@linux.intel.com>
>> ---
>>   debugfs/debugfs.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
>>   1 file changed, 53 insertions(+), 5 deletions(-)
>>
>> diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
>> index b77d0b5..0379f38 100644
>> --- a/debugfs/debugfs.c
>> +++ b/debugfs/debugfs.c
>> @@ -37,6 +37,16 @@ extern char *optarg;
>>   #include "../version.h"
>>   #include "jfs_user.h"
>>
>> +/* 64KiB is the minimium blksize to best minimize system call overhead. */
>> +#ifndef IO_BUFSIZE
>> +#define IO_BUFSIZE 64*1024
>> +#endif
>> +
>> +/* Block size for `st_blocks' */
>> +#ifndef S_BLKSIZE
>> +#define S_BLKSIZE 512
>> +#endif
>> +
>>   ss_request_table *extra_cmds;
>>   const char *debug_prog_name;
>>   int sci_idx;
>> @@ -1571,22 +1581,28 @@ void do_find_free_inode(int argc, char *argv[])
>>   }
>>
>>   #ifndef READ_ONLY
>> -static errcode_t copy_file(int fd, ext2_ino_t newfile)
>> +static errcode_t copy_file(int fd, ext2_ino_t newfile, int bufsize, int make_holes)
>>   {
>>   	ext2_file_t	e2_file;
>>   	errcode_t	retval;
>>   	int		got;
>>   	unsigned int	written;
>> -	char		buf[8192];
>> +	char		*buf;
>>   	char		*ptr;
>> +	char		*zeromem;
>> +	int		cmp;
>>
>>   	retval = ext2fs_file_open(current_fs, newfile,
>>   				  EXT2_FILE_WRITE, &e2_file);
>>   	if (retval)
>>   		return retval;
>>
>> +	if (!(buf = (char *) malloc(bufsize))){
>> +		fprintf(stderr, "copy_file: can't allocate buffer\n");
>> +		return;
>> +	}
>>   	while (1) {
>> -		got = read(fd, buf, sizeof(buf));
>> +		got = read(fd, buf, bufsize);
>>   		if (got == 0)
>>   			break;
>>   		if (got < 0) {
>> @@ -1594,20 +1610,42 @@ static errcode_t copy_file(int fd, ext2_ino_t newfile)
>>   			goto fail;
>>   		}
>>   		ptr = buf;
>> +
>> +		/* Sparse copy */
>> +		if (make_holes) {
>> +			if (!(zeromem = (char *) calloc(got, 1))) {
>
> Maybe ext2fs_get_memzero()?  And I suspect you can allocate a bufsize-sized
> zeromem outside the while loop.  Chances are pretty good that if make_holes,
> then buf_size won't be greater than 4096 anyway.

Thanks, sounds great, my testing shows that it is faster for copying the
large sparse file after move the ext2fs_get_memzero() out of the while loop,
and didn't have any obvious impaction for non-sparse file, I will update it
and send a V3.

// Robert

>
> --D
>
>> +				fprintf(stderr, "copy_file: can't allocate buffer\n");
>> +				return;
>> +			}
>> +			/* Check whether all is zero */
>> +			cmp = memcmp(ptr, zeromem, got);
>> +			/* Free it as early as possible */
>> +			free(zeromem);
>> +			if (cmp == 0) {
>> +				 /* The whole block is zero, make a hole */
>> +				retval = ext2fs_file_lseek(e2_file, got, EXT2_SEEK_CUR, NULL);
>> +				if (retval)
>> +					goto fail;
>> +				got = 0;
>> +			}
>> +		}
>> +
>> +		/* Normal copy */
>>   		while (got > 0) {
>>   			retval = ext2fs_file_write(e2_file, ptr,
>>   						   got, &written);
>>   			if (retval)
>>   				goto fail;
>> -
>>   			got -= written;
>>   			ptr += written;
>>   		}
>>   	}
>> +	free(buf);
>>   	retval = ext2fs_file_close(e2_file);
>>   	return retval;
>>
>>   fail:
>> +	free(buf);
>>   	(void) ext2fs_file_close(e2_file);
>>   	return retval;
>>   }
>> @@ -1620,6 +1658,8 @@ void do_write(int argc, char *argv[])
>>   	ext2_ino_t	newfile;
>>   	errcode_t	retval;
>>   	struct ext2_inode inode;
>> +	int		bufsize = IO_BUFSIZE;
>> +	int		make_holes = 0;
>>
>>   	if (common_args_process(argc, argv, 3, 3, "write",
>>   				"<native file> <new file>", CHECK_FS_RW))
>> @@ -1684,7 +1724,15 @@ void do_write(int argc, char *argv[])
>>   		return;
>>   	}
>>   	if (LINUX_S_ISREG(inode.i_mode)) {
>> -		retval = copy_file(fd, newfile);
>> +		if (statbuf.st_blocks < statbuf.st_size / S_BLKSIZE) {
>> +			make_holes = 1;
>> +			/*
>> +			 * Use I/O blocksize as buffer size when
>> +			 * copying sparse files.
>> +			 */
>> +			bufsize = statbuf.st_blksize;
>> +		}
>> +		retval = copy_file(fd, newfile, bufsize, make_holes);
>>   		if (retval)
>>   			com_err("copy_file", retval, 0);
>>   	}
>> --
>> 1.8.1.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
