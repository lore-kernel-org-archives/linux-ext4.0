From: akpm@linux-foundation.org
Subject: [patch 1/1] ext4: remove redundant test on unsigned
Date: Thu, 06 Aug 2009 16:07:21 -0700
Message-ID: <200908062307.n76N7LQw008071@imap1.linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
	roel.kluin@gmail.com
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756869AbZHFXHy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Aug 2009 19:07:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Roel Kluin <roel.kluin@gmail.com>

unsigned i_block cannot be less than 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/ext4/inode.c~ext4-remove-redundant-test-on-unsigned fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext4-remove-redundant-test-on-unsigned
+++ a/fs/ext4/inode.c
@@ -343,9 +343,7 @@ static int ext4_block_to_path(struct ino
 	int n = 0;
 	int final = 0;
 
-	if (i_block < 0) {
-		ext4_warning(inode->i_sb, "ext4_block_to_path", "block < 0");
-	} else if (i_block < direct_blocks) {
+	if (i_block < direct_blocks) {
 		offsets[n++] = i_block;
 		final = direct_blocks;
 	} else if ((i_block -= direct_blocks) < indirect_blocks) {
_
