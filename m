From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC PATCH] ext4: Fix fallocate to update the file size in each
 transaction.
Date: Fri, 07 Mar 2008 09:57:47 -0600
Message-ID: <47D165FB.4070508@redhat.com>
References: <1204887200-9929-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <47D16302.9090506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbYCGP6W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Mar 2008 10:58:22 -0500
In-Reply-To: <47D16302.9090506@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
>> ext4_fallocate need to update file size in each transaction. Otherwise
>> ife we crash the file size won't be updated. We were also not marking
>> the inode dirty after updating file size before. 
> 
> This led to losing the size update when unmounted...
> 
>> Also when we try to
>> retry allocation due to ENOSPC make sure we reset the variable ret so
>> that we actually do a retry.
> 
> That's a few alsos.  Should this be more than one patch when committed?
> 
> -Eric

Oops that "-Eric" was too soon, there are more comments below ;)

>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>> ---
>>  fs/ext4/extents.c |   78 +++++++++++++++++++++--------------------------------
>>  1 files changed, 31 insertions(+), 47 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index dcdf92a..09dd3c5 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -2783,6 +2783,26 @@ int ext4_ext_writepage_trans_blocks(struct inode *inode, int num)
>>  	return needed;
>>  }
>>  
>> +static void ext4_falloc_update_inode(struct inode *inode,
>> +					int mode, loff_t new_size)
>> +{
>> +	struct timespec now;
>> +
>> +	now = current_fs_time(inode->i_sb);
>> +	if (!timespec_equal(&inode->i_ctime, &now))
>> +		inode->i_ctime = now;
> 
> This used to depend on blocks actually being allocated; it looks like it
> doesn't anymore?
> 
>> +	/*
>> +	 * Update only when preallocation was requested beyond
>> +	 * the file size.
>> +	 */
>> +	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
>> +				new_size > i_size_read(inode)) {
>> +		i_size_write(inode, new_size);
>> +		EXT4_I(inode)->i_disksize = i_size_read(inode);
>> +	}
>> +
>> +}
> 
> Ok, I think this is all cleaner...
> 
>>  /*
>>   * preallocate space for a file. This implements ext4's fallocate inode
>>   * operation, which gets called from sys_fallocate system call.
>> @@ -2794,8 +2814,8 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
>>  {
>>  	handle_t *handle;
>>  	ext4_lblk_t block;
>> +	loff_t new_size;
>>  	unsigned long max_blocks;
>> -	ext4_fsblk_t nblocks = 0;
>>  	int ret = 0;
>>  	int ret2 = 0;
>>  	int retries = 0;
>> @@ -2814,8 +2834,7 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
>>  		return -ENODEV;
>>  
>>  	block = offset >> blkbits;
>> -	max_blocks = (EXT4_BLOCK_ALIGN(len + offset, blkbits) >> blkbits)
>> -			- block;
>> +	max_blocks = EXT4_BLOCK_ALIGN(len, blkbits) >> blkbits;
> 
> Ok, this makes much more sense IMHO.
> 
>>  
>>  	/*
>>  	 * credits to insert 1 extent into extent tree + buffers to be able to
>> @@ -2848,28 +2867,13 @@ retry:
>>  			ret2 = ext4_journal_stop(handle);
>>  			break;
>>  		}
>> -		if (ret > 0) {
>> -			/* check wrap through sign-bit/zero here */
>> -			if ((block + ret) < 0 || (block + ret) < block) {
>> -				ret = -EIO;
>> -				ext4_mark_inode_dirty(handle, inode);
>> -				ret2 = ext4_journal_stop(handle);
>> -				break;
>> -			}
>> -			if (buffer_new(&map_bh) && ((block + ret) >
>> -			    (EXT4_BLOCK_ALIGN(i_size_read(inode), blkbits)
>> -			    >> blkbits)))
>> -					nblocks = nblocks + ret;
>> -		}
>> +		if ((block + ret) >= (EXT4_BLOCK_ALIGN(offset + len,
>> +						blkbits) >> blkbits))
>> +			new_size = offset + len;
>> +		else
>> +			new_size = (block + ret) << blkbits;
> 
> Since we called ext4_get_blocks_wrap with max_blocks, will we really end
> up with more blocks allocated than we asked for?  And do we no longer
> need the wrap checks?  (I'd expect that to be tested higher up with the
> original offset+len requested, no?)
> 
>> -		/* Update ctime if new blocks get allocated */
>> -		if (nblocks) {
>> -			struct timespec now;
>> -
>> -			now = current_fs_time(inode->i_sb);
>> -			if (!timespec_equal(&inode->i_ctime, &now))
>> -				inode->i_ctime = now;
>> -		}
>> +		ext4_falloc_update_inode(inode, mode, new_size);
>>  
>>  		ext4_mark_inode_dirty(handle, inode);
>>  		ret2 = ext4_journal_stop(handle);
>> @@ -2877,30 +2881,10 @@ retry:
>>  			break;
>>  	}
>>  
>> -	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
>> +	if (ret == -ENOSPC &&
>> +			ext4_should_retry_alloc(inode->i_sb, &retries)) {
>> +		ret = 0;
>>  		goto retry;
>> -
>> -	/*
>> -	 * Time to update the file size.
>> -	 * Update only when preallocation was requested beyond the file size.
>> -	 */
>> -	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
>> -	    (offset + len) > i_size_read(inode)) {
>> -		if (ret > 0) {
>> -			/*
>> -			 * if no error, we assume preallocation succeeded
>> -			 * completely
>> -			 */
>> -			i_size_write(inode, offset + len);
>> -			EXT4_I(inode)->i_disksize = i_size_read(inode);
>> -		} else if (ret < 0 && nblocks) {
>> -			/* Handle partial allocation scenario */
>> -			loff_t newsize;
>> -
>> -			newsize  = (nblocks << blkbits) + i_size_read(inode);
>> -			i_size_write(inode, EXT4_BLOCK_ALIGN(newsize, blkbits));
>> -			EXT4_I(inode)->i_disksize = i_size_read(inode);
>> -		}
>>  	}
>>  
>>  	mutex_unlock(&inode->i_mutex);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

