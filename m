From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] mke2fs: check extents feature when bigalloc feature is enabled
Date: Sun,  6 Jan 2013 20:25:17 +0800
Message-ID: <1357475117-5095-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33954 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab3AFMLg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Jan 2013 07:11:36 -0500
Received: by mail-pa0-f51.google.com with SMTP id fb11so10180159pad.10
        for <linux-ext4@vger.kernel.org>; Sun, 06 Jan 2013 04:11:36 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

When bigalloc feature is enabled in mkfs, extents feature also needs to be
enabled.  But now when bigalloc feature is enabled without extents feature,
users will not get any warning messages until they try to mount this file
system.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 misc/mke2fs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index a288147..713eb21 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1988,6 +1988,15 @@ profile_error:
 		fs_param.s_feature_ro_compat &=
 				~EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
 
+	/* Can't support bigalloc feature without extents feature */
+	if ((fs_param.s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_BIGALLOC) &&
+	    !(fs_param.s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS)) {
+		com_err(program_name, 0,
+			_("Can't support bigalloc feature without "
+			  "extents feature"));
+		exit(1);
+	}
+
 	/* Since sparse_super is the default, we would only have a problem
 	 * here if it was explicitly disabled.
 	 */
-- 
1.7.12.rc2.18.g61b472e

