From: Robert Yang <liezhi.yang@windriver.com>
Subject: Re: [PATCH 2/2] debugfs.c: do sparse copy when src is a sparse file
Date: Tue, 23 Jul 2013 17:44:09 +0800
Message-ID: <51EE5069.6050003@windriver.com>
References: <1374200257-2873-1-git-send-email-liezhi.yang@windriver.com> <1374200257-2873-3-git-send-email-liezhi.yang@windriver.com> <20130719185515.GC5785@blackbox.djwong.org> <51EB4994.3050703@windriver.com> <20130722173031.GE5785@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <tytso@mit.edu>, <dvhart@linux.intel.com>,
	<linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:42528 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab3GWJog (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Jul 2013 05:44:36 -0400
In-Reply-To: <20130722173031.GE5785@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi Darrick,

Thank you very much for your very detailed review, I will fix them
one by one and send a V2 sooner.

// Robert


On 07/23/2013 01:30 AM, Darrick J. Wong wrote:
> On Sun, Jul 21, 2013 at 10:38:12AM +0800, Robert Yang wrote:
>>
>> Hi Darrick,
>>
>> Thanks for your reply, it seems that 64K is a good idea since put 128K
>> on the stack might cause problems, I will wait for one or two days for
>> more comments on other parts of the patches, then send a V2 with the
>> updates.
>
> Well in that case I'll review harder. :)
>
> (Actually I thought of a few more things this morning.)
>
>>
>> // Robert
>>
>>
>> On 07/20/2013 02:55 AM, Darrick J. Wong wrote:
>>> On Fri, Jul 19, 2013 at 10:17:37AM +0800, Robert Yang wrote:
>>>> Let debugfs do sparse copy when src is a sparse file, just like
>>>> "cp --sparse=auto"
>>>>
>>>> * For the
>>>>    #define IO_BUFSIZE 32*1024
>>>>
>>>>    This is from coreutils-8.13/src/ioblksize.h (GPL V3):
>>>> /* As of Mar 2009, 32KiB is determined to be the minimium
>>>>     blksize to best minimize system call overhead.
>>>>     This can be tested with this script with the results
>>>>     shown for a 1.7GHz pentium-m with 2GB of 400MHz DDR2 RAM:
>>>
>>> Um.... GNU updated this to 64K a couple of years ago:
>>> http://git.savannah.gnu.org/gitweb/?p=coreutils.git;a=blob;f=src/ioblksize.h;h=1ae93255e7d0ccf0855208c7ae5888209997bf16;hb=HEAD
>>>
>>> Just for laughs I tried it on a T430 with an i5-3320M and 16G of DDR3-1600 RAM:
>>>
>>>     1024=3.7 GB/s
>>>     2048=7.1 GB/s
>>>     4096=8.8 GB/s
>>>     8192=14.9 GB/s
>>>    16384=14.3 GB/s
>>>    32768=13.4 GB/s
>>>    65536=15.8 GB/s
>>>   131072=20.7 GB/s
>>>   262144=16.4 GB/s
>>>   524288=15.9 GB/s
>>> 1048576=15.8 GB/s
>>> 2097152=15.1 GB/s
>>> 4194304=11.7 GB/s
>>> 8388608=9.9 GB/s
>>> 16777216=9.4 GB/s
>>> 33554432=9.3 GB/s
>>> 67108864=9.3 GB/s
>>> 134217728=8.8 GB/s
>>>
>>> For that matter, a 2010-era i7-950/DDR3-1066 system showed this:
>>>
>>>     1024=3.4 GB/s
>>>     2048=5.6 GB/s
>>>     4096=7.8 GB/s
>>>     8192=9.5 GB/s
>>>    16384=10.8 GB/s
>>>    32768=11.4 GB/s
>>>    65536=11.6 GB/s
>>>   131072=12.2 GB/s
>>>   262144=11.9 GB/s
>>>   524288=12.3 GB/s
>>> 1048576=12.4 GB/s
>>> 2097152=12.5 GB/s
>>> 4194304=12.5 GB/s
>>> 8388608=10.3 GB/s
>>> 16777216=8.0 GB/s
>>> 33554432=7.6 GB/s
>>> 67108864=7.8 GB/s
>>> 134217728=7.5 GB/s
>>>
>>> And for good measure, a cruddy old T2300 Core Duo from 2006 spat out this:
>>>
>>>     1024=1.1 GB/s
>>>     2048=2.1 GB/s
>>>     4096=3.6 GB/s
>>>     8192=5.0 GB/s
>>>    16384=6.3 GB/s
>>>    32768=6.5 GB/s
>>>    65536=6.6 GB/s
>>>   131072=7.0 GB/s
>>>   262144=7.1 GB/s
>>>   524288=7.1 GB/s
>>> 1048576=6.8 GB/s
>>> 2097152=4.4 GB/s
>>> 4194304=2.3 GB/s
>>> 8388608=2.0 GB/s
>>> 16777216=2.0 GB/s
>>> 33554432=2.0 GB/s
>>> 67108864=2.0 GB/s
>>> 134217728=1.9 GB/s
>>>
>>> I suspect you could increase the buffer size to 128K (or possibly even BLKRAGET
>>> size?) without much of a problem...
>>>
>>>>
>>>>     for i in $(seq 0 10); do
>>>>       size=$((8*1024**3)) #ensure this is big enough
>>>>       bs=$((1024*2**$i))
>>>>       printf "%7s=" $bs
>>>>       dd bs=$bs if=/dev/zero of=/dev/null count=$(($size/$bs)) 2>&1 |
>>>>       sed -n 's/.* \([0-9.]* [GM]B\/s\)/\1/p'
>>>>     done
>>>>
>>>>        1024=734 MB/s
>>>>        2048=1.3 GB/s
>>>>        4096=2.4 GB/s
>>>>        8192=3.5 GB/s
>>>>       16384=3.9 GB/s
>>>>       32768=5.2 GB/s
>>>>       65536=5.3 GB/s
>>>>      131072=5.5 GB/s
>>>>      262144=5.7 GB/s
>>>>      524288=5.7 GB/s
>>>>     1048576=5.8 GB/s
>>>>
>>>>     Note that this is to minimize system call overhead.
>>>>     Other values may be appropriate to minimize file system
>>>>     or disk overhead.  For example on my current GNU/Linux system
>>>>     the readahead setting is 128KiB which was read using:
>>>>
>>>>     file="."
>>>>     device=$(df -P --local "$file" | tail -n1 | cut -d' ' -f1)
>>>>     echo $(( $(blockdev --getra $device) * 512 ))
>>>>
>>>>     However there isn't a portable way to get the above.
>>>>     In the future we could use the above method if available
>>>>     and default to io_blksize() if not.
>>>>   */
>>>> enum { IO_BUFSIZE = 32*1024 };
>>>>
>>>> Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
>>>> Acked-by: Darren Hart <dvhart@linux.intel.com>
>>>> ---
>>>>   debugfs/debugfs.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++--------
>>>>   1 file changed, 60 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
>>>> index b77d0b5..e443703 100644
>>>> --- a/debugfs/debugfs.c
>>>> +++ b/debugfs/debugfs.c
>>>> @@ -37,6 +37,16 @@ extern char *optarg;
>>>>   #include "../version.h"
>>>>   #include "jfs_user.h"
>>>>
>>>> +/* 32KiB is the minimium blksize to best minimize system call overhead. */
>>>> +#ifndef IO_BUFSIZE
>>>> +#define IO_BUFSIZE 32*1024
>>>> +#endif
>>>> +
>>>> +/* Block size for `st_blocks' */
>>>> +#ifndef S_BLKSIZE
>>>> +#define S_BLKSIZE 512
>>>> +#endif
>>>> +
>>>>   ss_request_table *extra_cmds;
>>>>   const char *debug_prog_name;
>>>>   int sci_idx;
>>>> @@ -1571,14 +1581,17 @@ void do_find_free_inode(int argc, char *argv[])
>>>>   }
>>>>
>>>>   #ifndef READ_ONLY
>>>> -static errcode_t copy_file(int fd, ext2_ino_t newfile)
>>>> +static errcode_t copy_file(int fd, ext2_ino_t newfile, int bufsize,
>>>> +			int make_holes, int *zero_written)
>>>>   {
>>>>   	ext2_file_t	e2_file;
>>>>   	errcode_t	retval;
>>>>   	int		got;
>>>>   	unsigned int	written;
>>>> -	char		buf[8192];
>>>> +	char		buf[bufsize];
>
> I wonder, do we allow variable length arrays?  I recall Ted was trying to get
> rid of these.
>
>>>
>>> ...well, I guess it could be more of a problem if you put 128K on the stack.
>>>
>>> --D
>>>
>>>>   	char		*ptr;
>>>> +	char		*cp;
>>>> +	int		count;
>>>>
>>>>   	retval = ext2fs_file_open(current_fs, newfile,
>>>>   				  EXT2_FILE_WRITE, &e2_file);
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
