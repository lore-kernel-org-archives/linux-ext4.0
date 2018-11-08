Return-Path: <SRS0=LXqi=NT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:60708 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725945AbeKHQUf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 8 Nov 2018 11:20:35 -0500
From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v2] ext4: missing !bh check in ext4_xattr_inode_write()
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-kernel@vger.kernel.org
References: <20181107163346.GH9919@thunk.org>
Message-ID: <a3f1e28c-fba0-2b07-b710-c559fab555b8@virtuozzo.com>
Date: Thu, 8 Nov 2018 09:46:30 +0300
MIME-Version: 1.0
In-Reply-To: <20181107163346.GH9919@thunk.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

According to Ted Ts'o ext4_getblk() called in ext4_xattr_inode_write()
should not return bh = NULL

The only time that bh could be NULL, then, would be in the case of
something really going wrong; a programming error elsewhere (perhaps a
wild pointer dereference) or I/O error causing on-disk file system
corruption (although that would be highly unlikely given that we had
*just* allocated the blocks and so the metadata blocks in question
probably would still be in the cache).

Fixes e50e5129f384 ("ext4: xattr-in-inode support")
Cc: stable@kernel.org # 4.13

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 fs/ext4/xattr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 0b9688683526..415f73d4c9e6 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1384,6 +1384,12 @@ static int ext4_xattr_inode_write(handle_t *handle, struct inode *ea_inode,
 		bh = ext4_getblk(handle, ea_inode, block, 0);
 		if (IS_ERR(bh))
 			return PTR_ERR(bh);
+		if (!bh) {
+			WARN_ON_ONCE(1);
+			__ext4_error_inode(ea_inode, __func__, __LINE__, 0,
+					   "ext4_getblk() return bh = NULL");
+			return -EFSCORRUPTED;
+		}
 		ret = ext4_journal_get_write_access(handle, bh);
 		if (ret)
 			goto out;
-- 
2.17.1
