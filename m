Return-Path: <SRS0=65gx=NY=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:37739 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbeKMKBD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 13 Nov 2018 05:01:03 -0500
From: Chengguang Xu <cgxu519@gmx.com>
To: jack@suse.com
Cc: linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH 06/10] ext2: fix coding style for file.c
Date: Tue, 13 Nov 2018 08:04:44 +0800
Message-Id: <20181113000448.16023-7-cgxu519@gmx.com>
In-Reply-To: <20181113000448.16023-1-cgxu519@gmx.com>
References: <20181113000448.16023-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix various complains from checkpatch.pl

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/ext2/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 28b2609f25c1..3820b17241af 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -137,7 +137,7 @@ static int ext2_file_mmap(struct file *file, struct vm_area_struct *vma)
  * for a single struct file are closed. Note that different open() calls
  * for the same file yield different struct file structures.
  */
-static int ext2_release_file (struct inode * inode, struct file * filp)
+static int ext2_release_file(struct inode *inode, struct file *filp)
 {
 	if (filp->f_mode & FMODE_WRITE) {
 		mutex_lock(&EXT2_I(inode)->truncate_mutex);
-- 
2.17.2
