From: Tao Ma <tm@tao.ma>
Subject: [PATCH V2] ext4: Protect group inode free counting with group lock.
Date: Thu, 17 May 2012 15:35:39 +0800
Message-ID: <1337240139-5005-1-git-send-email-tm@tao.ma>
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:36024 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761292Ab2EQHfu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 May 2012 03:35:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Now when we set the group inode free count, we don't have a proper
group lock so that multiple threads may decrease the inode free
count at the same time. And e2fsck will complain something like:

Free inodes count wrong for group #1 (1, counted=0).
Fix? no

Free inodes count wrong for group #2 (3, counted=0).
Fix? no

Directories count wrong for group #2 (780, counted=779).
Fix? no

Free inodes count wrong for group #3 (2272, counted=2273).
Fix? no

So this patch try to protect it with the ext4_lock_group.

btw, it is found by xfstests test case 269 and the volume is
mkfsed with the parameter
"-O ^resize_inode,^uninit_bg,extent,meta_bg,flex_bg,ext_attr"
and I have run it 100 times and the error in e2fsck doesn't
show up again.

Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/ialloc.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 409c2ee..ca533d7 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -772,7 +772,10 @@ got:
 			ext4_itable_unused_set(sb, gdp,
 					(EXT4_INODES_PER_GROUP(sb) - ino));
 		up_read(&grp->alloc_sem);
+	} else {
+		ext4_lock_group(sb, group);
 	}
+
 	ext4_free_inodes_set(sb, gdp, ext4_free_inodes_count(sb, gdp) - 1);
 	if (S_ISDIR(mode)) {
 		ext4_used_dirs_set(sb, gdp, ext4_used_dirs_count(sb, gdp) + 1);
@@ -782,10 +785,9 @@ got:
 			atomic_inc(&sbi->s_flex_groups[f].used_dirs);
 		}
 	}
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
 		gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
-		ext4_unlock_group(sb, group);
-	}
+	ext4_unlock_group(sb, group);
 
 	BUFFER_TRACE(inode_bitmap_bh, "call ext4_handle_dirty_metadata");
 	err = ext4_handle_dirty_metadata(handle, NULL, inode_bitmap_bh);
-- 
1.7.1

