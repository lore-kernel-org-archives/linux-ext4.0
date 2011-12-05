From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] libext2fs: don't break when ext2fs_clear_generic_bmap() for 32-bit bitmaps
Date: Mon,  5 Dec 2011 13:02:45 -0500
Message-ID: <1323108165-1429-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60350 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756432Ab1LESCr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Dec 2011 13:02:47 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is only an issue for programs compiled against e2fsprogs 1.41
that manipulate bitmaps directly.  Fortunately there are very few
programs which do that, especially those that try to clear a bitmap.

Addresses-Sourceforge-Bugs: #3451486

Reported-by: robi6@users.sourceforge.net
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/gen_bitmap64.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index 9dbbf9f..4dc4e08 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -297,8 +297,8 @@ void ext2fs_clear_generic_bmap(ext2fs_generic_bitmap bitmap)
 {
 	if (EXT2FS_IS_32_BITMAP(bitmap))
 		ext2fs_clear_generic_bitmap(bitmap);
