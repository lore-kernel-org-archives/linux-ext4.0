From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: [PATCH] libext2fs : Fix the return values for ino=0 in ext2fs_read_inode_full() if inode cache has been flushed.
Date: Sat, 12 Jul 2008 19:27:41 +0530
Message-ID: <ea11fea30807120657l2de0b501qefb45231edd5fac0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mkatiyar@gmail.com
To: linux-ext4@vger.kernel.org, "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.191]:52429 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbYGLN5n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Jul 2008 09:57:43 -0400
Received: by ti-out-0910.google.com with SMTP id b6so1967227tic.23
        for <linux-ext4@vger.kernel.org>; Sat, 12 Jul 2008 06:57:42 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

It looks like the right place to check for ino=0 in
ext2fs_read_inode_full() is before creating the inode cache, otherwise
since we set icache[i].ino = 0 in create_icache(), it will match the
loop below and thus we return a wrong value. Below patch fixes it.

==========================================================================

Signed-off-by: "Manish Katiyar" <mkatiyar@gmail.com>

---
 lib/ext2fs/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index 8908423..a08cb40 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -536,6 +536,8 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs,
ext2_ino_t ino,
 		if (retval != EXT2_ET_CALLBACK_NOTHANDLED)
 			return retval;
 	}
+	if ((ino == 0) || (ino > fs->super->s_inodes_count))
+		return EXT2_ET_BAD_INODE_NUM;
 	/* Create inode cache if not present */
 	if (!fs->icache) {
 		retval = create_icache(fs);
@@ -552,8 +554,6 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs,
ext2_ino_t ino,
 			}
 		}
 	}
-	if ((ino == 0) || (ino > fs->super->s_inodes_count))
-		return EXT2_ET_BAD_INODE_NUM;
 	if (fs->flags & EXT2_FLAG_IMAGE_FILE) {
 		inodes_per_block = fs->blocksize / EXT2_INODE_SIZE(fs->super);
 		block_nr = fs->image_header->offset_inode / fs->blocksize;
-- 
1.5.4.3


=====================================================================

Thanks -
Manish
