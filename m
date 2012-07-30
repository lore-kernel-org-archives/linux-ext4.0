From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/7] libext2fs: use strcpy()/strcat() instead of sprintf() in bmap functions
Date: Mon, 30 Jul 2012 17:47:38 -0400
Message-ID: <1343684862-13181-3-git-send-email-tytso@mit.edu>
References: <20120628024356.GB17989@thor.bakeyournoodle.com>
 <1343684862-13181-1-git-send-email-tytso@mit.edu>
Cc: tony@bakeyournoodle.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42138 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864Ab2G3Vro (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jul 2012 17:47:44 -0400
In-Reply-To: <1343684862-13181-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This simplifies the number of C library symbols needed by boot loader
systems such as yaboot.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/gen_bitmap64.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index 44b733d..dd2773a 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -322,7 +322,8 @@ errcode_t ext2fs_copy_generic_bmap(ext2fs_generic_bitmap src,
 			ext2fs_free_mem(&new_bmap);
 			return retval;
 		}
-		sprintf(new_descr, "copy of %s", descr);
+		strcpy(new_descr, "copy of ");
+		strcat(new_descr, descr);
 		new_bmap->description = new_descr;
 	}
 
-- 
1.7.12.rc0.22.gcdd159b

