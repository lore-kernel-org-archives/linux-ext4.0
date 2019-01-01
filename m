Return-Path: <SRS0=/7aD=PJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-eopbgr740112.outbound.protection.outlook.com ([40.107.74.112]:47856
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728381AbfAADiD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 31 Dec 2018 22:38:03 -0500
From: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
CC: <dan.carpenter@oracle.com>, Theodore Ts'o <tytso@mit.edu>,
        <stable@kernel.org>
Subject: [PATCH] ext4: fix special inode number checks in __ext4_iget()
Date: Mon, 31 Dec 2018 22:37:46 -0500
Message-ID: <20190101033746.4910-1-tytso@mit.edu>
In-Reply-To: <20181220191428.GA4895@kadam>
References: <20181220191428.GA4895@kadam>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The check for special (reserved) inode number checks in __ext4_iget()
was broken by commit 8a363970d1dc: ("ext4: avoid declaring fs
inconsistent due to invalid file handles").  This was caused by a
botched reversal of the sense of the flag now known as
EXT4_IGET_SPECIAL (when it was previously named EXT4_IGET_NORMAL).
Fix the logic appropriately.

Fixes: 8a363970d1dc ("ext4: avoid declaring fs inconsistent...")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable@kernel.org
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 165ff331d998..34d7e0703cc6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4834,7 +4834,7 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 	gid_t i_gid;
 	projid_t i_projid;
 
-	if (((flags & EXT4_IGET_NORMAL) &&
+	if ((!(flags & EXT4_IGET_SPECIAL) &&
 	     (ino < EXT4_FIRST_INO(sb) && ino != EXT4_ROOT_INO)) ||
 	    (ino < EXT4_ROOT_INO) ||
 	    (ino > le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count))) {
-- 
2.19.1
