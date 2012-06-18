From: Tony Breeds <tony@bakeyournoodle.com>
Subject: Re: Minimal configuration for e2fsprogs
Date: Mon, 18 Jun 2012 15:58:42 +1000
Message-ID: <20120618055836.GA30557@thor.bakeyournoodle.com>
References: <20120615042421.GA7021@thor.bakeyournoodle.com>
 <20120616000825.GE7363@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:53074 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308Ab2FRF6u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Jun 2012 01:58:50 -0400
Content-Disposition: inline
In-Reply-To: <20120616000825.GE7363@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 15, 2012 at 08:08:25PM -0400, Ted Ts'o wrote:

> So I think you need to break your list a bit more.  There are a number
> of functions on this list where, if yaboot doesn't actually call a
> particular function (for example, the progess bar functions, in
> lib/ext2fs/progress.c), the fact that they reference the stdio
> functions won't matter.  Something similar will be going on with
> test_io.c; if you don't use those functions, you won't need to provide
> stubs for any of the libc functions called by them.

I'm not certain we're on the same page.  We're linking statically so
that fact we don't call the progress functions doesn't matter.  The
code is in libext2fs.a and there must be a call path from (eg)
ext2fs_open() to fwrite(stderr, ...).  The fact we don't add the=20
EXT2_FLAG_PRINT_PROGRESS doesn't come into it does it?

What have I misunderstood?

> There are some cases where we may need to create some configure
> options.  For example, there are a large number of the symbols that
> you have listed that got dragged in by the lib/ext2fs/mmp.c.  That's
> one where it may be simplest to add a set of #ifdef's that comment out
> multi-mount protection --- I assume you don't plan to support booting
> over fibre channel where you might need to care about having two
> systems trying to modify the same file system at the same time.  :-)

No we really don't need mmp :)  I can see creating --enable-mmp and
--disbale-mmp options for configure would be reasonable and not too
intrusive, and it gets rid of nearly 30% of the libc functions.

Something like this lightly tested patch:
---
diff --git a/MCONFIG.in b/MCONFIG.in
index fa2b03e..a0c828a 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -53,7 +53,7 @@ datadir =3D @datadir@
 CC =3D @CC@
 BUILD_CC =3D @BUILD_CC@
 CFLAGS =3D @CFLAGS@
-CPPFLAGS =3D @INCLUDES@
+CPPFLAGS =3D @INCLUDES@ $(ENABLE_MPP)
 ALL_CFLAGS =3D $(CPPFLAGS) $(CFLAGS)
 LDFLAGS =3D @LDFLAGS@
 ALL_LDFLAGS =3D $(LDFLAGS) @LDFLAG_DYNAMIC@
diff --git a/configure.in b/configure.in
index 7373e8e..f7562d3 100644
--- a/configure.in
+++ b/configure.in
@@ -746,6 +746,24 @@ AC_MSG_RESULT([Building uuidd by default])
 )
 AC_SUBST(UUIDD_CMT)
 dnl
+dnl handle --disable-mmp
+dnl
+AC_ARG_ENABLE([mmp],
+[  --disable-mmp   	  disable support mmp, Multi Mount Protection],
+if test "$enableval" =3D "no"
+then
+	AC_MSG_RESULT([Disabling mmp support])
+	MMP_CMT=3D"#"
+else
+	AC_MSG_RESULT([Enabling mmp support])
+	MMP_CMT=3D
+fi
+,
+AC_MSG_RESULT([Enabling mmp support by default])
+MMP_CMT=3D
+)
+AC_SUBST(MMP_CMT)
+dnl
 dnl
 dnl
 MAKEFILE_LIBRARY=3D$srcdir/lib/Makefile.library
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 0d9ac21..021f3b0 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -14,9 +14,11 @@ MK_CMDS=3D	_SS_DIR_OVERRIDE=3D../ss ../ss/mk_cmds
 @RESIZER_CMT@RESIZE_LIB_OBJS =3D dupfs.o
 @TEST_IO_CMT@TEST_IO_LIB_OBJS =3D test_io.o
 @IMAGER_CMT@E2IMAGE_LIB_OBJS =3D imager.o
+@MMP_CMT@MMP_OBJS =3D mmp.o
+@MMP_CMT@ENABLE_MMP =3D -DENABLE_MMP
=20
 OBJS=3D $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
-	$(TEST_IO_LIB_OBJS) \
+	$(TEST_IO_LIB_OBJS) $(MMP_OBJS) \
 	ext2_err.o \
 	alloc.o \
 	alloc_sb.o \
@@ -66,7 +68,6 @@ OBJS=3D $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_=
LIB_OBJS) \
 	lookup.o \
 	mkdir.o \
 	mkjournal.o \
-	mmp.o \
 	namei.o \
 	native.o \
 	newdir.o \
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index ff088bb..cfa8822 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1366,6 +1366,7 @@ errcode_t ext2fs_unlink(ext2_filsys fs, ext2_ino_t di=
r, const char *name,
 			ext2_ino_t ino, int flags);
=20
 /* mmp.c */
+#ifdef ENABLE_MMP
 errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf);
 errcode_t ext2fs_mmp_write(ext2_filsys fs, blk64_t mmp_blk, void *buf);
 errcode_t ext2fs_mmp_clear(ext2_filsys fs);
@@ -1374,6 +1375,22 @@ errcode_t ext2fs_mmp_start(ext2_filsys fs);
 errcode_t ext2fs_mmp_update(ext2_filsys fs);
 errcode_t ext2fs_mmp_stop(ext2_filsys fs);
 unsigned ext2fs_mmp_new_seq(void);
+#else
+static errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *bu=
f)
+{ return (errcode_t)0; }
+static errcode_t ext2fs_mmp_write(ext2_filsys fs, blk64_t mmp_blk, void *b=
uf)
+{ return (errcode_t)0; }
+static errcode_t ext2fs_mmp_clear(ext2_filsys fs)
+{ return (errcode_t)0; }
+static errcode_t ext2fs_mmp_init(ext2_filsys fs)
+{ return (errcode_t)0; }
+static errcode_t ext2fs_mmp_start(ext2_filsys fs)
+{ return (errcode_t)0; }
+static errcode_t ext2fs_mmp_update(ext2_filsys fs)
+{ return (errcode_t)0; }
+static errcode_t ext2fs_mmp_stop(ext2_filsys fs)
+{ return (unsigned)0; }
+#endif /* ENABLE_MMP */
=20
 /* read_bb.c */
 extern errcode_t ext2fs_read_bb_inode(ext2_filsys fs,
---

Feedback very welcome but if it looks okay I'll add my signed off and
resubmit with a reasonable commit message.
=20
> Which brings up another point --- are you only planning on opening the
> file system read-only, or do you expect to modify the file system from
> yaboot?  If you don't need to modify the file system, and so you don't
> need to load the bitmap manipulation functions, that will make a whole
> bunch more of the libc dependencies drop out.

Well currently we open it read-write but I cannot see a problem with
switching to read-only.  Based on my very limited understanding of
e2fsprogs it seems that disabling the bitmap functions is good for yaboot
it would result in a library that has pretty limited value to anyone
else.

A really ugly local hack to disbale the bitmap functions (along with the
patch above) results in calloc() being the only missing symbol.  Adding
calloc is probably a good idea anyway :)
=20
> So the bottom line is yes, I think we can do somethings to help you;
> but depending on which parts of the libext2fs functionality yaboot
> actually needs, it may not be as bad as you think, especially if you
> are willing to limit which libext2fs functions you call.

We're a very simple user.  We only support ext* on local disks so no
fibre channel or anything too fancy.

For the record we currently only call:
	ext2fs_open()
	ext2fs_namei_follow()
	ext2fs_follow_link()
	ext2fs_read_inode()
	ext2fs_close()
	ext2fs_block_iterate()
	ext2fs_bmap() # Actually we may not use this anymore=20

I'm also happy to rewrite the yaboot code for ext* if someone with
more knowledge can make a provide pointers.

I'd like to keep the headaches involved with using yaboot "small", so if
I can do a little extra work now to ensure that users not need to really
care what options (dir_index etc) the file-system is created with I'm
all for that.

Yours Tony

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP3sOMAAoJEEsCiJRY75GKyL4P/0CL1FilE+tD4jeYzcFzWvoH
yzJ4vZYR99pxIZp1nhWpGsjae9EkCLEwB0iy0fJEVWASWqtFRn+1gRZA9S9HIY1P
af66D8gWrWYawkN+4I3TO9r8rqC1Nd/ZYagZlcTdDMcH0Jz1ou4Tw39Nv0ak+rmZ
GC2nlkOp8IGN+LbcxLDpTNMjJCeN6NaNeERVf0ZXtTb3t4M3vGdPXPKcEOc+yRVJ
Jm7ym4579jVmXYOaRHWccYo2uOwKwl5NtV4ukS72cIkS0UGY11ApH7NI44VcoQug
cRWQI8Ulbw1Z3eza7LMp51d5UmIgpVU6ukUDW+LBESfnl6H1XECNfo8Wkp1nq4LA
LC6eAu9PNNCjSwo4uqxyEccVGxGfAUjP1BbberBkLr8I2fZIR9RAuL3OgfpCn4tG
YA2Znlg1ppPcZFr8ywcUGdAfO+kzVpjqgF1/csd1hXMfWewGe0MzTFn6+5vjj77n
Zu/Zs8twnaLIi5HScW3YU1LrlCQRyMiwcdltJwhfAYUdSIEoJnwd8OQCWZ780Beu
Opvkn8bvlcVdSkmc6Zogk4eb92D7SV//X2r3u3NvZkgdC8U1xFjxx1jeNqgKc0xp
uq2S08hv3nfp1NPDXyJaUZjXC8CA2L5m1aTWQvaj88tInQdsRQK2YWqc4DPPuZpy
LRfxEa08XByJS6BBe+J1
=pvHu
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
