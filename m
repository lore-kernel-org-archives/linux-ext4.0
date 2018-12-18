Return-Path: <SRS0=0j4F=O3=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:16600 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726558AbeLROAh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 18 Dec 2018 09:00:37 -0500
From: "zhangyi (F)" <yi.zhang@huawei.com>
To: <linux-ext4@vger.kernel.org>
CC: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <yi.zhang@huawei.com>,
        <miaoxie@huawei.com>
Subject: [PATCH v2 1/2] ext4: use i_size_read() when converting initialized extent
Date: Tue, 18 Dec 2018 22:03:41 +0800
Message-ID: <1545141822-3082-2-git-send-email-yi.zhang@huawei.com>
In-Reply-To: <1545141822-3082-1-git-send-email-yi.zhang@huawei.com>
References: <1545141822-3082-1-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use i_size_read() in ext4_ext_convert_to_initialized() and
ext4_split_convert_extents() because we haven't taken inode->i_rwsem
in these two functions.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fs/ext4/extents.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 240b6de..0307fc6 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3483,7 +3483,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		(unsigned long long)map->m_lblk, map_len);
 
 	sbi = EXT4_SB(inode->i_sb);
-	eof_block = (inode->i_size + inode->i_sb->s_blocksize - 1) >>
+	eof_block = (i_size_read(inode) + inode->i_sb->s_blocksize - 1) >>
 		inode->i_sb->s_blocksize_bits;
 	if (eof_block < map->m_lblk + map_len)
 		eof_block = map->m_lblk + map_len;
@@ -3739,7 +3739,7 @@ static int ext4_split_convert_extents(handle_t *handle,
 		  __func__, inode->i_ino,
 		  (unsigned long long)map->m_lblk, map->m_len);
 
-	eof_block = (inode->i_size + inode->i_sb->s_blocksize - 1) >>
+	eof_block = (i_size_read(inode) + inode->i_sb->s_blocksize - 1) >>
 		inode->i_sb->s_blocksize_bits;
 	if (eof_block < map->m_lblk + map->m_len)
 		eof_block = map->m_lblk + map->m_len;
-- 
2.7.4
