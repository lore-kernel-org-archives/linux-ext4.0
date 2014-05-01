From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 21/37] libext2fs: have UNIX IO manager use pread/pwrite
Date: Thu, 01 May 2014 16:14:39 -0700
Message-ID: <20140501231439.31890.25006.stgit@birch.djwong.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28749 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbaEAXOo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 May 2014 19:14:44 -0400
In-Reply-To: <20140501231222.31890.82860.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If pread/pwrite are present, have the UNIX IO manager use them for
aligned IOs (instead of the current seek -> read/write), thereby
saving us a (minor) amount of system call overhead.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 configure            |    2 +-
 configure.in         |    2 ++
 lib/config.h.in      |    6 ++++++
 lib/ext2fs/unix_io.c |   24 ++++++++++++++++++++++++
 4 files changed, 33 insertions(+), 1 deletion(-)


diff --git a/configure b/configure
index 6449f59..7b0a0d1 100755
--- a/configure
+++ b/configure
@@ -11155,7 +11155,7 @@ if test "$ac_res" != no; then :
 fi
 
 fi
-for ac_func in  	__secure_getenv 	backtrace 	blkid_probe_get_topology 	chflags 	fadvise64 	fallocate 	fallocate64 	fchown 	fdatasync 	fstat64 	ftruncate64 	futimes 	getcwd 	getdtablesize 	getmntinfo 	getpwuid_r 	getrlimit 	getrusage 	jrand48 	llseek 	lseek64 	mallinfo 	mbstowcs 	memalign 	mempcpy 	mmap 	msync 	nanosleep 	open64 	pathconf 	posix_fadvise 	posix_fadvise64 	posix_memalign 	prctl 	secure_getenv 	setmntent 	setresgid 	setresuid 	srandom 	stpcpy 	strcasecmp 	strdup 	strnlen 	strptime 	strtoull 	sync_file_range 	sysconf 	usleep 	utime 	valloc
+for ac_func in  	__secure_getenv 	backtrace 	blkid_probe_get_topology 	chflags 	fadvise64 	fallocate 	fallocate64 	fchown 	fdatasync 	fstat64 	ftruncate64 	futimes 	getcwd 	getdtablesize 	getmntinfo 	getpwuid_r 	getrlimit 	getrusage 	jrand48 	llseek 	lseek64 	mallinfo 	mbstowcs 	memalign 	mempcpy 	mmap 	msync 	nanosleep 	open64 	pathconf 	posix_fadvise 	posix_fadvise64 	posix_memalign 	prctl 	pread 	pwrite 	secure_getenv 	setmntent 	setresgid 	setresuid 	srandom 	stpcpy 	strcasecmp 	strdup 	strnlen 	strptime 	strtoull 	sync_file_range 	sysconf 	usleep 	utime 	valloc
 do :
   as_ac_var=`$as_echo "ac_cv_func_$ac_func" | $as_tr_sh`
 ac_fn_c_check_func "$LINENO" "$ac_func" "$as_ac_var"
diff --git a/configure.in b/configure.in
index 8a033b0..f28bd46 100644
--- a/configure.in
+++ b/configure.in
@@ -1135,6 +1135,8 @@ AC_CHECK_FUNCS(m4_flatten([
 	posix_fadvise64
 	posix_memalign
 	prctl
+	pread
+	pwrite
 	secure_getenv
 	setmntent
 	setresgid
diff --git a/lib/config.h.in b/lib/config.h.in
index 12ac1e0..e0384ee 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -311,9 +311,15 @@
 /* Define to 1 if you have the `prctl' function. */
 #undef HAVE_PRCTL
 
+/* Define to 1 if you have the `pread' function. */
+#undef HAVE_PREAD
+
 /* Define to 1 if you have the `putenv' function. */
 #undef HAVE_PUTENV
 
+/* Define to 1 if you have the `pwrite' function. */
+#undef HAVE_PWRITE
+
 /* Define to 1 if dirent has d_reclen */
 #undef HAVE_RECLEN_DIRENT
 
diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index c3185b6..a818c13 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -130,6 +130,18 @@ static errcode_t raw_read_blk(io_channel channel,
 	size = (count < 0) ? -count : count * channel->block_size;
 	data->io_stats.bytes_read += size;
 	location = ((ext2_loff_t) block * channel->block_size) + data->offset;
+
+#ifdef HAVE_PREAD
+	/* Try an aligned pread */
+	if ((channel->align == 0) ||
+	    (IS_ALIGNED(buf, channel->align) &&
+	     IS_ALIGNED(size, channel->align))) {
+		actual = pread(data->dev, buf, size, location);
+		if (actual == size)
+			return 0;
+	}
+#endif /* HAVE_PREAD */
+
 	if (ext2fs_llseek(data->dev, location, SEEK_SET) != location) {
 		retval = errno ? errno : EXT2_ET_LLSEEK_FAILED;
 		goto error_out;
@@ -200,6 +212,18 @@ static errcode_t raw_write_blk(io_channel channel,
 	data->io_stats.bytes_written += size;
 
 	location = ((ext2_loff_t) block * channel->block_size) + data->offset;
+
+#ifdef HAVE_PWRITE
+	/* Try an aligned pwrite */
+	if ((channel->align == 0) ||
+	    (IS_ALIGNED(buf, channel->align) &&
+	     IS_ALIGNED(size, channel->align))) {
+		actual = pwrite(data->dev, buf, size, location);
+		if (actual == size)
+			return 0;
+	}
+#endif /* HAVE_PWRITE */
+
 	if (ext2fs_llseek(data->dev, location, SEEK_SET) != location) {
 		retval = errno ? errno : EXT2_ET_LLSEEK_FAILED;
 		goto error_out;

