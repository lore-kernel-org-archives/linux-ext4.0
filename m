From: tytso@mit.edu
Subject: Re: 2.6.33-rc1: kernel BUG at fs/ext4/inode.c:1063 (sparc)
Date: Wed, 30 Dec 2009 12:45:28 -0500
Message-ID: <20091230174528.GM4429@thunk.org>
References: <a4423d670912241449y2da43d5fi3e5a18c114b84178@mail.gmail.com>
 <87hbrfdylc.fsf@openvz.org>
 <a4423d670912251133u795338a4wd32d5cdef8c36c75@mail.gmail.com>
 <87eimir4yk.fsf@openvz.org>
 <a4423d670912271232y5bb928f7wb667ca71f1a93f8a@mail.gmail.com>
 <20091227225216.GB4429@thunk.org>
 <a4423d670912271502n13957e8boc168fdc75444dc09@mail.gmail.com>
 <20091228035159.GC4429@thunk.org>
 <20091230053720.GK4429@thunk.org>
 <87k4w4vbvy.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
	dmitry.torokhov@gmail.com, Jan Kara <jack@suse.cz>,
	aanisimov@inbox.ru, pl4nkton@googlemail.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:46540 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548AbZL3Rpl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Dec 2009 12:45:41 -0500
Content-Disposition: inline
In-Reply-To: <87k4w4vbvy.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 30, 2009 at 04:18:09PM +0300, Dmitry Monakhov wrote:
> Hello, I've finally able to reproduce the issue. I'm agree with your
> diagnose. But while looking in to code i've found some questions
> see late in the message.

The simplest way of reproducing the BUG() that I've found is:

mke2fs -t ext3 /dev/XXX
mount /dev/XXX /mnt
dd if=/dev/zero of=/mnt/big-file bs=1024k count=16
sync

Unfortunately, this is all to easy for users to stumble across, so we
need to fix this ASAP.   :-(

> Seems what this is not enough.
> Just imagine, we may have following call-trace:
> 
>  userspace pwrite(fd, d, 1000, off)
>  ->ext4_da_reserve_space(inode, 1000)
>    ->dq_reserve_space(1000 + md_needed)
>  userspace ftruncate(fd, off) /* "off"  is the same as in pwrite call */
>  ->ext4_da_invalidatepage()
>    ->ext4_da_page_release_reservation()
>     ->ext4_da_release_space()
> <<< And we decrease ->i_allocated_meta_blocks only if (mdb_free > 0)
>  userspace close(fd)

I don't think this is the problem.  After we do the truncate, we will
be calling ext4_da_release_space with a value that should cause us to
call ext4_calc_metadata_amount with 0, so it will return 0.  At that
point, we will have some i_reserved_metadata_blocks to free.  The
problem is that in ext4_da_release_space(), I forgot to call
vfs_dq_claim_block(mdb_claim).  That was probably the cause of the leak.

In any case, here's a patch which also fixes the blatent
under-estimation of the number of metadata blocks that could be needed
if the process is writing random blocks into a sparse file.
Unfortunately, especially for non-extent mapped files, we *very* badly
over-estimate how many indirect blocks will be necessary we assume
each data block requires 2-3 indirect blocks(!!!).  Guessing exactly
how many metadata blocks will be necessary when doing delayed
allocation is painful, and I'm very tempted to simply change the quota
system to not include metadata blocks at all.  The only thing stopping
me from doing this is we'd also need to make synchronized changes to
userspace programs like checkquota.

Care to give this a spin?  BTW, are you testing with lockdep enabled?
I'm reliably getting a LOCKDEP complaint any time I use quotas, either
normal quotas or journalled quotas, and if I use normal quotas, I get
a lot of complaints from the JBD layer about dirty metadata buffers
that aren't part of a transaction belonging to the aquota.user file.
(What's up with that?  I thought if you weren't using journalled
quotas the file that should be used is quota.user?)  In any case, it
looks like the quota code in ext4 needs more attention, and we may
want to check and see if any of these bugs are also turning up in the
ext3 code, or were introduced as part of the ext4 enhancements.
(Clearly the problems associated with quota and delalloc are ext4
specific.)

						- Ted

commit ef627929781c98113e6ae93f159dd3c12a884ad8
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Wed Dec 30 00:04:04 2009 -0500

    ext4: Patch up how we claim metadata blocks for quota purposes
    
    Commit d21cd8f triggered a BUG in the function
    ext4_da_update_reserve_space() found in fs/ext4/inode.c.  The root
    cause of this BUG() is caused by the fact that
    ext4_calc_metadata_amount() can severely over-estimate how many
    metadata blocks will be needed, especially when using direct
    block-mapped files.
    
    In addition, it can also badly *under* estimate how much space is
    needed, since ext4_calc_metadata_amount() assumes that the blocks are
    contiguous, and this is not always true.  If the application is
    writing blocks to a sparse file, the number of metadata blocks
    necessary can be severly underestimated by the functions
    ext4_da_reserve_space(), ext4_da_update_reserve_space() and
    ext4_da_release_space().
    
    Unfortunately, doing this right means that we need to massively
    over-estimate the amount of free space needed.  So in some cases we
    may need to force the inode to be written to disk asynchronously in
    the hope that we don't get spurious quota failures.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3e3b454..84eeb8f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1043,43 +1043,47 @@ static int ext4_calc_metadata_amount(struct inode *inode, int blocks)
 	return ext4_indirect_calc_metadata_amount(inode, blocks);
 }
 
+/*
+ * Called with i_data_sem down, which is important since we can call
+ * ext4_discard_preallocations() from here.
+ */
 static void ext4_da_update_reserve_space(struct inode *inode, int used)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	int total, mdb, mdb_free, mdb_claim = 0;
-
-	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
-	/* recalculate the number of metablocks still need to be reserved */
-	total = EXT4_I(inode)->i_reserved_data_blocks - used;
-	mdb = ext4_calc_metadata_amount(inode, total);
-
-	/* figure out how many metablocks to release */
-	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
-	mdb_free = EXT4_I(inode)->i_reserved_meta_blocks - mdb;
-
-	if (mdb_free) {
-		/* Account for allocated meta_blocks */
-		mdb_claim = EXT4_I(inode)->i_allocated_meta_blocks;
-		BUG_ON(mdb_free < mdb_claim);
-		mdb_free -= mdb_claim;
-
-		/* update fs dirty blocks counter */
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	int mdb_free = 0;
+
+	spin_lock(&ei->i_block_reservation_lock);
+	if (unlikely(used > ei->i_reserved_data_blocks)) {
+		ext4_msg(inode->i_sb, KERN_NOTICE, "%s: ino %lu, used %d "
+			 "with only %d reserved data blocks\n",
+			 __func__, inode->i_ino, used,
+			 ei->i_reserved_data_blocks);
+		WARN_ON(1);
+		used = ei->i_reserved_data_blocks;
+	}
+
+	/* Update per-inode reservations */
+	ei->i_reserved_data_blocks -= used;
+	used += ei->i_allocated_meta_blocks;
+	ei->i_reserved_meta_blocks -= ei->i_allocated_meta_blocks;
+	ei->i_allocated_meta_blocks = 0;
+	percpu_counter_sub(&sbi->s_dirtyblocks_counter, used);
+
+	if (ei->i_reserved_data_blocks == 0) {
+		/*
+		 * We can release all of the reserved metadata blocks
+		 * only when we have written all of the delayed
+		 * allocation blocks.
+		 */
+		mdb_free = ei->i_allocated_meta_blocks;
 		percpu_counter_sub(&sbi->s_dirtyblocks_counter, mdb_free);
-		EXT4_I(inode)->i_allocated_meta_blocks = 0;
-		EXT4_I(inode)->i_reserved_meta_blocks = mdb;
+		ei->i_allocated_meta_blocks = 0;
 	}
-
-	/* update per-inode reservations */
-	BUG_ON(used  > EXT4_I(inode)->i_reserved_data_blocks);
-	EXT4_I(inode)->i_reserved_data_blocks -= used;
-	percpu_counter_sub(&sbi->s_dirtyblocks_counter, used + mdb_claim);
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 
-	vfs_dq_claim_block(inode, used + mdb_claim);
-
-	/*
-	 * free those over-booking quota for metadata blocks
-	 */
+	/* Update quota subsystem */
+	vfs_dq_claim_block(inode, used);
 	if (mdb_free)
 		vfs_dq_release_reservation_block(inode, mdb_free);
 
@@ -1088,7 +1092,8 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
 	 * there aren't any writers on the inode, we can discard the
 	 * inode's preallocations.
 	 */
-	if (!total && (atomic_read(&inode->i_writecount) == 0))
+	if ((ei->i_reserved_data_blocks == 0) &&
+	    (atomic_read(&inode->i_writecount) == 0))
 		ext4_discard_preallocations(inode);
 }
 
@@ -1801,7 +1806,8 @@ static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 {
 	int retries = 0;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	unsigned long md_needed, mdblocks, total = 0;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	unsigned long md_needed, md_reserved, total = 0;
 
 	/*
 	 * recalculate the amount of metadata blocks to reserve
@@ -1809,35 +1815,44 @@ static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 	 * worse case is one extent per block
 	 */
 repeat:
-	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
-	total = EXT4_I(inode)->i_reserved_data_blocks + nrblocks;
-	mdblocks = ext4_calc_metadata_amount(inode, total);
-	BUG_ON(mdblocks < EXT4_I(inode)->i_reserved_meta_blocks);
-
-	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
+	spin_lock(&ei->i_block_reservation_lock);
+	md_reserved = ei->i_reserved_meta_blocks;
+	md_needed = ext4_calc_metadata_amount(inode, nrblocks);
 	total = md_needed + nrblocks;
-	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+	spin_unlock(&ei->i_block_reservation_lock);
 
 	/*
 	 * Make quota reservation here to prevent quota overflow
 	 * later. Real quota accounting is done at pages writeout
 	 * time.
 	 */
-	if (vfs_dq_reserve_block(inode, total))
+	if (vfs_dq_reserve_block(inode, total)) {
+		/* 
+		 * We tend to badly over-estimate the amount of
+		 * metadata blocks which are needed, so if we have
+		 * reserved any metadata blocks, try to force out the
+		 * inode and see if we have any better luck.
+		 */
+		if (md_reserved && retries++ <= 3)
+			goto retry;
 		return -EDQUOT;
+	}
 
 	if (ext4_claim_free_blocks(sbi, total)) {
 		vfs_dq_release_reservation_block(inode, total);
 		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
+		retry:
+			if (md_reserved)
+				write_inode_now(inode, (retries == 3));
 			yield();
 			goto repeat;
 		}
 		return -ENOSPC;
 	}
-	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
-	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
-	EXT4_I(inode)->i_reserved_meta_blocks += md_needed;
-	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+	spin_lock(&ei->i_block_reservation_lock);
+	ei->i_reserved_data_blocks += nrblocks;
+	ei->i_reserved_meta_blocks += md_needed;
+	spin_unlock(&ei->i_block_reservation_lock);
 
 	return 0;       /* success */
 }
@@ -1845,49 +1860,45 @@ repeat:
 static void ext4_da_release_space(struct inode *inode, int to_free)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	int total, mdb, mdb_free, release;
+	struct ext4_inode_info *ei = EXT4_I(inode);
 
 	if (!to_free)
 		return;		/* Nothing to release, exit */
 
 	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 
-	if (!EXT4_I(inode)->i_reserved_data_blocks) {
+	if (unlikely(to_free > ei->i_reserved_data_blocks)) {
 		/*
-		 * if there is no reserved blocks, but we try to free some
-		 * then the counter is messed up somewhere.
-		 * but since this function is called from invalidate
-		 * page, it's harmless to return without any action
+		 * if there aren't enough reserved blocks, then the
+		 * counter is messed up somewhere.  Since this
+		 * function is called from invalidate page, it's
+		 * harmless to return without any action.
 		 */
-		printk(KERN_INFO "ext4 delalloc try to release %d reserved "
-			    "blocks for inode %lu, but there is no reserved "
-			    "data blocks\n", to_free, inode->i_ino);
-		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
-		return;
+		ext4_msg(inode->i_sb, KERN_NOTICE, "ext4_da_release_space: "
+			 "ino %lu, to_free %d with only %d reserved "
+			 "data blocks\n", inode->i_ino, to_free,
+			 ei->i_reserved_data_blocks);
+		WARN_ON(1);
+		to_free = ei->i_reserved_data_blocks;
 	}
+	ei->i_reserved_data_blocks -= to_free;
 
-	/* recalculate the number of metablocks still need to be reserved */
-	total = EXT4_I(inode)->i_reserved_data_blocks - to_free;
-	mdb = ext4_calc_metadata_amount(inode, total);
-
-	/* figure out how many metablocks to release */
-	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
-	mdb_free = EXT4_I(inode)->i_reserved_meta_blocks - mdb;
-
-	release = to_free + mdb_free;
-
-	/* update fs dirty blocks counter for truncate case */
-	percpu_counter_sub(&sbi->s_dirtyblocks_counter, release);
+	if (ei->i_reserved_data_blocks == 0) {
+		/*
+		 * We can release all of the reserved metadata blocks
+		 * only when we have written all of the delayed
+		 * allocation blocks.
+		 */
+		to_free += ei->i_allocated_meta_blocks;
+		ei->i_allocated_meta_blocks = 0;
+	}
 
-	/* update per-inode reservations */
-	BUG_ON(to_free > EXT4_I(inode)->i_reserved_data_blocks);
-	EXT4_I(inode)->i_reserved_data_blocks -= to_free;
+	/* update fs dirty blocks counter */
+	percpu_counter_sub(&sbi->s_dirtyblocks_counter, to_free);
 
-	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
-	EXT4_I(inode)->i_reserved_meta_blocks = mdb;
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 
-	vfs_dq_release_reservation_block(inode, release);
+	vfs_dq_release_reservation_block(inode, to_free);
 }
 
 static void ext4_da_page_release_reservation(struct page *page,
