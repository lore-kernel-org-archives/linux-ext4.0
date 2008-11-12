From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: [RFC PATCH 09/17] Add progress bar for allocating block tables - takes forever on large
Date: Tue, 11 Nov 2008 19:43:02 -0800
Message-ID: <1226461390-5502-10-git-send-email-vaurora@redhat.com>
References: <1226461390-5502-1-git-send-email-vaurora@redhat.com>
 <1226461390-5502-2-git-send-email-vaurora@redhat.com>
 <1226461390-5502-3-git-send-email-vaurora@redhat.com>
 <1226461390-5502-4-git-send-email-vaurora@redhat.com>
 <1226461390-5502-5-git-send-email-vaurora@redhat.com>
 <1226461390-5502-6-git-send-email-vaurora@redhat.com>
 <1226461390-5502-7-git-send-email-vaurora@redhat.com>
 <1226461390-5502-8-git-send-email-vaurora@redhat.com>
 <1226461390-5502-9-git-send-email-vaurora@redhat.com>
Cc: Valerie Aurora Henson <vaurora@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42469 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbYKLDn5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Nov 2008 22:43:57 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mAC3hvER007449
	for <linux-ext4@vger.kernel.org>; Tue, 11 Nov 2008 22:43:57 -0500
In-Reply-To: <1226461390-5502-9-git-send-email-vaurora@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Valerie Aurora Henson <vaurora@redhat.com>
---
 misc/mke2fs.c               |   25 ++++++++++++++++++++++++-
 tests/f_resize_inode/expect |    1 +
 tests/m_dasd_bs/expect.1    |    1 +
 tests/m_large_file/expect.1 |    1 +
 tests/m_meta_bg/expect.1    |    1 +
 tests/m_no_opt/expect.1     |    1 +
 tests/m_raid_opt/expect.1   |    1 +
 tests/m_std/expect.1        |    1 +
 tests/m_uninit/expect.1     |    1 +
 9 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 4509c1a..a3388f6 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1833,6 +1833,29 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 	return retval;
 }
 
+static errcode_t ext2fs_allocate_tables_with_progress(ext2_filsys fs)
+{
+	errcode_t	retval;
+	dgrp_t		i;
+	struct progress_struct progress;
+
+	if (quiet)
+		memset(&progress, 0, sizeof(progress));
+	else
+		progress_init(&progress, _("Allocating group tables: "),
+			      fs->group_desc_count);
+
+	for (i = 0; i < fs->group_desc_count; i++) {
+		progress_update(&progress, i);
+		retval = ext2fs_allocate_group_table(fs, i, (ext2fs_block_bitmap64) fs->block_map);
+		if (retval)
+			return retval;
+	}
+	progress_close(&progress);
+
+	return 0;
+}
+
 int main (int argc, char *argv[])
 {
 	errcode_t	retval = 0;
@@ -1963,7 +1986,7 @@ int main (int argc, char *argv[])
 
 	handle_bad_blocks(fs, bb_list);
 	fs->stride = fs_stride = fs->super->s_raid_stride;
-	retval = ext2fs_allocate_tables(fs);
+	retval = ext2fs_allocate_tables_with_progress(fs);
 	if (retval) {
 		com_err(program_name, retval,
 			_("while trying to allocate filesystem tables"));
diff --git a/tests/f_resize_inode/expect b/tests/f_resize_inode/expect
index bd45575..c40deea 100644
--- a/tests/f_resize_inode/expect
+++ b/tests/f_resize_inode/expect
@@ -13,6 +13,7 @@ Maximum filesystem blocks=8421376
 Superblock backups stored on blocks: 
 	1025, 3073, 5121, 7169, 9217
 
+Allocating group tables:  0/16 1/16 2/16 3/16 4/16 5/16 6/16 7/16 8/16 9/1610/1611/1612/1613/1614/1615/16done                            
 Writing inode tables:  0/16 1/16 2/16 3/16 4/16 5/16 6/16 7/16 8/16 9/1610/1611/1612/1613/1614/1615/16done                            
 Writing superblocks and filesystem accounting information: done
 
diff --git a/tests/m_dasd_bs/expect.1 b/tests/m_dasd_bs/expect.1
index 59fc457..5cd3813 100644
--- a/tests/m_dasd_bs/expect.1
+++ b/tests/m_dasd_bs/expect.1
@@ -12,6 +12,7 @@ Maximum filesystem blocks=33554432
 Superblock backups stored on blocks: 
 	16384
 
+Allocating group tables: done                            
 Writing inode tables: done                            
 Writing superblocks and filesystem accounting information: done
 
diff --git a/tests/m_large_file/expect.1 b/tests/m_large_file/expect.1
index ae27f02..90a0940 100644
--- a/tests/m_large_file/expect.1
+++ b/tests/m_large_file/expect.1
@@ -10,6 +10,7 @@ Maximum filesystem blocks=16777216
 32768 blocks per group, 32768 fragments per group
 64 inodes per group
 
+Allocating group tables: done                            
 Writing inode tables: done                            
 Writing superblocks and filesystem accounting information: done
 
diff --git a/tests/m_meta_bg/expect.1 b/tests/m_meta_bg/expect.1
index 7401fd9..95021e2 100644
--- a/tests/m_meta_bg/expect.1
+++ b/tests/m_meta_bg/expect.1
@@ -11,6 +11,7 @@ First data block=1
 Superblock backups stored on blocks: 
 	1025, 3073, 5121, 7169, 9217, 25601, 27649, 50177, 82945, 128001
 
+Allocating group tables: done                            
 Writing inode tables: done                            
 Writing superblocks and filesystem accounting information: done
 
diff --git a/tests/m_no_opt/expect.1 b/tests/m_no_opt/expect.1
index a63358b..c268b63 100644
--- a/tests/m_no_opt/expect.1
+++ b/tests/m_no_opt/expect.1
@@ -11,6 +11,7 @@ First data block=1
 Superblock backups stored on blocks: 
 	8193, 16385, 24577, 32769, 40961, 49153, 57345
 
+Allocating group tables: done                            
 Writing inode tables: done                            
 Writing superblocks and filesystem accounting information: done
 
diff --git a/tests/m_raid_opt/expect.1 b/tests/m_raid_opt/expect.1
index f3c14b6..c99116b 100644
--- a/tests/m_raid_opt/expect.1
+++ b/tests/m_raid_opt/expect.1
@@ -12,6 +12,7 @@ Maximum filesystem blocks=8519680
 Superblock backups stored on blocks: 
 	1025, 3073, 5121, 7169, 9217, 25601, 27649, 50177, 82945, 128001
 
+Allocating group tables: done                            
 Writing inode tables: done                            
 Writing superblocks and filesystem accounting information: done
 
diff --git a/tests/m_std/expect.1 b/tests/m_std/expect.1
index 9f5e66e..c9ff315 100644
--- a/tests/m_std/expect.1
+++ b/tests/m_std/expect.1
@@ -12,6 +12,7 @@ Maximum filesystem blocks=67108864
 Superblock backups stored on blocks: 
 	8193, 24577, 40961, 57345
 
+Allocating group tables: done                            
 Writing inode tables: done                            
 Writing superblocks and filesystem accounting information: done
 
diff --git a/tests/m_uninit/expect.1 b/tests/m_uninit/expect.1
index 02649d8..7419ecf 100644
--- a/tests/m_uninit/expect.1
+++ b/tests/m_uninit/expect.1
@@ -12,6 +12,7 @@ Maximum filesystem blocks=67371008
 Superblock backups stored on blocks: 
 	8193, 24577, 40961, 57345, 73729
 
+Allocating group tables: done                            
 Writing inode tables: done                            
 Writing superblocks and filesystem accounting information: done
 
-- 
1.5.6.5

