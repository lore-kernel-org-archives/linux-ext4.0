From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 07/25] mke2fs: load configfile blocksize setting before 64bit
 checks
Date: Thu, 17 Oct 2013 21:49:42 -0700
Message-ID: <20131018044941.7339.43212.stgit@birch.djwong.org>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30511 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3JREtq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Oct 2013 00:49:46 -0400
In-Reply-To: <20131018044854.7339.48457.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

mke2fs has a series of checks to ensure that we don't create a
filesystem too big for its blocksize -- if auto-64bit is on, then it
turns on 64bit; otherwise it complains.  Unfortunately, it performs
these checks before looking in mke2fs.conf for a blocksize, which
means that the checks are incorrect if the user specifies a non-4096
blocksize in the config file and says nothing on the command line.  It
also has the effect of mandating a 4k block size on any block device
larger than 4T in that situation.  Therefore, read the block size from
the config file before performing the 64bit checks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/mke2fs.c |  132 ++++++++++++++++++++++++++++++---------------------------
 1 file changed, 70 insertions(+), 62 deletions(-)


diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index ce3c696..86091d7 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1298,6 +1298,21 @@ static void PRS(int argc, char *argv[])
 	char *		fs_type = 0;
 	char *		usage_types = 0;
 	blk64_t		dev_size;
+	/*
+	 * NOTE: A few words about fs_blocks_count and blocksize:
+	 *
+	 * Initially, blocksize is set to zero, which implies 1024.
+	 * If -b is specified, blocksize is updated to the user's value.
+	 *
+	 * Next, the device size or the user's "blocks" command line argument
+	 * is used to set fs_blocks_count; the units are blocksize.
+	 *
+	 * Later, if blocksize hasn't been set and the profile specifies a
+	 * blocksize, then blocksize is updated and fs_blocks_count is scaled
+	 * appropriately.  Note the change in units!
+	 *
+	 * Finally, we complain about fs_blocks_count > 2^32 on a non-64bit fs.
+	 */
 	blk64_t		fs_blocks_count = 0;
 #ifdef __linux__
 	struct 		utsname ut;
@@ -1780,15 +1795,65 @@ profile_error:
 		}
 	}
 
+	/* Get the hardware sector sizes, if available */
+	retval = ext2fs_get_device_sectsize(device_name, &lsector_size);
+	if (retval) {
+		com_err(program_name, retval,
+			_("while trying to determine hardware sector size"));
+		exit(1);
+	}
+	retval = ext2fs_get_device_phys_sectsize(device_name, &psector_size);
+	if (retval) {
+		com_err(program_name, retval,
+			_("while trying to determine physical sector size"));
+		exit(1);
+	}
+
+	if ((tmp = getenv("MKE2FS_DEVICE_SECTSIZE")) != NULL)
+		lsector_size = atoi(tmp);
+	if ((tmp = getenv("MKE2FS_DEVICE_PHYS_SECTSIZE")) != NULL)
+		psector_size = atoi(tmp);
+
+	/* Older kernels may not have physical/logical distinction */
+	if (!psector_size)
+		psector_size = lsector_size;
+
+	if (blocksize <= 0) {
+		use_bsize = get_int_from_profile(fs_types, "blocksize", 4096);
+
+		if (use_bsize == -1) {
+			use_bsize = sys_page_size;
+			if ((linux_version_code < (2*65536 + 6*256)) &&
+			    (use_bsize > 4096))
+				use_bsize = 4096;
+		}
+		if (lsector_size && use_bsize < lsector_size)
+			use_bsize = lsector_size;
+		if ((blocksize < 0) && (use_bsize < (-blocksize)))
+			use_bsize = -blocksize;
+		blocksize = use_bsize;
+		fs_blocks_count /= (blocksize / 1024);
+	} else {
+		if (blocksize < lsector_size) {			/* Impossible */
+			com_err(program_name, EINVAL,
+				_("while setting blocksize; too small "
+				  "for device\n"));
+			exit(1);
+		} else if ((blocksize < psector_size) &&
+			   (psector_size <= sys_page_size)) {	/* Suboptimal */
+			fprintf(stderr, _("Warning: specified blocksize %d is "
+				"less than device physical sectorsize %d\n"),
+				blocksize, psector_size);
+		}
+	}
+
+	fs_param.s_log_block_size =
+		int_log2(blocksize >> EXT2_MIN_BLOCK_LOG_SIZE);
+
 	/*
 	 * We now need to do a sanity check of fs_blocks_count for
 	 * 32-bit vs 64-bit block number support.
 	 */
-	if ((fs_blocks_count > MAX_32_NUM) && (blocksize == 0)) {
-		fs_blocks_count /= 4; /* Try using a 4k blocksize */
-		blocksize = 4096;
-		fs_param.s_log_block_size = 2;
-	}
 	if ((fs_blocks_count > MAX_32_NUM) &&
 	    !(fs_param.s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) &&
 	    get_bool_from_profile(fs_types, "auto_64-bit_support", 0)) {
@@ -1889,63 +1954,6 @@ profile_error:
 	if ((fs_param.s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) &&
 	    ((tmp = getenv("MKE2FS_FIRST_META_BG"))))
 		fs_param.s_first_meta_bg = atoi(tmp);
-
-	/* Get the hardware sector sizes, if available */
-	retval = ext2fs_get_device_sectsize(device_name, &lsector_size);
-	if (retval) {
-		com_err(program_name, retval,
-			_("while trying to determine hardware sector size"));
-		exit(1);
-	}
-	retval = ext2fs_get_device_phys_sectsize(device_name, &psector_size);
-	if (retval) {
-		com_err(program_name, retval,
-			_("while trying to determine physical sector size"));
-		exit(1);
-	}
-
-	if ((tmp = getenv("MKE2FS_DEVICE_SECTSIZE")) != NULL)
-		lsector_size = atoi(tmp);
-	if ((tmp = getenv("MKE2FS_DEVICE_PHYS_SECTSIZE")) != NULL)
-		psector_size = atoi(tmp);
-
-	/* Older kernels may not have physical/logical distinction */
-	if (!psector_size)
-		psector_size = lsector_size;
-
-	if (blocksize <= 0) {
-		use_bsize = get_int_from_profile(fs_types, "blocksize", 4096);
-
-		if (use_bsize == -1) {
-			use_bsize = sys_page_size;
-			if ((linux_version_code < (2*65536 + 6*256)) &&
-			    (use_bsize > 4096))
-				use_bsize = 4096;
-		}
-		if (lsector_size && use_bsize < lsector_size)
-			use_bsize = lsector_size;
-		if ((blocksize < 0) && (use_bsize < (-blocksize)))
-			use_bsize = -blocksize;
-		blocksize = use_bsize;
-		ext2fs_blocks_count_set(&fs_param,
-					ext2fs_blocks_count(&fs_param) /
-					(blocksize / 1024));
-	} else {
-		if (blocksize < lsector_size) {			/* Impossible */
-			com_err(program_name, EINVAL,
-				_("while setting blocksize; too small "
-				  "for device\n"));
-			exit(1);
-		} else if ((blocksize < psector_size) &&
-			   (psector_size <= sys_page_size)) {	/* Suboptimal */
-			fprintf(stderr, _("Warning: specified blocksize %d is "
-				"less than device physical sectorsize %d\n"),
-				blocksize, psector_size);
-		}
-	}
