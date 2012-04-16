From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 02/32] mke2fs: make it support inline data feature
Date: Mon, 16 Apr 2012 19:39:37 +0800
Message-ID: <1334576407-4007-3-git-send-email-wenqing.lz@taobao.com>
References: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43674 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab2DPLdz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Apr 2012 07:33:55 -0400
Received: by mail-pb0-f46.google.com with SMTP id un15so6233785pbc.19
        for <linux-ext4@vger.kernel.org>; Mon, 16 Apr 2012 04:33:55 -0700 (PDT)
In-Reply-To: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

EXT2_FEATURE_COMPAT_EXT_ATTR flag will be set when inline_data is set
because inline data feature depends on it.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 misc/mke2fs.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 7ec8cc2..145a6a8 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -856,7 +856,8 @@ static __u32 ok_features[3] = {
 		EXT2_FEATURE_INCOMPAT_META_BG|
 		EXT4_FEATURE_INCOMPAT_FLEX_BG|
 		EXT4_FEATURE_INCOMPAT_MMP |
-		EXT4_FEATURE_INCOMPAT_64BIT,
+		EXT4_FEATURE_INCOMPAT_64BIT|
+		EXT4_FEATURE_INCOMPAT_INLINE_DATA,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE|
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -1922,6 +1923,13 @@ profile_error:
 		exit(1);
 	}
 
+	/* if inline_data is set, ext_attr would be set because inline_data
+	 * depends on it.
+	 */
+	if ((fs_param.s_feature_incompat & EXT4_FEATURE_INCOMPAT_INLINE_DATA) &&
+	    !(fs_param.s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR))
+		fs_param.s_feature_compat |= EXT2_FEATURE_COMPAT_EXT_ATTR;
+
 	if (fs_param.s_blocks_per_group) {
 		if (fs_param.s_blocks_per_group < 256 ||
 		    fs_param.s_blocks_per_group > 8 * (unsigned) blocksize) {
-- 
1.7.4.1

