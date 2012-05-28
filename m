From: Ted Ts'o <tytso@mit.edu>
Subject: Re: libquota: add a quotactl prototype
Date: Mon, 28 May 2012 10:45:02 -0400
Message-ID: <20120528144502.GA3658@thunk.org>
References: <1337715689-7116-1-git-send-email-vapier@gentoo.org>
 <20120528142032.GA1578@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@whamcloud.com,
	adityakali@google.com
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45967 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043Ab2E1OpF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 May 2012 10:45:05 -0400
Content-Disposition: inline
In-Reply-To: <20120528142032.GA1578@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 28, 2012 at 10:20:32AM -0400, Ted Ts'o wrote:
> On Tue, May 22, 2012 at 09:41:29AM -0000, Mike Frysinger wrote:
> > The commit 0df8a27bbaf51b55c0e8c3a533ef4c2ff9d79c9f removed the system
> > quota.h include, but in doing so, added the problem:
> > mkquota.c:55:2: warning: implicit declaration of function 'quotactl'
> > 
> > Since we're maintaining a copy of quota.h, add a proper func prototype.
> > 
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> 
> Thanks, applied.

Your patch turned out to be problematic, since caddr_t isn't always
being defined by the header files (only if USE_BSD is defined).  As it
turns out, there's no real need to use the quotactl() system call at
all in e2fsprogs, so I've applied this patch instead.

I believe that there's more opportunities to simplify and cleanup
libquota, which is why I'm glad we never exported it as an external
library.  In fact, I'm seriously considering renaming it
"libinternal", and then moving things like profile.c and other utility
functions currently being informally shared between e2fsck and mke2fs
(either via .o or code duplication) into libinternal.

					- Ted

commit 3b802e43d9276a13cbc75144087cbf017672ca6c
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon May 28 10:38:06 2012 -0400

    libquota: remove quota_is_on() which was the last user of quotactl()
    
    The quotactl() system call was being used without the use of a
    function prototype.  On closer examination, it turns out the one user
    of that system call was the quota_is_on() function, which is not used
    by e2fsprogs at all.  Since libquota is an e2fsprogs-internal library,
    and not one that we plan to export any time soon, the simplest thing
    to do is to simply remove quota_is_on(), which in turn allows us to
    remove all of the infrastructure around using the Linux-specific
    quotactl() system call.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/configure b/configure
index ae599cd..b741112 100755
--- a/configure
+++ b/configure
@@ -10917,7 +10917,7 @@ if test "$ac_res" != no; then :
 fi
 
 fi
-for ac_func in  	__secure_getenv 	backtrace 	blkid_probe_get_topology 	chflags 	fallocate 	fallocate64 	fchown 	fdatasync 	fstat64 	ftruncate64 	getdtablesize 	getmntinfo 	getpwuid_r 	getrlimit 	getrusage 	jrand48 	llseek 	lseek64 	mallinfo 	mbstowcs 	memalign 	mmap 	msync 	nanosleep 	open64 	pathconf 	posix_fadvise 	posix_memalign 	prctl 	quotactl 	setmntent 	setresgid 	setresuid 	srandom 	strcasecmp 	strdup 	strnlen 	strptime 	strtoull 	sync_file_range 	sysconf 	usleep 	utime 	valloc
+for ac_func in  	__secure_getenv 	backtrace 	blkid_probe_get_topology 	chflags 	fallocate 	fallocate64 	fchown 	fdatasync 	fstat64 	ftruncate64 	getdtablesize 	getmntinfo 	getpwuid_r 	getrlimit 	getrusage 	jrand48 	llseek 	lseek64 	mallinfo 	mbstowcs 	memalign 	mmap 	msync 	nanosleep 	open64 	pathconf 	posix_fadvise 	posix_memalign 	prctl 	setmntent 	setresgid 	setresuid 	srandom 	strcasecmp 	strdup 	strnlen 	strptime 	strtoull 	sync_file_range 	sysconf 	usleep 	utime 	valloc
 do :
   as_ac_var=`$as_echo "ac_cv_func_$ac_func" | $as_tr_sh`
 ac_fn_c_check_func "$LINENO" "$ac_func" "$as_ac_var"
diff --git a/configure.in b/configure.in
index 83a6a1d..aa4c777 100644
--- a/configure.in
+++ b/configure.in
@@ -1003,7 +1003,6 @@ AC_CHECK_FUNCS(m4_flatten([
 	posix_fadvise
 	posix_memalign
 	prctl
-	quotactl
 	setmntent
 	setresgid
 	setresuid
diff --git a/lib/config.h.in b/lib/config.h.in
index 18539c6..90e9743 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -290,9 +290,6 @@
 /* Define to 1 if you have the `putenv' function. */
 #undef HAVE_PUTENV
 
-/* Define to 1 if you have the `quotactl' function. */
-#undef HAVE_QUOTACTL
-
 /* Define to 1 if dirent has d_reclen */
 #undef HAVE_RECLEN_DIRENT
 
diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
index 13994ad..973c35e 100644
--- a/lib/quota/mkquota.c
+++ b/lib/quota/mkquota.c
@@ -46,18 +46,6 @@ static void print_inode(struct ext2_inode *inode)
 	return;
 }
 
-int quota_is_on(ext2_filsys fs, int type)
-{
-	char tmp[1024];
-	qid_t id = (type == USRQUOTA) ? getuid() : getgid();
-
-#ifdef HAVE_QUOTACTL
-	if (!quotactl(QCMD(Q_V2_GETQUOTA, type), fs->device_name, id, tmp))
-		return 1;
-#endif
-	return 0;
-}
-
 /*
  * Returns 0 if not able to find the quota file, otherwise returns its
  * inode number.
diff --git a/lib/quota/mkquota.h b/lib/quota/mkquota.h
index ed6fabd..70107ba 100644
--- a/lib/quota/mkquota.h
+++ b/lib/quota/mkquota.h
@@ -56,7 +56,6 @@ errcode_t quota_compute_usage(quota_ctx_t qctx);
 void quota_release_context(quota_ctx_t *qctx);
 
 errcode_t quota_remove_inode(ext2_filsys fs, int qtype);
-int quota_is_on(ext2_filsys fs, int type);
 int quota_file_exists(ext2_filsys fs, int qtype, int fmt);
 void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, int qtype);
 errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
diff --git a/lib/quota/quota.h b/lib/quota/quota.h
index a943ec6..0fb4714 100644
--- a/lib/quota/quota.h
+++ b/lib/quota/quota.h
@@ -72,25 +72,6 @@ typedef int64_t qsize_t;	/* Type in which we store size limitations */
 #define kb2qb(x) ((x) >> (QUOTABLOCK_BITS-10))
 #define toqb(x) (((x) + QUOTABLOCK_SIZE - 1) >> QUOTABLOCK_BITS)
 
-/*
- * Command definitions for the 'quotactl' system call.
- * The commands are broken into a main command defined below
- * and a subcommand that is used to convey the type of
- * quota that is being manipulated (see above).
- */
-#define SUBCMDMASK  0x00ff
-#define SUBCMDSHIFT 8
-#define QCMD(cmd, type)  (((cmd) << SUBCMDSHIFT) | ((type) & SUBCMDMASK))
-
-#define Q_SYNC     0x800001	/* sync disk copy of a filesystems quotas */
-#define Q_QUOTAON  0x800002	/* turn quotas on */
-#define Q_QUOTAOFF 0x800003	/* turn quotas off */
-#define Q_GETFMT   0x800004	/* get quota format used on given filesystem */
-#define Q_GETINFO  0x800005	/* get information about quota files */
-#define Q_SETINFO  0x800006	/* set information about quota files */
-#define Q_GETQUOTA 0x800007	/* get user quota structure */
-#define Q_SETQUOTA 0x800008	/* set user quota structure */
-
 /* Quota format type IDs */
 #define	QFMT_VFS_OLD 1
 #define	QFMT_VFS_V0 2
@@ -103,22 +84,6 @@ typedef int64_t qsize_t;	/* Type in which we store size limitations */
 #define QIF_DQBLKSIZE (1 << QIF_DQBLKSIZE_BITS)
 
 /*
- * Structure used for setting quota information about file via quotactl
- * Following flags are used to specify which fields are valid
- */
-#define IIF_BGRACE	1
-#define IIF_IGRACE	2
-#define IIF_FLAGS	4
-#define IIF_ALL		(IIF_BGRACE | IIF_IGRACE | IIF_FLAGS)
-
-struct if_dqinfo {
-	__u64 dqi_bgrace;
-	__u64 dqi_igrace;
-	__u32 dqi_flags;
-	__u32 dqi_valid;
-};
