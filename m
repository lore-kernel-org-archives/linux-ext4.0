From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 10/74] debugfs: fix various minor bogosity
Date: Tue, 10 Dec 2013 17:19:28 -0800
Message-ID: <20131211011928.30655.5637.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Darren Hart <dvhart@linux.intel.com>, linux-ext4@vger.kernel.org,
	Robert Yang <liezhi.yang@windriver.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26058 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3LKBTi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:19:38 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We should really use the ext2fs memory allocator functions in
copy_file(), and we really should return a value if there's allocation
problems.

Also fix up a minor bogosity in an error message.

v2: Fix the buffer free paths too.

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: Robert Yang <liezhi.yang@windriver.com>
Cc: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/debugfs.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)


diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index ea0f2c4..c5f8a1f 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -1602,16 +1602,17 @@ static errcode_t copy_file(int fd, ext2_ino_t newfile, int bufsize, int make_hol
 	if (retval)
 		return retval;
 
-	if (!(buf = (char *) malloc(bufsize))){
-		com_err("copy_file", errno, "can't allocate buffer\n");
-		return;
+	retval = ext2fs_get_mem(bufsize, &buf);
+	if (retval) {
+		com_err("copy_file", retval, "can't allocate buffer\n");
+		return retval;
 	}
 
 	/* This is used for checking whether the whole block is zero */
 	retval = ext2fs_get_memzero(bufsize, &zero_buf);
 	if (retval) {
 		com_err("copy_file", retval, "can't allocate buffer\n");
-		free(buf);
+		ext2fs_free_mem(&buf);
 		return retval;
 	}
 
@@ -1649,13 +1650,13 @@ static errcode_t copy_file(int fd, ext2_ino_t newfile, int bufsize, int make_hol
 			ptr += written;
 		}
 	}
-	free(buf);
+	ext2fs_free_mem(&buf);
 	ext2fs_free_mem(&zero_buf);
 	retval = ext2fs_file_close(e2_file);
 	return retval;
 
 fail:
-	free(buf);
+	ext2fs_free_mem(&buf);
 	ext2fs_free_mem(&zero_buf);
 	(void) ext2fs_file_close(e2_file);
 	return retval;
@@ -2113,7 +2114,7 @@ void do_bmap(int argc, char *argv[])
 
 	errcode = ext2fs_bmap2(current_fs, ino, 0, 0, 0, blk, 0, &pblk);
 	if (errcode) {
-		com_err("argv[0]", errcode,
+		com_err(argv[0], errcode,
 			"while mapping logical block %llu\n", blk);
 		return;
 	}

