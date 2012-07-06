From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH 1/2] ext4: fix the comment in ext4_ext_insert_extent for ext4_ext_try_to_merge
 in extents.c
Date: Fri, 06 Jul 2012 14:26:25 +0800
Message-ID: <4FF68511.9050207@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51178 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab2GFG0h (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Jul 2012 02:26:37 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The left and right extents merge is done by
ext4_ext_try_to_merge. No specific left/right
fun calls any more.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/ext4/extents.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5207b7b..6c2a37d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1891,12 +1891,10 @@ has_space:
 	nearex->ee_len = newext->ee_len;
 
 merge:
-	/* try to merge extents to the right */
+	/* try to merge extents to the neighbours */
 	if (!(flag & EXT4_GET_BLOCKS_PRE_IO))
 		ext4_ext_try_to_merge(inode, path, nearex);
 
-	/* try to merge extents to the left */
