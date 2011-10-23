From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 2/8] e2fsprogs: add exclude bitmap support in mkfs
Date: Sun, 23 Oct 2011 15:21:22 +0800
Message-ID: <1319354488-6050-3-git-send-email-xiaoqiangnk@gmail.com>
References: <1319354488-6050-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: amir73il@users.sf.net, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58496 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab1JWJK5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Oct 2011 05:10:57 -0400
Received: by mail-iy0-f174.google.com with SMTP id y12so71200iab.19
        for <linux-ext4@vger.kernel.org>; Sun, 23 Oct 2011 02:10:57 -0700 (PDT)
In-Reply-To: <1319354488-6050-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Exclude bitmap is needed by ext4 snapshot. This patch adds
exclude bitmap support in mkfs.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 misc/mke2fs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 3dcb3b7..2dc28e7 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -828,6 +828,7 @@ static void parse_extended_opts(struct ext2_super_block *param,
 static __u32 ok_features[3] = {
 	/* Compat */
 	EXT3_FEATURE_COMPAT_HAS_JOURNAL |
+		EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP |
 		EXT2_FEATURE_COMPAT_RESIZE_INODE |
 		EXT2_FEATURE_COMPAT_DIR_INDEX |
 		EXT2_FEATURE_COMPAT_EXT_ATTR,
-- 
1.7.5.1

