From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/3] libext2fs: set the fs block size to new_io in ext2fs_rewrite_to_io()
Date: Mon,  2 Dec 2013 14:55:24 -0500
Message-ID: <1386014125-13664-2-git-send-email-tytso@mit.edu>
References: <20131202182606.GA11204@thunk.org>
 <1386014125-13664-1-git-send-email-tytso@mit.edu>
Cc: kwestneat@ddn.com, "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35712 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250Ab3LBTzx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Dec 2013 14:55:53 -0500
In-Reply-To: <1386014125-13664-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Kit Westneat <kwestneat@ddn.com>

e2image manually opens a new IO channel, and then sets the file system
to use this new IO channel via ext2fs_rewrite+to_io().  We need to
make sure the IO channel is set to the file system's block size to
avoid some nasty buffer overruns.

[ Modified by tytso to use io_channel_set_blksize() ]

Signed-off-by: Kit Westneat <kwestneat@ddn.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
---
 lib/ext2fs/openfs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 9fe1645..c38b586 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -451,8 +451,13 @@ errcode_t ext2fs_set_data_io(ext2_filsys fs, io_channel new_io)
 
 errcode_t ext2fs_rewrite_to_io(ext2_filsys fs, io_channel new_io)
 {
+	errcode_t err;
+
 	if ((fs->flags & EXT2_FLAG_IMAGE_FILE) == 0)
 		return EXT2_ET_NOT_IMAGE_FILE;
+	err = io_channel_set_blksize(new_io, fs->blocksize);
+	if (err)
+		return err;
 	fs->io = fs->image_io = new_io;
 	fs->flags |= EXT2_FLAG_DIRTY | EXT2_FLAG_RW |
 		EXT2_FLAG_BB_DIRTY | EXT2_FLAG_IB_DIRTY;
-- 
1.8.5.rc3.362.gdf10213

