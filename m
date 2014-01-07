From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 02/10] libext2fs: make ext2fs_group_desc_csum return 0 if meta_csum not enabled
Date: Tue,  7 Jan 2014 09:53:06 -0500
Message-ID: <1389106394-31898-2-git-send-email-tytso@mit.edu>
References: <1389106394-31898-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46591 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbaAGOxV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jan 2014 09:53:21 -0500
In-Reply-To: <1389106394-31898-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Addresses-Coverity-Id: #1147784

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/csum.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index b681d34..6989880 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -36,7 +36,7 @@ __u16 ext2fs_group_desc_csum(ext2_filsys fs, dgrp_t group)
 							 group);
 	size_t size = EXT2_DESC_SIZE(fs->super);
 	size_t offset;
-	__u16 crc;
+	__u16 crc = 0;
 
 	if (fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
 		size_t offset = offsetof(struct ext2_group_desc, bg_checksum);
-- 
1.8.5.rc3.362.gdf10213

