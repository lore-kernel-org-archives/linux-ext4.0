From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 28/74] libext2fs: check return values
Date: Tue, 17 Dec 2013 10:59:23 -0600
Message-ID: <52B082EB.4080902@redhat.com>
References: <20131211011813.30655.39624.stgit@birch.djwong.org> <20131211012128.30655.44051.stgit@birch.djwong.org> <52B08263.3080500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab3LQQ72 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Dec 2013 11:59:28 -0500
In-Reply-To: <52B08263.3080500@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/17/13, 10:57 AM, Eric Sandeen wrote:
> On 12/10/13, 7:21 PM, Darrick J. Wong wrote:
>> Fix up a few places where we ignore return values.
>>
>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>> ---
>>  lib/ext2fs/flushb.c    |    2 +-
>>  lib/ext2fs/icount.c    |    2 ++
>>  lib/ext2fs/imager.c    |    7 ++++++-
>>  lib/ext2fs/mkjournal.c |    4 +++-
>>  lib/ext2fs/punch.c     |    7 +++++++
>>  5 files changed, 19 insertions(+), 3 deletions(-)
>>
>>
>> diff --git a/lib/ext2fs/flushb.c b/lib/ext2fs/flushb.c
>> index ac8923c..98821fc 100644
>> --- a/lib/ext2fs/flushb.c
>> +++ b/lib/ext2fs/flushb.c
>> @@ -70,7 +70,7 @@ errcode_t ext2fs_sync_device(int fd, int flushb)
>>  #warning BLKFLSBUF not defined
>>  #endif
>>  #ifdef FDFLUSH
>> -		ioctl (fd, FDFLUSH, 0);   /* In case this is a floppy */
>> +		return ioctl(fd, FDFLUSH, 0);   /* In case this is a floppy */
>>  #elif defined(__linux__)
>>  #warning FDFLUSH not defined
>>  #endif
>> diff --git a/lib/ext2fs/icount.c b/lib/ext2fs/icount.c
>> index 84b74a9..c5ebf74 100644
>> --- a/lib/ext2fs/icount.c
>> +++ b/lib/ext2fs/icount.c
>> @@ -193,6 +193,8 @@ errcode_t ext2fs_create_icount_tdb(ext2_filsys fs, char *tdb_dir,
>>  	uuid_unparse(fs->super->s_uuid, uuid);
>>  	sprintf(fn, "%s/%s-icount-XXXXXX", tdb_dir, uuid);
>>  	fd = mkstemp(fn);
>> +	if (fd < 0)
>> +		return fd;
> 
> Turns out this leaks "fn" (coverity spotted this, CID 1138575)

oops, and icount as well.

-Eric

> Thanks,
> -Eric
> 
>>  
>>  	/*
>>  	 * This is an overestimate of the size that we will need; the
>> diff --git a/lib/ext2fs/imager.c b/lib/ext2fs/imager.c
>> index 7f3b25b..378a3c8 100644
>> --- a/lib/ext2fs/imager.c
>> +++ b/lib/ext2fs/imager.c
>> @@ -66,6 +66,7 @@ errcode_t ext2fs_image_inode_write(ext2_filsys fs, int fd, int flags)
>>  	blk64_t		blk;
>>  	ssize_t		actual;
>>  	errcode_t	retval;
>> +	off_t		r;
>>  
>>  	buf = malloc(fs->blocksize * BUF_BLOCKS);
>>  	if (!buf)
>> @@ -97,7 +98,11 @@ errcode_t ext2fs_image_inode_write(ext2_filsys fs, int fd, int flags)
>>  					blk++;
>>  					left--;
>>  					cp += fs->blocksize;
>> -					lseek(fd, fs->blocksize, SEEK_CUR);
>> +					r = lseek(fd, fs->blocksize, SEEK_CUR);
>> +					if (r < 0) {
>> +						retval = errno;
>> +						goto errout;
>> +					}
>>  					continue;
>>  				}
>>  				/* Find non-zero blocks */
>> diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
>> index 2afd3b7..1d5b1a7 100644
>> --- a/lib/ext2fs/mkjournal.c
>> +++ b/lib/ext2fs/mkjournal.c
>> @@ -520,8 +520,10 @@ errcode_t ext2fs_add_journal_inode(ext2_filsys fs, blk_t num_blocks, int flags)
>>  #if HAVE_EXT2_IOCTLS
>>  		fd = open(jfile, O_RDONLY);
>>  		if (fd >= 0) {
>> -			ioctl(fd, EXT2_IOC_SETFLAGS, &f);
>> +			retval = ioctl(fd, EXT2_IOC_SETFLAGS, &f);
>>  			close(fd);
>> +			if (retval)
>> +				return retval;
>>  		}
>>  #endif
>>  #endif
>> diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
>> index 790a0ad8..ceec336 100644
>> --- a/lib/ext2fs/punch.c
>> +++ b/lib/ext2fs/punch.c
>> @@ -192,6 +192,13 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
>>  	retval = ext2fs_extent_open2(fs, ino, inode, &handle);
>>  	if (retval)
>>  		return retval;
>> +	/*
>> +	 * Find the extent closest to the start of the punch range.  We don't
>> +	 * check the return value because _goto() sets the current node to the
>> +	 * next-lowest extent if 'start' is in a hole, and doesn't set a
>> +	 * current node if there was a real error reading the extent tree.
>> +	 * In that case, _get() will error out.
>> +	 */
>>  	ext2fs_extent_goto(handle, start);
>>  	retval = ext2fs_extent_get(handle, EXT2_EXTENT_CURRENT, &extent);
>>  	if (retval)
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 

