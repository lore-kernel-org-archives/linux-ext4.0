From: Robert Yang <liezhi.yang@windriver.com>
Subject: Re: [PATCH 2/3 V4] debugfs.c: do sparse copy when src is a sparse
 file
Date: Tue, 15 Oct 2013 12:52:38 +0800
Message-ID: <525CCA16.3010804@windriver.com>
References: <1377498124-25842-1-git-send-email-liezhi.yang@windriver.com> <1377498124-25842-3-git-send-email-liezhi.yang@windriver.com> <20131015031020.GZ6860@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>,
	<dvhart@linux.intel.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:62937 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3JOEwv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Oct 2013 00:52:51 -0400
In-Reply-To: <20131015031020.GZ6860@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 10/15/2013 11:10 AM, Darrick J. Wong wrote:
> On Mon, Aug 26, 2013 at 02:22:03PM +0800, Robert Yang wrote:
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
>>   debugfs/debugfs.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++----
>>   1 file changed, 58 insertions(+), 4 deletions(-)
>>
>> diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
>> index a6bc932..8c32eff 100644
>> --- a/debugfs/debugfs.c
>> +++ b/debugfs/debugfs.c
>> @@ -41,6 +41,16 @@ extern char *optarg;
>>   #define BUFSIZ 8192
>>   #endif
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
>> @@ -1575,22 +1585,37 @@ void do_find_free_inode(int argc, char *argv[])
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
>> +	char		*zero_buf;
>> +	int		cmp;
>>
>>   	retval = ext2fs_file_open(current_fs, newfile,
>>   				  EXT2_FILE_WRITE, &e2_file);
>>   	if (retval)
>>   		return retval;
>>
>> +	if (!(buf = (char *) malloc(bufsize))){
>> +		com_err("copy_file", errno, "can't allocate buffer\n");
>> +		return;
>> +	}
>
> Ugh.  I probably could have whined about this not using ext2fs_get_mem, but
> more importantly clang whines about the undefined return value.
>

Thanks, Darrick:-)

// Robert

> I'll fix it and send out a patch with my next patchbomb.
>
> --D
>> +
>> +	/* This is used for checking whether the whole block is zero */
>> +	retval = ext2fs_get_memzero(bufsize, &zero_buf);
>> +	if (retval) {
>> +		com_err("copy_file", retval, "can't allocate buffer\n");
>> +		free(buf);
>> +		return retval;
>> +	}
>> +
>>   	while (1) {
>> -		got = read(fd, buf, sizeof(buf));
>> +		got = read(fd, buf, bufsize);
>>   		if (got == 0)
>>   			break;
>>   		if (got < 0) {
>> @@ -1598,6 +1623,21 @@ static errcode_t copy_file(int fd, ext2_ino_t newfile)
>>   			goto fail;
>>   		}
>>   		ptr = buf;
>> +
>> +		/* Sparse copy */
>> +		if (make_holes) {
>> +			/* Check whether all is zero */
>> +			cmp = memcmp(ptr, zero_buf, got);
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
>> @@ -1608,10 +1648,14 @@ static errcode_t copy_file(int fd, ext2_ino_t newfile)
>>   			ptr += written;
>>   		}
>>   	}
>> +	free(buf);
>> +	ext2fs_free_mem(&zero_buf);
>>   	retval = ext2fs_file_close(e2_file);
>>   	return retval;
>>
>>   fail:
>> +	free(buf);
>> +	ext2fs_free_mem(&zero_buf);
>>   	(void) ext2fs_file_close(e2_file);
>>   	return retval;
>>   }
>> @@ -1624,6 +1668,8 @@ void do_write(int argc, char *argv[])
>>   	ext2_ino_t	newfile;
>>   	errcode_t	retval;
>>   	struct ext2_inode inode;
>> +	int		bufsize = IO_BUFSIZE;
>> +	int		make_holes = 0;
>>
>>   	if (common_args_process(argc, argv, 3, 3, "write",
>>   				"<native file> <new file>", CHECK_FS_RW))
>> @@ -1699,7 +1745,15 @@ void do_write(int argc, char *argv[])
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
