From: Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH] ext3: sreadahead hooks
Date: Tue, 14 Oct 2008 10:17:35 -0400
Message-ID: <20081014101735.04107779@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:47210 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbYJNORg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Oct 2008 10:17:36 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


>From 3d7a0ca0ee8a755251251bd9ddca0866c25acdc2 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 14 Oct 2008 10:12:08 -0400
Subject: [PATCH] ext3: sreadahead hooks

The sreadahead program, used to make the OS boot faster, needs to know in
the approximate order in files are used during the boot process. This patch
adds the ext3 hook for this functionality, basically it stores "jiffies"
into the inode at allocation time, and exposes it via an EXT3 ioctl (yes I
know but ioctl seems fitting for this).

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 fs/ext3/ioctl.c           |    3 +++
 fs/ext3/super.c           |    1 +
 include/linux/ext3_fs.h   |    1 +
 include/linux/ext3_fs_i.h |    2 ++
 4 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/ioctl.c b/fs/ext3/ioctl.c
index 0d0c701..b196f71 100644
--- a/fs/ext3/ioctl.c
+++ b/fs/ext3/ioctl.c
@@ -286,6 +286,9 @@ group_add_out:
 		mnt_drop_write(filp->f_path.mnt);
 		return err;
 	}
+	case EXT3_IOC_INODE_JIFFIES: {
+		return ei->created_when;
+	}
 
 
 	default:
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index f38a5af..c2c83dd 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -456,6 +456,7 @@ static struct inode *ext3_alloc_inode(struct super_block *sb)
 #endif
 	ei->i_block_alloc_info = NULL;
 	ei->vfs_inode.i_version = 1;
+	ei->created_when = jiffies;
 	return &ei->vfs_inode;
 }
 
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 8120fa1..d1ba6b8 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -225,6 +225,7 @@ struct ext3_new_group_data {
 #endif
 #define EXT3_IOC_GETRSVSZ		_IOR('f', 5, long)
 #define EXT3_IOC_SETRSVSZ		_IOW('f', 6, long)
+#define EXT3_IOC_INODE_JIFFIES		_IOR('f', 19, long)
 
 /*
  * ioctl commands in 32 bit emulation
diff --git a/include/linux/ext3_fs_i.h b/include/linux/ext3_fs_i.h
index 7894dd0..87d512a 100644
--- a/include/linux/ext3_fs_i.h
+++ b/include/linux/ext3_fs_i.h
@@ -141,6 +141,8 @@ struct ext3_inode_info {
 	 * by other means, so we have truncate_mutex.
 	 */
 	struct mutex truncate_mutex;
+	unsigned long		created_when; /* jiffies of creation time */	
+
 	struct inode vfs_inode;
 };
 
-- 
1.5.5.1


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
