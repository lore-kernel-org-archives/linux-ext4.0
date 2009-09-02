From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH 4/4]ext4: Fix small typo for move_extent_per_page()
Date: Wed, 02 Sep 2009 12:18:08 +0900
Message-ID: <4A9DE3F0.2040502@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:40007 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680AbZIBDTL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Sep 2009 23:19:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: Fix small typo for move_extent_per_page()

From: Akira Fujita <a-fujita@rs.jp.nec.com>

This function means moving extents every page.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.co.jp>
---
 fs/ext4/move_extent.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 643156a..7bfbd58 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -740,7 +740,7 @@ out:
  * on success, or a negative error value on failure.
  */
 static int
-move_extent_par_page(struct file *o_filp, struct inode *donor_inode,
+move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 		  pgoff_t orig_page_offset, int data_offset_in_page,
 		  int block_len_in_page, int uninit)
 {
@@ -1268,7 +1268,7 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
 		while (orig_page_offset <= seq_end_page) {

 			/* Swap original branches with new branches */
-			ret = move_extent_par_page(o_filp, donor_inode,
+			ret = move_extent_per_page(o_filp, donor_inode,
 						orig_page_offset,
 						data_offset_in_page,
 						block_len_in_page, uninit);

