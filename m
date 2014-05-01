From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 04/37] mke2fs: always warn if 128-byte inode and inline_data
Date: Thu, 01 May 2014 16:12:49 -0700
Message-ID: <20140501231249.31890.43562.stgit@birch.djwong.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38660 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaEAXMy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 May 2014 19:12:54 -0400
In-Reply-To: <20140501231222.31890.82860.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The combination of 128-byte inodes and inline_data is silly, since
there's no room in the inode table.  Unfortunately, if neither
mke2fs.conf nor the mkfs command line options specify an inode size,
the default inode size is set to 128 bytes (by libext2fs) and the
warning isn't printed.  Therefore, always do the check-and-warning.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/mke2fs.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)


diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index aecd5d5..6507d0d 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2282,21 +2282,22 @@ profile_error:
 				blocksize);
 			exit(1);
 		}
-		/*
-		 * If inode size is 128 and inline data is enabled, we need
-		 * to notify users that inline data will never be useful.
-		 */
-		if ((fs_param.s_feature_incompat &
-		     EXT4_FEATURE_INCOMPAT_INLINE_DATA) &&
-		    inode_size == EXT2_GOOD_OLD_INODE_SIZE) {
-			com_err(program_name, 0,
-				_("inode size is %d, inline data is useless"),
-				inode_size);
-			exit(1);
-		}
 		fs_param.s_inode_size = inode_size;
 	}
 
+	/*
+	 * If inode size is 128 and inline data is enabled, we need
+	 * to notify users that inline data will never be useful.
+	 */
+	if ((fs_param.s_feature_incompat &
+	     EXT4_FEATURE_INCOMPAT_INLINE_DATA) &&
+	    fs_param.s_inode_size == EXT2_GOOD_OLD_INODE_SIZE) {
+		com_err(program_name, 0,
+			_("inode size is %d, inline data is useless"),
+			inode_size);
+		exit(1);
+	}
+
 	/* Make sure number of inodes specified will fit in 32 bits */
 	if (num_inodes == 0) {
 		unsigned long long n;

