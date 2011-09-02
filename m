From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 09/16] ext4: Calculate and verify block bitmap checksum
Date: Fri, 2 Sep 2011 15:06:57 -0600
Message-ID: <318F91B6-2E4A-4E0E-9189-70AE2592AE51@dilger.ca>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com> <20110901003134.31048.23806.stgit@elm3c44.beaverton.ibm.com> <2492E720-3316-4561-8C9C-BBC6E8670EAD@dilger.ca> <20110902190829.GJ12086@tux1.beaverton.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:47218 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab1IBVG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Sep 2011 17:06:58 -0400
In-Reply-To: <20110902190829.GJ12086@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-09-02, at 1:08 PM, Darrick J. Wong wrote:
> On Thu, Sep 01, 2011 at 12:08:44AM -0600, Andreas Dilger wrote:
>> On 2011-08-31, at 6:31 PM, Darrick J. Wong wrote:
>>> Compute and verify the checksum of the block bitmap; this checksum is stored in the block group descriptor.
>> 
>> Since this is CPU intensive, it might make sense to start computing the
>> block bitmap checksums as soon as the buffer is uptodate, instead of
>> waiting for all of the buffers to be read and _then_ doing the checksums.
>> 
>> Even better might be to do move all of the above code to do the checksum
>> to be in a new the b_end_io callback, so that it can start as soon as each
>> buffer is read from disk, to maximize CPU and IO overlap, like:
> 
> Good suggestion.  I'll put it into the next rev.
> 
> --D
> 
>> struct ext4_csum_data {
>>        struct superblock *cd_sb;
>>        ext4_group_t       cd_group;
>> };
>> 
>> static void ext4_end_buffered_read_sync_csum(struct buffer_head *bh,
>>                                             int uptodate)
>> {
>> 	struct superblock *sb = (struct ext4_csum_data *)(bh->b_private)->cd_sb;
>> 	ext4_group_t group = (struct ext4_csum_data *)(bh->b_private)->cd_group;
>> 
>> 	end_buffer_read_sync(bh, uptodate);

Actually, the call to end_buffer_read_sync() should go _after_ the
checksum is calculated, so that no other thread can start using
the buffer before the checksum is verified (i.e. any checks on
buffer_uptodate() could incorrectly succeed before the checksum
is computed and set_buffer_verified(bh) is called, and it would
incorrectly return an IO error thinking the checksum failed).

Also, end_buffer_sync_read() drops the reference to bh, but this
code is accessing bh->b_data, so another reason to move it after
the checksum is computed.

Cheers, Andreas

>> 	if (uptodate) {
>> 		struct ext4_group_desc *desc;
>> 
>> 		desc = ext4_get_group_desc(sb, group, NULL);
>> 		if (!desc)
>> 			return;
>> 
>> 		ext4_lock_group(sb, group);
>> 		if (ext4_valid_block_bitmap(sb, desc, group, bh) &&
>> 		    ext4_bitmap_csum_verify(sb, group,
>> 					    desc->bg_block_bitmap_csum, bh,
>> 					    (EXT4_BLOCKS_PER_GROUP(sb) + 7) / 8))
>> 			set_buffer_verified(bh);
>> 
>> 		ext4_unlock_group(rcd->rcd_sb, rcd->rcd_group);
>> 	}
>> }
>> 
>> Then later in the code can just check buffer_verified() in the caller:
>> 
>> ext4_read_block_bitmap()
>> {
>>        /* read all groups the page covers into the cache */
>>        for (i = 0; i < groups_per_page; i++) {
>> 		:
>> 		:
>>                set_bitmap_uptodate(bh[i]);
>>                ecd[i].cd_sb = sb;
>>                ecd[i].cd_group = first_group + i;
>>                bh[i]->b_end_io = ext4_end_buffer_read_sync_csum;
>>                submit_bh(READ, bh[i]);
>>                mb_debug(1, "read bitmap for group %u\n", first_group + i);
>> 	}
>> 
>> 	err = 0;
>>        /* always wait for I/O completion before returning */
>>        for (i = 0; i < groups_per_page; i++) {
>>                if (bh[i]) {
>>                        wait_on_buffer(bh[i]);
>> 			if (!buffer_uptodate(bh[i]) ||
>> 			    !buffer_verified(bh[i]))
>> 				err = -EIO;
>> 		}
>> 	}
>> 
>> 
>>> 	err = 0;
>>> 	first_block = page->index * blocks_per_page;
>>> 	for (i = 0; i < blocks_per_page; i++) {
>>> @@ -2829,6 +2856,9 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
>>> 	}
>>> 	len = ext4_free_blks_count(sb, gdp) - ac->ac_b_ex.fe_len;
>>> 	ext4_free_blks_set(sb, gdp, len);
>>> +	ext4_bitmap_csum_set(sb, ac->ac_b_ex.fe_group,
>>> +			     &gdp->bg_block_bitmap_csum, bitmap_bh,
>>> +			     (EXT4_BLOCKS_PER_GROUP(sb) + 7) / 8);
>>> 	gdp->bg_checksum = ext4_group_desc_csum(sbi, ac->ac_b_ex.fe_group, gdp);
>>> 
>>> 	ext4_unlock_group(sb, ac->ac_b_ex.fe_group);
>>> @@ -4638,6 +4668,8 @@ do_more:
>>> 
>>> 	ret = ext4_free_blks_count(sb, gdp) + count;
>>> 	ext4_free_blks_set(sb, gdp, ret);
>>> +	ext4_bitmap_csum_set(sb, block_group, &gdp->bg_block_bitmap_csum,
>>> +			     bitmap_bh, (EXT4_BLOCKS_PER_GROUP(sb) + 7) / 8);
>>> 	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
>>> 	ext4_unlock_group(sb, block_group);
>>> 	percpu_counter_add(&sbi->s_freeblocks_counter, count);
>>> @@ -4780,6 +4812,8 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
>>> 	mb_free_blocks(NULL, &e4b, bit, count);
>>> 	blk_free_count = blocks_freed + ext4_free_blks_count(sb, desc);
>>> 	ext4_free_blks_set(sb, desc, blk_free_count);
>>> +	ext4_bitmap_csum_set(sb, block_group, &desc->bg_block_bitmap_csum,
>>> +			     bitmap_bh, (EXT4_BLOCKS_PER_GROUP(sb) + 7) / 8);
>>> 	desc->bg_checksum = ext4_group_desc_csum(sbi, block_group, desc);
>>> 	ext4_unlock_group(sb, block_group);
>>> 	percpu_counter_add(&sbi->s_freeblocks_counter, blocks_freed);
>>> 
>> 

