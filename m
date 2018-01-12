From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] misc: add e2mmpstatus utility via debugfs
Date: Thu, 11 Jan 2018 22:51:39 -0700
Message-ID: <1515736299-10160-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Shuichi Ihara <sihara@ddn.com>,
        Li Xi <lixi@ddn.com>, Wang Shilong <wshilong@ddn.com>,
        Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-no.shaw.ca ([64.59.134.9]:38582 "EHLO
        smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751786AbeALF7u (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Jan 2018 00:59:50 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Shuichi Ihara <sihara@ddn.com>

e2mmpstatus is a Multi-Mount Protection (MMP) helper utility to read
an MMP block to see if it is being updated.  It can also output the
latest update time, nodename, and device from the MMP block.

This is useful for HA and other maintenance scripts to determine if
the filesystem is in use on another node, and which one it is.

It is implemented as part of dumpe2fs, using the "-m" option to
check status, and "-i" to dump info.  If dumpe2fs is called as
e2mmpstatus, it assumes the "-m" option.

Modify dumpe2fs to exit with a non-zero error code if there is an
error while reading the filesystem metadata or MMP block, or if
"-m" is used with the "mmp" feature and is in use by another node.

Update the f_mmp, m_mmp, m_mmp_bad_csum, and m_mmp_bad_magic tests
to use e2mmpstatus to check and dump the MMP state before and after
e2fsck is run to verify it is working correctly.

Signed-off-by: Shuichi Ihara <sihara@ddn.com>
Signed-off-by: Li Xi <lixi@ddn.com>
Signed-off-by: Wang Shilong <wshilong@ddn.com>
Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 .gitignore                   |   2 +
 configure                    |   2 +-
 configure.ac                 |   1 +
 e2fsck/e2fsck.h              |   2 +-
 e2fsck/problem.c             |   2 +-
 e2fsck/unix.c                |   3 +-
 e2fsck/util.c                |  22 +++--
 e2fsprogs.spec.in            |   2 +
 lib/config.h.in              |  15 +++-
 lib/ext2fs/ext2_err.et.in    |   4 +-
 lib/ext2fs/mmp.c             |  12 ++-
 misc/Makefile.in             |  11 ++-
 misc/dumpe2fs.8.in           |  22 ++++-
 misc/dumpe2fs.c              | 202 ++++++++++++++++++++++++++++++++++---------
 misc/e2mmpstatus.8.in        |  59 +++++++++++++
 tests/f_mmp/script           |   7 ++
 tests/filter.sed             |   9 ++
 tests/m_mmp/expect.1         |   8 ++
 tests/m_mmp_bad_csum/expect  |  16 +++-
 tests/m_mmp_bad_csum/script  |   9 +-
 tests/m_mmp_bad_magic/expect |  13 +++
 tests/m_mmp_bad_magic/script |   9 +-
 tests/test_config            |   1 +
 23 files changed, 369 insertions(+), 64 deletions(-)
 create mode 100644 misc/e2mmpstatus.8.in

diff --git a/.gitignore b/.gitignore
index d3bcefc..30fd9cc 100644
--- a/.gitignore
+++ b/.gitignore
@@ -169,6 +169,8 @@ misc/e2image
 misc/e2image.8
 misc/e2initrd_helper
 misc/e2label.8
+misc/e2mmpstatus
+misc/e2mmpstatus.8
 misc/e2undo
 misc/e2undo.8
 misc/e4defrag
diff --git a/configure b/configure
index b2701d2..c7853d1 100755
--- a/configure
+++ b/configure
@@ -13097,7 +13097,7 @@ fi
 if test -n "$DLOPEN_LIB" ; then
    ac_cv_func_dlopen=yes
 fi
-for ac_func in  	__secure_getenv 	add_key 	backtrace 	blkid_probe_get_topology 	blkid_probe_enable_partitions 	chflags 	dlopen 	fadvise64 	fallocate 	fallocate64 	fchown 	fcntl 	fdatasync 	fstat64 	fsync 	ftruncate64 	futimes 	getcwd 	getdtablesize 	getmntinfo 	getpwuid_r 	getrlimit 	getrusage 	jrand48 	keyctl 	llistxattr 	llseek 	lseek64 	mallinfo 	mbstowcs 	memalign 	mempcpy 	mmap 	msync 	nanosleep 	open64 	pathconf 	posix_fadvise 	posix_fadvise64 	posix_memalign 	prctl 	pread 	pwrite 	pread64 	pwrite64 	secure_getenv 	setmntent 	setresgid 	setresuid 	snprintf 	srandom 	stpcpy 	strcasecmp 	strdup 	strnlen 	strptime 	strtoull 	sync_file_range 	sysconf 	usleep 	utime 	utimes 	valloc
+for ac_func in  	__secure_getenv 	add_key 	backtrace 	blkid_probe_get_topology 	blkid_probe_enable_partitions 	chflags 	dlopen 	fadvise64 	fallocate 	fallocate64 	fchown 	fcntl 	fdatasync 	fstat64 	fsync 	ftruncate64 	futimes 	getcwd 	getdtablesize 	gethostname 	getmntinfo 	getpwuid_r 	getrlimit 	getrusage 	jrand48 	keyctl 	llistxattr 	llseek 	lseek64 	mallinfo 	mbstowcs 	memalign 	mempcpy 	mmap 	msync 	nanosleep 	open64 	pathconf 	posix_fadvise 	posix_fadvise64 	posix_memalign 	prctl 	pread 	pwrite 	pread64 	pwrite64 	secure_getenv 	setmntent 	setresgid 	setresuid 	snprintf 	srandom 	stpcpy 	strcasecmp 	strdup 	strnlen 	strptime 	strtoull 	sync_file_range 	sysconf 	usleep 	utime 	utimes 	valloc
 do :
   as_ac_var=`$as_echo "ac_cv_func_$ac_func" | $as_tr_sh`
 ac_fn_c_check_func "$LINENO" "$ac_func" "$as_ac_var"
diff --git a/configure.ac b/configure.ac
index 7392959..5e837c9 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1124,6 +1124,7 @@ AC_CHECK_FUNCS(m4_flatten([
 	futimes
 	getcwd
 	getdtablesize
+	gethostname
 	getmntinfo
 	getpwuid_r
 	getrlimit
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 9eee4bc..187ceb4 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -638,7 +638,7 @@ extern blk64_t get_backup_sb(e2fsck_t ctx, ext2_filsys fs,
 			   const char *name, io_manager manager);
 extern int ext2_file_type(unsigned int mode);
 extern int write_all(int fd, char *buf, size_t count);
-void dump_mmp_msg(struct mmp_struct *mmp, const char *msg);
+void dump_mmp_msg(struct mmp_struct *mmp, const char *fmt, ...);
 errcode_t e2fsck_mmp_update(ext2_filsys fs);
 
 extern void e2fsck_set_bitmap_type(ext2_filsys fs,
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index edc9d51..df4ad14 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -450,7 +450,7 @@ static struct e2fsck_problem problem_table[] = {
 
 	/* Superblock MMP block checksum does not match MMP block. */
 	{ PR_0_MMP_CSUM_INVALID,
-	  N_("@S MMP @b checksum does not match MMP @b.  "),
+	  N_("@S MMP @b checksum does not match.  "),
 	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK},
 
 	/* Superblock 64bit filesystem needs extents to access the whole disk */
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 2e9be8b..a87f891 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1244,7 +1244,8 @@ check_error:
 		dump_mmp_msg(fs->mmp_buf,
 			     _("If you are sure the filesystem is not "
 			       "in use on any node, run:\n"
-			       "'tune2fs -f -E clear_mmp {device}'\n"));
+			       "'tune2fs -f -E clear_mmp %s'\n"),
+			     ctx->device_name);
 	} else if (retval == EXT2_ET_MMP_MAGIC_INVALID) {
 		if (fix_problem(ctx, PR_0_MMP_INVALID_MAGIC, &pctx)) {
 			ext2fs_mmp_clear(fs);
diff --git a/e2fsck/util.c b/e2fsck/util.c
index ed94702..5793b65 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -756,16 +756,28 @@ int write_all(int fd, char *buf, size_t count)
 	return c;
 }
 
-void dump_mmp_msg(struct mmp_struct *mmp, const char *msg)
+void dump_mmp_msg(struct mmp_struct *mmp, const char *fmt, ...)
 {
+	va_list pvar;
 
-	if (msg)
-		printf("MMP check failed: %s\n", msg);
+	if (fmt) {
+		printf("MMP check failed: ");
+		va_start(pvar, fmt);
+		vprintf(fmt, pvar);
+		va_end(pvar);
+	}
 	if (mmp) {
 		time_t t = mmp->mmp_time;
 
-		printf("MMP error info: last update: %s node: %s device: %s\n",
-		       ctime(&t), mmp->mmp_nodename, mmp->mmp_bdevname);
+		printf("MMP_block:\n");
+		printf("    mmp_magic: 0x%x\n", mmp->mmp_magic);
+		printf("    mmp_check_interval: %d\n",
+		       mmp->mmp_check_interval);
+		printf("    mmp_sequence: %08x\n", mmp->mmp_seq);
+		printf("    mmp_update_date: %s", ctime(&t));
+		printf("    mmp_update_time: %lld\n", mmp->mmp_time);
+		printf("    mmp_node_name: %s\n", mmp->mmp_nodename);
+		printf("    mmp_device_name: %s\n", mmp->mmp_bdevname);
 	}
 }
 
diff --git a/e2fsprogs.spec.in b/e2fsprogs.spec.in
index b188b75..f42c4be 100644
--- a/e2fsprogs.spec.in
+++ b/e2fsprogs.spec.in
@@ -116,6 +116,7 @@ exit 0
 %{_root_sbindir}/e2fsck
 %{_root_sbindir}/e2image
 %{_root_sbindir}/e2label
+%{_root_sbindir}/e2mmpstatus
 %{_root_sbindir}/e2undo
 %{_root_sbindir}/findfs
 %{_root_sbindir}/fsck
@@ -167,6 +168,7 @@ exit 0
 %{_mandir}/man8/fsck.ext4dev.8*
 %{_mandir}/man8/e2image.8*
 %{_mandir}/man8/e2label.8*
+%{_mandir}/man8/e2mmpstatus.8*
 %{_mandir}/man8/e2undo.8*
 %{_mandir}/man8/fsck.8*
 %{_mandir}/man8/logsave.8*
diff --git a/lib/config.h.in b/lib/config.h.in
index 9cc0793..67a0548 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -147,6 +147,9 @@
 /* Define to 1 if you have the `fchown' function. */
 #undef HAVE_FCHOWN
 
+/* Define to 1 if you have the `fcntl' function. */
+#undef HAVE_FCNTL
+
 /* Define to 1 if you have the `fdatasync' function. */
 #undef HAVE_FDATASYNC
 
@@ -156,6 +159,9 @@
 /* Define to 1 if you have the `fstat64' function. */
 #undef HAVE_FSTAT64
 
+/* Define to 1 if you have the `fsync' function. */
+#undef HAVE_FSYNC
+
 /* Define to 1 if you have the `ftruncate64' function. */
 #undef HAVE_FTRUNCATE64
 
@@ -183,6 +189,9 @@
 /* Define to 1 if you have the `getgid' function. */
 #undef HAVE_GETGID
 
+/* Define to 1 if you have the `gethostname' function. */
+#undef HAVE_GETHOSTNAME
+
 /* Define to 1 if you have the `getmntinfo' function. */
 #undef HAVE_GETMNTINFO
 
@@ -253,6 +262,9 @@
 /* Define to 1 if you have the <linux/major.h> header file. */
 #undef HAVE_LINUX_MAJOR_H
 
+/* Define to 1 if you have the <linux/types.h> header file. */
+#undef HAVE_LINUX_TYPES_H
+
 /* Define to 1 if you have the `llistxattr' function. */
 #undef HAVE_LLISTXATTR
 
@@ -470,9 +482,6 @@
 /* Define to 1 if you have the `sync_file_range' function. */
 #undef HAVE_SYNC_FILE_RANGE
 
-/* Define to 1 if you have the 'fsync' function. */
-#undef HAVE_FSYNC
-
 /* Define to 1 if you have the `sysconf' function. */
 #undef HAVE_SYSCONF
 
diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index ac96964..5b89b98 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -429,7 +429,7 @@ ec	EXT2_ET_MMP_FAILED,
 	"MMP: device currently active"
 
 ec	EXT2_ET_MMP_FSCK_ON,
-	"MMP: fsck being run"
+	"MMP: e2fsck being run"
 
 ec	EXT2_ET_MMP_BAD_BLOCK,
 	"MMP: block number beyond filesystem range"
@@ -471,7 +471,7 @@ ec	EXT2_ET_UNKNOWN_CSUM,
 	"Unknown checksum algorithm"
 
 ec	EXT2_ET_MMP_CSUM_INVALID,
-	"MMP block checksum does not match MMP block"
+	"MMP block checksum does not match"
 
 ec	EXT2_ET_FILE_EXISTS,
 	"Ext2 file already exists"
diff --git a/lib/ext2fs/mmp.c b/lib/ext2fs/mmp.c
index 9a771de..0cf0d0d 100644
--- a/lib/ext2fs/mmp.c
+++ b/lib/ext2fs/mmp.c
@@ -194,7 +194,7 @@ static errcode_t ext2fs_mmp_reset(ext2_filsys fs)
 	mmp_s->mmp_magic = EXT4_MMP_MAGIC;
 	mmp_s->mmp_seq = EXT4_MMP_SEQ_CLEAN;
 	mmp_s->mmp_time = 0;
-#if _BSD_SOURCE || _XOPEN_SOURCE >= 500
+#ifdef HAVE_GETHOSTNAME
 	gethostname(mmp_s->mmp_nodename, sizeof(mmp_s->mmp_nodename));
 #else
 	mmp_s->mmp_nodename[0] = '\0';
@@ -269,6 +269,10 @@ out:
 #endif
 }
 
+#ifndef min
+#define min(x, y) ((x) < (y) ? (x) : (y))
+#endif
+
 /*
  * Make sure that the fs is not mounted or being fsck'ed while opening the fs.
  */
@@ -316,7 +320,7 @@ errcode_t ext2fs_mmp_start(ext2_filsys fs)
 	if (mmp_s->mmp_check_interval > mmp_check_interval)
 		mmp_check_interval = mmp_s->mmp_check_interval;
 
-	sleep(2 * mmp_check_interval + 1);
+	sleep(min(mmp_check_interval * 2 + 1, mmp_check_interval + 60));
 
 	retval = ext2fs_mmp_read(fs, fs->super->s_mmp_block, fs->mmp_buf);
 	if (retval)
@@ -332,7 +336,7 @@ clean_seq:
 		goto mmp_error;
 
 	mmp_s->mmp_seq = seq = ext2fs_mmp_new_seq();
-#if _BSD_SOURCE || _XOPEN_SOURCE >= 500
+#ifdef HAVE_GETHOSTNAME
 	gethostname(mmp_s->mmp_nodename, sizeof(mmp_s->mmp_nodename));
 #else
 	strcpy(mmp_s->mmp_nodename, "unknown host");
@@ -344,7 +348,7 @@ clean_seq:
 	if (retval)
 		goto mmp_error;
 
-	sleep(2 * mmp_check_interval + 1);
+	sleep(min(2 * mmp_check_interval + 1, mmp_check_interval + 60));
 
 	retval = ext2fs_mmp_read(fs, fs->super->s_mmp_block, fs->mmp_buf);
 	if (retval)
diff --git a/misc/Makefile.in b/misc/Makefile.in
index 6f631eb..dea3178 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -39,7 +39,8 @@ USPROGS=	mklost+found filefrag e2freefrag $(UUIDD_PROG) \
 SMANPAGES=	tune2fs.8 mklost+found.8 mke2fs.8 dumpe2fs.8 badblocks.8 \
 			e2label.8 $(FINDFS_MAN) $(BLKID_MAN) $(E2IMAGE_MAN) \
 			logsave.8 filefrag.8 e2freefrag.8 e2undo.8 \
-			$(UUIDD_MAN) $(E4DEFRAG_MAN) $(E4CRYPT_MAN) @FSCK_MAN@
+			$(UUIDD_MAN) $(E4DEFRAG_MAN) $(E4CRYPT_MAN) @FSCK_MAN@ \
+			e2mmpstatus.8
 FMANPAGES=	mke2fs.conf.5 ext4.5
 
 UPROGS=		chattr lsattr @UUID_CMT@ uuidgen
@@ -463,6 +464,10 @@ dumpe2fs.8: $(DEP_SUBSTITUTE) $(srcdir)/dumpe2fs.8.in
 	$(E) "	SUBST $@"
 	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/dumpe2fs.8.in dumpe2fs.8
 
+e2mmpstatus.8: $(DEP_SUBSTITUTE) $(srcdir)/e2mmpstatus.8.in
+	$(E) "	SUBST $@"
+	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/e2mmpstatus.8.in e2mmpstatus.8
+
 badblocks.8: $(DEP_SUBSTITUTE) $(srcdir)/badblocks.8.in
 	$(E) "	SUBST $@"
 	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/badblocks.8.in badblocks.8	
@@ -534,6 +539,8 @@ install: all $(SMANPAGES) $(UMANPAGES) installdirs
 			$(LN) $(LINK_INSTALL_FLAGS) mke2fs mkfs.$$i); \
 	done
 	$(Q) (cd $(DESTDIR)$(root_sbindir); \
+		$(LN) $(LINK_INSTALL_FLAGS) dumpe2fs e2mmpstatus)
+	$(Q) (cd $(DESTDIR)$(root_sbindir); \
 		$(LN) $(LINK_INSTALL_FLAGS) tune2fs e2label)
 	$(Q) if test -n "$(FINDFS_LINK)"; then \
 		$(ES) "	LINK $(root_sbindir)/findfs"; \
@@ -649,7 +656,7 @@ uninstall:
 	for i in $(UMANPAGES); do \
 		$(RM) -f $(DESTDIR)$(man1dir)/$$i; \
 	done
-	for i in $(FINDFS_LINK) e2label ; do \
+	for i in $(FINDFS_LINK) e2label e2mmpstatus ; do \
 		$(RM) -f $(DESTDIR)$(root_sbindir)/$$i; \
 	done
 	for i in $(FMANPAGES); do \
diff --git a/misc/dumpe2fs.8.in b/misc/dumpe2fs.8.in
index da78d4f..ce3214f 100644
--- a/misc/dumpe2fs.8.in
+++ b/misc/dumpe2fs.8.in
@@ -69,6 +69,17 @@ using
 .I device
 as the pathname to the image file.
 .TP
+.B \-m
+If the
+.B mmp
+feature is enabled on the filesystem, check if
+.I device
+is in use by another node, see
+.BR e2mmpstatus (8)
+for full details.  If used together with the
+.B \-i
+option, only the MMP block information is printed.
+.TP
 .B \-x
 print the detailed group information block numbers in hexadecimal format
 .TP
@@ -76,8 +87,16 @@ print the detailed group information block numbers in hexadecimal format
 print the version number of
 .B dumpe2fs
 and exit.
+.SH EXIT CODE
+.B dumpe2fs
+exits with a return code of 0 if the operation completed without errors.
+It will exit with a non-zero return code if there are any errors, such
+as problems reading a valid superblock, bad checksums, or if the device
+is in use by another node and
+.B -m
+is specified.
 .SH BUGS
-You need to know the physical filesystem structure to understand the
+You may need to know the physical filesystem structure to understand the
 output.
 .SH AUTHOR
 .B dumpe2fs
@@ -89,6 +108,7 @@ is part of the e2fsprogs package and is available from
 http://e2fsprogs.sourceforge.net.
 .SH SEE ALSO
 .BR e2fsck (8),
+.BR e2mmpstatus (8),
 .BR mke2fs (8),
 .BR tune2fs (8).
 .BR ext4 (5)
diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 395ea9e..384ce92 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -53,7 +53,7 @@ static int blocks64 = 0;
 
 static void usage(void)
 {
-	fprintf(stderr, _("Usage: %s [-bfghixV] [-o superblock=<num>] "
+	fprintf(stderr, _("Usage: %s [-bfghimxV] [-o superblock=<num>] "
 		 "[-o blocksize=<num>] device\n"), program_name);
 	exit(1);
 }
@@ -420,6 +420,79 @@ static void print_journal_information(ext2_filsys fs)
 	e2p_list_journal_super(stdout, buf, fs->blocksize, 0);
 }
 
+static int check_mmp(ext2_filsys fs)
+{
+	int retval;
+
+	/* This won't actually start MMP on the filesystem, since fs is opened
+	 * readonly, but it will do the proper activity checking for us. */
+	retval = ext2fs_mmp_start(fs);
+	if (retval) {
+		com_err(program_name, retval, _("while trying to open %s"),
+			fs->device_name);
+		if (retval == EXT2_ET_MMP_FAILED ||
+		    retval == EXT2_ET_MMP_FSCK_ON ||
+		    retval == EXT2_ET_MMP_CSUM_INVALID ||
+		    retval == EXT2_ET_MMP_UNKNOWN_SEQ) {
+			if (fs->mmp_buf) {
+				struct mmp_struct *mmp = fs->mmp_buf;
+				time_t mmp_time = mmp->mmp_time;
+
+				fprintf(stderr,
+					"%s: MMP last updated by '%s' on %s",
+					program_name, mmp->mmp_nodename,
+					ctime(&mmp_time));
+			}
+			retval = 1;
+		} else {
+			retval = 2;
+		}
+	} else {
+		printf("%s: it is safe to mount '%s', MMP is clean\n",
+		       program_name, fs->device_name);
+	}
+
+	return retval;
+}
+
+static void print_mmp_block(ext2_filsys fs)
+{
+	struct mmp_struct *mmp;
+	time_t mmp_time;
+	errcode_t retval;
+
+	if (fs->mmp_buf == NULL) {
+		retval = ext2fs_get_mem(fs->blocksize, &fs->mmp_buf);
+		if (retval) {
+			com_err(program_name, retval,
+				_("failed to alloc MMP buffer\n"));
+			return;
+		}
+	}
+
+	retval = ext2fs_mmp_read(fs, fs->super->s_mmp_block, fs->mmp_buf);
+	/* this is only dumping, not checking status, so OK to skip this */
+	if (retval == EXT2_ET_OP_NOT_SUPPORTED)
+		return;
+	if (retval) {
+		com_err(program_name, retval,
+			_("reading MMP block %llu from '%s'\n"),
+			fs->super->s_mmp_block, fs->device_name);
+		return;
+	}
+
+	mmp = fs->mmp_buf;
+	mmp_time = mmp->mmp_time;
+	printf("MMP_block:\n");
+	printf("    mmp_magic: 0x%x\n", mmp->mmp_magic);
+	printf("    mmp_check_interval: %d\n", mmp->mmp_check_interval);
+	printf("    mmp_sequence: %#08x\n", mmp->mmp_seq);
+	printf("    mmp_update_date: %s", ctime(&mmp_time));
+	printf("    mmp_update_time: %lld\n", mmp->mmp_time);
+	printf("    mmp_node_name: %s\n", mmp->mmp_nodename);
+	printf("    mmp_device_name: %s\n", mmp->mmp_bdevname);
+}
+
 static void parse_extended_opts(const char *opts, blk64_t *superblock,
 				int *blocksize)
 {
@@ -500,11 +573,15 @@ static void parse_extended_opts(const char *opts, blk64_t *superblock,
 int main (int argc, char ** argv)
 {
 	errcode_t	retval;
+	errcode_t	retval_csum = 0;
+	const char	*error_csum = NULL;
 	ext2_filsys	fs;
 	int		print_badblocks = 0;
 	blk64_t		use_superblock = 0;
 	int		use_blocksize = 0;
 	int		image_dump = 0;
+	int		mmp_check = 0;
+	int		mmp_info = 0;
 	int		force = 0;
 	int		flags;
 	int		header_only = 0;
@@ -519,12 +596,23 @@ int main (int argc, char ** argv)
 	set_com_err_gettext(gettext);
 #endif
 	add_error_table(&et_ext2_error_table);
-	fprintf (stderr, "dumpe2fs %s (%s)\n", E2FSPROGS_VERSION,
-		 E2FSPROGS_DATE);
-	if (argc && *argv)
-		program_name = *argv;
+	if (argc && *argv) {
+		if (strrchr(*argv, '/'))
+			program_name = strrchr(*argv, '/') + 1;
+		else
+			program_name = *argv;
+
+		if (strstr(program_name, "mmpstatus") != NULL) {
+			mmp_check = 1;
+			header_only = 1;
+		}
+	}
 
-	while ((c = getopt(argc, argv, "bfghixVo:")) != EOF) {
+	if (!mmp_check)
+		fprintf(stderr, "dumpe2fs %s (%s)\n", E2FSPROGS_VERSION,
+			E2FSPROGS_DATE);
+
+	while ((c = getopt(argc, argv, "bfghimxVo:")) != EOF) {
 		switch (c) {
 		case 'b':
 			print_badblocks++;
@@ -539,7 +627,18 @@ int main (int argc, char ** argv)
 			header_only++;
 			break;
 		case 'i':
-			image_dump++;
+			if (mmp_check)
+				mmp_info++;
+			else
+				image_dump++;
+			break;
+		case 'm':
+			mmp_check++;
+			header_only++;
+			if (image_dump) {
+				mmp_info = image_dump;
+				image_dump = 0;
+			}
 			break;
 		case 'o':
 			parse_extended_opts(optarg, &use_superblock,
@@ -557,12 +656,12 @@ int main (int argc, char ** argv)
 			usage();
 		}
 	}
-	if (optind != argc - 1) {
+	if (optind != argc - 1)
 		usage();
-		exit(1);
-	}
+
 	device_name = argv[optind++];
-	flags = EXT2_FLAG_JOURNAL_DEV_OK | EXT2_FLAG_SOFTSUPP_FEATURES | EXT2_FLAG_64BITS;
+	flags = EXT2_FLAG_JOURNAL_DEV_OK | EXT2_FLAG_SOFTSUPP_FEATURES |
+		EXT2_FLAG_64BITS;
 	if (force)
 		flags |= EXT2_FLAG_FORCE;
 	if (image_dump)
@@ -579,64 +678,87 @@ try_open_again:
 			if (!retval)
 				break;
 		}
-	} else
-		retval = ext2fs_open (device_name, flags, use_superblock,
-				      use_blocksize, unix_io_manager, &fs);
-	if (retval && !(flags & EXT2_FLAG_IGNORE_CSUM_ERRORS)) {
-		flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
-		goto try_open_again;
+	} else {
+		retval = ext2fs_open(device_name, flags, use_superblock,
+				     use_blocksize, unix_io_manager, &fs);
 	}
-	if (!retval && (fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS))
-		printf("%s", _("\n*** Checksum errors detected in filesystem!  Run e2fsck now!\n\n"));
 	flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+	if (retval && !retval_csum) {
+		retval_csum = retval;
+		error_csum = _("while trying to open %s");
+		goto try_open_again;
+	}
 	if (retval) {
-		com_err (program_name, retval, _("while trying to open %s"),
-			 device_name);
+		com_err(program_name, retval, _("while trying to open %s"),
+			device_name);
 		printf("%s", _("Couldn't find valid filesystem superblock.\n"));
 		if (retval == EXT2_ET_BAD_MAGIC)
 			check_plausibility(device_name, CHECK_FS_EXIST, NULL);
-		exit (1);
+		goto out;
 	}
 	fs->default_bitmap_type = EXT2FS_BMAP64_RBTREE;
 	if (ext2fs_has_feature_64bit(fs->super))
 		blocks64 = 1;
-	if (print_badblocks) {
+	if (mmp_check) {
+		if (ext2fs_has_feature_mmp(fs->super) &&
+		    fs->super->s_mmp_block != 0) {
+			if (mmp_info) {
+				print_mmp_block(fs);
+				printf("    mmp_block_number: ");
+				print_number(fs->super->s_mmp_block);
+				printf("\n");
+			} else {
+				retval = check_mmp(fs);
+			}
+			if (!retval && retval_csum)
+				retval = 2;
+		} else {
+			fprintf(stderr, _("%s: MMP feature not enabled.\n"),
+				program_name);
+			retval = 2;
+		}
+	} else if (print_badblocks) {
 		list_bad_blocks(fs, 1);
 	} else {
 		if (grp_only)
 			goto just_descriptors;
-		list_super (fs->super);
+		list_super(fs->super);
 		if (ext2fs_has_feature_journal_dev(fs->super)) {
 			print_journal_information(fs);
-			ext2fs_close_free(&fs);
-			exit(0);
+
+			goto out_close;
 		}
 		if (ext2fs_has_feature_journal(fs->super) &&
 		    (fs->super->s_journal_inum != 0))
 			print_inline_journal_information(fs);
+		if (ext2fs_has_feature_mmp(fs->super) &&
+		    fs->super->s_mmp_block != 0)
+			print_mmp_block(fs);
 		list_bad_blocks(fs, 0);
-		if (header_only) {
-			ext2fs_close_free(&fs);
-			exit (0);
-		}
+		if (header_only)
+			goto out_close;
+
 		fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
 try_bitmaps_again:
-		retval = ext2fs_read_bitmaps (fs);
-		if (retval && !(fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS)) {
+		retval = ext2fs_read_bitmaps(fs);
+		if (retval && !retval_csum) {
 			fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+			retval_csum = retval;
+			error_csum = _("while trying to read '%s' bitmaps\n");
 			goto try_bitmaps_again;
 		}
-		if (!retval && (fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS))
-			printf("%s", _("\n*** Checksum errors detected in bitmaps!  Run e2fsck now!\n\n"));
 just_descriptors:
 		list_desc(fs, grp_only);
-		if (retval) {
-			printf(_("\n%s: %s: error reading bitmaps: %s\n"),
-			       program_name, device_name,
-			       error_message(retval));
-		}
+	}
+out_close:
+	if (retval_csum) {
+		com_err(program_name, retval_csum, error_csum, device_name);
+		printf("%s", _("*** Run e2fsck now!\n\n"));
+		if (!retval)
+			retval = retval_csum;
 	}
 	ext2fs_close_free(&fs);
 	remove_error_table(&et_ext2_error_table);
-	exit (0);
+out:
+	return retval;
 }
diff --git a/misc/e2mmpstatus.8.in b/misc/e2mmpstatus.8.in
new file mode 100644
index 0000000..51a7111
--- /dev/null
+++ b/misc/e2mmpstatus.8.in
@@ -0,0 +1,59 @@
+.\" -*- nroff -*-
+.\" This file may be copied under the terms of the GNU Public License.
+.\"
+.TH E2MMPSTATUS 8 "@E2FSPROGS_MONTH@ @E2FSPROGS_YEAR@" "E2fsprogs version @E2FSPROGS_VERSION@"
+.SH NAME
+e2mmpstatus \- Check MMP status of an ext4 filesystem
+.SH SYNOPSIS
+.BR e2mmpstatus " [" \-i ]
+.RI < filesystem >
+.SH OPTIONS
+.TP
+.B \-i
+prints out the MMP information rather than check it.
+.SH DESCRIPTION
+.B e2mmpstatus
+is used to check Multiple-Mount Protection (MMP) status of an ext4
+filesystem with the
+.B mmp
+feature enabled.  The specified
+.I filesystem
+can be a device name (e.g.
+.IR /dev/hdc1 ", " /dev/sdb2 ),
+or an ext4 filesystem label or UUID, for example
+.B UUID=8868abf6-88c5-4a83-98b8-bfc24057f7bd
+or
+.BR LABEL=root .
+By default, the
+.B e2mmpstatus
+program checks whether it is safe to mount the filesystem without taking
+the risk of mounting it more than once.
+.PP
+MMP (multiple-mount protection) is a feature that protects
+the filesystem from being mounted simultaneously to more than one node.
+It is NOT safe to mount a filesystem when one of the following conditions
+is true:
+.br
+\	1. The MMP block shows that e2fsck is running on the filesystem.
+.br
+\	2. The MMP block is being updated by another node.
+.br
+\	3. The MMP block is corrupted or cannot be read for some reason.
+.br
+The
+.B e2mmpstatus
+program might wait for some time to see whether MMP is updated by any node
+during this period.  The time taken depends on how often the MMP block is
+being written by the other node.
+.SH EXIT CODE
+The exit code returned by
+.B e2mmpstatus
+is 0 when it is safe to mount the filesystem, 1 when the MMP block shows
+the filesystem is in use on another node and it is NOT safe to mount
+the filesystem, and 2 if some other failure occurred that prevents the
+check from succeeding.
+.SH SEE ALSO
+.BR dumpe2fs (8),
+.BR e2fsck (8),
+.BR fstab (5),
+.BR fsck (8),
diff --git a/tests/f_mmp/script b/tests/f_mmp/script
index 9ff16c9..07ae232 100644
--- a/tests/f_mmp/script
+++ b/tests/f_mmp/script
@@ -43,6 +43,13 @@ rm -f $MARKFILE
 echo "kill debugfs abruptly (simulates e2fsck failure) ..." >> $test_name.log
 kill_debugfs
 
+$E2MMPSTATUS $TMPFILE > $test_name.log 2>&1
+status=$?
+if [ "$status" != 1 ] ; then
+	echo "$E2MMPSTATUS with EXT2_MMP_SEQ_FSCK passed!" > $test_name.failed
+	echo "$test_name: $test_description: failed"
+	return 1
+fi
 
 echo "e2fsck (should fail mmp_seq = EXT2_MMP_SEQ_FSCK) ..." >> $test_name.log
 $FSCK $FSCK_OPT $TMPFILE >> $test_name.log 2>&1
diff --git a/tests/filter.sed b/tests/filter.sed
index 628309d..aa50657 100644
--- a/tests/filter.sed
+++ b/tests/filter.sed
@@ -27,3 +27,12 @@ s/\\015//g
 s/, csum 0x\([0-9a-f]*\)//g
 s/ csum 0x\([0-9a-f]*\)//g
 /^Checksum:/d
+s/while trying to open [^ ]*/while trying to open test.img/
+s/he filesystem on [^ ]* /he filesystem on test.img /
+s/MMP block [0-9]* from [^ ]*/MMP block from test.img/
+s/safe to mount '.*', MMP/safe to mount 'test.img', MMP/
+s/mmp_device_name: .*/mmp_device_name: test.img/
+s/mmp_node_name: .*/mmp_node_name: test_node/
+s/mmp_update_date: .*/mmp_update_date: test date/
+s/mmp_update_time: .*/mmp_update_time: test_time/
+s/MMP last updated by '.*' on .*/MMP last updated by 'test_node' on test date/
diff --git a/tests/m_mmp/expect.1 b/tests/m_mmp/expect.1
index a1452e6..9d8a5a3 100644
--- a/tests/m_mmp/expect.1
+++ b/tests/m_mmp/expect.1
@@ -46,6 +46,14 @@ Inode size:	          128
 Default directory hash:   half_md4
 MMP block number:         1049
 MMP update interval:      5
+MMP_block:
+    mmp_magic: 0x4d4d50
+    mmp_check_interval: 5
+    mmp_sequence: 0xff4d4d50
+    mmp_update_date: test date
+    mmp_update_time: test_time
+    mmp_node_name: test_node
+    mmp_device_name: test.img
 
 
 Group 0: (Blocks 0-32767)
diff --git a/tests/m_mmp_bad_csum/expect b/tests/m_mmp_bad_csum/expect
index e15e7b4..a0678ac 100644
--- a/tests/m_mmp_bad_csum/expect
+++ b/tests/m_mmp_bad_csum/expect
@@ -1,4 +1,7 @@
-Superblock MMP block checksum does not match MMP block.  Fix? yes
+dumpe2fs: MMP block checksum does not match while trying to open test.img
+dumpe2fs: MMP last updated by 'test_node' on test date
+Exit status is 1
+Superblock MMP block checksum does not match.  Fix? yes
 
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
@@ -7,3 +10,14 @@ Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 test_filesys: 11/128 files (0.0% non-contiguous), 19/512 blocks
 Exit status is 0
+dumpe2fs: it is safe to mount 'test.img', MMP is clean
+Exit status is 0
+MMP_block:
+    mmp_magic: 0x4d4d50
+    mmp_check_interval: 5
+    mmp_sequence: 0xff4d4d50
+    mmp_update_date: test date
+    mmp_update_time: test_time
+    mmp_node_name: test_node
+    mmp_device_name: test.img
+    mmp_block_number: 8
diff --git a/tests/m_mmp_bad_csum/script b/tests/m_mmp_bad_csum/script
index 09e870c..11bf9bf 100644
--- a/tests/m_mmp_bad_csum/script
+++ b/tests/m_mmp_bad_csum/script
@@ -12,8 +12,15 @@ gzip -dc < $test_dir/image.gz > $TMPFILE
 
 OUT=$test_name.log
 EXP=$test_dir/expect
-$FSCK -fy $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed > $OUT
+$E2MMPSTATUS $TMPFILE > $OUT 2>&1
 echo Exit status is $? >> $OUT
+$FSCK -fy $TMPFILE >> $OUT 2>&1
+echo Exit status is $? >> $OUT
+$E2MMPSTATUS $TMPFILE >> $OUT 2>&1
+echo Exit status is $? >> $OUT
+$E2MMPSTATUS -i $TMPFILE >> $OUT 2>&1
+# need to filter afterward, so sed doesn't mess with exit status
+sed -f $cmd_dir/filter.sed -i "" $OUT
 
 rm -f $TMPFILE
 cmp -s $OUT $EXP
diff --git a/tests/m_mmp_bad_magic/expect b/tests/m_mmp_bad_magic/expect
index b5dfb89..d5fa98c 100644
--- a/tests/m_mmp_bad_magic/expect
+++ b/tests/m_mmp_bad_magic/expect
@@ -1,3 +1,5 @@
+dumpe2fs: MMP: invalid magic number while trying to open test.img
+Exit status is 2
 Superblock has invalid MMP magic.  Fix? yes
 
 Pass 1: Checking inodes, blocks, and sizes
@@ -7,3 +9,14 @@ Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 test_filesys: 11/128 files (0.0% non-contiguous), 19/512 blocks
 Exit status is 0
+dumpe2fs: it is safe to mount 'test.img', MMP is clean
+Exit status is 0
+MMP_block:
+    mmp_magic: 0x4d4d50
+    mmp_check_interval: 5
+    mmp_sequence: 0xff4d4d50
+    mmp_update_date: test date
+    mmp_update_time: test_time
+    mmp_node_name: test_node
+    mmp_device_name: test.img
+    mmp_block_number: 8
diff --git a/tests/m_mmp_bad_magic/script b/tests/m_mmp_bad_magic/script
index 09e870c..11bf9bf 100644
--- a/tests/m_mmp_bad_magic/script
+++ b/tests/m_mmp_bad_magic/script
@@ -12,8 +12,15 @@ gzip -dc < $test_dir/image.gz > $TMPFILE
 
 OUT=$test_name.log
 EXP=$test_dir/expect
-$FSCK -fy $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed > $OUT
+$E2MMPSTATUS $TMPFILE > $OUT 2>&1
 echo Exit status is $? >> $OUT
+$FSCK -fy $TMPFILE >> $OUT 2>&1
+echo Exit status is $? >> $OUT
+$E2MMPSTATUS $TMPFILE >> $OUT 2>&1
+echo Exit status is $? >> $OUT
+$E2MMPSTATUS -i $TMPFILE >> $OUT 2>&1
+# need to filter afterward, so sed doesn't mess with exit status
+sed -f $cmd_dir/filter.sed -i "" $OUT
 
 rm -f $TMPFILE
 cmp -s $OUT $EXP
diff --git a/tests/test_config b/tests/test_config
index c13aa74..2b1b3b9 100644
--- a/tests/test_config
+++ b/tests/test_config
@@ -18,6 +18,7 @@ RESIZE2FS_EXE="../resize/resize2fs"
 RESIZE2FS="$USE_VALGRIND $RESIZE2FS_EXE"
 E2UNDO_EXE="../misc/e2undo"
 E2UNDO="$USE_VALGRIND $E2UNDO_EXE"
+E2MMPSTATUS="$USE_VALGRIND ../misc/dumpe2fs -m"
 TEST_REL=../tests/progs/test_rel
 TEST_ICOUNT=../tests/progs/test_icount
 CRCSUM=../tests/progs/crcsum
-- 
1.8.0
