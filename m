From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/1] e2fsprogs: Swap values in extent header macros.
Date: Mon, 31 Mar 2008 10:55:15 -0500
Message-ID: <47F10963.1020202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbYCaPzS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Mar 2008 11:55:18 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m2VFtIl3029041
	for <linux-ext4@vger.kernel.org>; Mon, 31 Mar 2008 11:55:18 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2VFtI4Y023607
	for <linux-ext4@vger.kernel.org>; Mon, 31 Mar 2008 11:55:18 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2VFtGMe023603
	for <linux-ext4@vger.kernel.org>; Mon, 31 Mar 2008 11:55:17 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/ext2fs/ext3_extents.h |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/lib/ext2fs/ext3_extents.h b/lib/ext2fs/ext3_extents.h
index ba980e4..8d876f2 100644
--- a/lib/ext2fs/ext3_extents.h
+++ b/lib/ext2fs/ext3_extents.h
@@ -154,15 +154,20 @@ struct ext3_ext_path {
 	((struct ext3_extent_idx *) (((char *) (__hdr__)) +	\
 				     sizeof(struct ext3_extent_header)))
 #define EXT_HAS_FREE_INDEX(__path__) \
-	((__path__)->p_hdr->eh_entries < (__path__)->p_hdr->eh_max)
+	((__path__)->p_hdr->eh_entries <  \
+		ext2fs_le16_to_cpu((__path__)->p_hdr->eh_max))
 #define EXT_LAST_EXTENT(__hdr__) \
-	(EXT_FIRST_EXTENT((__hdr__)) + (__hdr__)->eh_entries - 1)
+	(EXT_FIRST_EXTENT((__hdr__)) + \
+		ext2fs_le16_to_cpu((__hdr__)->eh_entries) - 1)
 #define EXT_LAST_INDEX(__hdr__) \
-	(EXT_FIRST_INDEX((__hdr__)) + (__hdr__)->eh_entries - 1)
+	(EXT_FIRST_INDEX((__hdr__)) + \
+		ext2fs_le16_to_cpu((__hdr__)->eh_entries) - 1)
 #define EXT_MAX_EXTENT(__hdr__) \
-	(EXT_FIRST_EXTENT((__hdr__)) + (__hdr__)->eh_max - 1)
+	(EXT_FIRST_EXTENT((__hdr__)) + \
+		ext2fs_le16_to_cpu((__hdr__)->eh_max) - 1)
 #define EXT_MAX_INDEX(__hdr__) \
-	(EXT_FIRST_INDEX((__hdr__)) + (__hdr__)->eh_max - 1)
+	(EXT_FIRST_INDEX((__hdr__)) + \
+		ext2fs_le16_to_cpu((__hdr__)->eh_max) - 1)
 
 #define EXT_ROOT_HDR(tree) \
 	((struct ext3_extent_header *) (tree)->root)
-- 1.5.4.1

