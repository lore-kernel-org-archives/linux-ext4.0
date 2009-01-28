From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH] : Remove incompatible pointer assignment warning in ext4
	quota operations
Date: Wed, 28 Jan 2009 10:47:37 +0530
Message-ID: <ea11fea30901272117j760a34e8w5df0ec1916632f3f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mkatiyar@gmail.com
To: "Theodore Ts'o" <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.185]:30404 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbZA1FRj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Jan 2009 00:17:39 -0500
Received: by ti-out-0910.google.com with SMTP id b6so3428893tic.23
        for <linux-ext4@vger.kernel.org>; Tue, 27 Jan 2009 21:17:37 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Below patch removes the following warning during compilation :

  CC [M]  fs/ext4/super.o
fs/ext4/super.c:949: warning: initialization from incompatible pointer type
  LD [M]  fs/ext4/ext4.o


Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/ext4/ext4.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3ab1a41..0164866 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1088,7 +1088,7 @@ extern int ext4_chunk_trans_blocks(struct inode
*, int nrblocks);
 extern int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page);
-extern unsigned long long ext4_get_reserved_space(struct inode *inode);
+extern qsize_t ext4_get_reserved_space(struct inode *inode);

 /* ioctl.c */
 extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
-- 
1.5.4.3


Thanks -
Manish
