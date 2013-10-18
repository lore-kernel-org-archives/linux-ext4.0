From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 08/25] debugfs: fix various minor bogosity
Date: Thu, 17 Oct 2013 21:49:48 -0700
Message-ID: <20131018044948.7339.56696.stgit@birch.djwong.org>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Darren Hart <dvhart@linux.intel.com>, linux-ext4@vger.kernel.org,
	Robert Yang <liezhi.yang@windriver.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30531 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab3JREtz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Oct 2013 00:49:55 -0400
In-Reply-To: <20131018044854.7339.48457.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We should really use the ext2fs memory allocator functions in
copy_file(), and we really should return a value if there's allocation
problems.

Also fix up a minor bogosity in an error message.

Cc: Robert Yang <liezhi.yang@windriver.com>
Cc: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/debugfs.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)


diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 4f6108d..d3db356 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -1601,9 +1601,10 @@ static errcode_t copy_file(int fd, ext2_ino_t newfile, int bufsize, int make_hol
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
@@ -1654,7 +1655,7 @@ static errcode_t copy_file(int fd, ext2_ino_t newfile, int bufsize, int make_hol
 	return retval;
 
 fail:
-	free(buf);
+	ext2fs_free_mem(&buf);
 	ext2fs_free_mem(&zero_buf);
 	(void) ext2fs_file_close(e2_file);
 	return retval;
@@ -2112,7 +2113,7 @@ void do_bmap(int argc, char *argv[])
 
 	errcode = ext2fs_bmap2(current_fs, ino, 0, 0, 0, blk, 0, &pblk);
 	if (errcode) {
-		com_err("argv[0]", errcode,
+		com_err(argv[0], errcode,
 			"while mapping logical block %llu\n", blk);
 		return;
 	}

