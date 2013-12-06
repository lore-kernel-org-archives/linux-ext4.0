From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 16/30] debugfs: make lsdel command support inline data
Date: Fri,  6 Dec 2013 17:58:03 +0800
Message-ID: <1386323897-2354-17-git-send-email-wenqing.lz@taobao.com>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:64294 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757600Ab3LFJ4B (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Dec 2013 04:56:01 -0500
Received: by mail-pd0-f170.google.com with SMTP id g10so749450pdj.15
        for <linux-ext4@vger.kernel.org>; Fri, 06 Dec 2013 01:56:01 -0800 (PST)
In-Reply-To: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

After checking inline data in ext2fs_inode_have_valid_blocks2() we won't
traverse the block in do_lsdel() function.  But if an inode has inline
data we also need to report it.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/lsdel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/debugfs/lsdel.c b/debugfs/lsdel.c
index ba84611..b61951f 100644
--- a/debugfs/lsdel.c
+++ b/debugfs/lsdel.c
@@ -152,7 +152,8 @@ void do_lsdel(int argc, char **argv)
 				goto next;
 			}
 		}
-		if (lsd.free_blocks && !lsd.bad_blocks) {
+		if (lsd.free_blocks && !lsd.bad_blocks ||
+		    inode.i_flags & EXT4_INLINE_DATA_FL) {
 			if (num_delarray >= max_delarray) {
 				max_delarray += 50;
 				delarray = realloc(delarray,
-- 
1.7.9.7

