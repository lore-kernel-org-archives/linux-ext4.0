Return-Path: <SRS0=zKcc=NK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail2-drop-p4.anu.edu.au ([130.56.64.42]:54586 "EHLO
        mail2-drop-p4.anu.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbeJ3PNN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Oct 2018 11:13:13 -0400
From: Li Dongyang <dongyangli@ddn.com>
To: linux-ext4@vger.kernel.org
Cc: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] e2fsck: check xattr 'system.data' before setting inline_data feature
Date: Tue, 30 Oct 2018 17:15:01 +1100
Message-Id: <20181030061501.24406-1-dongyangli@ddn.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2fs_inline_data_size will happy return 0 and set size to
EXT4_MIN_INLINE_DATA_SIZE even when inode doesn't have
xattr 'system.data', a corrupted i_flags could make e2fsck
enable the inline_data on the superblock.

We should only offer to enable inline_data when i_flags is set
and xattr 'system.data' can be found.

Signed-off-by: Li Dongyang <dongyangli@ddn.com>
---
 e2fsck/pass1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 8abf0c33..45534388 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1496,8 +1496,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 		    (ino >= EXT2_FIRST_INODE(fs->super))) {
 			size_t size = 0;
 
-			pctx.errcode = ext2fs_inline_data_size(fs, ino, &size);
-			if (!pctx.errcode && size &&
+			pctx.errcode = get_inline_data_ea_size(fs, ino, &size);
+			if (!pctx.errcode &&
 			    fix_problem(ctx, PR_1_INLINE_DATA_FEATURE, &pctx)) {
 				ext2fs_set_feature_inline_data(sb);
 				ext2fs_mark_super_dirty(fs);
-- 
2.19.1
