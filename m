From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: tune2fs -l stale info
Date: Thu, 29 Mar 2007 13:59:39 -0600
Message-ID: <20070329195939.GI5967@schatzie.adilger.int>
References: <1175170676.5185.42.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, ext3-users@redhat.com
To: Vincent Caron <vcaron@bearstech.com>
Return-path: <ext3-users-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1175170676.5185.42.camel@localhost>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ext3-users>
List-Post: <mailto:ext3-users@redhat.com>
List-Help: <mailto:ext3-users-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=subscribe>
Sender: ext3-users-bounces@redhat.com
Errors-To: ext3-users-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

On Mar 29, 2007  14:17 +0200, Vincent Caron wrote:
>   I just noticed that 'tune2fs -l' did not returned a "lively" updated
> information regarding the free inodes count (looks like it's always
> correct after unmounting).

This is a bit of a defect in all 2.6 kernels.  They never update the
on disk superblock free blocks/inodes information to avoid lock contention,
even if this info is available.

Can you please give the following patch a try?  It fixes this issue,
and also makes statfs MUCH more efficient for large filesystems, because
the filesystem overhead is constant unless the filesystem size changes
and checking that for 16k groups is slow (hence hack to add cond_resched()
instead of fixing problem correctly).  It has not been tested much, but
is very straight forward.

Only the last part is strictly necessary to fix your particular problem
(setting of es->s_free_inodes_count and es->s_free_blocks_count).  This
is lazy, in the sense that you need a "statfs" to update the count, and
then a truncate or unlink or rmdir in order to dirty the superblock to
flush it to disk.  However, it will be correct in the buffer cache, and
it is a lot better than what we have now.  We don't want a non-lazy version
anyways, because of performance.

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>

======================= ext3-statfs-2.6.20.diff ==========================
Index: linux-stage/fs/ext3/super.c
===================================================================
--- linux-stage.orig/fs/ext3/super.c	2007-03-22 17:29:30.000000000 -0600
+++ linux-stage/fs/ext3/super.c	2007-03-23 01:48:41.000000000 -0600
@@ -2389,19 +2389,22 @@ restore_opts:
 	struct super_block *sb = dentry->d_sb;
 	struct ext3_sb_info *sbi = EXT3_SB(sb);
 	struct ext3_super_block *es = sbi->s_es;
-	ext3_fsblk_t overhead;
-	int i;
+	static ext3_fsblk_t overhead_last;
+	static __le32 blocks_last;
 	u64 fsid;
 
-	if (test_opt (sb, MINIX_DF))
-		overhead = 0;
-	else {
-		unsigned long ngroups;
-		ngroups = EXT3_SB(sb)->s_groups_count;
+	if (test_opt (sb, MINIX_DF)) {
+		overhead_last = 0;
+	} else if (blocks_last != es->s_blocks_count) {
+		unsigned long ngroups = sbi->s_groups_count, group, metabg = ~0;
+		unsigned three = 1, five = 5, seven = 7;
+		ext3_fsblk_t overhead = 0;
 		smp_rmb();
 
 		/*
-		 * Compute the overhead (FS structures)
+		 * Compute the overhead (FS structures).  This is constant
+		 * for a given filesystem unless the number of block groups
+		 * changes so we cache the previous value until it does.
 		 */
 
 		/*
@@ -2419,28 +2422,43 @@ static int ext3_statfs (struct super_blo
 		 * block group descriptors.  If the sparse superblocks
 		 * feature is turned on, then not all groups have this.
 		 */
-		for (i = 0; i < ngroups; i++) {
-			overhead += ext3_bg_has_super(sb, i) +
-				ext3_bg_num_gdb(sb, i);
-			cond_resched();
-		}
+		overhead += 1 + sbi->s_gdb_count +
+			le16_to_cpu(es->s_reserved_gdt_blocks); /* group 0 */
+		if (EXT3_HAS_INCOMPAT_FEATURE(sb,
+					      EXT3_FEATURE_INCOMPAT_META_BG)) {
+			metabg = le32_to_cpu(es->s_first_meta_bg) *
+					sbi->s_desc_per_block;
+			group = ngroups - metabg;
+			overhead += (group + 1) / sbi->s_desc_per_block * 3 +
+				((group%sbi->s_desc_per_block)>= 2?2:(group%2));
+		}
+
+		while ((group = ext3_list_backups(sb, &three, &five, &seven)) <
+		       ngroups) /* sb + group descriptors backups */
+			overhead += 1 +(group >= metabg ? 0 : sbi->s_gdb_count +
+					le16_to_cpu(es->s_reserved_gdt_blocks));
 
 		/*
 		 * Every block group has an inode bitmap, a block
 		 * bitmap, and an inode table.
 		 */
-		overhead += (ngroups * (2 + EXT3_SB(sb)->s_itb_per_group));
+		overhead += ngroups * (2 + sbi->s_itb_per_group);
+		overhead_last = overhead;
+		smp_wmb();
+		blocks_last = es->s_blocks_count;
 	}
 
 	buf->f_type = EXT3_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
-	buf->f_blocks = le32_to_cpu(es->s_blocks_count) - overhead;
+	buf->f_blocks = le32_to_cpu(es->s_blocks_count) - overhead_last;
 	buf->f_bfree = percpu_counter_sum(&sbi->s_freeblocks_counter);
+	es->s_free_blocks_count = cpu_to_le32(buf->f_bfree);
 	buf->f_bavail = buf->f_bfree - le32_to_cpu(es->s_r_blocks_count);
 	if (buf->f_bfree < le32_to_cpu(es->s_r_blocks_count))
 		buf->f_bavail = 0;
 	buf->f_files = le32_to_cpu(es->s_inodes_count);
 	buf->f_ffree = percpu_counter_sum(&sbi->s_freeinodes_counter);
+	es->s_free_inodes_count = cpu_to_le32(buf->f_ffree);
 	buf->f_namelen = EXT3_NAME_LEN;
 	fsid = le64_to_cpup((void *)es->s_uuid) ^
 	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));
Index: linux-stage/fs/ext3/resize.c
===================================================================
--- linux-stage.orig/fs/ext3/resize.c	2007-03-22 17:29:30.000000000 -0600
+++ linux-stage/fs/ext3/resize.c	2007-03-23 01:16:38.000000000 -0600
@@ -292,8 +292,8 @@ exit_journal:
  * sequence of powers of 3, 5, and 7: 1, 3, 5, 7, 9, 25, 27, 49, 81, ...
  * For a non-sparse filesystem it will be every group: 1, 2, 3, 4, ...
  */
-static unsigned ext3_list_backups(struct super_block *sb, unsigned *three,
-				  unsigned *five, unsigned *seven)
+unsigned ext3_list_backups(struct super_block *sb, unsigned *three,
+			   unsigned *five, unsigned *seven)
 {
 	unsigned *min = three;
 	int mult = 3;
Index: linux-stage/include/linux/ext3_fs.h
===================================================================
--- linux-stage.orig/include/linux/ext3_fs.h	2007-03-22 17:29:30.000000000 -0600
+++ linux-stage/include/linux/ext3_fs.h	2007-03-23 00:41:22.000000000 -0600
@@ -846,6 +846,8 @@ extern int ext3_group_add(struct super_b
 extern int ext3_group_extend(struct super_block *sb,
 				struct ext3_super_block *es,
 				ext3_fsblk_t n_blocks_count);
+extern unsigned ext3_list_backups(struct super_block *sb, unsigned *three,
+				  unsigned *five, unsigned *seven);
 
 /* super.c */
 extern void ext3_error (struct super_block *, const char *, const char *, ...)

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
