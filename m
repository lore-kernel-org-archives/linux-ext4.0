From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2 14/28] debugfs: make lsdel command support inline data
Date: Tue,  3 Dec 2013 20:11:41 +0800
Message-ID: <1386072715-9869-15-git-send-email-wenqing.lz@taobao.com>
References: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:58332 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab3LCMJi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Dec 2013 07:09:38 -0500
Received: by mail-pd0-f182.google.com with SMTP id v10so19858221pde.41
        for <linux-ext4@vger.kernel.org>; Tue, 03 Dec 2013 04:09:38 -0800 (PST)
In-Reply-To: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
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

