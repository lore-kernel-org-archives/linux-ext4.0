From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2] ext3: use proper little-endian bitops
Date: Wed,  1 Jun 2011 23:34:04 +0900
Message-ID: <1306938844-11178-1-git-send-email-akinobu.mita@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36536 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756766Ab1FAOdN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Jun 2011 10:33:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext3_{set,clear}_bit() is defined as __test_and_{set,clear}_bit_le()
for ext3.  But all ext3_{set,clear}_bit() calls ignore return values.
So these can be replaced with __{set,clear}_bit_le().

This changes ext3_{set,clear}_bit safely, because if someone uses
these macros without noticing the change, new ext3_{set,clear}_bit
don't have return value and causes compiler errors where the return
value is used.

This also removes unused ext3_find_first_zero_bit().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
v2: rewritten to keep ext3_*_bit() macros

 include/linux/ext3_fs.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 5e06acf..50f21ee 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -418,12 +418,11 @@ struct ext3_inode {
 #define EXT2_MOUNT_DATA_FLAGS		EXT3_MOUNT_DATA_FLAGS
 #endif
 
-#define ext3_set_bit			__test_and_set_bit_le
+#define ext3_set_bit			__set_bit_le
 #define ext3_set_bit_atomic		ext2_set_bit_atomic
-#define ext3_clear_bit			__test_and_clear_bit_le
+#define ext3_clear_bit			__clear_bit_le
 #define ext3_clear_bit_atomic		ext2_clear_bit_atomic
 #define ext3_test_bit			test_bit_le
-#define ext3_find_first_zero_bit	find_first_zero_bit_le
 #define ext3_find_next_zero_bit		find_next_zero_bit_le
 
 /*
-- 
1.7.4.4

