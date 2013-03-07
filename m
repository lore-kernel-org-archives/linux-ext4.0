From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [BUG][Bigalloc] applictions will be blocked for more than 120s
 when we run xfstests #083
Date: Thu, 7 Mar 2013 15:07:25 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1303071457150.24359@localhost>
References: <20130307121149.GB2800@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757737Ab3CGOH3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Mar 2013 09:07:29 -0500
In-Reply-To: <20130307121149.GB2800@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 7 Mar 2013, Zheng Liu wrote:

> Date: Thu, 7 Mar 2013 20:11:49 +0800
> From: Zheng Liu <gnehzuil.liu@gmail.com>
> To: linux-ext4@vger.kernel.org
> Subject: [BUG][Bigalloc] applictions will be blocked for more than 120s when
>     we run xfstests #083
> 
> Hi all,
> 
> This bug has been confirmed by Ted and Lukas.  When we run xfstests #083
> in a ext4 file system with bigalloc feature, it will be blocked for more
> than 120s.  I hit this bug in 3.8 kernel, and I can confirm that it
> doesn't be fixed in dev branch until now.  This bug is very hard to be
> hitted in my sand box.  I need to run the following commands to trigger
> it.
> 
>   for i in {0..9}
>   do
>     ./check 083
>   done
> 
> My sand box is a Dell Desktop with a Intel(R) Core(TM)2 Duo CPU E8400
> @ 3.00GHz, 4G memory, a 160G HDD and a Intel SSD.  The test runs against
> SSD.
> 
> In 3.8 kernel, we will get the follwing messages from dmesg, and will
> be blocked for more than 120s:
> 
> Mar  7 15:15:17 lz-desktop wenqing: run xfstest 083 
> Mar  7 15:15:17 lz-desktop kernel: EXT4-fs (sda2): mounted filesystem
> with ordered data mode. Opts: acl,user_xattr
> Mar  7 15:15:18 lz-desktop kernel: EXT4-fs (sda2): delayed block
> allocation failed for inode 32 at logical offset 631 with max blocks 29
>  with error -28 
> Mar  7 15:15:18 lz-desktop kernel: EXT4-fs (sda2): This should not
> happen!! Data will be lost
> Mar  7 15:15:18 lz-desktop kernel:
> Mar  7 15:15:18 lz-desktop kernel: EXT4-fs (sda2): Total free blocks count 288
> Mar  7 15:15:18 lz-desktop kernel: EXT4-fs (sda2): Free/Dirty block details
> Mar  7 15:15:18 lz-desktop kernel: EXT4-fs (sda2): free_blocks=288
> Mar  7 15:15:18 lz-desktop kernel: EXT4-fs (sda2): dirty_blocks=96
> Mar  7 15:15:18 lz-desktop kernel: EXT4-fs (sda2): Block reservation details
> Mar  7 15:15:18 lz-desktop kernel: EXT4-fs (sda2): i_reserved_data_blocks=3
> Mar  7 15:15:18 lz-desktop kernel: EXT4-fs (sda2): i_reserved_meta_blocks=3
> 
> These messages *disappears* in dev branch because Lukas's patches.
> 
> But we still are blocked for more than 120s as below (after running 9
> times):

Yes, I can confirm that. The problem is that when we have delayed
write into unwritten extent we do not reserve any space, which is ok
because the data has already been allocated, however we might need
metadata blocks to cover unwritten extent conversion which we do not
have reserved.

Then in writeback time when the extent splic actually happen we
might not have enough space to allocate metadata blocks hence
ext4_map_blocks() in mpage_da_map_and_submit() will return -ENOSPC
to the ext4_da_writepages() caller.

However we're in writeback and we do not expect allocation to fail
because of ENOSPC at all because we should have reserved everything
we need to complete successfully so in the loop we'll force the
journal commit hoping that some blocks will be released and retry
the allocation again...and we'll be stuck in this loop forever.

Now here is patch which fixes the problem for me, however it still
needs some testing. Also we should probably do something about the
infinite loop in the ext4_da_writepages() - at least warn the user
if we try too many times so we at least know what's happening
because it was not easy to find this out.

Hopefully I'll send the proper patch soon, but feel free to test the
fix yourself.

Thanks!
-Lukas

---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/inode.c |   76 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 70 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 6e16c18..c20efe2 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -581,6 +581,7 @@ enum {
 #define EXT4_GET_BLOCKS_NO_LOCK			0x0100
 	/* Do not put hole in extent cache */
 #define EXT4_GET_BLOCKS_NO_PUT_HOLE		0x0200
+#define EXT4_GET_BLOCKS_METADATA_RESERVED	0x0400
 
 /*
  * Flags used by ext4_free_blocks
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9ea0cde..46cc739 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -606,7 +606,8 @@ found:
 	 * let the underlying get_block() function know to
 	 * avoid double accounting
 	 */
-	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
+	if ((flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) ||
+	    (flags & EXT4_GET_BLOCKS_METADATA_RESERVED))
 		ext4_set_inode_state(inode, EXT4_STATE_DELALLOC_RESERVED);
 	/*
 	 * We need to check for EXT4 here because migrate
@@ -636,7 +637,8 @@ found:
 			(flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE))
 			ext4_da_update_reserve_space(inode, retval, 1);
 	}
-	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
+	if ((flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) ||
+	    (flags & EXT4_GET_BLOCKS_METADATA_RESERVED))
 		ext4_clear_inode_state(inode, EXT4_STATE_DELALLOC_RESERVED);
 
 	if (retval > 0) {
@@ -1215,6 +1217,56 @@ static int ext4_journalled_write_end(struct file *file,
 	return ret ? ret : copied;
 }
 
+
+/*
+ * Reserve a metadata for a single block located at lblock
+ */
+static int ext4_da_reserve_metadata(struct inode *inode, ext4_lblk_t lblock)
+{
+	int retries = 0;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	unsigned int md_needed;
+	ext4_lblk_t save_last_lblock;
+	int save_len;
+
+	/*
+	 * recalculate the amount of metadata blocks to reserve
+	 * in order to allocate nrblocks
+	 * worse case is one extent per block
+	 */
+repeat:
+	spin_lock(&ei->i_block_reservation_lock);
+	/*
+	 * ext4_calc_metadata_amount() has side effects, which we have
+	 * to be prepared undo if we fail to claim space.
+	 */
+	save_len = ei->i_da_metadata_calc_len;
+	save_last_lblock = ei->i_da_metadata_calc_last_lblock;
+	md_needed = EXT4_NUM_B2C(sbi,
+				 ext4_calc_metadata_amount(inode, lblock));
+	trace_ext4_da_reserve_space(inode, md_needed);
+
+	/*
+	 * We do still charge estimated metadata to the sb though;
+	 * we cannot afford to run out of free blocks.
+	 */
+	if (ext4_claim_free_clusters(sbi, md_needed, 0)) {
+		ei->i_da_metadata_calc_len = save_len;
+		ei->i_da_metadata_calc_last_lblock = save_last_lblock;
+		spin_unlock(&ei->i_block_reservation_lock);
+		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
+			yield();
+			goto repeat;
+		}
+		return -ENOSPC;
+	}
+	ei->i_reserved_meta_blocks += md_needed;
+	spin_unlock(&ei->i_block_reservation_lock);
+
+	return 0;       /* success */
+}
+
 /*
  * Reserve a single cluster located at lblock
  */
@@ -1601,7 +1653,8 @@ static void mpage_da_map_and_submit(struct mpage_da_data *mpd)
 	 */
 	map.m_lblk = next;
 	map.m_len = max_blocks;
-	get_blocks_flags = EXT4_GET_BLOCKS_CREATE;
+	get_blocks_flags = EXT4_GET_BLOCKS_CREATE |
+			   EXT4_GET_BLOCKS_METADATA_RESERVED;
 	if (ext4_should_dioread_nolock(mpd->inode))
 		get_blocks_flags |= EXT4_GET_BLOCKS_IO_CREATE_EXT;
 	if (mpd->b_state & (1 << BH_Delay))
@@ -1766,7 +1819,7 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 			      struct buffer_head *bh)
 {
 	struct extent_status es;
-	int retval;
+	int retval, ret;
 	sector_t invalid_block = ~((sector_t) 0xffff);
 
 	if (invalid_block < ext4_blocks_count(EXT4_SB(inode->i_sb)->s_es))
@@ -1804,9 +1857,19 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 		map->m_len = retval;
 		if (ext4_es_is_written(&es))
 			map->m_flags |= EXT4_MAP_MAPPED;
-		else if (ext4_es_is_unwritten(&es))
+		else if (ext4_es_is_unwritten(&es)) {
+			/*
+			 * We have delalloc write into the unwritten extent
+			 * which means that we have to reserve metadata
+			 * potentially required for converting unwritten
+			 * extent.
+			 */
+			ret = ext4_da_reserve_metadata(inode, iblock);
+			if (ret)
+				/* not enough space to reserve */
+				retval = ret;
 			map->m_flags |= EXT4_MAP_UNWRITTEN;
-		else
+		} else
 			BUG_ON(1);
 
 		return retval;
@@ -1838,7 +1901,6 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 
 add_delayed:
 	if (retval == 0) {
-		int ret;
 		/*
 		 * XXX: __block_prepare_write() unmaps passed block,
 		 * is it OK?
-- 
1.7.7.6




