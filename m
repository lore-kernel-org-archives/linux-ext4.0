From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/4] libext2fs: Provide prototype for ext2fs_symlink()
Date: Mon, 25 Feb 2013 16:55:07 +0100
Message-ID: <1361807708-15871-4-git-send-email-jack@suse.cz>
References: <1361807708-15871-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54882 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759698Ab3BYPzP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Feb 2013 10:55:15 -0500
In-Reply-To: <1361807708-15871-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

New function ext2fs_symlink() doesn't have a prototype in ext2fs.h and
thus debugfs compilation gives warning:

debugfs.c:2219:2: warning: implicit declaration of function 'ext2fs_symlink'

Signed-off-by: Jan Kara <jack@suse.cz>
---
 lib/ext2fs/ext2fs.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 7139b4d..cd59473 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1449,6 +1449,10 @@ errcode_t ext2fs_link(ext2_filsys fs, ext2_ino_t dir, const char *name,
 errcode_t ext2fs_unlink(ext2_filsys fs, ext2_ino_t dir, const char *name,
 			ext2_ino_t ino, int flags);
 
+/* symlink.c */
+errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
+			 const char *name, char *target);
+
 /* mmp.c */
 errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf);
 errcode_t ext2fs_mmp_write(ext2_filsys fs, blk64_t mmp_blk, void *buf);
-- 
1.7.1

