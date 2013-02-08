From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/3] e2fsprogs: use libblkid to wipe old signatures
Date: Fri,  8 Feb 2013 12:07:03 +0100
Message-ID: <1360321623-8188-3-git-send-email-lczerner@redhat.com>
References: <1360321623-8188-1-git-send-email-lczerner@redhat.com>
Cc: sandeen@redhat.com, tytso@mit.edu,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946252Ab3BHLHM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Feb 2013 06:07:12 -0500
In-Reply-To: <1360321623-8188-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently we only attempt to wipe old raid signatures at the end of the
device. However this might not be enough because some file system
(btrfs) may still have their signatures on the device which can be
confusing for userspace possibly resulting in the unmountable file
system.

This patch adds a function which uses libblkid library to wipe all the
signatures from the device. In case that libblkid lack the capability to
do so we still use the old method of wiping off raid signatures and new
method of wiping btrfs signatures (originally written by Eric Sandeed).

We attempt to wipe off signatures before creating the file system.
Information about existing signatures is printed only in verbose mode.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 configure       |    2 +-
 configure.in    |    1 +
 lib/config.h.in |    3 +
 misc/mke2fs.c   |  210 +++++++++++++++++++++++++++++++++++++++++++++----------
 4 files changed, 178 insertions(+), 38 deletions(-)

diff --git a/configure b/configure
index 5b91c01..8059f06 100755
--- a/configure
+++ b/configure
@@ -11091,7 +11091,7 @@ if test "$ac_res" != no; then :
 fi
 
 fi
-for ac_func in  	__secure_getenv 	backtrace 	blkid_probe_get_topology 	chflags 	fallocate 	fallocate64 	fchown 	fdatasync 	fstat64 	ftruncate64 	getdtablesize 	getmntinfo 	getpwuid_r 	getrlimit 	getrusage 	jrand48 	llseek 	lseek64 	mallinfo 	mbstowcs 	memalign 	mmap 	msync 	nanosleep 	open64 	pathconf 	posix_fadvise 	posix_memalign 	prctl 	setmntent 	setresgid 	setresuid 	srandom 	strcasecmp 	strdup 	strnlen 	strptime 	strtoull 	sync_file_range 	sysconf 	usleep 	utime 	valloc
+for ac_func in  	__secure_getenv 	backtrace 	blkid_probe_get_topology 	blkid_probe_step_back 	chflags 	fallocate 	fallocate64 	fchown 	fdatasync 	fstat64 	ftruncate64 	getdtablesize 	getmntinfo 	getpwuid_r 	getrlimit 	getrusage 	jrand48 	llseek 	lseek64 	mallinfo 	mbstowcs 	memalign 	mmap 	msync 	nanosleep 	open64 	pathconf 	posix_fadvise 	posix_memalign 	prctl 	setmntent 	setresgid 	setresuid 	srandom 	strcasecmp 	strdup 	strnlen 	strptime 	strtoull 	sync_file_range 	sysconf 	usleep 	utime 	valloc
 do :
   as_ac_var=`$as_echo "ac_cv_func_$ac_func" | $as_tr_sh`
 ac_fn_c_check_func "$LINENO" "$ac_func" "$as_ac_var"
diff --git a/configure.in b/configure.in
index 68fc806..f2d75cc 100644
--- a/configure.in
+++ b/configure.in
@@ -1053,6 +1053,7 @@ AC_CHECK_FUNCS(m4_flatten([
 	__secure_getenv
 	backtrace
 	blkid_probe_get_topology
+	blkid_probe_step_back
 	chflags
 	fallocate
 	fallocate64
diff --git a/lib/config.h.in b/lib/config.h.in
index 6f88c9c..2735452 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -64,6 +64,9 @@
 /* Define to 1 if you have the `blkid_probe_get_topology' function. */
 #undef HAVE_BLKID_PROBE_GET_TOPOLOGY
 
+/* Define to 1 if you have the `blkid_probe_step_back' function. */
+#undef HAVE_BLKID_PROBE_STEP_BACK
+
 /* Define to 1 if you have the `chflags' function. */
 #undef HAVE_CHFLAGS
 
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index bbf477a..9270b55 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -481,42 +481,42 @@ static void reserve_inodes(ext2_filsys fs)
 #define BSD_MAGICDISK   (0x57455682UL)  /* The disk magic number reversed */
 #define BSD_LABEL_OFFSET        64
 
-static void zap_sector(ext2_filsys fs, int sect, int nsect)
+static int zap_bytes(ext2_filsys fs, unsigned long long offset, int size)
 {
 	char *buf;
 	int retval;
 	unsigned int *magic;
 
-	buf = malloc(512*nsect);
+	buf = malloc(size < 512 ? 512 : size);
 	if (!buf) {
-		printf(_("Out of memory erasing sectors %d-%d\n"),
-		       sect, sect + nsect - 1);
+		com_err(program_name, errno,
+			_("wile allocating memory to erase %d bytes from offset %llu"),
+			size, offset);
 		exit(1);
 	}
 
-	if (sect == 0) {
+	if (offset == 0 && size > 64) {
 		/* Check for a BSD disklabel, and don't erase it if so */
 		retval = io_channel_read_blk64(fs->io, 0, -512, buf);
 		if (retval)
-			fprintf(stderr,
-				_("Warning: could not read block 0: %s\n"),
-				error_message(retval));
+			com_err(program_name, retval,
+				_("could not read sector 0"));
 		else {
 			magic = (unsigned int *) (buf + BSD_LABEL_OFFSET);
 			if ((*magic == BSD_DISKMAGIC) ||
 			    (*magic == BSD_MAGICDISK))
-				return;
+				return -1;
 		}
 	}
 
-	memset(buf, 0, 512*nsect);
-	io_channel_set_blksize(fs->io, 512);
-	retval = io_channel_write_blk64(fs->io, sect, -512*nsect, buf);
-	io_channel_set_blksize(fs->io, fs->blocksize);
+	memset(buf, 0, size);
+	retval = io_channel_write_byte64(fs->io, offset, size, buf);
 	free(buf);
 	if (retval)
-		fprintf(stderr, _("Warning: could not erase sector %d: %s\n"),
-			sect, error_message(retval));
+		com_err(program_name, retval,
+			 _("while erasing %d bytes from offset %llu\n"),
+			size, offset);
+	return retval;
 }
 
 static void create_journal_dev(ext2_filsys fs)
@@ -2346,6 +2346,140 @@ static int create_quota_inodes(ext2_filsys fs)
 	return 0;
 }
 
+#ifdef HAVE_BLKID_PROBE_STEP_BACK
+/*
+ * Wipe out all signatures on the device using libblkid
+ */
+static void wipe_signatures(ext2_filsys fs)
+{
+	int value, retval;
+	blkid_probe pr;
+	size_t len = 0;
+	const char *ostr = NULL;
+	const char *name = NULL;
+	long long offset;
+
+	pr = blkid_new_probe_from_filename(fs->device_name);
+
+	blkid_probe_enable_partitions(pr, 1);
+	blkid_probe_enable_superblocks(pr, 1);
+	blkid_probe_set_partitions_flags(pr, BLKID_PARTS_MAGIC);
+	blkid_probe_set_superblocks_flags(pr,
+					BLKID_SUBLKS_MAGIC | BLKID_SUBLKS_TYPE);
+
+	while (1) {
+
+		value = blkid_do_probe(pr);
+		if (value != 0)
+			break;
+
+		if (blkid_probe_lookup_value(pr, "TYPE", &name, NULL) == 0) {
+			blkid_probe_lookup_value(pr, "SBMAGIC_OFFSET", &ostr,
+						 NULL);
+			blkid_probe_lookup_value(pr, "SBMAGIC", NULL, &len);
+
+		} else if (blkid_probe_lookup_value(pr, "PTTYPE",
+						    &name, NULL) == 0) {
+			blkid_probe_lookup_value(pr, "PTMAGIC_OFFSET",
+						 &ostr, NULL);
+			blkid_probe_lookup_value(pr, "PTMAGIC", NULL, &len);
+		} else
+			continue;
+
+		/* Convert ostr to the real offset */
+		offset = strtoll(ostr, NULL, 10);
+
+		if (verbose)
+			printf(_("Wiping off %s signature from the device: "),
+			       name);
+
+		/* Wipe off the signature */
+		retval = zap_bytes(fs, offset, len);
+		if (verbose) {
+			if (retval < 0)
+				printf(_("skipped\n"));
+			else
+				printf(_("done\n"));
+		}
+
+		/*
+		 * Retry the last probing to check for backup
+		 * superblocks ..etc.
+		 * */
+		blkid_probe_step_back(pr);
+	}
+}
+#else
+/*
+ * Wipe out old MD RAID signatures on the device
+ */
+static void wipe_raid(ext2_filsys fs)
+{
+	/* rsv must be a power of two (64kB is MD RAID sb alignment) */
+	blk64_t rsv = 65536 / fs->blocksize;
+	blk64_t blocks = ext2fs_blocks_count(fs->super);
+	blk64_t start;
+	blk64_t ret_blk;
+	int retval = 0;
+
+
+	if (verbose)
+		printf(_("Wiping off linux_raid_member signature from the device: "));
+	/*
+	 * Wipe out any old MD RAID (or other) metadata at the end
+	 * of the device.  This will also verify that the device is
+	 * as large as we think.  Be careful with very small devices.
+	 */
+	start = (blocks & ~(rsv - 1));
+	if (start > rsv)
+		start -= rsv;
+	if (start > 0)
+		retval = ext2fs_zero_blocks2(fs, start, blocks - start,
+					    &ret_blk, NULL);
+	if (retval)
+		com_err(program_name, retval,
+			_("while zeroing block %llu at end of filesystem"),
+			ret_blk);
+	else if (verbose)
+		printf(_("done\n"));
+}
+
+/*
+ * Wipe out all btrfs signatures on the device
+ */
+static int wipe_btrfs(ext2_filsys fs)
+{
+	int blocks;     /* nr of blocks to zero */
+	blk64_t start;  /* location to zero out */
+	int retval = 0; /* accumulate any failures */
+
+	blocks = 1;
+	if (fs->blocksize < 4096)
+		blocks = 4096 / fs->blocksize;
+	/*
+	* Wipe out any old btrfs superblocks, at
+	* 64k, 64M, and 256G.
+	*/
+	start = 64ULL * 1024 / fs->blocksize;
+	retval += ext2fs_zero_blocks2(fs, start, blocks, NULL, NULL);
+	start = 64ULL * 1024 * 1024 / fs->blocksize;
+	if (start + blocks <= ext2fs_blocks_count(fs->super))
+		retval += ext2fs_zero_blocks2(fs, start, blocks, NULL, NULL);
+	start = 256ULL * 1024 * 1024 * 1024 / fs->blocksize;
+	if (start + blocks <= ext2fs_blocks_count(fs->super))
+		retval += ext2fs_zero_blocks2(fs, start, blocks, NULL, NULL);
+	if (verbose)
+		printf(_("Wiping off btrfs signature from the device: "));
+	/* free the static zeroing buffer */
+	ext2fs_zero_blocks2(0, 0, 0, 0, 0);
+	if (retval)
+		com_err(program_name, retval,
+			_("while wiping old btrfs super locations"));
+	else if (verbose)
+		printf(_("done\n"));
+}
+#endif /* HAVE_BLKID_PROBE_STEP_BACK */
+
 int main (int argc, char *argv[])
 {
 	errcode_t	retval = 0;
@@ -2459,8 +2593,10 @@ int main (int argc, char *argv[])
 	/*
 	 * Wipe out the old on-disk superblock
 	 */
+	/*
 	if (!noaction)
 		zap_sector(fs, 2, 6);
+	*/
 
 	/*
 	 * Parse or generate a UUID for the filesystem
@@ -2605,33 +2741,33 @@ int main (int argc, char *argv[])
 				ext2fs_bg_itable_unused_set(fs, i, 0);
 		}
 	} else {
-		/* rsv must be a power of two (64kB is MD RAID sb alignment) */
-		blk64_t rsv = 65536 / fs->blocksize;
-		blk64_t blocks = ext2fs_blocks_count(fs->super);
-		blk64_t start;
-		blk64_t ret_blk;
-
-#ifdef ZAP_BOOTBLOCK
-		zap_sector(fs, 0, 2);
+		/* Get rid of the old signatures */
+#ifdef HAVE_BLKID_PROBE_STEP_BACK
+		wipe_signatures(fs);
+#else
+		wipe_btrfs(fs);
+		wipe_raid(fs);
 #endif
 
 		/*
-		 * Wipe out any old MD RAID (or other) metadata at the end
-		 * of the device.  This will also verify that the device is
-		 * as large as we think.  Be careful with very small devices.
+		 * Overwrite loast block of the file system. There are two
+		 * reasons we're doing so:
+		 * - we ensure that the device is at least as big as it claims
+		 *   to be.
+		 * - in the case we're creating a file system on the file we
+		 *   have to set the size of that file properly
 		 */
-		start = (blocks & ~(rsv - 1));
-		if (start > rsv)
-			start -= rsv;
-		if (start > 0)
-			retval = ext2fs_zero_blocks2(fs, start, blocks - start,
-						    &ret_blk, NULL);
