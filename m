From: Martin Michlmayr <tbm@cyrius.com>
Subject: [PATCH] ext4: Remove an old reference to ext4dev
Date: Mon, 13 Oct 2008 13:34:17 +0200
Message-ID: <20081013113417.GA14954@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:4455 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755815AbYJMLea (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Oct 2008 07:34:30 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Remove an old reference to ext4dev.

Signed-off-by: Martin Michlmayr <tbm@cyrius.com>

diff --git a/fs/Makefile b/fs/Makefile
index de404b0..1f6f9f5 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -69,7 +69,7 @@ obj-$(CONFIG_DLM)		+= dlm/
 # Do not add any filesystems before this line
 obj-$(CONFIG_REISERFS_FS)	+= reiserfs/
 obj-$(CONFIG_EXT3_FS)		+= ext3/ # Before ext2 so root fs can be ext3
-obj-$(CONFIG_EXT4_FS)		+= ext4/ # Before ext2 so root fs can be ext4dev
+obj-$(CONFIG_EXT4_FS)		+= ext4/ # Before ext2 so root fs can be ext4
 obj-$(CONFIG_JBD)		+= jbd/
 obj-$(CONFIG_JBD2)		+= jbd2/
 obj-$(CONFIG_EXT2_FS)		+= ext2/

-- 
Martin Michlmayr
http://www.cyrius.com/
