From: Tony Breeds <tony@bakeyournoodle.com>
Subject: Re: Minimal configuration for e2fsprogs
Date: Wed, 20 Jun 2012 15:26:05 +1000
Message-ID: <20120620052604.GB11330@thor.bakeyournoodle.com>
References: <20120615042421.GA7021@thor.bakeyournoodle.com>
 <20120616000825.GE7363@thunk.org>
 <20120618055836.GA30557@thor.bakeyournoodle.com>
 <20120618171257.GA16017@thunk.org>
 <20120619054751.GA2660@thor.bakeyournoodle.com>
 <86585638-21F5-4FEE-9313-28AC122FCCEE@dilger.ca>
 <20120619135610.GA10637@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="A6N2fC+uXW/VQSAv"
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:42984 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975Ab2FTF0K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Jun 2012 01:26:10 -0400
Content-Disposition: inline
In-Reply-To: <20120619135610.GA10637@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 19, 2012 at 09:56:10AM -0400, Ted Ts'o wrote:
> On Tue, Jun 19, 2012 at 12:01:54AM -0600, Andreas Dilger wrote:
> >=20
> > That is what I would do, though perhaps with macro names that are not
> > so confusingly similar to the actual macro names, which might otherwise
> > cause confusion if someone doesn't read the code very closely.  Like:
> >=20
> > #ifdef ENABLE_MMP
> > ...
> > #define EXT2_LIB_INCOMPAT_SUPP_MMP EXT4_FEATURE_INCOMPAT_MMP
> > #else
> > #define EXT2_LIB_INCOMPAT_SUPP_MMP (0)
> > #endif
>=20
> either name is fine with me; I'm not particularly picky here, since
> the only place the #define would get used is the header file, the
> opportunities for confusion are pretty limited.

Okay.  As I said to Andreas we could #undef them once we're done with
them.
=20
> > > 2) in debugfs you have a command table (debug_cmds.ct or similar) the=
re
> > > doesn't seem to be a way to exclude commands based on the state of
> > > CONFIG_MMP.  Is it a problem the expose a debugfs command that will do
> > > nothing when built with --disable-mmp, or should I look at extending
> > > the command table generator to support the conditionals?
>=20
> I'd have it print an error of some kind, i.e., "MMP not supported"

Okay done.

<snip>

> If we've removed MMP from the list of supported features, a much
> simpler thing we can do is to just add at the beginning of each of the
> functions in mmp.c:
>=20
> #ifndef CONFIG_MMP
> 	return EXT2_ET_OP_NOT_SUPPORTED;
> #endif
>=20
> and then letting the compiler optimize out the rest of the code in the
> function; I wouldn't worry about using static inlines, since it's not
> something we really need to optimize in this case.  The mmp functions
> don't get called all that often anyway.
>=20
> I also wouldn't bother commenting out the function signatures in
> ext2fs.h.  For programs which are including ext2fs.h, they're not
> going to be including the config.h which has CONFIG_* or ENABLE_*
> autoconf #defines anyway.

Okay all taken on board.
=20
> Arguably all of the EXT2_LIB_* defines shouldn't be in ext2fs.h for
> that reason; they should be in ext2fsP.h, and the only reason why they
> aren't is due to history (since we didn't have ext2fsP.h when they
> were first introduced).  At some point I'll probably move that logic
> into ext2fsP.h, just to keep ext2fs.h smaller/cleaner for application
> programs.
>=20
> Regards,
>=20
> 						- Ted
>=20
> P.S.  I'm debating whether or not it makes sense to create a special
> static library just for bootloaders which is stripped down and
> read-only.  I realized while looking at things that there is a pretty
> large amount of coding getting dragged in due to namei.c pulling in
> dir_iterate.c pulling in block_iterate.c pulling in extent.c, which
> then pulls in a lot of code since we might need to allocate or
> deallocate blocks.  If we made a read-only variant of the library, it
> could significantly reduce the size of the statically linked
> bootloader.  I'm not entirely sure it's worth it, since you don't seem
> to be worrying about the compiled binary size of yaboot, but it's
> something we could do if it was interesting.  What do you think?

Well that does seem to be a lot of work.  Yaboot isn't really too worried
about code size and I worry that yaboot's requirements from this library
would probably be different to another boot loaders.

For example I know that grub2 can boot from a Fibre Channel device so
right off the bat MMP might be something they want.

I guess that means it's something that needs a reasonable amount of
thought.

Below is my "v3" of the patch.  It's only been tested by building
=2E/configure && make install install-libs  && (cd ~/yaboot && make)
=2E/configure --enable-mmp && make install install-libs  && (cd ~/yaboot &&=
 make)
=2E/configure --disable-mmp && make install install-libs  && (cd ~/yaboot &=
& make)

and the yaboot link behaves as expected.

=46rom my point of view I'd need to submit the changes in behavior of
ENABLE_COMPRESSION as one patch so that we stick with the one patch one
logical change approach.  For the sake of review/feedback it's a single
patch.

Yours Tony


=46rom 5f6a6528c93ad9b3eb878afbeab10c01802647b0 Mon Sep 17 00:00:00 2001
=46rom: Tony Breeds <tony@bakeyournoodle.com>
Date: Wed, 20 Jun 2012 15:04:43 +1000
Subject: [PATCH] WiP: Add --disable-mmp

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
---
 configure.in         |   17 +++++++++++++++++
 debugfs/debugfs.c    |    5 +++++
 debugfs/set_fields.c |    5 +++++
 lib/config.h.in      |    3 +++
 lib/ext2fs/ext2fs.h  |   23 ++++++++++++-----------
 lib/ext2fs/mmp.c     |   24 ++++++++++++++++++++++++
 6 files changed, 66 insertions(+), 11 deletions(-)

diff --git a/configure.in b/configure.in
index 7373e8e..a02234d 100644
--- a/configure.in
+++ b/configure.in
@@ -746,6 +746,23 @@ AC_MSG_RESULT([Building uuidd by default])
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
+else
+	AC_MSG_RESULT([Enabling mmp support])
+	AC_DEFINE(CONFIG_MMP, 1)
+fi
+,
+AC_MSG_RESULT([Enabling mmp support by default])
+AC_DEFINE(CONFIG_MMP, 1)
+)
+dnl
 dnl
 dnl
 MAKEFILE_LIBRARY=3D$srcdir/lib/Makefile.library
diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index cf80bd0..0c27b1e 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -2194,6 +2194,7 @@ void do_punch(int argc, char *argv[])
=20
 void do_dump_mmp(int argc EXT2FS_ATTR((unused)), char *argv[])
 {
+#if CONFIG_MMP
 	struct ext2_super_block *sb;
 	struct mmp_struct *mmp_s;
 	time_t t;
@@ -2237,6 +2238,10 @@ void do_dump_mmp(int argc EXT2FS_ATTR((unused)), cha=
r *argv[])
 	fprintf(stdout, "node_name: %s\n", mmp_s->mmp_nodename);
 	fprintf(stdout, "device_name: %s\n", mmp_s->mmp_bdevname);
 	fprintf(stdout, "magic: 0x%x\n", mmp_s->mmp_magic);
+#else
+	fprintf(stdout, "MMP is unsupported, please recompile with "
+	                "--enable-mmp\n");
+#endif
 }
=20
 static int source_file(const char *cmd_file, int sci_idx)
diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index 08bfd8d..a42faa2 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -765,6 +765,7 @@ static errcode_t parse_mmp_clear(struct field_set_info =
*info,
=20
 void do_set_mmp_value(int argc, char *argv[])
 {
+#ifdef CONFIG_MMP
 	const char *usage =3D "<field> <value>\n"
 		"\t\"set_mmp_value -l\" will list the names of "
 		"MMP fields\n\twhich can be set.";
@@ -819,5 +820,9 @@ void do_set_mmp_value(int argc, char *argv[])
 				 &set_mmp);
 		*mmp_s =3D set_mmp;
 	}
+#else
+	fprintf(stdout, "MMP is unsupported, please recompile with "
+	                "--enable-mmp\n");
+#endif
 }
=20
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
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index ff088bb..542b20f 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -554,25 +554,26 @@ typedef struct ext2_icount *ext2_icount_t;
    environment at configure time. */
  #warning "Compression support is experimental"
 #endif
-#define EXT2_LIB_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
-					 EXT2_FEATURE_INCOMPAT_COMPRESSION|\
-					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
-					 EXT2_FEATURE_INCOMPAT_META_BG|\
-					 EXT3_FEATURE_INCOMPAT_RECOVER|\
-					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
-					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
-					 EXT4_FEATURE_INCOMPAT_MMP|\
-					 EXT4_FEATURE_INCOMPAT_64BIT)
+#define EXT2_LIB_INCOMPAT_COMPRESSION	EXT2_FEATURE_INCOMPAT_COMPRESSION
 #else
+#define EXT2_LIB_INCOMPAT_COMPRESSION	(0)
+#endif
+
+#ifdef CONFIG_MMP
+#define EXT4_LIB_INCOMPAT_MMP		EXT4_FEATURE_INCOMPAT_MMP
+#else
+#define EXT4_LIB_INCOMPAT_MMP		(0)
+#endif
+
 #define EXT2_LIB_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
+					 EXT2_LIB_INCOMPAT_COMPRESSION|\
 					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
 					 EXT2_FEATURE_INCOMPAT_META_BG|\
 					 EXT3_FEATURE_INCOMPAT_RECOVER|\
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
-					 EXT4_FEATURE_INCOMPAT_MMP|\
+					 EXT4_LIB_INCOMPAT_MMP|\
 					 EXT4_FEATURE_INCOMPAT_64BIT)
-#endif
 #ifdef CONFIG_QUOTA
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUP=
ER|\
 					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\
diff --git a/lib/ext2fs/mmp.c b/lib/ext2fs/mmp.c
index bb3772d..a783698 100644
--- a/lib/ext2fs/mmp.c
+++ b/lib/ext2fs/mmp.c
@@ -33,6 +33,9 @@
=20
 errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf)
 {
+#ifndef CONFIG_MMP
+	return EXT2_ET_OP_NOT_SUPPORTED;
+#endif
 	struct mmp_struct *mmp_cmp;
 	errcode_t retval =3D 0;
=20
@@ -92,6 +95,9 @@ out:
=20
 errcode_t ext2fs_mmp_write(ext2_filsys fs, blk64_t mmp_blk, void *buf)
 {
+#ifndef CONFIG_MMP
+	return EXT2_ET_OP_NOT_SUPPORTED;
+#endif
 	struct mmp_struct *mmp_s =3D buf;
 	struct timeval tv;
 	errcode_t retval =3D 0;
@@ -128,6 +134,9 @@ errcode_t ext2fs_mmp_write(ext2_filsys fs, blk64_t mmp_=
blk, void *buf)
=20
 unsigned ext2fs_mmp_new_seq()
 {
+#ifndef CONFIG_MMP
+	return EXT2_ET_OP_NOT_SUPPORTED;
+#endif
 	unsigned new_seq;
 	struct timeval tv;
=20
@@ -182,6 +191,9 @@ out:
=20
 errcode_t ext2fs_mmp_clear(ext2_filsys fs)
 {
+#ifndef CONFIG_MMP
+	return EXT2_ET_OP_NOT_SUPPORTED;
+#endif
 	errcode_t retval =3D 0;
=20
 	if (!(fs->flags & EXT2_FLAG_RW))
@@ -194,6 +206,9 @@ errcode_t ext2fs_mmp_clear(ext2_filsys fs)
=20
 errcode_t ext2fs_mmp_init(ext2_filsys fs)
 {
+#ifndef CONFIG_MMP
+	return EXT2_ET_OP_NOT_SUPPORTED;
+#endif
 	struct ext2_super_block *sb =3D fs->super;
 	blk64_t mmp_block;
 	errcode_t retval;
@@ -229,6 +244,9 @@ out:
  */
 errcode_t ext2fs_mmp_start(ext2_filsys fs)
 {
+#ifndef CONFIG_MMP
+	return EXT2_ET_OP_NOT_SUPPORTED;
+#endif
 	struct mmp_struct *mmp_s;
 	unsigned seq;
 	unsigned int mmp_check_interval;
@@ -328,6 +346,9 @@ mmp_error:
  */
 errcode_t ext2fs_mmp_stop(ext2_filsys fs)
 {
+#ifndef CONFIG_MMP
+	return EXT2_ET_OP_NOT_SUPPORTED;
+#endif
 	struct mmp_struct *mmp, *mmp_cmp;
 	errcode_t retval =3D 0;
=20
@@ -366,6 +387,9 @@ mmp_error:
  */
 errcode_t ext2fs_mmp_update(ext2_filsys fs)
 {
+#ifndef CONFIG_MMP
+	return EXT2_ET_OP_NOT_SUPPORTED;
+#endif
 	struct mmp_struct *mmp, *mmp_cmp;
 	struct timeval tv;
 	errcode_t retval =3D 0;
--=20
1.7.6.4


--A6N2fC+uXW/VQSAv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP4V7sAAoJEEsCiJRY75GKMoQQAL4ZsZDIl9iGRNmcdTzLFqSF
l3zZBQ/Ck/xEjmEUDvaqx2hQ2+aIgfLH0jdnes4RMl1ZutUtxrq14/xNAaorBN8P
/40MBuVKSle2SaYZCVOpTImDAfQZ6HFN9AAdw00l3L48g4kjwLucLGonRCJXpeN0
u8E0mTDs7i6XFAP72c4//KruGAqZggFn05WFo/LD9DyxiKMdKTwRXjjER1E0JXj8
tHNq4EuQC6HFmiOhpNJ7oudb+MLtKs22dj5b/h8/8prTB5dPua5NB+/wtGrx73aA
xn9B7jWYQvDZsSRhmObTiBoJatXAdalTZKKGXqEVyMuyANZ1IJjKjloU1/l9g2LP
hXWyeuYEaiGNx/r68aft8z1f1dvS1To2QHQLBJ0+mIaZ01ri6ClQvt430GWSBjku
Auj2FjFM0U+cnqL88/hSbWoXLXHjS6n8CGsuYHyk957NZUfAuSeRNxdxk2jkr+uY
NEg7bxmblKJkMHUS/3IHum3aBbwJFHvwGgAkQB0wwoVcpdNSw/2YtUp4WbxrjGXF
CbhdXZMKse0h4nMSEQCIVtMNNQ7QtDedi8eu2ZaMayqW/E7r7RzjOV5CtkBdIm/V
6Kzdm8ziG7D7lRSgGGR1kvNsP7w6giIuskTrl55VsL3bymJK5056/cQMV8zoLyOT
WyNtT/IZL+NxqRElWVee
=Gm7u
-----END PGP SIGNATURE-----

--A6N2fC+uXW/VQSAv--
