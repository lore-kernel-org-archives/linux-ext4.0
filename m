From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: fix extent tree corruption that incurred by hole
 punch
Date: Thu, 06 Dec 2012 09:48:16 -0600
Message-ID: <50C0BE40.5060003@redhat.com>
References: <1354623069-8124-1-git-send-email-forrestl@synology.com> <50C0BDA2.4090203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Forrest Liu <forrestl@synology.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422692Ab2LFPsJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Dec 2012 10:48:09 -0500
In-Reply-To: <50C0BDA2.4090203@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/6/12 9:45 AM, Eric Sandeen wrote:
> On 12/4/12 6:11 AM, Forrest Liu wrote:
>> Extent indexes didn't update correctly in ext4_ext_rm_idx, when depth
>> of extent tree is greater than 1.
> 
> This is interesting; we had 2 reports of similar corruption on the
> list, I wonder if the application in question was doing hole punching.
> I didn't expect that they were, so TBH I was pretty much ignoring
> the hole-punch cases for parent index updates.  Hm.  I'll have
> to look into that.
> 
> Could you turn your testcase into an xfstest regression test?

Also, please note that I sent an e2fsck patch to try to fix this
problem after the fact; it'd be great if in your testing, you could
also confirm that e2fsck w/ my patch fixes it correctly.

Thanks,
-Eric

> -Eric
> 
>> Signed-off-by: Forrest Liu <forrestl@synology.com>
>> ---
>>  fs/ext4/extents.c |   24 ++++++++++++++++++++----
>>  1 files changed, 20 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index d3dd618..b10b8c0 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -2190,13 +2190,15 @@ errout:
>>   * removes index from the index block.
>>   */
>>  static int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
>> -			struct ext4_ext_path *path)
>> +			struct ext4_ext_path *path, int depth)
>>  {
>>  	int err;
>>  	ext4_fsblk_t leaf;
>> +	__le32 border;
>>  
>>  	/* free index block */
>> -	path--;
>> +	depth--;
>> +	path = path + depth;
>>  	leaf = ext4_idx_pblock(path->p_idx);
>>  	if (unlikely(path->p_hdr->eh_entries == 0)) {
>>  		EXT4_ERROR_INODE(inode, "path->p_hdr->eh_entries == 0");
>> @@ -2221,6 +2223,20 @@ static int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
>>  
>>  	ext4_free_blocks(handle, inode, NULL, leaf, 1,
>>  			 EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_FORGET);
>> +
>> +	border = path->p_idx->ei_block;
>> +	while (--depth >= 0) {
>> +		if (path->p_idx != EXT_FIRST_INDEX(path->p_hdr))
>> +			break;
>> +		path--;
>> +		err = ext4_ext_get_access(handle, inode, path);
>> +		if (err)
>> +			break;
>> +		path->p_idx->ei_block = border;
>> +		err = ext4_ext_dirty(handle, inode, path);
>> +		if (err)
>> +			break;
>> +	}
>>  	return err;
>>  }
>>  
>> @@ -2557,7 +2573,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
>>  	/* if this leaf is free, then we should
>>  	 * remove it from index block above */
>>  	if (err == 0 && eh->eh_entries == 0 && path[depth].p_bh != NULL)
>> -		err = ext4_ext_rm_idx(handle, inode, path + depth);
>> +		err = ext4_ext_rm_idx(handle, inode, path, depth);
>>  
>>  out:
>>  	return err;
>> @@ -2760,7 +2776,7 @@ again:
>>  				/* index is empty, remove it;
>>  				 * handle must be already prepared by the
>>  				 * truncatei_leaf() */
>> -				err = ext4_ext_rm_idx(handle, inode, path + i);
>> +				err = ext4_ext_rm_idx(handle, inode, path, i);
>>  			}
>>  			/* root level has p_bh == NULL, brelse() eats this */
>>  			brelse(path[i].p_bh);
>>
> 

