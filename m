From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] FS_MBCACHE: don't needlessly make it built-in
Date: Sun, 3 Aug 2008 21:43:25 +0300
Message-ID: <20080803184325.GC7442@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36367 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbYHCSoi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Aug 2008 14:44:38 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Assume you have:
- one or more of ext2/3/4 statically built into your kernel
- none of these with extended attributes enabled and
- want to add onother one of ext2/3/4 modular and with
  extended attributes enabled

then you currently have to reboot to use it since this results in 
CONFIG_FS_MBCACHE=y.

That's not a common issue, but I just ran into it and since there's no 
reason to get a built-in mbcache in this case this patch fixes it.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
8eb5eb7496002855dfcb9dda31c9390fb9d625e5 
diff --git a/fs/Kconfig b/fs/Kconfig
index d387358..4e94ee8 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -270,9 +270,10 @@ config JBD2_DEBUG
 config FS_MBCACHE
 # Meta block cache for Extended Attributes (ext2/ext3/ext4)
 	tristate
-	depends on EXT2_FS_XATTR || EXT3_FS_XATTR || EXT4DEV_FS_XATTR
-	default y if EXT2_FS=y || EXT3_FS=y || EXT4DEV_FS=y
-	default m if EXT2_FS=m || EXT3_FS=m || EXT4DEV_FS=m
+	default y if EXT2_FS=y && EXT2_FS_XATTR
+	default y if EXT3_FS=y && EXT3_FS_XATTR
+	default y if EXT4DEV_FS=y && EXT4DEV_FS_XATTR
+	default m if EXT2_FS_XATTR || EXT3_FS_XATTR || EXT4DEV_FS_XATTR
 
 config REISERFS_FS
 	tristate "Reiserfs support"

