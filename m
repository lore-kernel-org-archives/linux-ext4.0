From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/5] mke2fs: enforce that the cluster size must be less that the block size
Date: Mon, 14 Jan 2013 19:37:08 -0500
Message-ID: <1358210232-30578-1-git-send-email-tytso@mit.edu>
References: <20130114211014.GA22642@thunk.org>
Cc: gnehzuil.liu@gmail.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43389 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756764Ab3AOAhT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jan 2013 19:37:19 -0500
In-Reply-To: <20130114211014.GA22642@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In addition, do not allow a cluster size of 1024, since that will be
interpreted by ext2fs_initialize() as requesting the default cluster
size.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reported-by: Zheng Liu <wenqing.lz@taobao.com>
---
 misc/mke2fs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 4748f4a..75d0e48 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1346,7 +1346,7 @@ profile_error:
 			break;
 		case 'C':
 			cluster_size = strtoul(optarg, &tmp, 0);
-			if (cluster_size < EXT2_MIN_CLUSTER_SIZE ||
+			if (cluster_size <= EXT2_MIN_CLUSTER_SIZE ||
 			    cluster_size > EXT2_MAX_CLUSTER_SIZE || *tmp) {
 				com_err(program_name, 0,
 					_("invalid cluster size - %s"),
@@ -1847,6 +1847,13 @@ profile_error:
 							    blocksize*16);
 		fs_param.s_log_cluster_size =
 			int_log2(cluster_size >> EXT2_MIN_CLUSTER_LOG_SIZE);
+		if (fs_param.s_log_cluster_size &&
+		    fs_param.s_log_cluster_size < fs_param.s_log_block_size) {
+			com_err(program_name, 0,
+				_("The cluster size must not be "
+				  "smaller than the block size.\n"));
+			exit(1);
+		}
 	} else if (cluster_size) {
 		com_err(program_name, 0,
 			_("specifying a cluster size requires the "
-- 
1.7.12.rc0.22.gcdd159b

