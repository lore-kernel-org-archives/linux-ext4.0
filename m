From: Theodore Tso <tytso@mit.edu>
Subject: Re: Ext4 tree backports for 2.6.27.13 and 2.6.28.2
Date: Tue, 31 Mar 2009 08:33:20 -0400
Message-ID: <20090331123320.GC13356@mit.edu>
References: <E1LT8MN-0003Ps-Ur@closure.thunk.org> <20090211075914.GC20842@skywalker> <20090211153328.37ef255f@dhcp-100-2-144.bos.redhat.com> <20090212211935.GE6922@mini-me.lan> <20090216163507.1e73f452@dhcp-100-2-144.bos.redhat.com> <b637ec0b0903310502q56fc82eeobd5f62d24a367ac4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chuck Ebbert <cebbert@redhat.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Fabio Comolli <fabio.comolli@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757661AbZCaMd4@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b637ec0b0903310502q56fc82eeobd5f62d24a367ac4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 31, 2009 at 02:02:26PM +0200, Fabio Comolli wrote:
> Is there a patch for 2.6.27.X for people not using git?

These patches that were referenced in the mail thread which you
replied against have already been integrated into the latest 2.6.27.X
series.

There is another batch of patches which is being queued for the stable
series, which I sent out last week.  The for-stable branch and
for-stable-2.6.27 branches are for people to do a final round of
testing before I submit them to the stable series.  At the moment,
they are only available via git, but usually after a week or so, I'll
send them out to stable@kernel.org, and then usually within a week or
so (unless Greg and Chris are travelling), a new stable series shows
up with the latest ext4 bug fixes.

If you really are interested in testing the latest pre-release stable
patches for 2.6.27 --- these are versus 2.6.27.20, they're small
enough that I'll include them here.

						- Ted

Eric Sandeen (4):
      ext4: fix ext4_free_inode() vs. ext4_claim_inode() race
      ext4: fix header check in ext4_ext_search_right() for deep extent trees.
      ext4: fix bogus BUG_ONs in in mballoc code
      ext4: fix bb_prealloc_list corruption due to wrong group locking

Theodore Ts'o (1):
      ext4: Print the find_group_flex() warning only once

 fs/ext4/extents.c |    6 ++++--
 fs/ext4/ialloc.c  |   16 ++++++++++------
 fs/ext4/mballoc.c |   13 +++++++++----
 3 files changed, 23 insertions(+), 12 deletions(-)
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index b24d3c5..acb98c9 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1118,7 +1118,8 @@ ext4_ext_search_right(struct inode *inode, struct ext4_ext_path *path,
 	struct ext4_extent_idx *ix;
 	struct ext4_extent *ex;
 	ext4_fsblk_t block;
-	int depth, ee_len;
+	int depth;	/* Note, NOT eh_depth; depth from top of tree */
+	int ee_len;
 
 	BUG_ON(path == NULL);
 	depth = path->p_depth;
@@ -1177,7 +1178,8 @@ ext4_ext_search_right(struct inode *inode, struct ext4_ext_path *path,
 		if (bh == NULL)
 			return -EIO;
 		eh = ext_block_hdr(bh);
-		if (ext4_ext_check_header(inode, eh, depth)) {
+		/* subtract from p_depth to get proper eh_depth */
+		if (ext4_ext_check_header(inode, eh, path->p_depth - depth)) {
 			put_bh(bh);
 			return -EIO;
 		}
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index cce841f..b9457e1 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -188,7 +188,7 @@ void ext4_free_inode (handle_t *handle, struct inode * inode)
 	struct ext4_group_desc * gdp;
 	struct ext4_super_block * es;
 	struct ext4_sb_info *sbi;
-	int fatal = 0, err;
+	int fatal = 0, err, cleared;
 	ext4_group_t flex_group;
 
 	if (atomic_read(&inode->i_count) > 1) {
@@ -242,10 +242,12 @@ void ext4_free_inode (handle_t *handle, struct inode * inode)
 		goto error_return;
 
 	/* Ok, now we can actually update the inode bitmaps.. */
-	if (!ext4_clear_bit_atomic(sb_bgl_lock(sbi, block_group),
-					bit, bitmap_bh->b_data))
-		ext4_error (sb, "ext4_free_inode",
-			      "bit already cleared for inode %lu", ino);
+	spin_lock(sb_bgl_lock(sbi, block_group));
+	cleared = ext4_clear_bit(bit, bitmap_bh->b_data);
+	spin_unlock(sb_bgl_lock(sbi, block_group));
+	if (!cleared)
+		ext4_error(sb, "ext4_free_inode",
+			   "bit already cleared for inode %lu", ino);
 	else {
 		gdp = ext4_get_group_desc (sb, block_group, &bh2);
 
@@ -685,6 +687,7 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode)
 	struct inode *ret;
 	ext4_group_t i;
 	int free = 0;
+	static int once = 1;
 	ext4_group_t flex_group;
 
 	/* Cannot create files in a deleted directory */
@@ -704,7 +707,8 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode)
 		ret2 = find_group_flex(sb, dir, &group);
 		if (ret2 == -1) {
 			ret2 = find_group_other(sb, dir, &group);
-			if (ret2 == 0 && printk_ratelimit())
+			if (ret2 == 0 && once)
+				once = 0;
 				printk(KERN_NOTICE "ext4: find_group_flex "
 				       "failed, fallback succeeded dir %lu\n",
 				       dir->i_ino);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 39d7cc1..f34dada 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1450,7 +1450,7 @@ static void ext4_mb_measure_extent(struct ext4_allocation_context *ac,
 	struct ext4_free_extent *gex = &ac->ac_g_ex;
 
 	BUG_ON(ex->fe_len <= 0);
-	BUG_ON(ex->fe_len >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
+	BUG_ON(ex->fe_len > EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
 	BUG_ON(ex->fe_start >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
 	BUG_ON(ac->ac_status != AC_STATUS_CONTINUE);
 
@@ -3400,7 +3400,7 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	}
 	BUG_ON(start + size <= ac->ac_o_ex.fe_logical &&
 			start > ac->ac_o_ex.fe_logical);
-	BUG_ON(size <= 0 || size >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
+	BUG_ON(size <= 0 || size > EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
 
 	/* now prepare goal request */
 
@@ -3698,6 +3698,7 @@ static void ext4_mb_put_pa(struct ext4_allocation_context *ac,
 			struct super_block *sb, struct ext4_prealloc_space *pa)
 {
 	unsigned long grp;
+	ext4_fsblk_t grp_blk;
 
 	if (!atomic_dec_and_test(&pa->pa_count) || pa->pa_free != 0)
 		return;
@@ -3712,8 +3713,12 @@ static void ext4_mb_put_pa(struct ext4_allocation_context *ac,
 	pa->pa_deleted = 1;
 	spin_unlock(&pa->pa_lock);
 
-	/* -1 is to protect from crossing allocation group */
-	ext4_get_group_no_and_offset(sb, pa->pa_pstart - 1, &grp, NULL);
+	grp_blk = pa->pa_pstart;
+	/* If linear, pa_pstart may be in the next group when pa is used up */
+	if (pa->pa_linear)
+		grp_blk--;
+
+	ext4_get_group_no_and_offset(sb, grp_blk, &grp, NULL);
 
 	/*
 	 * possible race:
