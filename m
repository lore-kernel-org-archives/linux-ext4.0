From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 02/36 v4] mke2fs: make it support inline data feature
Date: Tue, 31 Jul 2012 19:47:55 +0800
Message-ID: <1343735309-30579-3-git-send-email-wenqing.lz@taobao.com>
References: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:54597 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab2GaLjv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2012 07:39:51 -0400
Received: by ghrr11 with SMTP id r11so5889814ghr.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 Jul 2012 04:39:51 -0700 (PDT)
In-Reply-To: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
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
index 9564e81..13c3634 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -883,7 +883,8 @@ static __u32 ok_features[3] = {
 		EXT2_FEATURE_INCOMPAT_META_BG|
 		EXT4_FEATURE_INCOMPAT_FLEX_BG|
 		EXT4_FEATURE_INCOMPAT_MMP |
-		EXT4_FEATURE_INCOMPAT_64BIT,
+		EXT4_FEATURE_INCOMPAT_64BIT|
+		EXT4_FEATURE_INCOMPAT_INLINE_DATA,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE|
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -1956,6 +1957,13 @@ profile_error:
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

