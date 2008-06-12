From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 1/2] ext3: kill 2 useless magic numbers
Date: Thu, 12 Jun 2008 09:18:28 +0800
Message-ID: <48507964.1060309@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:64767 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbYFLBT6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jun 2008 21:19:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

dx_root_limit() will never return 20, and I can't figure out
what 20 stands for. This function has never changed since htree
directory indexing was merged.

Similar for dx_node_limit() and the magic 22.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/ext3/namei.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 0b8cf80..d282ea8 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -240,13 +240,13 @@ static inline unsigned dx_root_limit (struct inode *dir, unsigned infosize)
 {
 	unsigned entry_space = dir->i_sb->s_blocksize - EXT3_DIR_REC_LEN(1) -
 		EXT3_DIR_REC_LEN(2) - infosize;
-	return 0? 20: entry_space / sizeof(struct dx_entry);
+	return entry_space / sizeof(struct dx_entry);
 }
 
 static inline unsigned dx_node_limit (struct inode *dir)
 {
 	unsigned entry_space = dir->i_sb->s_blocksize - EXT3_DIR_REC_LEN(0);
-	return 0? 22: entry_space / sizeof(struct dx_entry);
+	return entry_space / sizeof(struct dx_entry);
 }
 
 /*
-- 
1.5.4.rc3

