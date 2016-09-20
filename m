From: Eric Engestrom <eric.engestrom@imgtec.com>
Subject: [PATCH 1/2] ext4: remove unused variable
Date: Tue, 20 Sep 2016 17:16:18 +0100
Message-ID: <20160920161619.16586-1-eric.engestrom@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Eric Engestrom <eric.engestrom@imgtec.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>
To: <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Eric Engestrom <eric.engestrom@imgtec.com>
---
 fs/ext4/dir.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 67415e0..acd76f1 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -627,7 +627,7 @@ int ext4_check_all_de(struct inode *dir, struct buffer_head *bh, void *buf,
 		      int buf_size)
 {
 	struct ext4_dir_entry_2 *de;
-	int nlen, rlen;
+	int rlen;
 	unsigned int offset = 0;
 	char *top;
 
@@ -637,7 +637,6 @@ int ext4_check_all_de(struct inode *dir, struct buffer_head *bh, void *buf,
 		if (ext4_check_dir_entry(dir, NULL, de, bh,
 					 buf, buf_size, offset))
 			return -EFSCORRUPTED;
-		nlen = EXT4_DIR_REC_LEN(de->name_len);
 		rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
 		de = (struct ext4_dir_entry_2 *)((char *)de + rlen);
 		offset += rlen;
-- 
Cheers,
  Eric
