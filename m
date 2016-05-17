From: Colin King <colin.king@canonical.com>
Subject: [PATCH] ext4: remove unused variable offset
Date: Tue, 17 May 2016 11:47:54 +0100
Message-ID: <1463482074-12365-1-git-send-email-colin.king@canonical.com>
Cc: linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

static analysis with smatch detected that offset is not used in
ext4_direct_IO_read, so remove it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/ext4/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cd72f20..f7140ca 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3499,7 +3499,6 @@ static ssize_t ext4_direct_IO_read(struct kiocb *iocb, struct iov_iter *iter)
 {
 	int unlocked = 0;
 	struct inode *inode = iocb->ki_filp->f_mapping->host;
-	loff_t offset = iocb->ki_pos;
 	ssize_t ret;
 
 	if (ext4_should_dioread_nolock(inode)) {
-- 
2.8.1
