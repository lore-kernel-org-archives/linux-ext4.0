From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: use s_extent_max_zeroout_kb value as number of kb
Date: Tue, 12 Mar 2013 17:36:49 +0100
Message-ID: <1363106209-1883-1-git-send-email-lczerner@redhat.com>
Cc: wenqing.lz@taobao.com, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab3CLQg6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Mar 2013 12:36:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently when converting extent to initialized, we have to decide
whether to zeroout part/all of the uninitialized extent in order to
avoid extent tree growing rapidly.

The decision is made by comparing the size of the extent with the
configurable value s_extent_max_zeroout_kb which is in kibibytes units.

However when converting it to number of blocks we currently use it as it
was in bytes. This is obviously bug and it will result in ext4 _never_
zeroout extents, but rather always split and convert parts to
initialized while leaving the rest uninitialized in default setting.

Fix this by using s_extent_max_zeroout_kb as kibibytes.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index cac80120..aeb80bc 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3227,7 +3227,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 
 	if (EXT4_EXT_MAY_ZEROOUT & split_flag)
 		max_zeroout = sbi->s_extent_max_zeroout_kb >>
-			inode->i_sb->s_blocksize_bits;
+			(inode->i_sb->s_blocksize_bits - 10);
 
 	/* If extent is less than s_max_zeroout_kb, zeroout directly */
 	if (max_zeroout && (ee_len <= max_zeroout)) {
-- 
1.7.7.6

