From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/7] libext2fs: use abort() instead of perror()/exit()
Date: Mon, 30 Jul 2012 17:47:37 -0400
Message-ID: <1343684862-13181-2-git-send-email-tytso@mit.edu>
References: <20120628024356.GB17989@thor.bakeyournoodle.com>
 <1343684862-13181-1-git-send-email-tytso@mit.edu>
Cc: tony@bakeyournoodle.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42139 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599Ab2G3Vro (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jul 2012 17:47:44 -0400
In-Reply-To: <1343684862-13181-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This simplifies the number of C library symbols needed by boot loader
systems such as yaboot.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/blkmap64_rb.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
index e6b7e04..74140ec 100644
--- a/lib/ext2fs/blkmap64_rb.c
+++ b/lib/ext2fs/blkmap64_rb.c
@@ -134,10 +134,8 @@ static void rb_get_new_extent(struct bmap_rb_extent **ext, __u64 start,
 
 	retval = ext2fs_get_mem(sizeof (struct bmap_rb_extent),
 				&new_ext);
-	if (retval) {
-		perror("ext2fs_get_mem");
-		exit(1);
-	}
+	if (retval)
+		abort();
 
 	new_ext->start = start;
 	new_ext->count = count;
-- 
1.7.12.rc0.22.gcdd159b

