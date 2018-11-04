Return-Path: <SRS0=rf2I=NP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:46944 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731157AbeKECp0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 4 Nov 2018 21:45:26 -0500
From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH] ext4: missing !bh check in ext4_xattr_inode_write()
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-kernel@vger.kernel.org
Message-ID: <710ddac8-eb88-e631-3b27-74410039d15f@virtuozzo.com>
Date: Sun, 4 Nov 2018 20:29:39 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_getblk() called with map_flags=0 can return NULL,
it can lead to oops on bh dereferemce

Fixes e50e5129f384 ("ext4: xattr-in-inode support")
Cc: stable@kernel.org # 4.13

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 fs/ext4/xattr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 0b9688683526..6dc6c70828f0 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1384,6 +1384,8 @@ static int ext4_xattr_inode_write(handle_t *handle, struct inode *ea_inode,
 		bh = ext4_getblk(handle, ea_inode, block, 0);
 		if (IS_ERR(bh))
 			return PTR_ERR(bh);
+		if (!bh)
+			return -ENOMEM;
 		ret = ext4_journal_get_write_access(handle, bh);
 		if (ret)
 			goto out;
-- 
2.17.1
