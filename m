From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs : Add stricter checks for blocksize in
	ext2fs_open
Date: Fri, 11 Jul 2008 17:46:59 -0400
Message-ID: <20080711214659.GE26656@mit.edu>
References: <ea11fea30807110149g31065f31k5231bbebc5133587@mail.gmail.com> <20080711125506.GB20099@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:36294 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755467AbYGKVrD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Jul 2008 17:47:03 -0400
Content-Disposition: inline
In-Reply-To: <20080711125506.GB20099@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is what I ended up checking into my tree:

From: Manish Katiyar <mkatiyar@gmail.com>
Date: Fri, 11 Jul 2008 17:45:07 -0400
Subject: [PATCH] libext2fs: Add stricter/earlier tests for blocksize in ext2fs_open()

Signed-off-by: "Manish Katiyar" <mkatiyar@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/openfs.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index fc54afe..525693e 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -232,11 +232,12 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 		}
 	}
 	
-	fs->blocksize = EXT2_BLOCK_SIZE(fs->super);
-	if (fs->blocksize == 0) {
+	if ((fs->super->s_log_block_size + EXT2_MIN_BLOCK_LOG_SIZE) >
+	    EXT2_MAX_BLOCK_LOG_SIZE) {
 		retval = EXT2_ET_CORRUPT_SUPERBLOCK;
 		goto cleanup;
 	}
+	fs->blocksize = EXT2_BLOCK_SIZE(fs->super);
 	if (EXT2_INODE_SIZE(fs->super) < EXT2_GOOD_OLD_INODE_SIZE) {
 		retval = EXT2_ET_CORRUPT_SUPERBLOCK;
 		goto cleanup;
-- 
1.5.6.1.205.ge2c7.dirty

