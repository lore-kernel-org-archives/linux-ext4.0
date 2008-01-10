From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH] e2fsprogs: play with 8TB to 16TB fs's better
Date: Thu, 10 Jan 2008 16:53:21 -0500
Message-ID: <20080110215321.GI3323@unused.rdu.redhat.com>
References: <20080108193325.GB3323@unused.rdu.redhat.com> <20080108230215.GI3351@webber.adilger.int> <20080109210438.GF3323@unused.rdu.redhat.com> <20080110035934.GD3351@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: adilger@sun.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970AbYAJVyF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Jan 2008 16:54:05 -0500
Content-Disposition: inline
In-Reply-To: <20080110035934.GD3351@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Here's take 3.  I've moved the blocks >= 1 << 31 check after the instantiation
of the ext2_filsys so I can use the io manager stuff directly.  Also made a few
tweaks and such based on Andreas' comments.  Let me know if this works.  Thank
you,

Josef


Index: e2fsprogs/lib/ext2fs/getsize.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/getsize.c
+++ e2fsprogs/lib/ext2fs/getsize.c
@@ -135,6 +135,21 @@ static int valid_offset (int fd, ext2_lo
 	return 1;
 }
 
+static int valid_size(unsigned long long *size64, int blocksize)
+{
+	/* see if we are above 16tb */
+	if ((*size64 / blocksize) > 0xFFFFFFFF) {
+		/* if we are just at 2^32 blocks adjust the size slightly */
+		if ((*size64 / blocksize) == 0x100000000) {
+			(*size64)--;
+			return 1;
+		} else
+			return 0;
+	}
+
+	return 1;
+}
+
 /*
  * Returns the number of blocks in a partition
  */
@@ -189,7 +204,7 @@ errcode_t ext2fs_get_device_size(const c
 	if (valid_blkgetsize64 &&
 	    ioctl(fd, BLKGETSIZE64, &size64) >= 0) {
 		if ((sizeof(*retblocks) < sizeof(unsigned long long)) &&
-		    ((size64 / blocksize) > 0xFFFFFFFF)) {
+		    !valid_size(&size64, blocksize)) {
 			rc = EFBIG;
 			goto out;
 		}
@@ -252,13 +267,14 @@ errcode_t ext2fs_get_device_size(const c
 		struct stat	st;
 		if (fstat(fd, &st) == 0)
 #endif
+			size64 = st.st_size;
 			if (S_ISREG(st.st_mode)) {
 				if ((sizeof(*retblocks) < sizeof(unsigned long long)) &&
-				    ((st.st_size / blocksize) > 0xFFFFFFFF)) {
+				    !valid_size(&size64, blocksize)) {
 					rc = EFBIG;
 					goto out;
 				}
-				*retblocks = st.st_size / blocksize;
+				*retblocks = size64 / blocksize;
 				goto out;
 			}
 	}
@@ -283,7 +299,7 @@ errcode_t ext2fs_get_device_size(const c
 	valid_offset (fd, 0);
 	size64 = low + 1;
 	if ((sizeof(*retblocks) < sizeof(unsigned long long))
-	    && ((size64 / blocksize) > 0xFFFFFFFF)) {
+	    && !valid_size(&size64, blocksize)) {
 		rc = EFBIG;
 		goto out;
 	}
Index: e2fsprogs/misc/mke2fs.c
===================================================================
--- e2fsprogs.orig/misc/mke2fs.c
+++ e2fsprogs/misc/mke2fs.c
@@ -916,6 +916,54 @@ static void edit_feature(const char *str
 	}
 }
 
+static errcode_t check_for_wrap(ext2_filsys fs)
+{
+	char *buf, *orig;
+	errcode_t retval;
+
+	buf = malloc(fs->blocksize);
+	if (!buf) {
+		com_err(program_name, retval, "trying to allocate buffer\n");
+		exit(1);
+	}
+
+	orig = malloc(fs->blocksize);
+	if (!orig) {
+		com_err(program_name, retval, "trying to allocate buffer\n");
+		free(buf);
+		exit(1);
+	}
+
+	memset(buf, 0, fs->blocksize);
+	memset(orig, 0, fs->blocksize);
+
+	retval = io_channel_write_blk(fs->io, 1, 1, buf);
+	if (retval)
+		goto out;
+
+	memset(buf, 0xdead, fs->blocksize);
+	retval = io_channel_write_blk(fs->io, (1UL << 31)+1, 1, buf);
+	if (retval)
+		goto out;
+
+	retval = io_channel_flush(fs->io);
+	if (retval)
+		goto out;
+
+	retval = io_channel_read_blk(fs->io, 1, 1, buf);
+	if (retval)
+		goto out;
+
+	if (memcmp(buf, orig, fs->blocksize))
+		retval = -1;
+
+out:
+	free(buf);
+	free(orig);
+
+	return retval;
+}
+
 extern const char *mke2fs_default_profile;
 static const char *default_files[] = { "<default>", 0 };
 
@@ -1455,13 +1503,6 @@ static void PRS(int argc, char *argv[])
 		}
 	}
 
-	if (!force && fs_param.s_blocks_count >= ((unsigned) 1 << 31)) {
-		com_err(program_name, 0,
-			_("Filesystem too large.  No more than 2**31-1 blocks\n"
-			  "\t (8TB using a blocksize of 4k) are currently supported."));
-             exit(1);
-	}
-
 	if ((blocksize > 4096) &&
 	    (fs_param.s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL))
 		fprintf(stderr, _("\nWarning: some 2.4 kernels do not support "
@@ -1572,6 +1613,23 @@ int main (int argc, char *argv[])
 		exit(1);
 	}
 
+	if (fs->super->s_blocks_count >= ((unsigned) 1 << 31)) {
+		if (!noaction) {
+			retval = check_for_wrap(fs);
+			if (retval) {
+				com_err(program_name, retval, "Write wrapped,"
+					"filesystem is too large for the disk"
+					"to handle %d\n", (signed)retval);
+				exit(1);
+			}
+		}
+
+		com_err(program_name, 0, "\nWarning: older 2.6 kernels "
+		       "(2.6.18 and older) may have problems with such a \n\t"
+		       "large filesystem.  If you have problems try a newer "
+		       "kernel\n");
+	}
+
 	/*
 	 * Wipe out the old on-disk superblock
 	 */
