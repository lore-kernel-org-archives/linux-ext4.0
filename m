From: Ernesto =?utf-8?Q?A=2E_Fern=C3=A1ndez?=
        <ernesto.mnd.fernandez@gmail.com>
Subject: [PATCH] ext2: Fix memory leak when truncate races ext2_get_blocks
Date: Fri, 23 Jun 2017 21:37:21 -0300
Message-ID: <20170624003719.GA5670@debian.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: jack@suse.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:34090 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754075AbdFXAh0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Jun 2017 20:37:26 -0400
Received: by mail-qk0-f195.google.com with SMTP id 91so2377768qkq.1
        for <linux-ext4@vger.kernel.org>; Fri, 23 Jun 2017 17:37:25 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Buffer heads referencing indirect blocks may not be released if the file
is truncated at the right time. This happens because ext2_get_branch()
returns NULL when it finds the whole chain of indirect blocks already
set, and when truncate alters the chain this value of NULL is
treated as the address of the last head to be released. Handle this in the
same way as it's done after the got_it label.

Signed-off-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
---
Despite trying I haven't actually managed to trigger this race. I tested
the patch by inducing regular failures in verify_chain().

 fs/ext2/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 2dcbd56..30163d0 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -659,6 +659,7 @@ static int ext2_get_blocks(struct inode *inode,
 				 */
 				err = -EAGAIN;
 				count = 0;
+				partial = chain + depth - 1;
 				break;
 			}
 			blk = le32_to_cpu(*(chain[depth-1].p + count));
-- 
2.1.4
