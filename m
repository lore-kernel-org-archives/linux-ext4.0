Return-Path: <SRS0=65gx=NY=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:44031 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbeKMKBP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 13 Nov 2018 05:01:15 -0500
From: Chengguang Xu <cgxu519@gmx.com>
To: jack@suse.com
Cc: linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH 10/10] ext2: fix coding style for xattr.c
Date: Tue, 13 Nov 2018 08:04:48 +0800
Message-Id: <20181113000448.16023-11-cgxu519@gmx.com>
In-Reply-To: <20181113000448.16023-1-cgxu519@gmx.com>
References: <20181113000448.16023-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix various complains from checkpatch.pl

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/ext2/xattr.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 62d9a659a8ff..7908ff3a1884 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -88,14 +88,15 @@
 # define ea_bdebug(f...)
 #endif
 
-static int ext2_xattr_set2(struct inode *, struct buffer_head *,
-			   struct ext2_xattr_header *);
-
-static int ext2_xattr_cache_insert(struct mb_cache *, struct buffer_head *);
-static struct buffer_head *ext2_xattr_cache_find(struct inode *,
-						 struct ext2_xattr_header *);
-static void ext2_xattr_rehash(struct ext2_xattr_header *,
-			      struct ext2_xattr_entry *);
+static int ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
+			   struct ext2_xattr_header *header);
+
+static int ext2_xattr_cache_insert(struct mb_cache *cache,
+				   struct buffer_head *bh);
+static struct buffer_head *ext2_xattr_cache_find(struct inode *inode,
+					 struct ext2_xattr_header *header);
+static void ext2_xattr_rehash(struct ext2_xattr_header *header,
+			      struct ext2_xattr_entry *entry);
 
 static const struct xattr_handler *ext2_xattr_handler_map[] = {
 	[EXT2_XATTR_INDEX_USER]		     = &ext2_xattr_user_handler,
-- 
2.17.2
