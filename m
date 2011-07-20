From: Aditya Kali <adityakali@google.com>
Subject: [PATCH 2/5] e2fsprogs: Make quota as a supported feature
Date: Wed, 20 Jul 2011 11:40:03 -0700
Message-ID: <1311187206-30553-3-git-send-email-adityakali@google.com>
References: <1311187206-30553-1-git-send-email-adityakali@google.com>
Cc: Aditya Kali <adityakali@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:10148 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab1GTSlG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jul 2011 14:41:06 -0400
Received: from hpaq2.eem.corp.google.com (hpaq2.eem.corp.google.com [172.25.149.2])
	by smtp-out.google.com with ESMTP id p6KIf6KO030057
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jul 2011 11:41:06 -0700
In-Reply-To: <1311187206-30553-1-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Make EXT4_FEATURE_RO_COMPAT_QUOTA part of the supported features by
e2fsprogs.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 lib/ext2fs/ext2fs.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index dc83fb0..9d68cbe 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -564,7 +564,8 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK|\
 					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|\
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM|\
-					 EXT4_FEATURE_RO_COMPAT_BIGALLOC)
+					 EXT4_FEATURE_RO_COMPAT_BIGALLOC|\
+					 EXT4_FEATURE_RO_COMPAT_QUOTA)
 
 /*
  * These features are only allowed if EXT2_FLAG_SOFTSUPP_FEATURES is passed
-- 
1.7.3.1

