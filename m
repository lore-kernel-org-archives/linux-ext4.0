From: Tony Breeds <tony@bakeyournoodle.com>
Subject: Re: Minimal configuration for e2fsprogs
Date: Tue, 19 Jun 2012 15:48:10 +1000
Message-ID: <20120619054751.GA2660@thor.bakeyournoodle.com>
References: <20120615042421.GA7021@thor.bakeyournoodle.com>
 <20120616000825.GE7363@thunk.org>
 <20120618055836.GA30557@thor.bakeyournoodle.com>
 <20120618171257.GA16017@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="9zSXsLTf0vkW971A"
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:54503 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab2FSFsT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jun 2012 01:48:19 -0400
Content-Disposition: inline
In-Reply-To: <20120618171257.GA16017@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--9zSXsLTf0vkW971A
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 18, 2012 at 01:12:57PM -0400, Ted Ts'o wrote:
> On Mon, Jun 18, 2012 at 03:58:42PM +1000, Tony Breeds wrote:
> >=20
> > I'm not certain we're on the same page.  We're linking statically so
> > that fact we don't call the progress functions doesn't matter.  The
> > code is in libext2fs.a and there must be a call path from (eg)
> > ext2fs_open() to fwrite(stderr, ...).  The fact we don't add the=20
> > EXT2_FLAG_PRINT_PROGRESS doesn't come into it does it?
>=20
> Oh, I see, the problem is that ext2fs_closefs() is calling the
> progress functions; I had forgotten about it.  Yeah, that's something
> I can fix so that the progress functions are only dragged in if mke2fs
> explicitly requests it, via adding function which enables the progress
> functions, instead of just setting the EXT2_FLAG_PRINT_PROGRESS.

Okay that sounds good to me.  If I get the other bits implemented
before you get to it.  I'm happy to take a run at it.
=20
> So a couple of things; it's a really bad to define static functions in
> a header file such as ext2fs.h.  Yes, gcc will normally optimize out
> functions which aren't used, but it will also complain with warnings
> if you enable them.

Thanks for the pointers.  I had meant to make them static inline I just
forgot the inline.
=20
> Instead, what I would do is to simply take out the calls to the
> ext2fs_mmp library functions in e2fsck and tune2fs, and remove the MMP
> feature flag from the list of supported features.  That way, if
> someone tries to use the e2fsck binary compiled with --disable-mmp on
> a file system with MMP enabled, e2fsck will refuse to touch the file
> system saying that it doesn't support the feature.  If you just make
> the mmp functions silently succeed (by returning 0), that's really bad
> since file system damage could result.

Okay that all make sense I've had a try but I think it's pretty brutal.
I'm sure I could finesse it a bit but I have a couple of questions:

1) The only way I could see to remove MMP from the supported features
was with something like:

#ifdef CONFIG_MMP
#define EXT2_LIB_FEATURE_INCOMPAT_SUPP (...|EXT4_FEATURE_INCOMPAT_MMP|...)
#else
#define EXT2_LIB_FEATURE_INCOMPAT_SUPP (...)
#endif

But EXT2_LIB_FEATURE_INCOMPAT_SUPP is already #defined twice depending
on the state of ENABLE_COMPRESSION.  So going down the path above would
mean #defining it 4 times which I'd think is starting to indicate there
must be a better way.  Firstly am I in the right ball park, secondly
Would something like

#ifdef ENABLE_COMPRESSION
=2E..
#define _EXT4_FEATURE_INCOMPAT_COMPRESSION EXT4_FEATURE_INCOMPAT_COMPRESSION
#else
#define _EXT4_FEATURE_INCOMPAT_COMPRESSION (0)
#endif

#ifdef ENABLE_MMP
=2E..
#define _EXT4_FEATURE_INCOMPAT_MMP EXT4_FEATURE_INCOMPAT_MMP
#else
#define _EXT4_FEATURE_INCOMPAT_MMP (0)
#endif

#define EXT2_LIB_FEATURE_INCOMPAT_SUPP  (...\
                                         _EXT2_FEATURE_INCOMPAT_COMPRESSION=
|\
                                         ... \
                                         _EXT4_FEATURE_INCOMPAT_MMP|\
                                         ...)

Be acceptable?

2) in debugfs you have a command table (debug_cmds.ct or similar) there
doesn't seem to be a way to exclude commands based on the state of
CONFIG_MMP.  Is it a problem the expose a debugfs command that will do
nothing when built with --disable-mmp, or should I look at extending
the command table generator to support the conditionals?

I'll add my current patch after my .signature

> I already have things set up so that if you don't actually call the
> functions to read in the bitmaps, the functions to read and write the
> bitmaps don't get dragged into a static library link.  That's what I'm
> referring to.

Ahh thanks for the clarification.
=20
> The functions to actually create in-memory bitmaps for various
> housekeeping things, do need to get dragged in, but we don't
> necessarily need to drag in all of the different bitmap back-ends.  If
> we assume that yaboot doesn't need to optimize for low-memory usage
> for really, really big file systems (i.e., you're not going to try to
> allocate files or blocks while opening a multi-terrabyte file system
> using libext2fs on a system with only 512mb), then you wouldn't need
> blkmap64_rb.c.

Right, we're operating in a pretty tight memory environment (typically
128MB or 256MB) but we're also usually opening file-systems <100GB
usually closer to 200MB.
=20
> And the bitmap statistics functions are sometihng we can use a
> configure option to disable, which should remove the last bits of
> stdio usage I believe.

Okay.  If I can get the disable-mmp patch into a state you like it I'll
tackle that configure option as well.

> If you'd like to try to clean up the --disable-mmp patch, and perhaps
> try your hand at a --disable-libext2fs-stats patch which disable the
> statistics options, that would be great.  Otherwise, I'll try to get
> to it in the next few weeks.

I really appreciate you help and time, and hope that continually
pointing me in the right direction isn't too taxing on you.

Yours Tony

---
 configure.in           |   21 +++++++++++++++++++++
 debugfs/debugfs.c      |    2 ++
 debugfs/set_fields.c   |    9 +++++++++
 e2fsck/journal.c       |    2 ++
 e2fsck/unix.c          |    4 ++++
 e2fsck/util.c          |    6 ++++++
 lib/config.h.in        |    3 +++
 lib/ext2fs/Makefile.in |    4 ++--
 lib/ext2fs/closefs.c   |    2 ++
 lib/ext2fs/ext2fs.h    |    2 ++
 lib/ext2fs/openfs.c    |    2 ++
 misc/mke2fs.c          |    2 ++
 misc/tune2fs.c         |    6 ++++++
 13 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/configure.in b/configure.in
index 7373e8e..4bacd1a 100644
--- a/configure.in
+++ b/configure.in
@@ -746,6 +746,27 @@ AC_MSG_RESULT([Building uuidd by default])
 )
 AC_SUBST(UUIDD_CMT)
 dnl
+dnl handle --disable-mmp
+dnl
+AH_TEMPLATE([CONFIG_MMP], [Define to 1 to enable mmp support])
+AC_ARG_ENABLE([mmp],
+[  --disable-mmp   	  disable support mmp, Multi Mount Protection],
+if test "$enableval" =3D "no"
+then
+	AC_MSG_RESULT([Disabling mmp support])
+	MMP_CMT=3D"#"
+else
+	AC_MSG_RESULT([Enabling mmp support])
+	AC_DEFINE(CONFIG_MMP, 1)
+	MMP_CMT=3D
+fi
+,
+AC_MSG_RESULT([Enabling mmp support by default])
+AC_DEFINE(CONFIG_MMP, 1)
+MMP_CMT=3D
+)
+AC_SUBST(MMP_CMT)
+dnl
 dnl
 dnl
 MAKEFILE_LIBRARY=3D$srcdir/lib/Makefile.library
diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index cf80bd0..5df915e 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -2194,6 +2194,7 @@ void do_punch(int argc, char *argv[])
=20
 void do_dump_mmp(int argc EXT2FS_ATTR((unused)), char *argv[])
 {
+#ifdef CONFIG_MMP
 	struct ext2_super_block *sb;
 	struct mmp_struct *mmp_s;
 	time_t t;
@@ -2237,6 +2238,7 @@ void do_dump_mmp(int argc EXT2FS_ATTR((unused)), char=
 *argv[])
 	fprintf(stdout, "node_name: %s\n", mmp_s->mmp_nodename);
 	fprintf(stdout, "device_name: %s\n", mmp_s->mmp_bdevname);
 	fprintf(stdout, "magic: 0x%x\n", mmp_s->mmp_magic);
+#endif
 }
=20
 static int source_file(const char *cmd_file, int sci_idx)
diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index 08bfd8d..77fbbc1 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -69,8 +69,10 @@ static errcode_t parse_hashalg(struct field_set_info *in=
fo, char *field, char *a
 static errcode_t parse_time(struct field_set_info *info, char *field, char=
 *arg);
 static errcode_t parse_bmap(struct field_set_info *info, char *field, char=
 *arg);
 static errcode_t parse_gd_csum(struct field_set_info *info, char *field, c=
har *arg);
+#ifdef CONFIG_MMP
 static errcode_t parse_mmp_clear(struct field_set_info *info, char *field,
 				 char *arg);
+#endif
=20
 static struct field_set_info super_fields[] =3D {
 	{ "inodes_count", &set_sb.s_inodes_count, NULL, 4, parse_uint },
@@ -246,6 +248,7 @@ static struct field_set_info ext4_bg_fields[] =3D {
 };
=20
 static struct field_set_info mmp_fields[] =3D {
+#ifdef CONFIG_MMP
 	{ "clear", &set_mmp.mmp_magic, NULL, sizeof(set_mmp), parse_mmp_clear },
 	{ "magic", &set_mmp.mmp_magic, NULL, 4, parse_uint },
 	{ "seq", &set_mmp.mmp_seq, NULL, 4, parse_uint },
@@ -255,6 +258,8 @@ static struct field_set_info mmp_fields[] =3D {
 	{ "bdevname", &set_mmp.mmp_bdevname, NULL, sizeof(set_mmp.mmp_bdevname),
 		parse_string },
 	{ "check_interval", &set_mmp.mmp_check_interval, NULL, 2, parse_uint },
+#endif
+	{ 0, 0, 0, 0 }
 };
=20
 static int check_suffix(const char *field)
@@ -748,6 +753,7 @@ void do_set_block_group_descriptor(int argc, char *argv=
[])
 	}
 }
=20
+#ifdef CONFIG
 static errcode_t parse_mmp_clear(struct field_set_info *info,
 				 char *field EXT2FS_ATTR((unused)),
 				 char *arg EXT2FS_ATTR((unused)))
@@ -762,9 +768,11 @@ static errcode_t parse_mmp_clear(struct field_set_info=
 *info,
=20
 	return 1; /* we don't need the MMP block written again */
 }
+#endif
=20
 void do_set_mmp_value(int argc, char *argv[])
 {
+#ifdef CONFIG_MMP
 	const char *usage =3D "<field> <value>\n"
 		"\t\"set_mmp_value -l\" will list the names of "
 		"MMP fields\n\twhich can be set.";
@@ -819,5 +827,6 @@ void do_set_mmp_value(int argc, char *argv[])
 				 &set_mmp);
 		*mmp_s =3D set_mmp;
 	}
+#endif
 }
=20
diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 767ea10..e5ee4ed 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -889,7 +889,9 @@ int e2fsck_run_ext3_journal(e2fsck_t ctx)
 	if (stats && stats->bytes_written)
 		kbytes_written =3D stats->bytes_written >> 10;
=20
+#ifdef CONFIG_MMP
 	ext2fs_mmp_stop(ctx->fs);
+#endif
 	ext2fs_free(ctx->fs);
 	retval =3D ext2fs_open(ctx->filesystem_name, EXT2_FLAG_RW,
 			     ctx->superblock, blocksize, io_ptr,
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 94260bd..6cca9e0 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1042,6 +1042,7 @@ static const char *my_ver_date =3D E2FSPROGS_DATE;
=20
 static int e2fsck_check_mmp(ext2_filsys fs, e2fsck_t ctx)
 {
+#ifdef CONFIG_MMP
 	struct mmp_struct *mmp_s;
 	unsigned int mmp_check_interval;
 	errcode_t retval =3D 0;
@@ -1120,6 +1121,9 @@ check_error:
 		}
 	}
 	return retval;
+#else
+	return 0;
+#endif
 }
=20
 int main (int argc, char *argv[])
diff --git a/e2fsck/util.c b/e2fsck/util.c
index 7c4caab..5b9b154 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -56,7 +56,9 @@ void fatal_error(e2fsck_t ctx, const char *msg)
 	if (!fs)
 		goto out;
 	if (fs->io) {
+#ifdef CONFIG_MMP
 		ext2fs_mmp_stop(ctx->fs);
+#endif
 		if (ctx->fs->io->magic =3D=3D EXT2_ET_MAGIC_IO_CHANNEL)
 			io_channel_flush(ctx->fs->io);
 		else
@@ -780,6 +782,7 @@ void dump_mmp_msg(struct mmp_struct *mmp, const char *m=
sg)
=20
 errcode_t e2fsck_mmp_update(ext2_filsys fs)
 {
+#ifdef CONFIF_MMP
 	errcode_t retval;
=20
 	retval =3D ext2fs_mmp_update(fs);
@@ -789,6 +792,9 @@ errcode_t e2fsck_mmp_update(ext2_filsys fs)
 			       "being modified while fsck is running.\n"));
=20
 	return retval;
+#else
+	return 0;
+#endif
 }
=20
 void e2fsck_set_bitmap_type(ext2_filsys fs, unsigned int default_type,
diff --git a/lib/config.h.in b/lib/config.h.in
index 90e9743..52c3897 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -12,6 +12,9 @@
 /* Define to 1 if debugging ext3/4 journal code */
 #undef CONFIG_JBD_DEBUG
=20
+/* Define to 1 to enable mmp support */
+#undef CONFIG_MMP
+
 /* Define to 1 to enable quota support */
 #undef CONFIG_QUOTA
=20
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 0d9ac21..5b73958 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -14,9 +14,10 @@ MK_CMDS=3D	_SS_DIR_OVERRIDE=3D../ss ../ss/mk_cmds
 @RESIZER_CMT@RESIZE_LIB_OBJS =3D dupfs.o
 @TEST_IO_CMT@TEST_IO_LIB_OBJS =3D test_io.o
 @IMAGER_CMT@E2IMAGE_LIB_OBJS =3D imager.o
+@MMP_CMT@MMP_OBJS =3D mmp.o
=20
 OBJS=3D $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
-	$(TEST_IO_LIB_OBJS) \
+	$(TEST_IO_LIB_OBJS) $(MMP_OBJS) \
 	ext2_err.o \
 	alloc.o \
 	alloc_sb.o \
@@ -66,7 +67,6 @@ OBJS=3D $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_=
LIB_OBJS) \
 	lookup.o \
 	mkdir.o \
 	mkjournal.o \
-	mmp.o \
 	namei.o \
 	native.o \
 	newdir.o \
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 973c2a2..abf77cc 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -464,9 +464,11 @@ errcode_t ext2fs_close2(ext2_filsys fs, int flags)
 			return retval;
 	}
=20
+#ifdef CONFIG_MMP
 	retval =3D ext2fs_mmp_stop(fs);
 	if (retval)
 		return retval;
+#endif
=20
 	ext2fs_free(fs);
 	return 0;
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index ff088bb..fc83973 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1366,6 +1366,7 @@ errcode_t ext2fs_unlink(ext2_filsys fs, ext2_ino_t di=
r, const char *name,
 			ext2_ino_t ino, int flags);
=20
 /* mmp.c */
+#ifdef CONFIG_MMP
 errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf);
 errcode_t ext2fs_mmp_write(ext2_filsys fs, blk64_t mmp_blk, void *buf);
 errcode_t ext2fs_mmp_clear(ext2_filsys fs);
@@ -1374,6 +1375,7 @@ errcode_t ext2fs_mmp_start(ext2_filsys fs);
 errcode_t ext2fs_mmp_update(ext2_filsys fs);
 errcode_t ext2fs_mmp_stop(ext2_filsys fs);
 unsigned ext2fs_mmp_new_seq(void);
+#endif /* CONFIG_MMP */
=20
 /* read_bb.c */
 extern errcode_t ext2fs_read_bb_inode(ext2_filsys fs,
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 482e4ab..88fdd4d 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -391,6 +391,7 @@ errcode_t ext2fs_open2(const char *name, const char *io=
_options,
 	fs->flags &=3D ~EXT2_FLAG_NOFREE_ON_ERROR;
 	*ret_fs =3D fs;
=20
+#ifdef CONFIG_MMP
 	if ((fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) &&
 	    !(flags & EXT2_FLAG_SKIP_MMP) &&
 	    (flags & (EXT2_FLAG_RW | EXT2_FLAG_EXCLUSIVE))) {
@@ -401,6 +402,7 @@ errcode_t ext2fs_open2(const char *name, const char *io=
_options,
 			goto cleanup;
 		}
 	}
+#endif
=20
 	return 0;
 cleanup:
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 7ec8cc2..e9b4c1f 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2557,6 +2557,7 @@ int main (int argc, char *argv[])
 			printf(_("done\n"));
 	}
 no_journal:
+#ifdef CONFIG_MMP
 	if (!super_only &&
 	    fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) {
 		retval =3D ext2fs_mmp_init(fs);
@@ -2570,6 +2571,7 @@ no_journal:
 				 "with update interval %d seconds.\n"),
 			       fs->super->s_mmp_update_interval);
 	}
+#endif
=20
 	if (EXT2_HAS_RO_COMPAT_FEATURE(&fs_param,
 				       EXT4_FEATURE_RO_COMPAT_BIGALLOC))
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index f1f0bcf..2c4b20b 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -430,6 +430,7 @@ static int update_feature_set(ext2_filsys fs, char *fea=
tures)
 				return 1;
 		}
 	}
+#ifdef CONFIG_MMP
 	if (FEATURE_ON(E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_MMP)) {
 		int error;
=20
@@ -495,6 +496,7 @@ mmp_error:
 		sb->s_mmp_block =3D 0;
 		sb->s_mmp_update_interval =3D 0;
 	}
+#endif
=20
 	if (FEATURE_ON(E2P_FEATURE_COMPAT, EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
 		/*
@@ -2105,10 +2107,12 @@ retry_open:
 			goto closefs;
 		}
 	}
+#ifdef CONFIG_MMP
 	if (clear_mmp) {
 		rc =3D ext2fs_mmp_clear(fs);
 		goto closefs;
 	}
+#endif
 	if (journal_size || journal_device) {
 		rc =3D add_journal(fs);
 		if (rc)
@@ -2219,7 +2223,9 @@ retry_open:
=20
 closefs:
 	if (rc) {
+#ifdef CONFIG_MMP
 		ext2fs_mmp_stop(fs);
+#endif
 		exit(1);
 	}
=20
--=20
1.7.6.4


--9zSXsLTf0vkW971A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP4BKaAAoJEEsCiJRY75GKymEP/RH27h0z/KCck8AmsmaVbsz2
xRZTA8Lcnm5jKUJ10fNCbsAVIaOSZTnJR6GvBO9r6t2tjfbVnMRV+i1I2DgZTPhM
DLiyqPOAUlRHh9YB7Xt2RIGC9VSVz7UUNO67oiKCaccz8xWHX1CJbP9wSxmamZh4
IsuWzsOGkxNYiw4esXZsWAoE+Qr0Y/TpHUcAyFjaX/Az2+RvJvszLO+xTrqolE1f
TKE4klt6uwR3fnYEUL/i3LYVfV3Ywy1nI4V7V44Vo6bKTLjXJ3bVPI0VNEwyKbrv
iCDdlgwKJDL0JhFpayC5AIMQ8IvJ5E8lAqi1vCwVigpKGIBEpNEeQR8YlehwiwCR
7lWCidOjNz6je1sTCuFoS0FaVMFuHk8z4u6VhCTscqCWTH5vKn4MR5h8fxuHoKxM
g3HvGdECrw/V/sXgk88I7pY/B2wh7/Rtd105OGCLG0g5aUgm/DTasjbyZ3ldKNFq
3J0IHer0yhGSLrreGT66Q+cMrmQeg8NIlXvJ4MCf03pOcR5dNA9eaWgLSGLjFDc2
e+1TedJzq6PpIqAARiR8QpUjyONjyVuFnhZqCg4Mrpp3jBMWe0uI1GCs6wHrks8K
ZjEBffR5gRfSLSP5aHc4MXR871L4FB5K1Z0/cXnO0KXv/+HuSNQvNalIVMYQGpy3
vLbJDOzzFbYrpA7RFz+u
=t//Q
-----END PGP SIGNATURE-----

--9zSXsLTf0vkW971A--
