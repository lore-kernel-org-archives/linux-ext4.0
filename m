From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH] ext4: fix potential null pointer dereference in ext4_free_inode
Date: Tue, 08 Jul 2014 14:41:22 +0900
Message-ID: <002901cf9a6f$401a0c50$c04e24f0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	'Dan Carpenter' <dan.carpenter@oracle.com>,
	Ashish Sangwan <a.sangwan@samsung.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:18610 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaGHFlY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jul 2014 01:41:24 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N8D00DMXP4YIS70@mailout4.samsung.com> for
 linux-ext4@vger.kernel.org; Tue, 08 Jul 2014 14:41:22 +0900 (KST)
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix potential null pointer dereferencing problem caused by e43bb4e612
("ext4: decrement free clusters/inodes counters when block group declared bad")

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/ext4/ialloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index a87455d..6bfe7eb 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -338,7 +338,7 @@ out:
 			fatal = err;
 	} else {
 		ext4_error(sb, "bit already cleared for inode %lu", ino);
-		if (!EXT4_MB_GRP_IBITMAP_CORRUPT(grp)) {
+		if (gdp && !EXT4_MB_GRP_IBITMAP_CORRUPT(grp)) {
 			int count;
 			count = ext4_free_inodes_count(sb, gdp);
 			percpu_counter_sub(&sbi->s_freeinodes_counter,
-- 
1.7.11-rc0

