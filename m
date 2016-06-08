From: mchristi@redhat.com
Subject: [PATCH 1/2] ext4: use bio op helprs in ext4 crypto code
Date: Wed,  8 Jun 2016 15:49:40 -0500
Message-ID: <1465418981-7360-2-git-send-email-mchristi@redhat.com>
References: <1465418981-7360-1-git-send-email-mchristi@redhat.com>
Cc: Mike Christie <mchristi@redhat.com>
To: linux-ext4@vger.kernel.org, linux-block@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425254AbcFHUtq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Jun 2016 16:49:46 -0400
In-Reply-To: <1465418981-7360-1-git-send-email-mchristi@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Mike Christie <mchristi@redhat.com>

This was missed from my last patchset.

This patch has ext4 crypto code use the bio op helper
to set the operation. The operation (discard, write, writesame,
etc) is now defined seperately from the other REQ bits. They
still share the bi_rw field to save space, so we use these
helpers so modules do not have to worry about setting/overwriting
info.

Jens, I am not sure how you handle patches on top of patches
in the next branches. If you merge patches that fix issues
in previous patches in next, then this patch could be part
of

commit 95fe6c1a209ef89d9f94dd04a0ad72be1487d5d5
Author: Mike Christie <mchristi@redhat.com>
Date:   Sun Jun 5 14:31:48 2016 -0500

    block, fs, mm, drivers: use bio set/get op accessors

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 fs/ext4/crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index 811bd5d..d3fa47c 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -428,7 +428,7 @@ int ext4_encrypted_zeroout(struct inode *inode, ext4_lblk_t lblk,
 		bio->bi_bdev = inode->i_sb->s_bdev;
 		bio->bi_iter.bi_sector =
 			pblk << (inode->i_sb->s_blocksize_bits - 9);
-		bio->bi_rw = WRITE;
+		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 		ret = bio_add_page(bio, ciphertext_page,
 				   inode->i_sb->s_blocksize, 0);
 		if (ret != inode->i_sb->s_blocksize) {
-- 
2.7.2

