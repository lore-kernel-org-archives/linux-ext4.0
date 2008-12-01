From: roel kluin <roel.kluin@gmail.com>
Subject: [PATCH v2] ext3, ext4: do_split() fix loop, with obvious unsigned
 wrap
Date: Mon, 01 Dec 2008 14:28:25 -0500
Message-ID: <49343AD9.4020606@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, adilger@sun.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: davidsen@tmr.com
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753853AbYLAT2r@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Fix loop, with obvious unsigned wrap

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 3e5edc9..b0dcfb3 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1188,7 +1188,7 @@ static struct ext3_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	/* Split the existing block in the middle, size-wise */
 	size = 0;
 	move = 0;
-	for (i = count-1; i >= 0; i--) {
+	for (i = count; i--; ) {
 		/* is more than half of this entry in 2nd half of the block? */
 		if (size + map[i].size/2 > blocksize/2)
 			break;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 63adcb7..34232c6 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1198,7 +1198,7 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	/* Split the existing block in the middle, size-wise */
 	size = 0;
 	move = 0;
-	for (i = count-1; i >= 0; i--) {
+	for (i = count; i--; ) {
 		/* is more than half of this entry in 2nd half of the block? */
 		if (size + map[i].size/2 > blocksize/2)
 			break;
