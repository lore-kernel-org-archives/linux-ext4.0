From: amir73il@users.sourceforge.net
Subject: [PATCH v1 12/36] ext4: snapshot file - store on disk
Date: Tue,  7 Jun 2011 18:07:39 +0300
Message-ID: <1307459283-22130-13-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60303 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab1FGPJ1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:09:27 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so3629480wya.19
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:09:27 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Snapshot inode is stored differently in memory and on disk.
During store and load of snapshot inode, some of the inode flags
and fields are converted.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/inode.c |   33 +++++++++++++++++++++++++++------
 1 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b210b33..33692fd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5183,6 +5183,17 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	 */
 	for (block = 0; block < EXT4_N_BLOCKS; block++)
 		ei->i_data[block] = raw_inode->i_block[block];
+	/* snapshot on-disk list is stored in snapshot inode on-disk version */
+	if (ext4_snapshot_file(inode)) {
+		ei->i_next_snapshot_ino =
+			le32_to_cpu(raw_inode->i_disk_version);
+		/*
+		 * snapshot volume size is stored in i_disksize.
+		 * in-memory i_size of snapshot files is set to 0 (disabled).
+		 * enabling a snapshot is setting i_size to i_disksize.
+		 */
+		inode->i_size = 0;
+	}
 	INIT_LIST_HEAD(&ei->i_orphan);
 
 	/*
@@ -5447,12 +5458,22 @@ static int ext4_do_update_inode(handle_t *handle,
 		for (block = 0; block < EXT4_N_BLOCKS; block++)
 			raw_inode->i_block[block] = ei->i_data[block];
 
-	raw_inode->i_disk_version = cpu_to_le32(inode->i_version);
-	if (ei->i_extra_isize) {
-		if (EXT4_FITS_IN_INODE(raw_inode, ei, i_version_hi))
-			raw_inode->i_version_hi =
-			cpu_to_le32(inode->i_version >> 32);
-		raw_inode->i_extra_isize = cpu_to_le16(ei->i_extra_isize);
+	if (ext4_snapshot_file(inode)) {
+		/*
+		 * Snapshot on-disk list overrides snapshot on-disk version.
+		 * Snapshot files are not writable and have a fixed version.
+		 */
+		raw_inode->i_disk_version =
+			cpu_to_le32(ei->i_next_snapshot_ino);
+	} else {
+		raw_inode->i_disk_version = cpu_to_le32(inode->i_version);
+		if (ei->i_extra_isize) {
+			if (EXT4_FITS_IN_INODE(raw_inode, ei, i_version_hi))
+				raw_inode->i_version_hi =
+					cpu_to_le32(inode->i_version >> 32);
+			raw_inode->i_extra_isize =
+				cpu_to_le16(ei->i_extra_isize);
+		}
 	}
 
 	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
-- 
1.7.4.1

