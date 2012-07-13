From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: remove dynamic array size in ext4_chksum()
Date: Thu, 12 Jul 2012 23:25:36 -0400
Message-ID: <1342149936-15148-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38846 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698Ab2GMDZj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jul 2012 23:25:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ext4_checksum() inline function was using a dynamic array size,
which is not legal C.  (It is a gcc extension).

Remove it.

Cc: "Darrick J. Wong" <djwong@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1610e80..e8e8afa 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1667,10 +1667,12 @@ static inline u32 ext4_chksum(struct ext4_sb_info *sbi, u32 crc,
 {
 	struct {
 		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(sbi->s_chksum_driver)];
+		char ctx[4];
 	} desc;
 	int err;
 
+	BUG_ON(crypto_shash_descsize(sbi->s_chksum_driver)!=sizeof(desc.ctx));
+
 	desc.shash.tfm = sbi->s_chksum_driver;
 	desc.shash.flags = 0;
 	*(u32 *)desc.ctx = crc;
-- 
1.7.11.1.108.gb129051

