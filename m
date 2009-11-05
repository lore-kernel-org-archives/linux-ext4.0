From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH, RFC V2] ext4: flush delalloc blocks when space is low
Date: Thu, 5 Nov 2009 15:09:13 +0100
Message-ID: <20091105140913.GD17008@atrey.karlin.mff.cuni.cz>
References: <4ADE24CF.1080906@redhat.com> <4ADF6628.9080105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45300 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935AbZKEOJI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Nov 2009 09:09:08 -0500
Content-Disposition: inline
In-Reply-To: <4ADF6628.9080105@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Creating many small files in rapid succession on a small
> filesystem can lead to spurious ENOSPC; on a 104MB filesystem:
> 
> for i in `seq 1 22500`; do
>     echo -n > $SCRATCH_MNT/$i
>     echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX > $SCRATCH_MNT/$i
> done
> 
> leads to ENOSPC even though after a sync, 40% of the fs is free
> again.
> 
> This is because we reserve worst-case metadata for delalloc writes,
> and when data is allocated that worst-case reservation was not
> needed.
> 
> I've added 2 flushers here:
> 
>  * when free space is low compared to dirty blocks, do an async flush
>  * when we get a hard ENOSPC, do a sync flush before retry
> 
> This resolves the testcase for me, and survives all 4 generic
> ENOSPC tests in xfstests.
> 
> V2: don't try to sync if we're still in a (probably nested) transaction.
> 
> Thanks to Josef for pointing out that possibility.
  I still think it's deadlockable... See below.

> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 1d04189..28bde58 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -605,11 +605,27 @@ int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
>   */
>  int ext4_should_retry_alloc(struct super_block *sb, int *retries)
>  {
> -	if (!ext4_has_free_blocks(EXT4_SB(sb), 1) ||
> +	s64 dirtyblocks = 0;
> +	struct percpu_counter *dbc = &EXT4_SB(sb)->s_dirtyblocks_counter;
> +
> +	if (test_opt(sb, DELALLOC))
> +		dirtyblocks = percpu_counter_read_positive(dbc);
> +
> +	if ((!ext4_has_free_blocks(EXT4_SB(sb), 1) && !dirtyblocks) ||
>  	    (*retries)++ > 3 ||
>  	    !EXT4_SB(sb)->s_journal)
>  		return 0;
>  
> +	/* try a sync to flush delalloc space & free resvd metadata */
> +	if (!ext4_has_free_blocks(EXT4_SB(sb), 1) && dirtyblocks) {
> +		if (!ext4_journal_current_handle()) {
> +			down_read(&sb->s_umount);
> +			sync_inodes_sb(sb);
> +			up_read(&sb->s_umount);
  ext4_should_retry_alloc() is called quite deep from the filesystem. In
particular we can hold i_mutex of some inodes etc. So I'd almost bet
that taking s_umount sem here violates lock ranking in some code paths
(an easy check would be to enable lockdep and stress the filesystem a
bit).
  Also calling sync_inodes_sb() with i_mutex held just seems as a bad
thing to do although I don't see where it could deadlock and so it's
probably just a matter of taste...
  If we start writeback from ext4_nonda_switch as you do below, I think
that we should get decent results even without synchronous writeback in
the allocation path (maybe we'd need to tweak a bit the logic in
ext4_nonda_switch to provide more time for writeback thread to catchup).

								Honza

> +			return 1;
> +		}
> +	}
> +
>  	jbd_debug(1, "%s: retrying operation after ENOSPC\n", sb->s_id);
>  
>  	return jbd2_journal_force_commit_nested(EXT4_SB(sb)->s_journal);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 5c5bc5d..27c8b9b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3024,11 +3024,18 @@ static int ext4_nonda_switch(struct super_block *sb)
>  	if (2 * free_blocks < 3 * dirty_blocks ||
>  		free_blocks < (dirty_blocks + EXT4_FREEBLOCKS_WATERMARK)) {
>  		/*
> -		 * free block count is less that 150% of dirty blocks
> -		 * or free blocks is less that watermark
> +		 * free block count is less than 150% of dirty blocks
> +		 * or free blocks is less than watermark
>  		 */
>  		return 1;
>  	}
> +	/*
> +	 * Even if we don't switch but are nearing capacity,
> +	 * start pushing delalloc when 1/2 of free blocks are dirty.
> +	 */
> +	if (free_blocks < 2 * dirty_blocks)
> +		writeback_inodes_sb(sb);
> +
>  	return 0;
>  }
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
