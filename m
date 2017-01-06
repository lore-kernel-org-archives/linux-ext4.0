From: Roman Pen <roman.penyaev@profitbricks.com>
Subject: [PATCH v2 2/2] ext4: Do not populate extents tree with outdated offsets while shifting extents
Date: Fri,  6 Jan 2017 21:26:01 +0100
Message-ID: <20170106202601.32722-3-roman.penyaev@profitbricks.com>
References: <20170106202601.32722-1-roman.penyaev@profitbricks.com>
Cc: Roman Pen <roman.penyaev@profitbricks.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wj0-f170.google.com ([209.85.210.170]:36496 "EHLO
        mail-wj0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938474AbdAFU0S (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Jan 2017 15:26:18 -0500
Received: by mail-wj0-f170.google.com with SMTP id ew7so28693352wjc.3
        for <linux-ext4@vger.kernel.org>; Fri, 06 Jan 2017 12:26:17 -0800 (PST)
In-Reply-To: <20170106202601.32722-1-roman.penyaev@profitbricks.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Inside ext4_ext_shift_extents() function ext4_find_extent() is called
without EXT4_EX_NOCACHE flag, which should prevent cache population.

This leads to oudated offsets in the extents tree and wrong blocks
afterwards.

Patch fixes the problem providing EXT4_EX_NOCACHE flag for each
ext4_find_extents() call inside ext4_ext_shift_extents function.

Signed-off-by: Roman Pen <roman.penyaev@profitbricks.com>
Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 fs/ext4/extents.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4d3014b5a3f9..2a97dff87b96 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5334,7 +5334,8 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 	ext4_lblk_t stop, *iterator, ex_start, ex_end;
 
 	/* Let path point to the last extent */
-	path = ext4_find_extent(inode, EXT_MAX_BLOCKS - 1, NULL, 0);
+	path = ext4_find_extent(inode, EXT_MAX_BLOCKS - 1, NULL,
+				EXT4_EX_NOCACHE);
 	if (IS_ERR(path))
 		return PTR_ERR(path);
 
@@ -5350,7 +5351,8 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 	 * sure the hole is big enough to accommodate the shift.
 	*/
 	if (SHIFT == SHIFT_LEFT) {
-		path = ext4_find_extent(inode, start - 1, &path, 0);
+		path = ext4_find_extent(inode, start - 1, &path,
+					EXT4_EX_NOCACHE);
 		if (IS_ERR(path))
 			return PTR_ERR(path);
 		depth = path->p_depth;
@@ -5388,7 +5390,8 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 	 * becomes NULL to indicate the end of the loop.
 	 */
 	while (iterator && start <= stop) {
-		path = ext4_find_extent(inode, *iterator, &path, 0);
+		path = ext4_find_extent(inode, *iterator, &path,
+					EXT4_EX_NOCACHE);
 		if (IS_ERR(path))
 			return PTR_ERR(path);
 		depth = path->p_depth;
-- 
2.10.2

