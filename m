From: Dave Kleikamp <shaggy@austin.ibm.com>
Subject: Re: ext4 kernel patches against linux-2.6.18-mm1
Date: Fri, 29 Sep 2006 15:28:21 -0500
Message-ID: <1159561701.13366.19.camel@kleikamp.austin.ibm.com>
References: <20060926164347.GA24382@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:52419 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S1422810AbWI2U20
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Sep 2006 16:28:26 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e34.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k8TKSPli030699
	for <linux-ext4@vger.kernel.org>; Fri, 29 Sep 2006 16:28:25 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8TKSPPZ526148
	for <linux-ext4@vger.kernel.org>; Fri, 29 Sep 2006 14:28:25 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8TKSOix019808
	for <linux-ext4@vger.kernel.org>; Fri, 29 Sep 2006 14:28:25 -0600
To: Alexandre Ratchov <alexandre.ratchov@bull.net>
In-Reply-To: <20060926164347.GA24382@openx1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2006-09-26 at 18:43 +0200, Alexandre Ratchov wrote:
> hi,
> 
> i've updated the ext4 kernel patches to 2.6.18-mm1. I've just done some
> reordering/simplifications and fixed some minor bugs:
> 
>  - merge all 64bit "metadata" patches together
> 
>  - fix false-positive format warnings in balloc.c and resize.c because of
>    arithmetic with 'unsigned long' variables:
> 
>    the following snippet:
> 
> 	unsigned long x;
> 	unsigned long long long y;
> 	printf("%llu", x + y);
> 	
>    triggers a warning on 64bit archs because gcc doen't
>    seem to promote x + y to unsigned long long since long and long long
>    have the same size and signedness. So we avoid the warning by:
> 
> 	printf("%llu", (unsigned long long)(x + y));
> 
>  - fix ext4_blocks_count_set() and ext4_r_blocks_count_set() to use 64bit
>    block numbers (ie ext4_fsblk_t) instead of __u32
> 
>  - coding style fixes: remove misplaced spaces, wrap some lines to 80 cols
> 
>  - fix ext4_check_descriptors() and ext4_group_add() to use 
>    ext4_blocks_count() (returns full 64bit value) instead of just reading
>    sbi->s_es->s_blocks_count (32bit low bits)
> 
>  - include fix for JBD2 not to use the same slab naming than JBD (fix from
>    Johann Lomabardi)
> 
>  - remove unused EXT4_FREE_BLOCKS_COUNT() macro
>    
>  - update missing %u -> %llu replacements in resize.c
> 
>  - make 64bit ext4_super_block getters and setters inline C functions

I made a few cleanups on top of Alexandre's.  The updated patchset can
be found at:
http://www.kernel.org/pub/linux/kernel/people/shaggy/ext4/2.6.18-mm1/

So far, compile-tested only.

First, 2.6.18-mm1 contained a patch from Eric to change inode number
types from unsigned longs to unsigned ints, so I based the rebuilt the
patches against the updated ext3 source.

Also, a couple whitespace cleanups.

Changed the type of first and last from unsigned int to unsigned long
long as suggested by Eric.

Changed journal_brelse_array to a static to avoid renaming it to jbd2_*.

> Just to "summarize" the changes, here is attached a diff between results of
> the old patch set and the updated patch set.

Good idea.  I've done the same below.

> The new patch set can be found
> here:
> 
> http://www.bullopensource.org/ext4/20060926/
> 
> there are also patches for e2fsprogs-1.39 in sync with the kernel patch set;
> both are tested on x86_64 with an 20TB devices.

I didn't touch the e2fsprogs patches.

> 
> cheers,
> 
> -- Alexandre

Thanks,
Shaggy

diff -Nurp linux-bull/fs/ext4/ialloc.c linux-new/fs/ext4/ialloc.c
--- linux-bull/fs/ext4/ialloc.c	2006-09-29 15:07:38.000000000 -0500
+++ linux-new/fs/ext4/ialloc.c	2006-09-29 14:21:19.000000000 -0500
@@ -202,7 +202,7 @@ error_return:
 static int find_group_dir(struct super_block *sb, struct inode *parent)
 {
 	int ngroups = EXT4_SB(sb)->s_groups_count;
-	unsigned long freei, avefreei;
+	unsigned int freei, avefreei;
 	struct ext4_group_desc *desc, *best_desc = NULL;
 	struct buffer_head *bh;
 	int group, best_group = -1;
@@ -261,10 +261,10 @@ static int find_group_orlov(struct super
 	struct ext4_super_block *es = sbi->s_es;
 	int ngroups = sbi->s_groups_count;
 	int inodes_per_group = EXT4_INODES_PER_GROUP(sb);
-	unsigned long freei, avefreei;
+	unsigned int freei, avefreei;
 	ext4_fsblk_t freeb, avefreeb;
 	ext4_fsblk_t blocks_per_dir;
-	unsigned long ndirs;
+	unsigned int ndirs;
 	int max_debt, max_dirs, min_inodes;
 	ext4_grpblk_t min_blocks;
 	int group = -1, i;
diff -Nurp linux-bull/fs/ext4/resize.c linux-new/fs/ext4/resize.c
--- linux-bull/fs/ext4/resize.c	2006-09-29 15:07:38.000000000 -0500
+++ linux-new/fs/ext4/resize.c	2006-09-29 14:21:19.000000000 -0500
@@ -341,14 +341,14 @@ static int verify_reserved_gdb(struct su
 	int gdbackups = 0;
 
 	while ((grp = ext4_list_backups(sb, &three, &five, &seven)) < end) {
-		if (le32_to_cpu(*p++) != 
+		if (le32_to_cpu(*p++) !=
 		    grp * EXT4_BLOCKS_PER_GROUP(sb) + blk){
 			ext4_warning(sb, __FUNCTION__,
 				     "reserved GDT %llu"
 				     " missing grp %d (%llu)",
 				     blk, grp,
-				     grp * 
-				     (ext4_fsblk_t)EXT4_BLOCKS_PER_GROUP(sb) + 
+				     grp *
+				     (ext4_fsblk_t)EXT4_BLOCKS_PER_GROUP(sb) +
 				     blk);
 			return -EINVAL;
 		}
@@ -735,7 +735,7 @@ int ext4_group_add(struct super_block *s
 		return -EPERM;
 	}
 
-	if (ext4_blocks_count(es) + input->blocks_count < 
+	if (ext4_blocks_count(es) + input->blocks_count <
 	    ext4_blocks_count(es)) {
 		ext4_warning(sb, __FUNCTION__, "blocks_count overflow\n");
 		return -EINVAL;
diff -Nurp linux-bull/fs/ext4/super.c linux-new/fs/ext4/super.c
--- linux-bull/fs/ext4/super.c	2006-09-29 15:07:38.000000000 -0500
+++ linux-new/fs/ext4/super.c	2006-09-29 14:21:19.000000000 -0500
@@ -45,7 +45,7 @@
 static int ext4_load_journal(struct super_block *, struct ext4_super_block *,
 			     unsigned long journal_devnum);
 static int ext4_create_journal(struct super_block *, struct ext4_super_block *,
-			       unsigned long);
+			       unsigned int);
 static void ext4_commit_super (struct super_block * sb,
 			       struct ext4_super_block * es,
 			       int sync);
@@ -805,7 +805,7 @@ static ext4_fsblk_t get_sb_block(void **
 }
 
 static int parse_options (char *options, struct super_block *sb,
-			  unsigned long *inum, unsigned long *journal_devnum,
+			  unsigned int *inum, unsigned long *journal_devnum,
 			  ext4_fsblk_t *n_blocks_count, int is_remount)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -1451,7 +1451,7 @@ static int ext4_fill_super (struct super
 	ext4_fsblk_t sb_block = get_sb_block(&data);
 	ext4_fsblk_t logic_sb_block;
 	unsigned long offset = 0;
-	unsigned long journal_inum = 0;
+	unsigned int journal_inum = 0;
 	unsigned long journal_devnum = 0;
 	unsigned long def_mount_opts;
 	struct inode *root;
@@ -1918,7 +1918,7 @@ static void ext4_init_journal_params(str
 }
 
 static journal_t *ext4_get_journal(struct super_block *sb,
-				   unsigned long journal_inum)
+				   unsigned int journal_inum)
 {
 	struct inode *journal_inode;
 	journal_t *journal;
@@ -2053,7 +2053,7 @@ static int ext4_load_journal(struct supe
 			     unsigned long journal_devnum)
 {
 	journal_t *journal;
-	unsigned long journal_inum = le32_to_cpu(es->s_journal_inum);
+	unsigned int journal_inum = le32_to_cpu(es->s_journal_inum);
 	dev_t journal_dev;
 	int err = 0;
 	int really_read_only;
@@ -2139,7 +2139,7 @@ static int ext4_load_journal(struct supe
 
 static int ext4_create_journal(struct super_block * sb,
 			       struct ext4_super_block * es,
-			       unsigned long journal_inum)
+			       unsigned int journal_inum)
 {
 	journal_t *journal;
 
@@ -2152,7 +2152,7 @@ static int ext4_create_journal(struct su
 	if (!(journal = ext4_get_journal(sb, journal_inum)))
 		return -EINVAL;
 
-	printk(KERN_INFO "EXT4-fs: creating new journal on inode %lu\n",
+	printk(KERN_INFO "EXT4-fs: creating new journal on inode %u\n",
 	       journal_inum);
 
 	if (jbd2_journal_create(journal)) {
diff -Nurp linux-bull/fs/jbd2/journal.c linux-new/fs/jbd2/journal.c
--- linux-bull/fs/jbd2/journal.c	2006-09-29 15:07:37.000000000 -0500
+++ linux-new/fs/jbd2/journal.c	2006-09-29 14:21:19.000000000 -0500
@@ -696,7 +696,7 @@ fail:
  *  @bdev: Block device on which to create the journal
  *  @fs_dev: Device which hold journalled filesystem for this journal.
  *  @start: Block nr Start of journal.
- *  @len:  Lenght of the journal in blocks.
+ *  @len:  Length of the journal in blocks.
  *  @blocksize: blocksize of journalling device
  *  @returns: a newly created journal_t *
  *
@@ -820,7 +820,7 @@ static void journal_fail_superblock (jou
 static int journal_reset(journal_t *journal)
 {
 	journal_superblock_t *sb = journal->j_superblock;
-	unsigned int first, last;
+	unsigned long long first, last;
 
 	first = be32_to_cpu(sb->s_first);
 	last = be32_to_cpu(sb->s_maxlen);
diff -Nurp linux-bull/fs/jbd2/recovery.c linux-new/fs/jbd2/recovery.c
--- linux-bull/fs/jbd2/recovery.c	2006-09-29 15:07:37.000000000 -0500
+++ linux-new/fs/jbd2/recovery.c	2006-09-29 14:21:19.000000000 -0500
@@ -46,7 +46,7 @@ static int scan_revoke_records(journal_t
 #ifdef __KERNEL__
 
 /* Release readahead buffers after use */
-void jbd2_journal_brelse_array(struct buffer_head *b[], int n)
+static void journal_brelse_array(struct buffer_head *b[], int n)
 {
 	while (--n >= 0)
 		brelse (b[n]);
@@ -104,7 +104,7 @@ static int do_readahead(journal_t *journ
 			bufs[nbufs++] = bh;
 			if (nbufs == MAXBUF) {
 				ll_rw_block(READ, nbufs, bufs);
-				jbd2_journal_brelse_array(bufs, nbufs);
+				journal_brelse_array(bufs, nbufs);
 				nbufs = 0;
 			}
 		} else
@@ -117,7 +117,7 @@ static int do_readahead(journal_t *journ
 
 failed:
 	if (nbufs)
-		jbd2_journal_brelse_array(bufs, nbufs);
+		journal_brelse_array(bufs, nbufs);
 	return err;
 }
 
diff -Nurp linux-bull/include/linux/jbd2.h linux-new/include/linux/jbd2.h
--- linux-bull/include/linux/jbd2.h	2006-09-29 15:07:37.000000000 -0500
+++ linux-new/include/linux/jbd2.h	2006-09-29 14:21:19.000000000 -0500
@@ -985,7 +985,6 @@ extern void	   jbd2_journal_write_revoke
 extern int	jbd2_journal_set_revoke(journal_t *, unsigned long long, tid_t);
 extern int	jbd2_journal_test_revoke(journal_t *, unsigned long long, tid_t);
 extern void	jbd2_journal_clear_revoke(journal_t *);
-extern void	jbd2_journal_brelse_array(struct buffer_head *b[], int n);
 extern void	jbd2_journal_switch_revoke_table(journal_t *journal);
 
 /*

-- 
David Kleikamp
IBM Linux Technology Center

