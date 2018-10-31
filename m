Return-Path: <SRS0=VEyz=NL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:47210 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725731AbeKAEMR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 1 Nov 2018 00:12:17 -0400
From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 5/7] ext4: bs.bh cleanup before re-using in
 ext4_xattr_block_find()
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org, Tiger Yang <tiger.yang@oracle.com>
References: <cover.1541011937.git.vvs@virtuozzo.com>
Message-ID: <1a83ea26-a159-490a-1e07-e7c8f187672a@virtuozzo.com>
Date: Wed, 31 Oct 2018 22:12:52 +0300
MIME-Version: 1.0
In-Reply-To: <cover.1541011937.git.vvs@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

bs.bh was taken in previous ext4_xattr_block_find() call,
it should be released before re-using

Fixes 7e01c8e5420b ("ext3/4: fix uninitialized bs in ...") # 2.6.26
cc: Tiger Yang <tiger.yang@oracle.com>

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 fs/ext4/xattr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 07c3a115f7ae..07b9a335c8eb 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2395,6 +2395,8 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 			error = ext4_xattr_block_set(handle, inode, &i, &bs);
 		} else if (error == -ENOSPC) {
 			if (EXT4_I(inode)->i_file_acl && !bs.s.base) {
+				brelse(bs.bh);
+				bs.bh = NULL;
 				error = ext4_xattr_block_find(inode, &i, &bs);
 				if (error)
 					goto cleanup;
-- 
2.17.1
