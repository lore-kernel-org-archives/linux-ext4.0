From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: [PATCH 7/8] sysv: remove lock/unlock super
Date: Thu, 16 Aug 2012 12:05:15 +0200
Message-ID: <502CC5DB.6040400@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: bharrosh@panasas.com, bhalevy@tonian.com, jack@suse.cz,
	Andrew Morton <akpm@linux-foundation.org>,
	adilger.kernel@dilger.ca, tytso@mit.edu,
	hirofumi@mail.parknet.co.jp, mikulas@artax.karlin.mff.cuni.cz,
	Al Viro <viro@ZenIV.linux.org.uk>, hch@infradead.org,
	dushistov@mail.ru, osd-dev@open-osd.org,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:58940 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab2HPKLo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Aug 2012 06:11:44 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Marco Stornelli <marco.stornelli@gmail.com>

Replaced lock and unlock super with a new fs mutex s_lock.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---

diff -Nurp linux-3.6-rc1-orig/fs/sysv/balloc.c linux-3.6-rc1/fs/sysv/balloc.c
--- linux-3.6-rc1-orig/fs/sysv/balloc.c	2012-08-16 09:37:35.000000000 +0200
+++ linux-3.6-rc1/fs/sysv/balloc.c	2012-08-16 11:17:38.000000000 +0200
@@ -60,12 +60,12 @@ void sysv_free_block(struct super_block
 		return;
 	}
 
-	lock_super(sb);
+	mutex_lock(&sbi->s_lock);
 	count = fs16_to_cpu(sbi, *sbi->s_bcache_count);
 
 	if (count > sbi->s_flc_size) {
 		printk("sysv_free_block: flc_count > flc_size\n");
-		unlock_super(sb);
+		mutex_unlock(&sbi->s_lock);
 		return;
 	}
 	/* If the free list head in super-block is full, it is copied
@@ -77,7 +77,7 @@ void sysv_free_block(struct super_block
 		bh = sb_getblk(sb, block);
 		if (!bh) {
 			printk("sysv_free_block: getblk() failed\n");
-			unlock_super(sb);
+			mutex_unlock(&sbi->s_lock);
 			return;
 		}
 		memset(bh->b_data, 0, sb->s_blocksize);
@@ -93,7 +93,7 @@ void sysv_free_block(struct super_block
 	*sbi->s_bcache_count = cpu_to_fs16(sbi, count);
 	fs32_add(sbi, sbi->s_free_blocks, 1);
 	dirty_sb(sb);
-	unlock_super(sb);
+	mutex_unlock(&sbi->s_lock);
 }
 
 sysv_zone_t sysv_new_block(struct super_block * sb)
@@ -104,7 +104,7 @@ sysv_zone_t sysv_new_block(struct super_
 	struct buffer_head * bh;
 	unsigned count;
 
-	lock_super(sb);
+	mutex_lock(&sbi->s_lock);
 	count = fs16_to_cpu(sbi, *sbi->s_bcache_count);
 
 	if (count == 0) /* Applies only to Coherent FS */
@@ -147,11 +147,11 @@ sysv_zone_t sysv_new_block(struct super_
 	/* Now the free list head in the superblock is valid again. */
 	fs32_add(sbi, sbi->s_free_blocks, -1);
 	dirty_sb(sb);
-	unlock_super(sb);
+	mutex_unlock(&sbi->s_lock);
 	return nr;
 
 Enospc:
-	unlock_super(sb);
+	mutex_unlock(&sbi->s_lock);
 	return 0;
 }
 
@@ -173,7 +173,7 @@ unsigned long sysv_count_free_blocks(str
 	if (sbi->s_type == FSTYPE_AFS)
 		return 0;
 
-	lock_super(sb);
+	mutex_lock(&sbi->s_lock);
 	sb_count = fs32_to_cpu(sbi, *sbi->s_free_blocks);
 
 	if (0)
@@ -211,7 +211,7 @@ unsigned long sysv_count_free_blocks(str
 	if (count != sb_count)
 		goto Ecount;
 done:
-	unlock_super(sb);
+	mutex_unlock(&sbi->s_lock);
 	return count;
 
 Einval:
diff -Nurp linux-3.6-rc1-orig/fs/sysv/ialloc.c linux-3.6-rc1/fs/sysv/ialloc.c
--- linux-3.6-rc1-orig/fs/sysv/ialloc.c	2012-08-16 09:37:35.000000000 +0200
+++ linux-3.6-rc1/fs/sysv/ialloc.c	2012-08-16 10:08:26.000000000 +0200
@@ -118,7 +118,7 @@ void sysv_free_inode(struct inode * inod
 		       "%s\n", inode->i_sb->s_id);
 		return;
 	}
-	lock_super(sb);
+	mutex_lock(&sbi->s_lock);
 	count = fs16_to_cpu(sbi, *sbi->s_sb_fic_count);
 	if (count < sbi->s_fic_size) {
 		*sv_sb_fic_inode(sb,count++) = cpu_to_fs16(sbi, ino);
@@ -128,7 +128,7 @@ void sysv_free_inode(struct inode * inod
 	dirty_sb(sb);
 	memset(raw_inode, 0, sizeof(struct sysv_inode));
 	mark_buffer_dirty(bh);
-	unlock_super(sb);
+	mutex_unlock(&sbi->s_lock);
 	brelse(bh);
 }
 
@@ -147,13 +147,13 @@ struct inode * sysv_new_inode(const stru
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
-	lock_super(sb);
+	mutex_lock(&sbi->s_lock);
 	count = fs16_to_cpu(sbi, *sbi->s_sb_fic_count);
 	if (count == 0 || (*sv_sb_fic_inode(sb,count-1) == 0)) {
 		count = refill_free_cache(sb);
 		if (count == 0) {
 			iput(inode);
-			unlock_super(sb);
+			mutex_unlock(&sbi->s_lock);
 			return ERR_PTR(-ENOSPC);
 		}
 	}
@@ -174,7 +174,7 @@ struct inode * sysv_new_inode(const stru
 	sysv_write_inode(inode, &wbc);	/* ensure inode not allocated again */
 	mark_inode_dirty(inode);	/* cleared by sysv_write_inode() */
 	/* That's it. */
-	unlock_super(sb);
+	mutex_unlock(&sbi->s_lock);
 	return inode;
 }
 
@@ -185,7 +185,7 @@ unsigned long sysv_count_free_inodes(str
 	struct sysv_inode * raw_inode;
 	int ino, count, sb_count;
 
-	lock_super(sb);
+	mutex_lock(&sbi->s_lock);
 
 	sb_count = fs16_to_cpu(sbi, *sbi->s_sb_total_free_inodes);
 
@@ -213,7 +213,7 @@ unsigned long sysv_count_free_inodes(str
 	if (count != sb_count)
 		goto Einval;
 out:
-	unlock_super(sb);
+	mutex_unlock(&sbi->s_lock);
 	return count;
 
 Einval:
diff -Nurp linux-3.6-rc1-orig/fs/sysv/inode.c linux-3.6-rc1/fs/sysv/inode.c
--- linux-3.6-rc1-orig/fs/sysv/inode.c	2012-08-16 09:37:35.000000000 +0200
+++ linux-3.6-rc1/fs/sysv/inode.c	2012-08-16 10:08:55.000000000 +0200
@@ -36,7 +36,7 @@ static int sysv_sync_fs(struct super_blo
 	struct sysv_sb_info *sbi = SYSV_SB(sb);
 	unsigned long time = get_seconds(), old_time;
 
-	lock_super(sb);
+	mutex_lock(&sbi->s_lock);
 
 	/*
 	 * If we are going to write out the super block,
@@ -51,7 +51,7 @@ static int sysv_sync_fs(struct super_blo
 		mark_buffer_dirty(sbi->s_bh2);
 	}
 
-	unlock_super(sb);
+	mutex_unlock(&sbi->s_lock);
 
 	return 0;
 }
diff -Nurp linux-3.6-rc1-orig/fs/sysv/super.c linux-3.6-rc1/fs/sysv/super.c
--- linux-3.6-rc1-orig/fs/sysv/super.c	2012-08-16 09:37:35.000000000 +0200
+++ linux-3.6-rc1/fs/sysv/super.c	2012-08-16 10:10:46.000000000 +0200
@@ -368,6 +368,7 @@ static int sysv_fill_super(struct super_
 
 	sbi->s_sb = sb;
 	sbi->s_block_base = 0;
+	mutex_init(&sbi->s_lock);
 	sb->s_fs_info = sbi;
 
 	sb_set_blocksize(sb, BLOCK_SIZE);
diff -Nurp linux-3.6-rc1-orig/fs/sysv/sysv.h linux-3.6-rc1/fs/sysv/sysv.h
--- linux-3.6-rc1-orig/fs/sysv/sysv.h	2012-08-16 09:37:35.000000000 +0200
+++ linux-3.6-rc1/fs/sysv/sysv.h	2012-08-16 10:06:12.000000000 +0200
@@ -58,6 +58,7 @@ struct sysv_sb_info {
 	u32            s_nzones;	/* same as s_sbd->s_fsize */
 	u16	       s_namelen;       /* max length of dir entry */
 	int	       s_forced_ro;
+	struct mutex s_lock;
 };
 
 /*


