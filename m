From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 03/10] e2fsck: fix memory leak on error path in read_bad_blocks_files()
Date: Tue,  7 Jan 2014 09:53:07 -0500
Message-ID: <1389106394-31898-3-git-send-email-tytso@mit.edu>
References: <1389106394-31898-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46595 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbaAGOxV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jan 2014 09:53:21 -0500
In-Reply-To: <1389106394-31898-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Addresses-Coverity-Id: #1049170

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/badblocks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/e2fsck/badblocks.c b/e2fsck/badblocks.c
index 8519df0..7f3641b 100644
--- a/e2fsck/badblocks.c
+++ b/e2fsck/badblocks.c
@@ -111,6 +111,8 @@ void read_bad_blocks_file(e2fsck_t ctx, const char *bad_blocks_file,
 
 fatal:
 	ctx->flags |= E2F_FLAG_ABORT;
+	if (bb_list)
+		ext2fs_badblocks_list_free(bb_list);
 	return;
 
 }
-- 
1.8.5.rc3.362.gdf10213

