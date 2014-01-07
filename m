From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 08/10] debugfs: remove dead code
Date: Tue,  7 Jan 2014 09:53:12 -0500
Message-ID: <1389106394-31898-8-git-send-email-tytso@mit.edu>
References: <1389106394-31898-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46598 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbaAGOxV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jan 2014 09:53:21 -0500
In-Reply-To: <1389106394-31898-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Addresses-Coverity-Id: #1138573

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 debugfs/debugfs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 998af33..0e56ead 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -289,8 +289,6 @@ void do_init_filesys(int argc, char **argv)
 	if (err)
 		return;
 	ext2fs_blocks_count_set(&param, blocks);
-	if (err)
-		return;
 	retval = ext2fs_initialize(argv[1], 0, &param,
 				   unix_io_manager, &current_fs);
 	if (retval) {
-- 
1.8.5.rc3.362.gdf10213

