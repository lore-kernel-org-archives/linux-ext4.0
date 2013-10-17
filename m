From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] ext4: don't cache out of order extents
Date: Thu, 17 Oct 2013 17:27:53 +0800
Message-ID: <1382002073-27862-1-git-send-email-guaneryu@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:49221 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab3JQJ3D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Oct 2013 05:29:03 -0400
Received: by mail-pb0-f54.google.com with SMTP id ro12so2057142pbb.13
        for <linux-ext4@vger.kernel.org>; Thu, 17 Oct 2013 02:28:59 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A corrupted ext4 may have out of order leaf extents, i.e.

extent: lblk 0--1023, len 1024, pblk 9217, flags: LEAF UNINIT
extent: lblk 1000--2047, len 1024, pblk 10241, flags: LEAF UNINIT
             ^^^^ overlap with previous extent

Reading such extent could hit BUG_ON() in ext4_es_cache_extent().

	BUG_ON(end < lblk);

The problem is that __read_extent_tree_block() tries to cache holes as
well but assumes 'lblk' is greater than 'prev' and passes underflowed
length to ext4_es_cache_extent().

I hit this when fuzz testing ext4, and am able to reproduce it by
modifying the on-disk extent by hand.

Ran xfstests on patched ext4 and no regression.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 fs/ext4/extents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 54d52af..c9ebcb9 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -503,7 +503,7 @@ __read_extent_tree_block(const char *function, unsigned int line,
 			ext4_lblk_t lblk = le32_to_cpu(ex->ee_block);
 			int len = ext4_ext_get_actual_len(ex);
 
-			if (prev && (prev != lblk))
+			if (prev && (prev < lblk))
 				ext4_es_cache_extent(inode, prev,
 						     lblk - prev, ~0,
 						     EXTENT_STATUS_HOLE);
-- 
1.8.3.1

