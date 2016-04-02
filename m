From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] ext4 crypto: fix some error handling
Date: Sat, 2 Apr 2016 07:49:16 +0300
Message-ID: <20160402044916.GC11775@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We should be testing for -ENOMEM but the minus sign is missing.

Fixes: c9af28fdd449 ('ext4 crypto: don't let data integrity writebacks fail with ENOMEM')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 51b3492..b39d9c7 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -477,7 +477,7 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 		data_page = ext4_encrypt(inode, page, gfp_flags);
 		if (IS_ERR(data_page)) {
 			ret = PTR_ERR(data_page);
-			if (ret == ENOMEM && wbc->sync_mode == WB_SYNC_ALL) {
+			if (ret == -ENOMEM && wbc->sync_mode == WB_SYNC_ALL) {
 				if (io->io_bio) {
 					ext4_io_submit(io);
 					congestion_wait(BLK_RW_ASYNC, HZ/50);
