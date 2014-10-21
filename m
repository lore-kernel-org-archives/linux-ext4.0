From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: fix endian handling of ext3_extent_header
Date: Mon, 20 Oct 2014 21:36:29 -0500
Message-ID: <5445C6AD.9060306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835AbaJUCg2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Oct 2014 22:36:28 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9L2aSiS028585
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Mon, 20 Oct 2014 22:36:28 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s9L2aRtS026738
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 20 Oct 2014 22:36:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This turned up when trying to resize a filesystem containing
a file with many extents on PPC64.

Fix all locations where ext3_extent_header members aren't
handled in an endian-safe manner.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I only audited ext3_extent_header's members, and found places
where they were not properly endian-handled.

Is there a reason that disk structures aren't sparse-annotated
for endianness?  I can't help but wonder if there's a lot
more than this lurking.

diff --git a/lib/ext2fs/ext3_extents.h b/lib/ext2fs/ext3_extents.h
index 4163436..a18d705 100644
--- a/lib/ext2fs/ext3_extents.h
+++ b/lib/ext2fs/ext3_extents.h
@@ -106,15 +106,20 @@ struct ext3_ext_path {
 	((struct ext3_extent_idx *) (((char *) (__hdr__)) +	\
 				     sizeof(struct ext3_extent_header)))
 #define EXT_HAS_FREE_INDEX(__path__) \
-	((__path__)->p_hdr->eh_entries < (__path__)->p_hdr->eh_max)
+	(ext2fs_le16_to_cpu((__path__)->p_hdr->eh_entries) < \
+	 ext2fs_le16_to_cpu((__path__)->p_hdr->eh_max))
 #define EXT_LAST_EXTENT(__hdr__) \
-	(EXT_FIRST_EXTENT((__hdr__)) + (__hdr__)->eh_entries - 1)
+	(EXT_FIRST_EXTENT((__hdr__)) + \
+	ext2fs_le16_to_cpu((__hdr__)->eh_entries) - 1)
 #define EXT_LAST_INDEX(__hdr__) \
-	(EXT_FIRST_INDEX((__hdr__)) + (__hdr__)->eh_entries - 1)
+	(EXT_FIRST_INDEX((__hdr__)) + \
+	ext2fs_le16_to_cpu((__hdr__)->eh_entries) - 1)
 #define EXT_MAX_EXTENT(__hdr__) \
-	(EXT_FIRST_EXTENT((__hdr__)) + (__hdr__)->eh_max - 1)
+	(EXT_FIRST_EXTENT((__hdr__)) + \
+	ext2fs_le16_to_cpu((__hdr__)->eh_max) - 1)
 #define EXT_MAX_INDEX(__hdr__) \
-	(EXT_FIRST_INDEX((__hdr__)) + (__hdr__)->eh_max - 1)
+	(EXT_FIRST_INDEX((__hdr__)) + \
+	ext2fs_le16_to_cpu((__hdr__)->eh_max) - 1)
 
 #endif /* _LINUX_EXT3_EXTENTS */
 
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 7eb8b94..8167b76 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -420,7 +420,7 @@ ext2fs_inline_data_file_expand(ext2_filsys fs, ext2_ino_t ino,
 		eh = (struct ext3_extent_header *) &inode->i_block[0];
 		eh->eh_depth = 0;
 		eh->eh_entries = 0;
-		eh->eh_magic = EXT3_EXT_MAGIC;
+		eh->eh_magic = ext2fs_cpu_to_le16(EXT3_EXT_MAGIC);
 		i = (sizeof(inode->i_block) - sizeof(*eh)) /
 			sizeof(struct ext3_extent);
 		eh->eh_max = ext2fs_cpu_to_le16(i);

