From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/3] libext2fs: fix some memory leaks with image file handling
Date: Mon,  2 Dec 2013 14:55:25 -0500
Message-ID: <1386014125-13664-3-git-send-email-tytso@mit.edu>
References: <20131202182606.GA11204@thunk.org>
 <1386014125-13664-1-git-send-email-tytso@mit.edu>
Cc: kwestneat@ddn.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35711 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831Ab3LBTzx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Dec 2013 14:55:53 -0500
In-Reply-To: <1386014125-13664-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

These memory leaks were discovered by using "valgrind
--leak-check=full" while running "e2image -I bar.img foo.e2i"

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/freefs.c | 2 ++
 lib/ext2fs/openfs.c | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/lib/ext2fs/freefs.c b/lib/ext2fs/freefs.c
index 28c4132..1ad2d91 100644
--- a/lib/ext2fs/freefs.c
+++ b/lib/ext2fs/freefs.c
@@ -43,6 +43,8 @@ void ext2fs_free(ext2_filsys fs)
 		ext2fs_free_block_bitmap(fs->block_map);
 	if (fs->inode_map)
 		ext2fs_free_inode_bitmap(fs->inode_map);
+	if (fs->image_header)
+		ext2fs_free_mem(&fs->image_header);
 
 	if (fs->badblocks)
 		ext2fs_badblocks_list_free(fs->badblocks);
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index c38b586..4cdbde1 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -458,6 +458,13 @@ errcode_t ext2fs_rewrite_to_io(ext2_filsys fs, io_channel new_io)
 	err = io_channel_set_blksize(new_io, fs->blocksize);
 	if (err)
 		return err;
+	if ((new_io == fs->image_io) || (new_io == fs->io))
+		return 0;
+	if ((fs->image_io != fs->io) &&
+	    fs->image_io)
+		io_channel_close(fs->image_io);
+	if (fs->io)
+		io_channel_close(fs->io);
 	fs->io = fs->image_io = new_io;
 	fs->flags |= EXT2_FLAG_DIRTY | EXT2_FLAG_RW |
 		EXT2_FLAG_BB_DIRTY | EXT2_FLAG_IB_DIRTY;
-- 
1.8.5.rc3.362.gdf10213

