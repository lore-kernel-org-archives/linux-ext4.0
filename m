Return-Path: <SRS0=/GAa=M3=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37482 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbeJPE70 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Oct 2018 00:59:26 -0400
From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH e2fsprogs 1/9] e2fsprogs: Add timestamp extension bits to superblock
Date: Mon, 15 Oct 2018 17:12:12 -0400
Message-Id: <20181015211220.27370-2-krisman@collabora.co.uk>
In-Reply-To: <20181015211220.27370-1-krisman@collabora.co.uk>
References: <20181015211220.27370-1-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Re-sync the superblock structure declaration with its kernel counterpart
to include the fields added by kernel commit 6a0678a79bb3 ("ext4: super:
extend timestamps to 40 bits")

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 lib/ext2fs/ext2_fs.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 13c2c20e5c42..ab2595486d21 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -748,7 +748,14 @@ struct ext2_super_block {
 /*268*/	__le32	s_lpf_ino;		/* Location of the lost+found inode */
 	__le32  s_prj_quota_inum;	/* inode for tracking project quota */
 /*270*/	__le32	s_checksum_seed;	/* crc32c(orig_uuid) if csum_seed set */
-	__le32	s_reserved[98];		/* Padding to the end of the block */
+/*274*/	__u8	s_wtime_hi;
+	__u8	s_mtime_hi;
+	__u8	s_mkfs_time_hi;
+	__u8	s_lastcheck_hi;
+	__u8	s_first_error_time_hi;
+	__u8	s_last_error_time_hi;
+	__u8	s_pad[2];
+	__le32	s_reserved[96];		/* Padding to the end of the block */
 /*3fc*/	__u32	s_checksum;		/* crc32c(superblock) */
 };
 
-- 
2.19.1
