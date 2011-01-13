From: Simon Xu <xu.simon@oracle.com>
Subject: [PATCH] ext4: reduce redundant check of '*options'
Date: Thu, 13 Jan 2011 20:45:32 +0800
Message-ID: <1294922732-2385-1-git-send-email-xu.simon@oracle.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Simon Xu <xu.simon@oracle.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We don't need to check whether '*options' equals to ',' twice.

Signed-off-by: Simon Xu <xu.simon@oracle.com>
---
 fs/ext4/super.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 29c80f6..5d8c173 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1350,13 +1350,13 @@ static ext4_fsblk_t get_sb_block(void **data)
 	options += 3;
 	/* TODO: use simple_strtoll with >32bit ext4 */
 	sb_block = simple_strtoul(options, &options, 0);
-	if (*options && *options != ',') {
+	if (*options == ',') {
+		options++;
+	else if (*options) {
 		printk(KERN_ERR "EXT4-fs: Invalid sb specification: %s\n",
 		       (char *) *data);
 		return 1;
 	}
-	if (*options == ',')
-		options++;
 	*data = (void *) options;
 
 	return sb_block;
-- 
1.7.3.5
