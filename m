From: Robert Yang <liezhi.yang@windriver.com>
Subject: Re: [PATCH 2/2] debugfs.c: do sparse copy when src is a sparse file
Date: Fri, 26 Jul 2013 18:18:59 +0800
Message-ID: <51F24D13.6030402@windriver.com>
References: <1374200257-2873-1-git-send-email-liezhi.yang@windriver.com> <1374200257-2873-3-git-send-email-liezhi.yang@windriver.com> <20130719185515.GC5785@blackbox.djwong.org> <51EB4994.3050703@windriver.com> <20130722173031.GE5785@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <tytso@mit.edu>, <dvhart@linux.intel.com>,
	<linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:60609 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab3GZKT1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Jul 2013 06:19:27 -0400
In-Reply-To: <20130722173031.GE5785@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Darrick,

Thank you very much, I've pulled in most of your suggestions, the V2 is
coming, please see my comments in line, and please feel free to give
your comments.

On 07/23/2013 01:30 AM, Darrick J. Wong wrote:
> On Sun, Jul 21, 2013 at 10:38:12AM +0800, Robert Yang wrote:
>>
>>>> @@ -1594,14 +1607,30 @@ static errcode_t copy_file(int fd, ext2_ino_t newfile)
>>>>   			goto fail;
>>>>   		}
>>>>   		ptr = buf;
>>>> +		cp = ptr;
>>>> +		count = got;
>>>>   		while (got > 0) {
>>>> -			retval = ext2fs_file_write(e2_file, ptr,
>>>> -						   got, &written);
>>>> -			if (retval)
>>>> -				goto fail;
>>>> -
>>>> -			got -= written;
>>>> -			ptr += written;
>>>> +			if (make_holes) {
>>>> +				/* Check whether all is zero */
>>>> +				while (count-- && *cp++ == 0)
>>>> +					continue;
>
> I suspect that calloc()ing a zero buffer and calling memcmp() would be faster
> than a byte-for-byte comparison.
>
>>>> +				if (count < 0) {
>>>> +					 /* The whole block is zero, make a hole */
>>>> +					retval = ext2fs_file_lseek(e2_file, got, EXT2_SEEK_CUR, NULL);
>>>> +					if (retval)
>>>> +						goto fail;
>>>> +					got = 0;
>
> I think the entire make_holes clause could be lifted out of the inner while and
> placed in the outer while, since the is-zero-buffer test depends only on the
> input.
>
> You could use FIEMAP/FIBMAP or SEEK_DATA or something to efficiently walk the
> allocated regions of the incoming file.  If they're available...
>

It seems that the "ioctl(fd, FIBMAP, &b)" requires the root privileges, so I
didn't use it, others are fixed.

>>>> +				}
>>>> +			}
>>>> +			/* Normal copy */
>>>> +			if (got > 0) {
>
> Then you don't need the test here.
>
>>>> +				*zero_written = 0;
>>>> +				retval = ext2fs_file_write(e2_file, ptr, got, &written);
>>>> +				if (retval)
>>>> +					goto fail;
>>>> +				got -= written;
>>>> +				ptr += written;
>>>> +			}
>>>>   		}
>>>>   	}
>>>>   	retval = ext2fs_file_close(e2_file);
>>>> @@ -1620,6 +1649,9 @@ void do_write(int argc, char *argv[])
>>>>   	ext2_ino_t	newfile;
>>>>   	errcode_t	retval;
>>>>   	struct ext2_inode inode;
>>>> +	int		bufsize = IO_BUFSIZE;
>>>> +	int		make_holes = 0;
>>>> +	int 		zero_written = 1;
>>>>
>>>>   	if (common_args_process(argc, argv, 3, 3, "write",
>>>>   				"<native file> <new file>", CHECK_FS_RW))
>>>> @@ -1684,9 +1716,27 @@ void do_write(int argc, char *argv[])
>>>>   		return;
>>>>   	}
>>>>   	if (LINUX_S_ISREG(inode.i_mode)) {
>>>> -		retval = copy_file(fd, newfile);
>>>> +		if (statbuf.st_blocks < statbuf.st_size / S_BLKSIZE) {
>
> Well, that's one way to detect a sparse file coming in -- but do we care about
> the case of copying in a non-sparse file that contains a lot of zero regions?
>

I think that we need to care about whether it is a sparse file or not:
1) We need to use the statbuf.st_blksize as the buffer size to check
    whether the entire block is full of holes, and for the non-sparse
    file, statbuf.st_blksize (usually 512B) is too small to be the buffer.

2) For performance reason, we need to avoid checking whether it is a sparse
    file or not in copy_file() if we know that it is not a sparse file.

// Robert

> Maybe we could add a flag to the 'write' command to force make_holes=1?
>
> (Or just figure it out ourselves via fiemap as suggested above.)
>
>>>> +			make_holes = 1;
>>>> +			/*
>>>> +			 * Use I/O blocksize as buffer size when
>>>> +			 * copying sparse files.
>>>> +			 */
>>>> +			bufsize = statbuf.st_blksize;
>>>> +		}
>>>> +		retval = copy_file(fd, newfile, bufsize, make_holes, &zero_written);
>>>>   		if (retval)
>>>>   			com_err("copy_file", retval, 0);
>>>> +
>>>> +		if ((inode.i_flags & EXT4_EXTENTS_FL) && zero_written) {
>>>> +			/*
>>>> +			 * If no data is copied which indicateds that no write
>>>> +			 * happens, we need to turn off the EXT4_EXTENTS_FL.
>
> I don't think removing the extents flag is necessary; "touch /mnt/emptyfile"
> creates an empty flag with the extents flag set.
>
> --D
>>>> +			 */
>>>> +			inode.i_flags &= ~EXT4_EXTENTS_FL;
>>>> +			if (debugfs_write_inode(newfile, &inode, argv[0]))
>>>> +				close(fd);
>>>> +		}
>>>>   	}
>>>>   	close(fd);
>>>>   }
>>>> --
>>>> 1.8.1.2
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
