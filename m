From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: [PATCH] libext2fs : Fix memory leaks in ext2fs_extent_open()
Date: Sat, 16 Aug 2008 02:26:43 +0530
Message-ID: <ea11fea30808151356g49cc399fna2457d8902926e97@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mkatiyar@gmail.com
To: "Theodore Tso" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.189]:43757 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbYHOU4o (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Aug 2008 16:56:44 -0400
Received: by ti-out-0910.google.com with SMTP id b6so482413tic.23
        for <linux-ext4@vger.kernel.org>; Fri, 15 Aug 2008 13:56:43 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Memory allocated for the ext2_extent_handle is not getting freed from
all the return paths in case of error. Below patch fixes it.

Signed-off-by: "Manish Katiyar" <mkatiyar@gmail.com>

---
 lib/ext2fs/extent.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 44d7d9b..42a6cb9 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -222,12 +222,14 @@ extern errcode_t ext2fs_extent_open(ext2_filsys
fs, ext2_ino_t ino,
 		handle->inode->i_flags |= EXT4_EXTENTS_FL;
 	}

-	if (!(handle->inode->i_flags & EXT4_EXTENTS_FL))
-		return EXT2_ET_INODE_NOT_EXTENT;
+	if (!(handle->inode->i_flags & EXT4_EXTENTS_FL)) {
+		retval = EXT2_ET_INODE_NOT_EXTENT;
+		goto errout;
+	}

 	retval = ext2fs_extent_header_verify(eh, sizeof(handle->inode->i_block));
-	if (retval)
-		return (retval);
+	if (retval)
+		goto errout;

 	handle->max_depth = ext2fs_le16_to_cpu(eh->eh_depth);
 	handle->type = ext2fs_le16_to_cpu(eh->eh_magic);
-- 
1.5.4.3
