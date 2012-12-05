From: Darren Hart <dvhart@infradead.org>
Subject: [PATCH 1/3] lib/ext2fs: Correct interates typo in texinfo docs
Date: Wed,  5 Dec 2012 13:56:03 -0800
Message-ID: <ff54dc35c816ae53f149f2f032c12147deac8508.1354743799.git.dvhart@infradead.org>
References: <1354744565-12594-1-git-send-email-dvhart@infradead.org>
Cc: Darren Hart <dvhart@infradead.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:62577 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711Ab2LEV40 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Dec 2012 16:56:26 -0500
In-Reply-To: <1354744565-12594-1-git-send-email-dvhart@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Just a typo fix.

Signed-off-by: Darren Hart <dvhart@infradead.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>
---
 doc/libext2fs.texinfo | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/libext2fs.texinfo b/doc/libext2fs.texinfo
index 9d8e7f1..8272d1d 100644
--- a/doc/libext2fs.texinfo
+++ b/doc/libext2fs.texinfo
@@ -767,7 +767,7 @@ to initialize directory entries for @file{.} and @file{..}, respectively.
 
 @deftypefun errcode_t ext2fs_dir_iterate (ext2_filsys @var{fs}, ext2_ino_t @var{dir}, int @var{flags}, char *@var{block_buf}, int (*@var{func})(struct ext2_dir_entry *@var{dirent}, int @var{offset}, int @var{blocksize}, char *@var{buf}, void *@var{private}), void *@var{private})
 
-This function interates over all of the directory entries in the
+This function iterates over all of the directory entries in the
 directory @var{dir}, calling the callback function @var{func} for each
 directory entry in the directory.  The @var{block_buf} parameter should
 either be NULL, or if the @code{ext2fs_dir_iterate} function is 
-- 
1.7.11.7

