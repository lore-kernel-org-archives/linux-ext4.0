From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC][PATCH 9/9 v1] ext4: set dioread_nolock by default for extent-based files
Date: Mon, 24 Dec 2012 15:55:42 +0800
Message-ID: <1356335742-11793-10-git-send-email-wenqing.lz@taobao.com>
References: <1356335742-11793-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:32864 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab2LXHuU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Dec 2012 02:50:20 -0500
Received: by mail-pb0-f45.google.com with SMTP id mc8so3819871pbc.4
        for <linux-ext4@vger.kernel.org>; Sun, 23 Dec 2012 23:50:20 -0800 (PST)
In-Reply-To: <1356335742-11793-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

After a dio improvement had been done, we can try to set dioread_nolock by
default for extent-based files when block size is not smaller than page size.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 Documentation/filesystems/ext4.txt | 5 ++---
 fs/ext4/super.c                    | 8 ++++++++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 34ea4f1..b377a1e 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -368,9 +368,8 @@ dioread_nolock		locking. If the dioread_nolock option is specified
 			speed storages. However this does not work with
 			data journaling and dioread_nolock option will be
 			ignored with kernel warning. Note that dioread_nolock
-			code path is only used for extent-based files.
-			Because of the restrictions this options comprises
-			it is off by default (e.g. dioread_lock).
+			code path is only used for extent-based files.  it is
+			on by default for extent-based files.
 
 max_dir_size_kb=n	This limits the size of directories so that any
 			attempt to expand them beyond the specified
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3cdb0a2..e6def09 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3402,6 +3402,14 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		set_opt(sb, DELALLOC);
 
 	/*
+	 * enable dioread_nolock by default
+	 * Use -o dioread_lock to turn it off
+	 */
+	if (!IS_EXT3_SB(sb) && !IS_EXT2_SB(sb) &&
+	    EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS))
+		set_opt(sb, DIOREAD_NOLOCK);
+
+	/*
 	 * set default s_li_wait_mult for lazyinit, for the case there is
 	 * no mount option specified.
 	 */
-- 
1.7.12.rc2.18.g61b472e

