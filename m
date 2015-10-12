From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/8] ext4: promote ext4 over ext2 in the default probe order
Date: Mon, 12 Oct 2015 14:54:31 -0700
Message-ID: <20151012215431.28872.84139.stgit@birch.djwong.org>
References: <20151012215416.28872.8160.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43669 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbbJLVyg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Oct 2015 17:54:36 -0400
In-Reply-To: <20151012215416.28872.8160.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Prevent clean ext3 filesystems from mounting by default with the ext2
driver (with no journal!) by putting ext4 ahead of ext2 in the default
probe order.  This will have the effect of mounting ext2 filesystems
with ext4.ko by default, which is a safer failure than hoping the user
notices that their journalled ext3 is now running without a journal!

Users who require ext2.ko for ext2 can either disable ext4.ko or
explicitly request ext2 via "mount -t ext2" or "rootfstype=ext2".

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/Makefile |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff --git a/fs/Makefile b/fs/Makefile
index f79cf40..79f5225 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -63,10 +63,11 @@ obj-$(CONFIG_DLM)		+= dlm/
 # Do not add any filesystems before this line
 obj-$(CONFIG_FSCACHE)		+= fscache/
 obj-$(CONFIG_REISERFS_FS)	+= reiserfs/
-obj-$(CONFIG_EXT2_FS)		+= ext2/
-# We place ext4 after ext2 so plain ext2 root fs's are mounted using ext2
-# unless explicitly requested by rootfstype
 obj-$(CONFIG_EXT4_FS)		+= ext4/
+# We place ext4 before ext2 so that clean ext3 root fs's do NOT mount using the
+# ext2 driver, which doesn't know about journalling!  Explicitly request ext2
+# by giving the rootfstype= parameter.
+obj-$(CONFIG_EXT2_FS)		+= ext2/
 obj-$(CONFIG_JBD2)		+= jbd2/
 obj-$(CONFIG_CRAMFS)		+= cramfs/
 obj-$(CONFIG_SQUASHFS)		+= squashfs/

