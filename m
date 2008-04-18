From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] libext2fs: swap in extent header macros
Date: Fri, 18 Apr 2008 14:20:59 -0500
Message-ID: <4808F49B.5020009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756547AbYDRTVA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Apr 2008 15:21:00 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m3IJKxLm008680
	for <linux-ext4@vger.kernel.org>; Fri, 18 Apr 2008 15:20:59 -0400
Received: from file.rdu.redhat.com (file.rdu.redhat.com [10.11.255.147])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3IJKxES010735
	for <linux-ext4@vger.kernel.org>; Fri, 18 Apr 2008 15:20:59 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by file.rdu.redhat.com (8.13.1/8.13.1) with ESMTP id m3IJKxbC008368
	for <linux-ext4@vger.kernel.org>; Fri, 18 Apr 2008 15:20:59 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Resend... with some I missed last time.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/lib/ext2fs/ext3_extents.h b/lib/ext2fs/ext3_extents.h
index ba980e4..f7c3832 100644
--- a/lib/ext2fs/ext3_extents.h
+++ b/lib/ext2fs/ext3_extents.h
@@ -154,24 +154,31 @@ struct ext3_ext_path {
 	((struct ext3_extent_idx *) (((char *) (__hdr__)) +	\
 				     sizeof(struct ext3_extent_header)))
 #define EXT_HAS_FREE_INDEX(__path__) \
-	((__path__)->p_hdr->eh_entries < (__path__)->p_hdr->eh_max)
+	(ext2fs_le16_to_cpu((__path__)->p_hdr->eh_entries) <  \
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
 #define EXT_BLOCK_HDR(bh) \
 	((struct ext3_extent_header *) (bh)->b_data)
 #define EXT_DEPTH(_t_)	\
-	(((struct ext3_extent_header *)((_t_)->root))->eh_depth)
+	(ext2fs_le16_to_cpu(	\
+		((struct ext3_extent_header *)((_t_)->root))->eh_depth))
 #define EXT_GENERATION(_t_)	\
-	(((struct ext3_extent_header *)((_t_)->root))->eh_generation)
+	(ext2fs_le32_to_cpu(	\
+		((struct ext3_extent_header *)((_t_)->root))->eh_generation))
 
 
 #define EXT_ASSERT(__x__) if (!(__x__)) BUG();

