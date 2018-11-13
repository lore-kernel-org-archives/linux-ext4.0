Return-Path: <SRS0=65gx=NY=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:35481 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbeKMKBy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 13 Nov 2018 05:01:54 -0500
From: Chengguang Xu <cgxu519@gmx.com>
To: jack@suse.com
Cc: linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH 01/10] ext2: fix coding style for acl.h
Date: Tue, 13 Nov 2018 08:04:39 +0800
Message-Id: <20181113000448.16023-2-cgxu519@gmx.com>
In-Reply-To: <20181113000448.16023-1-cgxu519@gmx.com>
References: <20181113000448.16023-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix various complains from checkpatch.pl

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/ext2/acl.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/acl.h b/fs/ext2/acl.h
index 0f01c759daac..768e490ac5e5 100644
--- a/fs/ext2/acl.h
+++ b/fs/ext2/acl.h
@@ -57,14 +57,14 @@ static inline int ext2_acl_count(size_t size)
 /* acl.c */
 extern struct posix_acl *ext2_get_acl(struct inode *inode, int type);
 extern int ext2_set_acl(struct inode *inode, struct posix_acl *acl, int type);
-extern int ext2_init_acl (struct inode *, struct inode *);
+extern int ext2_init_acl(struct inode *inode, struct inode *dir);
 
 #else
 #include <linux/sched.h>
 #define ext2_get_acl	NULL
 #define ext2_set_acl	NULL
 
-static inline int ext2_init_acl (struct inode *inode, struct inode *dir)
+static inline int ext2_init_acl(struct inode *inode, struct inode *dir)
 {
 	return 0;
 }
-- 
2.17.2
