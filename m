From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] ext4: modify cluster macro parameter names for consistency
Date: Fri, 26 Jan 2018 13:11:10 -0500
Message-ID: <20180126181110.5wypja267n6azgtj@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:41636 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751677AbeAZSLQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Jan 2018 13:11:16 -0500
Received: by mail-qt0-f194.google.com with SMTP id i1so3433209qtj.8
        for <linux-ext4@vger.kernel.org>; Fri, 26 Jan 2018 10:11:16 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Not all the parameter names used to refer to ext4_sb_info structs in
the cluster-related macro definitions are consistent.  Some use the
name "s" rather than "sbi" when operating on a component of an
ext4_sb_info struct.  Use of the latter helps comprehensibility, since
the name "sbi" is commonly used for instances of ext4_sb_info in ext4.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 fs/ext4/ext4.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3241475a1733..7705d7f36ccb 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -279,15 +279,15 @@ struct ext4_io_submit {
 #define EXT4_NUM_B2C(sbi, blks)	(((blks) + (sbi)->s_cluster_ratio - 1) >> \
 				 (sbi)->s_cluster_bits)
 /* Mask out the low bits to get the starting block of the cluster */
-#define EXT4_PBLK_CMASK(s, pblk) ((pblk) &				\
-				  ~((ext4_fsblk_t) (s)->s_cluster_ratio - 1))
-#define EXT4_LBLK_CMASK(s, lblk) ((lblk) &				\
-				  ~((ext4_lblk_t) (s)->s_cluster_ratio - 1))
+#define EXT4_PBLK_CMASK(sbi, pblk) ((pblk) &				\
+				    ~((ext4_fsblk_t)(sbi)->s_cluster_ratio - 1))
+#define EXT4_LBLK_CMASK(sbi, lblk) ((lblk) &				\
+				    ~((ext4_lblk_t) (sbi)->s_cluster_ratio - 1))
 /* Get the cluster offset */
-#define EXT4_PBLK_COFF(s, pblk) ((pblk) &				\
-				 ((ext4_fsblk_t) (s)->s_cluster_ratio - 1))
-#define EXT4_LBLK_COFF(s, lblk) ((lblk) &				\
-				 ((ext4_lblk_t) (s)->s_cluster_ratio - 1))
+#define EXT4_PBLK_COFF(sbi, pblk) ((pblk) &				\
+				   ((ext4_fsblk_t) (sbi)->s_cluster_ratio - 1))
+#define EXT4_LBLK_COFF(sbi, lblk) ((lblk) &				\
+				   ((ext4_lblk_t) (sbi)->s_cluster_ratio - 1))
 
 /*
  * Structure of a blocks group descriptor
-- 
2.11.0
