From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH] e2fsprogs: play with 8TB to 16TB fs's better
Date: Wed, 9 Jan 2008 16:04:38 -0500
Message-ID: <20080109210438.GF3323@unused.rdu.redhat.com>
References: <20080108193325.GB3323@unused.rdu.redhat.com> <20080108230215.GI3351@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: adilger@sun.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbYAIVFT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Jan 2008 16:05:19 -0500
Content-Disposition: inline
In-Reply-To: <20080108230215.GI3351@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 08, 2008 at 04:02:16PM -0700, Andreas Dilger wrote:
> On Jan 08, 2008  14:33 -0500, Josef Bacik wrote:
> > @@ -190,8 +190,13 @@ errcode_t ext2fs_get_device_size(const c
> >  	    ioctl(fd, BLKGETSIZE64, &size64) >= 0) {
> >  		if ((sizeof(*retblocks) < sizeof(unsigned long long)) &&
> >  		    ((size64 / blocksize) > 0xFFFFFFFF)) {
> > -			rc = EFBIG;
> > -			goto out;
> > +			/* 16tb fs is fine, just adjust slightly */
> > +			if ((size64 / blocksize) == 0x100000000) {
> > +				size64--;
> > +			} else {
> > +				rc = EFBIG;
> > +				goto out;
> > +			}
> 
> It might be cleaner to localize this check/fixup into a small helper function?
> 
> > +++ e2fsprogs/misc/mke2fs.c
> > @@ -1455,13 +1455,6 @@ static void PRS(int argc, char *argv[])
> > -	if (!force && fs_param.s_blocks_count >= ((unsigned) 1 << 31)) {
> > -		com_err(program_name, 0,
> > -			_("Filesystem too large.  No more than 2**31-1 blocks\n"
> > -			  "\t (8TB using a blocksize of 4k) are currently supported."));
> > -             exit(1);
> > -	}
> > -
> >  	if ((blocksize > 4096) &&
> >  	    (fs_param.s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL))
> >  		fprintf(stderr, _("\nWarning: some 2.4 kernels do not support "
> 
> It is also worthwhile to report at least a warning for filesystems larger
> than 0x7fffffff blocks that older kernels (2.6.18 and older, IIRC) don't
> necessarily work correctly with such large filesystems.
> 
> Doing something like having mke2fs zero out block 1, flush it from cache
> with ioctl(BLKFLSBUF), then write some data at 8TB+1 to verify it doesn't
> clobber block 1 might also be prudent.  I've seen some RAID arrays do this
> in the past, and when we pass 0xffffffff blocks we should do the same so
> it may as well be a simple helper function.
>

Ok I've reworked this with your comments in mind.  Tested it with 6TB, 8TB,
10TB, 16TB and 17TB to make sure everything was kosher.  Let me know how this
works.  Thank you,

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
+		/* if we are just at 16tb adjust the size slightly */
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
@@ -916,6 +916,90 @@ static void edit_feature(const char *str
 	}
 }
 
+static int check_for_wrap(const char *file, int blocksize)
+{
+	int fd, tmp, total = 0;
+	char buffer[blocksize];
+
+#ifdef HAVE_OPEN64
+	fd = open64(file, O_RDWR);
+#else
+	fd = open(file, O_RDWR);
+#endif
+
+	if (fd < 0) {
+		fprintf(stderr, "Error opening disk %s\n", file);
+		exit(1);
+	}
+
+	memset(buffer, 0, blocksize);
+	ext2fs_llseek(fd, 1*blocksize, SEEK_SET);
+
+	while (total < blocksize) {
+		tmp = write(fd, buffer+total, blocksize-total);
+		if (tmp < 0) {
+			fprintf(stderr, "Error writing to disk %s\n", file);
+			close(fd);
+			exit(1);
+		}
+
+		total += tmp;
+	}
+
+	if (ext2fs_sync_device(fd, 1)) {
+		fprintf(stderr, "Error flushing cache to disk %s\n", file);
+		close(fd);
+		exit(1);
+	}
+
+	memset(buffer, 0xa, blocksize);
+	ext2fs_llseek(fd, ((1UL << 31)+1)*blocksize, SEEK_SET);
+	total = 0;
+
+	while (total < blocksize) {
+		tmp = write(fd, buffer+total, blocksize-total);
+		if (tmp < 0) {
+			fprintf(stderr, "Error writing to disk %s\n", file);
+			close(fd);
+			exit(1);
+		}
+
+		total += tmp;
+	}
+
+	if (ext2fs_sync_device(fd, 1)) {
+		fprintf(stderr, "Error flushing cache to disk %s\n", file);
+		close(fd);
+		exit(1);
+	}
+
+	memset(buffer, 0xa, blocksize);
+	ext2fs_llseek(fd, 1*blocksize, SEEK_SET);
+	total = 0;
+
+	while (total < blocksize) {
+		tmp = read(fd, buffer+total, blocksize-total);
+		if (tmp < 0) {
+			fprintf(stderr, "Error reading from disk %s\n", file);
+			close(fd);
+			exit(1);
+		}
+
+		total += tmp;
+	}
+
+	for (tmp = 0; tmp < blocksize; tmp++) {
+		if (buffer[tmp] != 0x0) {
+			close(fd);
+			return -1;
+		}
+	}
+
+	close(fd);
+
+	return 0;
+}
+
 extern const char *mke2fs_default_profile;
 static const char *default_files[] = { "<default>", 0 };
 
@@ -1455,11 +1539,22 @@ static void PRS(int argc, char *argv[])
 		}
 	}
 
-	if (!force && fs_param.s_blocks_count >= ((unsigned) 1 << 31)) {
-		com_err(program_name, 0,
-			_("Filesystem too large.  No more than 2**31-1 blocks\n"
-			  "\t (8TB using a blocksize of 4k) are currently supported."));
-             exit(1);
+	if (fs_param.s_blocks_count >= ((unsigned) 1 << 31)) {
+		if (!noaction) {
+			retval = check_for_wrap(device_name,
+						EXT2_BLOCK_SIZE(&fs_param));
+			if (retval) {
+				com_err(program_name, retval, "Write wrapped, "
+					"filesystem is too large for the disk "
+					"to handle\n");
+				exit(1);
+			}
+		}
+
+		fprintf(stderr, "\nWarning: older 2.6 kernels (2.6.18 and "
+			"older) may have problems with such a \n\tlarge "
+			"filesystem.  If you have problems try a newer "
+			"kernel\n");
 	}
 
 	if ((blocksize > 4096) &&
