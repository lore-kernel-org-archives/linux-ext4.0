From: Eric Sandeen <sandeen@redhat.com>
Subject: [RFC][PATCH] process orphan list if device transitions to readonly
Date: Wed, 06 Dec 2006 17:37:51 -0600
Message-ID: <4577544F.5080900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937806AbWLFXh4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Dec 2006 18:37:56 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id kB6Nbtxu001709
	for <linux-ext4@vger.kernel.org>; Wed, 6 Dec 2006 18:37:55 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id kB6NbtdF018221
	for <linux-ext4@vger.kernel.org>; Wed, 6 Dec 2006 18:37:55 -0500
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id kB6NbqXL018862
	for <linux-ext4@vger.kernel.org>; Wed, 6 Dec 2006 18:37:54 -0500
To: ext4 development <linux-ext4@vger.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I have a patch in -mm now to skip orphan inode processing on a read-only
device (where IO may fail if issued), but Stephen points out that if
the device ever transitions back to readwrite, and the filesystem is
remounted as rewrite, we should process the orphan inode list at that point.

Today, I'm not sure how we can easily get into this situation - for example,
lvm apparently cannot transform a RO snapshot into RW.  But it is at least
possible to do this.  For example I tested by:

create orphan list
crash
mark block device RO via BLKROSET
mount fs RO
mark block device RW via BLKROSET
remount fs RW

so it's within the realm of possibility, certainly.

here's what I came up with; I'm not very pleased with it though, but I need
some way to let ext3_orphan_del know that the sb is already locked and it's
safe to do this orphan processing w/o re-taking it, so I added a state flag...

Comments?

Thanks,

-Eric

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: linux-2.6.19/fs/ext3/namei.c
===================================================================
--- linux-2.6.19.orig/fs/ext3/namei.c
+++ linux-2.6.19/fs/ext3/namei.c
@@ -1942,15 +1942,15 @@ int ext3_orphan_del(handle_t *handle, st
 	struct ext3_iloc iloc;
 	int err = 0;
 
-	lock_super(inode->i_sb);
-	if (list_empty(&ei->i_orphan)) {
-		unlock_super(inode->i_sb);
-		return 0;
-	}
+	sbi = EXT3_SB(inode->i_sb);
+	if (!(sbi->s_mount_state & EXT3_REMOUNTING_FS))
+		lock_super(inode->i_sb);
+
+	if (list_empty(&ei->i_orphan))
+		goto out;
 
 	ino_next = NEXT_ORPHAN(inode);
 	prev = ei->i_orphan.prev;
-	sbi = EXT3_SB(inode->i_sb);
 
 	jbd_debug(4, "remove inode %lu from orphan list\n", inode->i_ino);
 
@@ -1996,7 +1996,8 @@ int ext3_orphan_del(handle_t *handle, st
 out_err:
 	ext3_std_error(inode->i_sb, err);
 out:
-	unlock_super(inode->i_sb);
+	if (!(sbi->s_mount_state & EXT3_REMOUNTING_FS))
+		unlock_super(inode->i_sb);
 	return err;
 
 out_brelse:
Index: linux-2.6.19/fs/ext3/super.c
===================================================================
--- linux-2.6.19.orig/fs/ext3/super.c
+++ linux-2.6.19/fs/ext3/super.c
@@ -2358,6 +2358,10 @@ static int ext3_remount (struct super_bl
 				goto restore_opts;
 			if (!ext3_setup_super (sb, es, 0))
 				sb->s_flags &= ~MS_RDONLY;
+			EXT3_SB(sb)->s_mount_state |= (EXT3_ORPHAN_FS|EXT3_REMOUNTING_FS);
+			ext3_orphan_cleanup(sb, es);
+			EXT3_SB(sb)->s_mount_state &= ~(EXT3_ORPHAN_FS|EXT3_REMOUNTING_FS);
+
 		}
 	}
 #ifdef CONFIG_QUOTA
Index: linux-2.6.19/include/linux/ext3_fs.h
===================================================================
--- linux-2.6.19.orig/include/linux/ext3_fs.h
+++ linux-2.6.19/include/linux/ext3_fs.h
@@ -356,6 +356,7 @@ struct ext3_inode {
 #define	EXT3_VALID_FS			0x0001	/* Unmounted cleanly */
 #define	EXT3_ERROR_FS			0x0002	/* Errors detected */
 #define	EXT3_ORPHAN_FS			0x0004	/* Orphans being recovered */
+#define	EXT3_REMOUNTING_FS		0x0008	/* Filesystem remounting, sb locked */
 
 /*
  * Mount flags
