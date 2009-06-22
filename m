From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] ext4: remove redundant test on unsigned
Date: Tue, 23 Jun 2009 00:53:07 +0200
Message-ID: <4A400B53.2080903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:35023 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528AbZFVUwa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Jun 2009 16:52:30 -0400
Received: by ewy6 with SMTP id 6so5028294ewy.37
        for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2009 13:52:32 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

unsigned i_block cannot be less than 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Maybe a test `if (i_block > MAX)' but what should MAX be?

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7c17ae2..3cd567d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -343,9 +343,7 @@ static int ext4_block_to_path(struct inode *inode,
 	int n = 0;
 	int final = 0;
 
-	if (i_block < 0) {
-		ext4_warning(inode->i_sb, "ext4_block_to_path", "block < 0");
-	} else if (i_block < direct_blocks) {
+	if (i_block < direct_blocks) {
 		offsets[n++] = i_block;
 		final = direct_blocks;
 	} else if ((i_block -= direct_blocks) < indirect_blocks) {
