From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: [PATCH 8/8] ufs: remove lock/unlock super
Date: Thu, 16 Aug 2012 12:06:21 +0200
Message-ID: <502CC61D.40800@gmail.com>
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
Received: from mail-we0-f174.google.com ([74.125.82.174]:38318 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab2HPKMt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Aug 2012 06:12:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Marco Stornelli <marco.stornelli@gmail.com>

Replaced lock and unlock super with a new fs mutex s_lock.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---

diff -Nurp linux-3.6-rc1-orig/fs/ufs/balloc.c linux-3.6-rc1/fs/ufs/balloc.c
--- linux-3.6-rc1-orig/fs/ufs/balloc.c	2012-08-16 09:37:36.000000000 +0200
+++ linux-3.6-rc1/fs/ufs/balloc.c	2012-08-16 10:25:31.000000000 +0200
@@ -54,7 +54,7 @@ void ufs_free_fragments(struct inode *in
 	if (ufs_fragnum(fragment) + count > uspi->s_fpg)
 		ufs_error (sb, "ufs_free_fragments", "internal error");
 	
-	lock_super(sb);
+	mutex_lock(&UFS_SB(sb)->s_lock);
 	
 	cgno = ufs_dtog(uspi, fragment);
 	bit = ufs_dtogd(uspi, fragment);
@@ -118,12 +118,12 @@ void ufs_free_fragments(struct inode *in
 		ubh_sync_block(UCPI_UBH(ucpi));
 	ufs_mark_sb_dirty(sb);
 	
-	unlock_super (sb);
+	mutex_unlock(&UFS_SB(sb)->s_lock);
 	UFSD("EXIT\n");
 	return;
 
 failed:
-	unlock_super (sb);
+	mutex_unlock(&UFS_SB(sb)->s_lock);
 	UFSD("EXIT (FAILED)\n");
 	return;
 }
@@ -155,7 +155,7 @@ void ufs_free_blocks(struct inode *inode
 		goto failed;
 	}
 
-	lock_super(sb);
+	mutex_lock(&UFS_SB(sb)->s_lock);
 	
 do_more:
 	overflow = 0;
@@ -215,12 +215,12 @@ do_more:
 	}
 
 	ufs_mark_sb_dirty(sb);
-	unlock_super (sb);
+	mutex_unlock(&UFS_SB(sb)->s_lock);
 	UFSD("EXIT\n");
 	return;
 
 failed_unlock:
-	unlock_super (sb);
+	mutex_unlock(&UFS_SB(sb)->s_lock);
 failed:
 	UFSD("EXIT (FAILED)\n");
 	return;
@@ -361,7 +361,7 @@ u64 ufs_new_fragments(struct inode *inod
 	usb1 = ubh_get_usb_first(uspi);
 	*err = -ENOSPC;
 
-	lock_super (sb);
+	mutex_lock(&UFS_SB(sb)->s_lock);
 	tmp = ufs_data_ptr_to_cpu(sb, p);
 
 	if (count + ufs_fragnum(fragment) > uspi->s_fpb) {
@@ -382,19 +382,19 @@ u64 ufs_new_fragments(struct inode *inod
 				  "fragment %llu, tmp %llu\n",
 				  (unsigned long long)fragment,
 				  (unsigned long long)tmp);
-			unlock_super(sb);
+			mutex_unlock(&UFS_SB(sb)->s_lock);
 			return INVBLOCK;
 		}
 		if (fragment < UFS_I(inode)->i_lastfrag) {
 			UFSD("EXIT (ALREADY ALLOCATED)\n");
-			unlock_super (sb);
+			mutex_unlock(&UFS_SB(sb)->s_lock);
 			return 0;
 		}
 	}
 	else {
 		if (tmp) {
 			UFSD("EXIT (ALREADY ALLOCATED)\n");
-			unlock_super(sb);
+			mutex_unlock(&UFS_SB(sb)->s_lock);
 			return 0;
 		}
 	}
@@ -403,7 +403,7 @@ u64 ufs_new_fragments(struct inode *inod
 	 * There is not enough space for user on the device
 	 */
 	if (!capable(CAP_SYS_RESOURCE) && ufs_freespace(uspi, UFS_MINFREE) <= 0) {
-		unlock_super (sb);
+		mutex_unlock(&UFS_SB(sb)->s_lock);
 		UFSD("EXIT (FAILED)\n");
 		return 0;
 	}
@@ -428,7 +428,7 @@ u64 ufs_new_fragments(struct inode *inod
 			ufs_clear_frags(inode, result + oldcount,
 					newcount - oldcount, locked_page != NULL);
 		}
-		unlock_super(sb);
+		mutex_unlock(&UFS_SB(sb)->s_lock);
 		UFSD("EXIT, result %llu\n", (unsigned long long)result);
 		return result;
 	}
@@ -443,7 +443,7 @@ u64 ufs_new_fragments(struct inode *inod
 						fragment + count);
 		ufs_clear_frags(inode, result + oldcount, newcount - oldcount,
 				locked_page != NULL);
-		unlock_super(sb);
+		mutex_unlock(&UFS_SB(sb)->s_lock);
 		UFSD("EXIT, result %llu\n", (unsigned long long)result);
 		return result;
 	}
@@ -481,7 +481,7 @@ u64 ufs_new_fragments(struct inode *inod
 		*err = 0;
 		UFS_I(inode)->i_lastfrag = max(UFS_I(inode)->i_lastfrag,
 						fragment + count);
-		unlock_super(sb);
+		mutex_unlock(&UFS_SB(sb)->s_lock);
 		if (newcount < request)
 			ufs_free_fragments (inode, result + newcount, request - newcount);
 		ufs_free_fragments (inode, tmp, oldcount);
@@ -489,7 +489,7 @@ u64 ufs_new_fragments(struct inode *inod
 		return result;
 	}
 
-	unlock_super(sb);
+	mutex_unlock(&UFS_SB(sb)->s_lock);
 	UFSD("EXIT (FAILED)\n");
 	return 0;
 }		
diff -Nurp linux-3.6-rc1-orig/fs/ufs/ialloc.c linux-3.6-rc1/fs/ufs/ialloc.c
--- linux-3.6-rc1-orig/fs/ufs/ialloc.c	2012-08-16 09:37:36.000000000 +0200
+++ linux-3.6-rc1/fs/ufs/ialloc.c	2012-08-16 10:27:38.000000000 +0200
@@ -71,11 +71,11 @@ void ufs_free_inode (struct inode * inod
 	
 	ino = inode->i_ino;
 
-	lock_super (sb);
+	mutex_lock(&UFS_SB(sb)->s_lock);
 
 	if (!((ino > 1) && (ino < (uspi->s_ncg * uspi->s_ipg )))) {
 		ufs_warning(sb, "ufs_free_inode", "reserved inode or nonexistent inode %u\n", ino);
-		unlock_super (sb);
+		mutex_unlock(&UFS_SB(sb)->s_lock);
 		return;
 	}
 	
@@ -83,7 +83,7 @@ void ufs_free_inode (struct inode * inod
 	bit = ufs_inotocgoff (ino);
 	ucpi = ufs_load_cylinder (sb, cg);
 	if (!ucpi) {
-		unlock_super (sb);
+		mutex_unlock(&UFS_SB(sb)->s_lock);
 		return;
 	}
 	ucg = ubh_get_ucg(UCPI_UBH(ucpi));
@@ -117,7 +117,7 @@ void ufs_free_inode (struct inode * inod
 		ubh_sync_block(UCPI_UBH(ucpi));
 	
 	ufs_mark_sb_dirty(sb);
-	unlock_super (sb);
+	mutex_unlock(&UFS_SB(sb)->s_lock);
 	UFSD("EXIT\n");
 }
 
@@ -197,7 +197,7 @@ struct inode *ufs_new_inode(struct inode
 	uspi = sbi->s_uspi;
 	usb1 = ubh_get_usb_first(uspi);
 
-	lock_super (sb);
+	mutex_lock(&sbi->s_lock);
 
 	/*
 	 * Try to place the inode in its parent directory
@@ -333,20 +333,20 @@ cg_found:
 		brelse(bh);
 	}
 
-	unlock_super (sb);
+	mutex_unlock(&sbi->s_lock);
 
 	UFSD("allocating inode %lu\n", inode->i_ino);
 	UFSD("EXIT\n");
 	return inode;
 
 fail_remove_inode:
-	unlock_super(sb);
+	mutex_unlock(&sbi->s_lock);
 	clear_nlink(inode);
 	iput(inode);
 	UFSD("EXIT (FAILED): err %d\n", err);
 	return ERR_PTR(err);
 failed:
-	unlock_super (sb);
+	mutex_unlock(&sbi->s_lock);
 	make_bad_inode(inode);
 	iput (inode);
 	UFSD("EXIT (FAILED): err %d\n", err);
diff -Nurp linux-3.6-rc1-orig/fs/ufs/super.c linux-3.6-rc1/fs/ufs/super.c
--- linux-3.6-rc1-orig/fs/ufs/super.c	2012-08-16 09:37:36.000000000 +0200
+++ linux-3.6-rc1/fs/ufs/super.c	2012-08-16 11:18:38.000000000 +0200
@@ -699,7 +699,7 @@ static int ufs_sync_fs(struct super_bloc
 	unsigned flags;
 
 	lock_ufs(sb);
-	lock_super(sb);
+	mutex_lock(&UFS_SB(sb)->s_lock);
 
 	UFSD("ENTER\n");
 
@@ -717,7 +717,7 @@ static int ufs_sync_fs(struct super_bloc
 	ufs_put_cstotal(sb);
 
 	UFSD("EXIT\n");
-	unlock_super(sb);
+	mutex_unlock(&UFS_SB(sb)->s_lock);
 	unlock_ufs(sb);
 
 	return 0;
@@ -805,6 +805,7 @@ static int ufs_fill_super(struct super_b
 	}
 #endif
 	mutex_init(&sbi->mutex);
+	mutex_init(&sbi->s_lock);
 	spin_lock_init(&sbi->work_lock);
 	INIT_DELAYED_WORK(&sbi->sync_work, delayed_sync_fs);
 	/*
@@ -1280,7 +1281,7 @@ static int ufs_remount (struct super_blo
 	unsigned flags;
 
 	lock_ufs(sb);
-	lock_super(sb);
+	mutex_lock(&UFS_SB(sb)->s_lock);
 	uspi = UFS_SB(sb)->s_uspi;
 	flags = UFS_SB(sb)->s_flags;
 	usb1 = ubh_get_usb_first(uspi);
@@ -1294,7 +1295,7 @@ static int ufs_remount (struct super_blo
 	new_mount_opt = 0;
 	ufs_set_opt (new_mount_opt, ONERROR_LOCK);
 	if (!ufs_parse_options (data, &new_mount_opt)) {
-		unlock_super(sb);
+		mutex_unlock(&UFS_SB(sb)->s_lock);
 		unlock_ufs(sb);
 		return -EINVAL;
 	}
@@ -1302,14 +1303,14 @@ static int ufs_remount (struct super_blo
 		new_mount_opt |= ufstype;
 	} else if ((new_mount_opt & UFS_MOUNT_UFSTYPE) != ufstype) {
 		printk("ufstype can't be changed during remount\n");
-		unlock_super(sb);
+		mutex_unlock(&UFS_SB(sb)->s_lock);
 		unlock_ufs(sb);
 		return -EINVAL;
 	}
 
 	if ((*mount_flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY)) {
 		UFS_SB(sb)->s_mount_opt = new_mount_opt;
-		unlock_super(sb);
+		mutex_unlock(&UFS_SB(sb)->s_lock);
 		unlock_ufs(sb);
 		return 0;
 	}
@@ -1334,7 +1335,7 @@ static int ufs_remount (struct super_blo
 #ifndef CONFIG_UFS_FS_WRITE
 		printk("ufs was compiled with read-only support, "
 		"can't be mounted as read-write\n");
-		unlock_super(sb);
+		mutex_unlock(&UFS_SB(sb)->s_lock);
 		unlock_ufs(sb);
 		return -EINVAL;
 #else
@@ -1344,13 +1345,13 @@ static int ufs_remount (struct super_blo
 		    ufstype != UFS_MOUNT_UFSTYPE_SUNx86 &&
 		    ufstype != UFS_MOUNT_UFSTYPE_UFS2) {
 			printk("this ufstype is read-only supported\n");
-			unlock_super(sb);
+			mutex_unlock(&UFS_SB(sb)->s_lock);
 			unlock_ufs(sb);
 			return -EINVAL;
 		}
 		if (!ufs_read_cylinder_structures(sb)) {
 			printk("failed during remounting\n");
-			unlock_super(sb);
+			mutex_unlock(&UFS_SB(sb)->s_lock);
 			unlock_ufs(sb);
 			return -EPERM;
 		}
@@ -1358,7 +1359,7 @@ static int ufs_remount (struct super_blo
 #endif
 	}
 	UFS_SB(sb)->s_mount_opt = new_mount_opt;
-	unlock_super(sb);
+	mutex_unlock(&UFS_SB(sb)->s_lock);
 	unlock_ufs(sb);
 	return 0;
 }
diff -Nurp linux-3.6-rc1-orig/fs/ufs/ufs.h linux-3.6-rc1/fs/ufs/ufs.h
--- linux-3.6-rc1-orig/fs/ufs/ufs.h	2012-08-16 09:37:36.000000000 +0200
+++ linux-3.6-rc1/fs/ufs/ufs.h	2012-08-16 10:24:05.000000000 +0200
@@ -24,6 +24,7 @@ struct ufs_sb_info {
 	int work_queued; /* non-zero if the delayed work is queued */
 	struct delayed_work sync_work; /* FS sync delayed work */
 	spinlock_t work_lock; /* protects sync_work and work_queued */
+	struct mutex s_lock;
 };
 
 struct ufs_inode_info {


