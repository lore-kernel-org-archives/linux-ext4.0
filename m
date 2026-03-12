Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338ED38655E
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 20:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773349049; cv=none; b=ZPOUHTU5lxgwzays8G5BR0Phkx6BJEKJmLMTz/8U9E+PWKU6xhHvibgPd+YQo7XskCptj318TePucMZKIxbpIgYB1fAeJpF4pxlXDjdKhrC5WRbqNpgpzzPBm5rX2gaAtkNY8OeC16UzWbIU8NtqB6RWh3xNleNBjRzbu3+fvsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773349049; c=relaxed/simple;
	bh=L2QMuZ682aCeUW93Q2vo28Np3YqBNnZofW7LgCVTy6c=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=krpZo3PqNToh59Vek43Q20GBW+MHBNXHaMWVxY+1xjFNiR8a4EoYpeh8KZr4aPGDGTUw6goFM1xWqga6X+23nvv0ddhk9J5caqtXhY3ZC5qKTRfJGLFFw0Jsck5nJQxwemk3elcijuAnT7MxKL+Sx8SQpqTvIdUD9tvXKdpL5hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZfK1quCt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZfK1quCt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C976EC4CEF7;
	Thu, 12 Mar 2026 20:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773349048;
	bh=L2QMuZ682aCeUW93Q2vo28Np3YqBNnZofW7LgCVTy6c=;
	h=Date:From:To:Cc:Subject:From;
	b=ZfK1quCtYwBj0RWtlP3wSHb6uaNx5MFdc29LzpgwSLTKtQD7wHQB6GAlrbbsvV9bu
	 c2MiRZs7NaOeOh6E6WKYnXjOHJE65EhgdMIkZC0fx8suewIBfuy3R8jau3vzSZ9PMb
	 LtrimR1efn0bpVpOlLzgJG3y6BY50FBwWYbq4SGQyWQde1gcQAEwSkyPHXZt8ssoSM
	 bLfKGPXC7cvyD+DqX2vrO9mfAG0r4ahRokE3j5UdCoIR2QAZq9sX+dYwCaKY6DgOF+
	 D9r8JjU5bynTPVqQ861v/cANWo7LUJXyfFOVpk3vx7pLnGq9Bmm5dudSvv7qZMChpy
	 j9qs7sl7NYKIQ==
Date: Thu, 12 Mar 2026 13:57:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, amir73il@gmail.com
Subject: [PULLBOMB v2 1.48] fuse2fs: new features, new server
Message-ID: <20260312205728.GA6004@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Ted,

As promised, this large patchbomb contains all the improvements that I'd
like to make to fuse2fs before integrating iomap.  Major new features
include:

 - Fix locking of the block device (or image file) to prevent multiple
   fuse2fs instances.
 - Initializing the htree index in a growing directory so that directory
   lookups aren't horrifyingly slow.
 - Implementing MMP for cluster support.
 - Use file handles to reduce directory path lookups.
 - Implement directory seeking, readdir plus (the fuse version), and
   dirsync.
 - Fix differences in nlink overflow handling vs the kernel.
 - Cache symlinks when possible.
 - Refactor startup and shutdown to reduce main() complexity.
 - Add tracing for file operations.
 - Add the shutdown ioctl for better recovery testing.
 - Drop fuse 2.xx support.

At the end of this series, I create a new fuse ext* server (fuse4fs)
which uses the lowlevel FUSE API instead of the high level one.  The
major advantage of using the lowlevel API is that all file operations
are performed in terms of inodes instead of paths.  As a result, fuse4fs
has MUCH less overhead than fuse2fs because we avoid the overhead of
having libfuse translate inode numbers to paths only to have fuse2fs
translate paths back into inode numbers.

Obviously, this stuff should go into e2fsprogs 1.48, not a 1.47.x stable
release.  This patchbomb hasn't changed much since its last posting on
6 Nov 2025.  The range-diff between then and now is appended below;
changes include:

 * Don't purge pagecache when opening a file

 * Cache dirents from readdir contents to speed up directory tree ops

 * Disable rw mode for bigalloc filesystems due to many bugs in the
   extent tree punch code for implied cluster deallocation

As we discussed in the ext4 call this morning, I'm sending you pull
requests to initiate review, instead of hammering the list with ~70
patches.

--D

 1:  bcc1485fc77acc !  1:  44ce8e421929b5 libext2fs: add POSIX advisory locking to the unix IO manager
    @@ lib/ext2fs/ext2_io.h: extern errcode_t io_channel_zeroout(io_channel channel,
      #ifdef _WIN32
      /* windows_io.c */
      extern io_manager windows_io_manager;
      #define default_io_manager windows_io_manager
      #else
     
    - ## debian/libext2fs2.symbols ##
    -@@ debian/libext2fs2.symbols: libext2fs.so.2 libext2fs2 #MINVER#
    + ## debian/libext2fs2t64.symbols ##
    +@@ debian/libext2fs2t64.symbols: libext2fs.so.2 libext2fs2t64 #MINVER#
       initialize_ext2_error_table@Base 1.37
       initialize_ext2_error_table_r@Base 1.37
       inode_io_manager@Base 1.37
       io_channel_alloc_buf@Base 1.42.3
       io_channel_cache_readahead@Base 1.43
       io_channel_discard@Base 1.42
 2:  264facf1b0d183 =  2:  e9dad24e491754 fuse2fs: try to lock filesystem image files before using them
 3:  f0a723fa339d8b =  3:  82fd502239e8cc fuse2fs: quiet down write-protect warning
 4:  79bafc32b10284 =  4:  b22ae270a1016c fuse2fs: try to grab block device O_EXCL repeatedly
 5:  99d557bab152ca =  5:  f3c5e16bc36c9e libext2fs: initialize htree when expanding directory
 6:  7b80e2c803cb49 !  6:  875fe146da5295 libext2fs: create link count adjustment helpers for dir_nlink
    @@ lib/ext2fs/ext2fs.h: extern errcode_t ext2fs_get_pathname(ext2_filsys fs, ext2_i
      /* symlink.c */
      errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
      			 const char *name, const char *target);
      int ext2fs_is_fast_symlink(struct ext2_inode *inode);
      
     
    - ## debian/libext2fs2.symbols ##
    -@@ debian/libext2fs2.symbols: libext2fs.so.2 libext2fs2 #MINVER#
    + ## debian/libext2fs2t64.symbols ##
    +@@ debian/libext2fs2t64.symbols: libext2fs.so.2 libext2fs2t64 #MINVER#
       ext2fs_dblist_get_last@Base 1.40.8
       ext2fs_dblist_iterate2@Base 1.42
       ext2fs_dblist_iterate3@Base 1.43
       ext2fs_dblist_iterate@Base 1.37
       ext2fs_dblist_sort2@Base 1.42
       ext2fs_dblist_sort@Base 1.37
    @@ debian/libext2fs2.symbols: libext2fs.so.2 libext2fs2 #MINVER#
       ext2fs_dirent_csum_verify@Base 1.43
       ext2fs_dirent_file_type@Base 1.43
       ext2fs_dirent_has_tail@Base 1.43
       ext2fs_dirent_name_len@Base 1.43
       ext2fs_dirent_set_file_type@Base 1.43
       ext2fs_dirent_set_name_len@Base 1.43
    -@@ debian/libext2fs2.symbols: libext2fs.so.2 libext2fs2 #MINVER#
    +@@ debian/libext2fs2t64.symbols: libext2fs.so.2 libext2fs2t64 #MINVER#
       ext2fs_image_bitmap_read@Base 1.37
       ext2fs_image_bitmap_write@Base 1.37
       ext2fs_image_inode_read@Base 1.37
       ext2fs_image_inode_write@Base 1.37
       ext2fs_image_super_read@Base 1.37
       ext2fs_image_super_write@Base 1.37
 7:  c7a7b06d18564f =  7:  7feaab70961cb8 libext2fs: fix ext2fs_mmp_update
 8:  d07d6905ab25a4 !  8:  f314bc313c42dd libext2fs: refactor aligned MMP buffer allocation
    @@ lib/ext2fs/ext2fs.h: errcode_t ext2fs_mmp_clear(ext2_filsys fs);
      /* read_bb.c */
      extern errcode_t ext2fs_read_bb_inode(ext2_filsys fs,
      				      ext2_badblocks_list *bb_list);
      
      /* read_bb_file.c */
     
    - ## debian/libext2fs2.symbols ##
    -@@ debian/libext2fs2.symbols: libext2fs.so.2 libext2fs2 #MINVER#
    + ## debian/libext2fs2t64.symbols ##
    +@@ debian/libext2fs2t64.symbols: libext2fs.so.2 libext2fs2t64 #MINVER#
       ext2fs_mem_is_zero@Base 1.42
       ext2fs_mkdir2@Base 1.47.3~rc1
       ext2fs_mkdir@Base 1.37
       ext2fs_mmp_clear@Base 1.42
       ext2fs_mmp_csum_set@Base 1.43
       ext2fs_mmp_csum_verify@Base 1.43
 9:  9195f58a6cdb5a =  9:  ee84dbe7a9514e libext2fs: always use ext2fs_mmp_get_mem to allocate fs->mmp_buf
 -:  -------------- > 10:  afa1dbf0d36c71 fuse2fs: disable write access when cluster size > block size
 -:  -------------- > 11:  c5aea20cdc9bcf fuse2fs: enable more caching
10:  5e53170f5006b9 = 12:  128e4060e8f7cb fuse2fs: check root directory while mounting
11:  6fb5993b8f8e67 = 13:  af6da8a2f69768 fuse2fs: read bitmaps asynchronously during initialization
12:  d4e650b532df8f = 14:  aed6d1da1fa27e fuse2fs: use file handles when possible
13:  e6f47498d1b230 = 15:  10ec1962b5cce3 fuse2fs: implement dir seeking
14:  9efce340aa14ce = 16:  bf5daa34c6e1dd fuse2fs: implement readdirplus
15:  96bea8a553ef1e = 17:  8e09e6bb49baf2 fuse2fs: implement dirsync mode
16:  a9db4be25ceeba = 18:  45651efd6db7da fuse2fs: only flush O_SYNC files on close
17:  85dd57210496bf = 19:  b725c9a9e5786e fuse2fs: improve want_extra_isize handling
18:  6ec67afffee30a = 20:  b0bd58062bbf64 fuse2fs: cache symlink targets in the kernel
19:  60c6cbeab89382 = 21:  d485cf2972ac6e fuse2fs: constrain worker thread count
20:  17deed32e9410c = 22:  3010930102a352 fuse2fs: improve error handling behaviors
21:  e6758bfae61f95 = 23:  ff0bc6e2385fd0 fuse2fs: fix link count overflows on dir_nlink filesystems
22:  9bf264d29e2c45 ! 24:  a381f38cac203d libsupport: add background thread manager
    @@ Commit message
     
      ## lib/support/bthread.h (new) ##
     @@
     +/*
     + * bthread.h - Background thread manager
     + *
    -+ * Copyright (C) 2025 Oracle.
    ++ * Copyright (C) 2025-2026 Oracle.
     + *
     + * %Begin-Header%
     + * This file may be redistributed under the terms of the GNU Public
     + * License.
     + * %End-Header%
     + */
    @@ lib/support/Makefile.in: $(OBJS):
     
      ## lib/support/bthread.c (new) ##
     @@
     +/*
     + * bthread.c - Background thread manager
     + *
    -+ * Copyright (C) 2025 Oracle.
    ++ * Copyright (C) 2025-2026 Oracle.
     + *
     + * %Begin-Header%
     + * This file may be redistributed under the terms of the GNU Public
     + * License.
     + * %End-Header%
     + */
23:  0227370767f5a0 = 25:  a4fc4817e3072c fuse2fs: implement MMP updates
24:  deb1ee6f9121cb = 26:  ff8cf11cc27f77 fuse2fs: rework FUSE2FS_CHECK_CONTEXT not to rely on global_fs
25:  245b3b30d8bbd9 = 27:  81e273f16cd965 fuse2fs: rework checking file handles
26:  364f8e7b9cf55c = 28:  6347b122e30a89 fuse2fs: rework fallocate file handle extraction
27:  d3d25033d3e0df = 29:  5eb98f914a0bc3 fuse2fs: consolidate file handle checking in op_ioctl
28:  0a7cd8ae2c3303 = 30:  88ee26a59290bb fuse2fs: move fs assignment closer to locking the bfl
29:  ac2c12db4635ea = 31:  620f236eaf0281 fuse2fs: clean up operation startup
30:  947debc109b8d2 = 32:  a95a1577d15074 fuse2fs: clean up operation completion
31:  1f6402ed4f8cc3 ! 33:  849857563a87d0 fuse2fs: clean up more boilerplate
    @@ misc/fuse2fs.c: static int __op_open(struct fuse2fs *ff, const char *path,
      	}
      
      	file->check_flags = check;
     -	fp->fh = (uintptr_t)file;
     +	fuse2fs_set_handle(fp, file);
      
    - out:
    - 	if (ret)
    + 	/* fuse 2.4: do not purge pagecache on open */
    + 	fp->keep_cache = 1;
    + #ifdef HAVE_FUSE_CACHE_READDIR
    + 	/* fuse 3.5: cache dirents from readdir contents */
    + 	fp->cache_readdir = 1;
    +@@ misc/fuse2fs.c: static int __op_open(struct fuse2fs *ff, const char *path,
      		ext2fs_free_mem(&file);
      	return ret;
      }
      
      static int op_open(const char *path, struct fuse_file_info *fp)
      {
32:  ddfbba8195c29f ! 34:  f5c46155c79ccc fuse2fs: collect runtime of various operations
    @@ Commit message
         Collect the run time of various operations so that we can do some simple
         profiling.
     
         Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
     
      ## configure.ac ##
    -@@ configure.ac: then
    - fi
    - if test -n "$FUSE_USE_VERSION"
    +@@ configure.ac: fi
    + if test -n "$have_fuse_cache_readdir"
      then
    - 	AC_DEFINE_UNQUOTED(FUSE_USE_VERSION, $FUSE_USE_VERSION,
    - 		[Define to the version of FUSE to use])
    + 	AC_DEFINE(HAVE_FUSE_CACHE_READDIR, 1,
    + 		  [Define to 1 if fuse supports cache_readdir])
      fi
    + 
     +dnl
     +dnl see if CLOCK_MONOTONIC exists
     +dnl
     +AC_MSG_CHECKING(for CLOCK_MONOTONIC)
     +AC_LINK_IFELSE(
     +[	AC_LANG_PROGRAM([[
    @@ configure.ac: then
      AC_MSG_CHECKING(for optreset)
      AC_CACHE_VAL(ac_cv_have_optreset,
      [AC_EGREP_HEADER(optreset, unistd.h,
     
      ## lib/config.h.in ##
     @@
    - /* Define to 1 if Apple Darwin libintl workaround is needed */
    - #undef _INTL_REDIRECT_MACROS
    + /* Number of bits in time_t, on hosts where this is settable. */
    + #undef _TIME_BITS
      
    - /* Define for large files, on AIX-style hosts. */
    - #undef _LARGE_FILES
    + /* Define to 1 on platforms where this makes time_t a 64-bit type. */
    + #undef __MINGW_USE_VC2005_COMPAT
      
     +/* Define to 1 if CLOCK_MONOTONIC is present */
     +#undef HAVE_CLOCK_MONOTONIC
     +
      #include <dirpaths.h>
     
33:  1315fa41329faf ! 35:  8a58d8b126d4e6 fuse2fs: get rid of the global_fs variable
    @@ misc/fuse2fs.c: int main(int argc, char *argv[])
      	 * we must force ro mode.
      	 */
     -	if (ext2fs_has_feature_shared_blocks(global_fs->super))
     +	if (ext2fs_has_feature_shared_blocks(fctx.fs->super))
      		fctx.ro = 1;
      
    + 	/*
    + 	 * libext2fs' extent tree modification code has severe problems with
    + 	 * implied cluster deallocation, so we must force ro mode.
    + 	 */
    +-	if (ext2fs_has_feature_bigalloc(global_fs->super) &&
    +-	    EXT2FS_CLUSTER_RATIO(global_fs) > 1) {
    ++	if (ext2fs_has_feature_bigalloc(fctx.fs->super) &&
    ++	    EXT2FS_CLUSTER_RATIO(fctx.fs) > 1) {
    + 		log_printf(&fctx, "%s\n",
    +  _("Mounting read-only because writes with large cluster sizes is not supported."));
    + 		fctx.ro = 1;
    + 	}
    + 
     -	if (ext2fs_has_feature_journal_needs_recovery(global_fs->super)) {
     +	if (ext2fs_has_feature_journal_needs_recovery(fctx.fs->super)) {
      		if (fctx.norecovery) {
      			log_printf(&fctx, "%s\n",
       _("Mounting read-only without recovering journal."));
      			fctx.ro = 1;
34:  ca07f54a419987 = 36:  179e4af57d7e85 fuse2fs: hoist lockfile code
35:  69f0801db74143 = 37:  5d3394ff8d6f2e fuse2fs: hoist unmount code from main
36:  3579eba15ddd98 ! 38:  a65babb03b3e37 fuse2fs: split filesystem mounting into helper functions
    @@ misc/fuse2fs.c: int main(int argc, char *argv[])
      
      	/*
      	 * ext4 can't do COW of shared blocks, so if the feature is enabled,
      	 * we must force ro mode.
      	 */
      	if (ext2fs_has_feature_shared_blocks(fctx.fs->super))
    +@@ misc/fuse2fs.c: int main(int argc, char *argv[])
    + 	    EXT2FS_CLUSTER_RATIO(fctx.fs) > 1) {
    + 		log_printf(&fctx, "%s\n",
    +  _("Mounting read-only because writes with large cluster sizes is not supported."));
      		fctx.ro = 1;
    + 	}
      
     -	if (ext2fs_has_feature_journal_needs_recovery(fctx.fs->super)) {
     -		if (fctx.norecovery) {
     -			log_printf(&fctx, "%s\n",
     - _("Mounting read-only without recovering journal."));
     -			fctx.ro = 1;
37:  e3a706d012a1c6 ! 39:  612e59bedd71c0 fuse2fs: register as an IO flusher thread
    @@ Commit message
         a round of filesystem memory reclaim, which could cause more writeout to
         get dumped on fuse2fs.
     
         Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
     
      ## configure.ac ##
    -@@ configure.ac: then
    - fi
    - if test -n "$FUSE_USE_VERSION"
    +@@ configure.ac: fi
    + if test -n "$have_fuse_cache_readdir"
      then
    - 	AC_DEFINE_UNQUOTED(FUSE_USE_VERSION, $FUSE_USE_VERSION,
    - 		[Define to the version of FUSE to use])
    + 	AC_DEFINE(HAVE_FUSE_CACHE_READDIR, 1,
    + 		  [Define to 1 if fuse supports cache_readdir])
      fi
    -+
    + 
     +dnl
     +dnl see if PR_SET_IO_FLUSHER exists
     +dnl
     +AC_MSG_CHECKING(for PR_SET_IO_FLUSHER)
     +AC_LINK_IFELSE(
     +[	AC_LANG_PROGRAM([[
    @@ misc/fuse2fs.c: static void fuse2fs_compute_libfuse_args(struct fuse2fs *ff,
      		fflush(stdout);
      	}
      }
      
     +/*
     + * Try to register as a filesystem I/O server process so that our memory
    -+ * allocations don't cause fs reclaim.
    ++ * allocations don't cause io reclaim.
     + */
     +static void try_set_io_flusher(struct fuse2fs *ff)
     +{
     +#ifdef HAVE_PR_SET_IO_FLUSHER
     +	int ret = prctl(PR_GET_IO_FLUSHER, 0, 0, 0, 0);
     +
38:  05b8b9046da861 = 40:  9476b1377d8878 fuse2fs: adjust OOM killer score if possible
39:  c383cd4fbc27bc = 41:  15a4aa0d4329b9 fuse2fs: hook library error message printing
40:  c21b7bb856d99d = 42:  5ee2df0fe9b5e0 fuse2fs: print the function name in error messages, not the file name
41:  1f5fc734e00b00 = 43:  d3151f36edf52b fuse2fs: improve tracing for file range operations
42:  1fe3afbc4dd4b8 = 44:  fe8281316fd371 fuse2fs: record thread id in debug trace data
43:  184741e8ec67fc = 45:  0fb191361aff22 fuse2fs: pass a struct fuse2fs to fs_writeable
44:  bb42690c6ab468 = 46:  144fdfd3fad4e0 fuse2fs: track our own writable state
45:  0bba0f4e19ebba = 47:  f066b2d71d6270 fuse2fs: enable the shutdown ioctl
46:  9055fe8b34276b = 48:  ee84bb825b0ba0 fuse2fs: bump library version
47:  d6c0188aeefa3e = 49:  7e7bb349a384f7 fuse2fs: wrap the fuse_set_feature_flag helper for older libfuse
48:  3378dd43db6f20 = 50:  631d3f8d14b613 fuse2fs: disable nfs exports
49:  7ee503ad6acb6b = 51:  96ca2a29cc7dcb fuse2fs: drop fuse 2.x support code
50:  31e3bba3857cc7 ! 52:  e048f198d7b598 fuse2fs: separate libfuse3 and fuse2fs detection in configure
    @@ configure.ac: fi
     -	AC_DEFINE_UNQUOTED(FUSE_USE_VERSION, $FUSE_USE_VERSION,
     -		[Define to the version of FUSE to use])
     -fi
     +AC_SUBST(FUSE2FS_CMT)
      
      dnl
    - dnl see if PR_SET_IO_FLUSHER exists
    + dnl Check if the FUSE cache_readdir flag is supported
      dnl
    - AC_MSG_CHECKING(for PR_SET_IO_FLUSHER)
    - AC_LINK_IFELSE(
    + have_fuse_cache_readdir=
    + if test -n "$FUSE_USE_VERSION"
     
      ## misc/Makefile.in ##
     @@ misc/Makefile.in: MKDIR_P = @MKDIR_P@
      @BLKID_CMT@BLKID_STATIC= blkid.static
      @BLKID_CMT@BLKID_MAN= blkid.8
      
51:  260e9383838bf6 ! 53:  3b02fa292dda7c fuse2fs: start porting fuse2fs to lowlevel libfuse API
    @@ configure.ac: AS_HELP_STRING([--disable-fuse2fs],[do not build fuse2fs]),
     +	fi
     +]
     +)
     +AC_SUBST(FUSE4FS_CMT)
     +
      dnl
    - dnl see if PR_SET_IO_FLUSHER exists
    + dnl Check if the FUSE cache_readdir flag is supported
      dnl
    - AC_MSG_CHECKING(for PR_SET_IO_FLUSHER)
    - AC_LINK_IFELSE(
    - [	AC_LANG_PROGRAM([[
    + have_fuse_cache_readdir=
    + if test -n "$FUSE_USE_VERSION"
    + then
     @@ configure.ac: for i in MCONFIG Makefile \
      	lib/ext2fs/Makefile lib/ext2fs/ext2_types.h \
      	$uuid_out_list $blkid_out_list lib/support/Makefile \
      	lib/ss/ss.pc lib/et/com_err.pc lib/e2p/e2p.pc lib/ext2fs/ext2fs.pc \
      	misc/Makefile ext2ed/Makefile e2fsck/Makefile \
      	debugfs/Makefile tests/Makefile tests/progs/Makefile \
    @@ fuse4fs/fuse4fs.1.in (new)
     
      ## fuse4fs/fuse4fs.c (new) ##
     @@
     +/*
     + * fuse4fs.c - FUSE low-level server for e2fsprogs.
     + *
    -+ * Copyright (C) 2014-2025 Oracle.
    ++ * Copyright (C) 2014-2026 Oracle.
     + *
     + * %Begin-Header%
     + * This file may be redistributed under the terms of the GNU Public
     + * License.
     + * %End-Header%
     + */
    @@ fuse4fs/fuse4fs.c (new)
     +			goto out;
     +	}
     +
     +	file->check_flags = check;
     +	fuse4fs_set_handle(fp, file);
     +
    ++	/* fuse 2.4: do not purge pagecache on open */
    ++	fp->keep_cache = 1;
    ++#ifdef HAVE_FUSE_CACHE_READDIR
    ++	/* fuse 3.5: cache dirents from readdir contents */
    ++	fp->cache_readdir = 1;
    ++#endif
    ++
     +out:
     +	if (ret)
     +		ext2fs_free_mem(&file);
     +	return ret;
     +}
     +
    @@ fuse4fs/fuse4fs.c (new)
     +		fflush(stdout);
     +	}
     +}
     +
     +/*
     + * Try to register as a filesystem I/O server process so that our memory
    -+ * allocations don't cause fs reclaim.
    ++ * allocations don't cause io reclaim.
     + */
     +static void try_set_io_flusher(struct fuse4fs *ff)
     +{
     +#ifdef HAVE_PR_SET_IO_FLUSHER
     +	int ret = prctl(PR_GET_IO_FLUSHER, 0, 0, 0, 0);
     +
    @@ fuse4fs/fuse4fs.c (new)
     +	 * ext4 can't do COW of shared blocks, so if the feature is enabled,
     +	 * we must force ro mode.
     +	 */
     +	if (ext2fs_has_feature_shared_blocks(fctx.fs->super))
     +		fctx.ro = 1;
     +
    ++	/*
    ++	 * libext2fs' extent tree modification code has severe problems with
    ++	 * implied cluster deallocation, so we must force ro mode.
    ++	 */
    ++	if (ext2fs_has_feature_bigalloc(fctx.fs->super) &&
    ++	    EXT2FS_CLUSTER_RATIO(fctx.fs) > 1) {
    ++		log_printf(&fctx, "%s\n",
    ++ _("Mounting read-only because writes with large cluster sizes is not supported."));
    ++		fctx.ro = 1;
    ++	}
    ++
     +	err = fuse4fs_mount(&fctx);
     +	if (err) {
     +		ret = 32;
     +		goto out;
     +	}
     +
52:  7ebb0d37daa7e0 ! 54:  480ffd57c3152f debian: create new package for fuse4fs
    @@ Commit message
      ## debian/control ##
     @@
      Source: e2fsprogs
      Section: admin
      Priority: important
      Maintainer: Theodore Y. Ts'o <tytso@mit.edu>
    --Build-Depends: dpkg-dev, gettext, texinfo, pkgconf, libarchive-dev <!nocheck>, libfuse3-dev [linux-any kfreebsd-any] <!pkg.e2fsprogs.no-fuse2fs>, debhelper-compat (= 12), dh-exec, libblkid-dev, uuid-dev, m4, udev [linux-any], systemd [linux-any], udev | systemd-dev [linux-any], cron [linux-any]
    -+Build-Depends: dpkg-dev, gettext, texinfo, pkgconf, libarchive-dev <!nocheck>, libfuse3-dev [linux-any kfreebsd-any] <!pkg.e2fsprogs.no-fuse2fs> <!pkg.e2fsprogs.no-fuse4fs>, debhelper-compat (= 12), dh-exec, libblkid-dev, uuid-dev, m4, udev [linux-any], systemd [linux-any], udev | systemd-dev [linux-any], cron [linux-any]
    +-Build-Depends: dpkg-dev (>= 1.22.5), gettext, texinfo, pkgconf, libarchive-dev <!nocheck>, libfuse3-dev [linux-any] <!pkg.e2fsprogs.no-fuse2fs>, debhelper-compat (= 12), dh-exec, libblkid-dev, uuid-dev, m4, udev [linux-any], systemd [linux-any], systemd-dev [linux-any], cron [linux-any], dh-sequence-movetousr
    ++Build-Depends: dpkg-dev (>= 1.22.5), gettext, texinfo, pkgconf, libarchive-dev <!nocheck>, libfuse3-dev [linux-any] <!pkg.e2fsprogs.no-fuse2fs> <!pkg.e2fsprogs.no-fuse4fs>, debhelper-compat (= 12), dh-exec, libblkid-dev, uuid-dev, m4, udev [linux-any], systemd [linux-any], systemd-dev [linux-any], cron [linux-any], dh-sequence-movetousr
      Rules-Requires-Root: no
      Standards-Version: 4.7.2
      Homepage: http://e2fsprogs.sourceforge.net
      Vcs-Browser: https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
      Vcs-Git: https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git -b debian/master
      
     @@ debian/control: Replaces: fuseext2 (<< 1.47.1-2~)
    - Architecture: linux-any kfreebsd-any
    + Architecture: linux-any
      Description: ext2 / ext3 / ext4 file system driver for FUSE
       fuse2fs is a FUSE file system client that supports reading and
       writing from devices or image files containing ext2, ext3, and ext4
       file systems.
      
     +Package: fuse4fs
53:  4369876c2c94cb = 55:  eb97e1fefbf286 fuse4fs: namespace some helpers
54:  3d879e8b9af2f6 ! 56:  7a2e6084f203a4 fuse4fs: convert to low level API
    @@ Commit message
     
      ## fuse4fs/fuse4fs.c ##
     @@
      /*
       * fuse4fs.c - FUSE low-level server for e2fsprogs.
       *
    -  * Copyright (C) 2014-2025 Oracle.
    +  * Copyright (C) 2014-2026 Oracle.
     + * Copyright (C) 2025 CTERA Networks.
       *
       * %Begin-Header%
       * This file may be redistributed under the terms of the GNU Public
       * License.
       * %End-Header%
55:  e503449ebd35fa = 57:  8072dafea5ba54 libsupport: port the kernel list.h to libsupport
56:  5bf09d97df47be = 58:  df5e76db0018b3 libsupport: add a cache
57:  b0567861fb4c48 = 59:  f13414a72be32f cache: disable debugging
58:  d8d9a1d2c77497 = 60:  383f3dd0b56f64 cache: use modern list iterator macros
59:  d72a8bf319a337 = 61:  a9c0181ee15128 cache: embed struct cache in the owner
60:  12ae5b5676175b = 62:  31e5763e32dfc2 cache: pass cache pointer to callbacks
61:  ce739cf7e07770 = 63:  a5c773947bd56d cache: pass a private data pointer through cache_walk
62:  5f29a509ae6ff5 = 64:  4f017b4dc8920f cache: add a helper to grab a new refcount for a cache_node
63:  35f2f492357fdc = 65:  d1dea709493fdc cache: return results of a cache flush
64:  b83bb727f35e35 = 66:  e59f4eba2f22f8 cache: add a "get only if incore" flag to cache_node_get
65:  93ab9d85892539 = 67:  a999b4c74344cd cache: support gradual expansion
66:  34832daae14e22 = 68:  019aa0d8a8c87d cache: support updating maxcount and flags
67:  133ccdd2700d31 = 69:  0283835cbfa2db cache: support channging flags
68:  4e0e55db4c2825 = 70:  0f5c83c6c88c3f cache: implement automatic shrinking
69:  2987f5a8e19d4d ! 71:  26f78774c08acc fuse4fs: add cache to track open files
    @@ fuse4fs/fuse4fs.c: static int fuse4fs_open_file(struct fuse4fs *ff, const struct
     +	}
     +	file->fi->i_open_count++;
     +
      	file->check_flags = check;
      	fuse4fs_set_handle(fp, file);
      
    - out:
    - 	if (ret)
    - 		ext2fs_free_mem(&file);
    + 	/* fuse 2.4: do not purge pagecache on open */
    + 	fp->keep_cache = 1;
    + #ifdef HAVE_FUSE_CACHE_READDIR
     @@ fuse4fs/fuse4fs.c: static void op_release(fuse_req_t req, fuse_ino_t fino EXT2FS_ATTR((unused)),
      	    (fh->open_flags & EXT2_FILE_WRITE)) {
      		err = ext2fs_flush2(fs, EXT2_FLAG_FLUSH_NO_SYNC);
      		if (err)
      			ret = translate_error(fs, fh->ino, err);
      	}
70:  4e19c5a99fd721 ! 72:  d6a2e3be991671 fuse4fs: use the orphaned inode list
    @@ fuse4fs/fuse4fs.c: static int fuse4fs_open_file(struct fuse4fs *ff, const struct
      
      	file->check_flags = check;
      	fuse4fs_set_handle(fp, file);
     +	dbg_printf(ff, "%s: ino=%d fh=%p opencount=%d\n", __func__, ino, file,
     +		   file->fi->i_open_count);
      
    - out:
    - 	if (ret)
    - 		ext2fs_free_mem(&file);
    - 	return ret;
    - }
    + 	/* fuse 2.4: do not purge pagecache on open */
    + 	fp->keep_cache = 1;
    + #ifdef HAVE_FUSE_CACHE_READDIR
    + 	/* fuse 3.5: cache dirents from readdir contents */
    + 	fp->cache_readdir = 1;
     @@ fuse4fs/fuse4fs.c: static void op_open(fuse_req_t req, fuse_ino_t fino, struct fuse_file_info *fp)
      	struct fuse4fs *ff = fuse4fs_get(req);
      	ext2_ino_t ino;
      	int ret;
      
      	FUSE4FS_CHECK_CONTEXT(req);
71:  1ec06be479c7ce = 73:  2a4c9c2e579556 fuse4fs: implement FUSE_TMPFILE
72:  489d5de33dcf64 = 74:  38cd25631692e6 fuse4fs: create incore reverse orphan list
