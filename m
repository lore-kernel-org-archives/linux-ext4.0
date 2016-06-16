From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] ext4: underflow in alignment check
Date: Thu, 16 Jun 2016 10:07:09 +0300
Message-ID: <20160616070709.GC23129@mwanda>
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

My static checker complains that this can underflow if arg is negative
which is true.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b1a3471..a2a17e9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1576,7 +1576,7 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 	} else if (token == Opt_min_batch_time) {
 		sbi->s_min_batch_time = arg;
 	} else if (token == Opt_inode_readahead_blks) {
-		if (arg && (arg > (1 << 30) || !is_power_of_2(arg))) {
+		if (arg && (arg > (1U << 30) || !is_power_of_2(arg))) {
 			ext4_msg(sb, KERN_ERR,
 				 "EXT4-fs: inode_readahead_blks must be "
 				 "0 or a power of 2 smaller than 2^31");
