From: Jean Delvare <jdelvare@suse.de>
Subject: [PATCH] ext4: Update EXT4_USE_FOR_EXT2 description
Date: Thu, 24 Sep 2015 12:38:22 +0200
Message-ID: <20150924123822.1a0917bf@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40208 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745AbbIXKi1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Sep 2015 06:38:27 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Configuration option EXT4_USE_FOR_EXT2 has no effect on ext3 support.
Support for ext3 is always included now.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Fixes: c290ea01ab ("fs: Remove ext3 filesystem driver")
Cc: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
---
 fs/ext4/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-4.3-rc2.orig/fs/ext4/Kconfig	2015-09-20 23:32:34.000000000 +0200
+++ linux-4.3-rc2/fs/ext4/Kconfig	2015-09-24 11:45:21.911961421 +0200
@@ -63,7 +63,7 @@ config EXT4_FS
 	  If unsure, say N.
 
 config EXT4_USE_FOR_EXT2
-	bool "Use ext4 for ext2/ext3 file systems"
+	bool "Use ext4 for ext2 file systems"
 	depends on EXT4_FS
 	depends on EXT2_FS=n
 	default y


-- 
Jean Delvare
SUSE L3 Support
