From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] libext2fs: ext2fs_open2() should not set ret_fs after a MMP failure
Date: Tue,  8 Jan 2013 21:01:15 -0500
Message-ID: <1357696875-22642-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42431 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756634Ab3AICBW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jan 2013 21:01:22 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The addition of MMP code was added in the wrong place, so ret_fs could
get set (and EXT2_FLAG_NOFREE_ON_ERROR was cleared as well, which
could confuse e2fsck which depends on this flag being cleared if
ext2fs_open2() succeeded.)

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/openfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index d483bd9..113b80e 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -391,9 +391,6 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 			ext2fs_mark_super_dirty(fs);
 	}
 
-	fs->flags &= ~EXT2_FLAG_NOFREE_ON_ERROR;
-	*ret_fs = fs;
