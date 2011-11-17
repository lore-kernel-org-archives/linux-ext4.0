From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 3/6] ext4: correct comment on extent merging in ext4_ext_insert_extent
Date: Thu, 17 Nov 2011 10:03:22 +0800
Message-ID: <1321495405-9583-3-git-send-email-xiaoqiangnk@gmail.com>
References: <1321495405-9583-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38853 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab1KQEby (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Nov 2011 23:31:54 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so1594550iag.19
        for <linux-ext4@vger.kernel.org>; Wed, 16 Nov 2011 20:31:54 -0800 (PST)
In-Reply-To: <1321495405-9583-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_ext_try_to_merge merges both to right and left.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/extents.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 8591bc8..6888d1a 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1804,12 +1804,10 @@ has_space:
 	nearex->ee_len = newext->ee_len;
 
 merge:
-	/* try to merge extents to the right */
+	/* try to merge extents */
 	if (!(flag & EXT4_GET_BLOCKS_PRE_IO))
 		ext4_ext_try_to_merge(inode, path, nearex);
 
-	/* try to merge extents to the left */
