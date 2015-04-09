From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] ext4 crypto: fix an error code in ext4_init_crypto()
Date: Thu, 9 Apr 2015 12:03:08 +0300
Message-ID: <20150409090308.GB17605@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Michael Halcrow <mhalcrow@google.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The callers don't care about the error so it doesn't make a difference,
but static checkers complain so let's return an error code here.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index 226e07f..6110ccd 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -233,7 +233,7 @@ void ext4_exit_crypto(void)
  */
 int ext4_init_crypto(void)
 {
-	int i, res = 0;
+	int i, res;
 
 	mutex_lock(&crypto_init);
 	if (ext4_read_workqueue)
@@ -257,8 +257,10 @@ int ext4_init_crypto(void)
 
 	ext4_bounce_page_pool =
 		mempool_create_page_pool(num_prealloc_crypto_pages, 0);
-	if (!ext4_bounce_page_pool)
+	if (!ext4_bounce_page_pool) {
+		res = -ENOMEM;
 		goto fail;
+	}
 already_initialized:
 	mutex_unlock(&crypto_init);
 	return 0;
