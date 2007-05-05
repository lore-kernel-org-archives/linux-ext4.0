From: Dennis Gilmore <dennis@ausil.us>
Subject: PATCH: use CFLAGS when linking always
Date: Sat, 5 May 2007 09:20:47 -0500
Message-ID: <200705050920.56558.dennis@ausil.us>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3934245.N5Bl8ZHKCe";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from anubis.ausil.us ([216.75.14.43]:36119 "EHLO mail.ausil.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933859AbXEEQcR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 May 2007 12:32:17 -0400
Received: from localhost (unknown [127.0.0.1])
	by mail.ausil.us (Postfix) with ESMTP id 67E9E15803B
	for <linux-ext4@vger.kernel.org>; Sat,  5 May 2007 13:21:08 +0000 (UTC)
Received: from mail.ausil.us ([127.0.0.1])
	by localhost (anubis.ausil.us [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yxqs2nlb2sfD for <linux-ext4@vger.kernel.org>;
	Sat,  5 May 2007 06:21:06 -0700 (PDT)
Received: from bratac.ausil.us (74-135-67-221.dhcp.insightbb.com [74.135.67.221])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.ausil.us (Postfix) with ESMTP id 8ED35158031
	for <linux-ext4@vger.kernel.org>; Sat,  5 May 2007 06:21:06 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--nextPart3934245.N5Bl8ZHKCe
Content-Type: multipart/mixed;
  boundary="Boundary-01=_ALJPGy2hbPT0+jl"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_ALJPGy2hbPT0+jl
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

for multilib archs default CFLAGS may be inappropriate  and reslut in binar=
ies=20
unable to be linked.  since e2fsprogs uses gcc for linking I noticed this=20
while building for sparc64.  patch has been tested and applied in Aurora=20
SPARC Linux.=20

Please CC me on responses.

Dennis

--Boundary-01=_ALJPGy2hbPT0+jl
Content-Type: text/x-diff;
  charset="utf-8";
  name="e2fsprogs-1.39-useCFLAGSwithCC.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="e2fsprogs-1.39-useCFLAGSwithCC.patch"

=2D-- e2fsprogs-1.39/configure.BAD	2006-07-11 20:21:08.000000000 -0400
+++ e2fsprogs-1.39/configure	2006-07-11 20:21:17.000000000 -0400
@@ -14645,7 +14645,7 @@
=20
 if test $cross_compiling =3D no; then
    BUILD_CFLAGS=3D"$CFLAGS"
=2D   BUILD_LDFLAGS=3D"$LDFLAGS"
+   BUILD_LDFLAGS=3D"$CFLAGS $LDFLAGS"
 else
    BUILD_CFLAGS=3D
    BUILD_LDFLAGS=3D
=2D-- e2fsprogs-1.39/configure.in.BAD	2006-07-11 20:27:02.000000000 -0400
+++ e2fsprogs-1.39/configure.in	2006-07-11 20:27:09.000000000 -0400
@@ -830,7 +830,7 @@
 dnl
 if test $cross_compiling =3D no; then
    BUILD_CFLAGS=3D"$CFLAGS"
=2D   BUILD_LDFLAGS=3D"$LDFLAGS"
+   BUILD_LDFLAGS=3D"$CFLAGS $LDFLAGS"
 else
    BUILD_CFLAGS=3D
    BUILD_LDFLAGS=3D
=2D-- e2fsprogs-1.39/lib/Makefile.elf-lib.BAD	2006-07-12 10:43:02.000000000=
 -0400
+++ e2fsprogs-1.39/lib/Makefile.elf-lib	2006-07-12 10:43:12.000000000 -0400
@@ -24,7 +24,7 @@
=20
 $(ELF_LIB): $(OBJS)
 	@echo "	GEN_ELF_SOLIB $(ELF_LIB)"
=2D	@(cd elfshared; $(CC) --shared -o $(ELF_LIB) $(LDFLAGS) \
+	@(cd elfshared; $(CC) $(CFLAGS) --shared -o $(ELF_LIB) $(LDFLAGS) \
 		-Wl,-soname,$(ELF_SONAME) $(OBJS) $(ELF_OTHER_LIBS))
 	@$(MV) elfshared/$(ELF_LIB) .
 	@$(RM) -f ../$(ELF_LIB) ../$(ELF_IMAGE).so ../$(ELF_SONAME)
=2D-- e2fsprogs-1.39/MCONFIG.in.BAD	2006-07-12 12:10:33.000000000 -0400
+++ e2fsprogs-1.39/MCONFIG.in	2006-07-12 12:10:42.000000000 -0400
@@ -40,7 +40,7 @@
 ALL_CFLAGS =3D $(CPPFLAGS) $(DEFS) $(USE_WFLAGS) $(CFLAGS) $(XTRA_CFLAGS) \
 	$(INTL_FLAGS) $(LINUX_INCLUDE)=20
 LDFLAGS =3D @LDFLAGS@
=2DALL_LDFLAGS =3D $(LDFLAGS)
+ALL_LDFLAGS =3D $(LDFLAGS) $(CFLAGS)
 BUILD_CFLAGS =3D @BUILD_CFLAGS@
 BUILD_LDFLAGS =3D @BUILD_LDFLAGS@
 RM =3D @RM@
=2D-- e2fsprogs-1.39/lib/ext2fs/Makefile.in.BAD	2006-07-12 12:41:09.0000000=
00 -0400
+++ e2fsprogs-1.39/lib/ext2fs/Makefile.in	2006-07-12 12:44:14.000000000 -04=
00
@@ -189,17 +189,17 @@
 	@echo "	LD $@"
 	@$(CC) -o tst_badblocks tst_badblocks.o freefs.o \
 		read_bb_file.o write_bb_file.o badblocks.o \
=2D		inline.o bitops.o gen_bitmap.o $(LIBCOM_ERR)
+		inline.o bitops.o gen_bitmap.o $(ALL_CFLAGS) $(LIBCOM_ERR)
=20
 tst_iscan: tst_iscan.o inode.o badblocks.o test_io.o $(STATIC_LIBEXT2FS)
 	@echo "	LD $@"
 	@$(CC) -o tst_iscan tst_iscan.o inode.o badblocks.o test_io.o \
=2D		$(STATIC_LIBEXT2FS) $(LIBCOM_ERR)
+		$(ALL_CFLAGS) $(STATIC_LIBEXT2FS) $(LIBCOM_ERR)
=20
 tst_getsize: tst_getsize.o getsize.o $(STATIC_LIBEXT2FS)
 	@echo "	LD $@"
=2D	@$(CC) -o tst_getsize tst_getsize.o getsize.o $(STATIC_LIBEXT2FS) \
=2D		$(LIBCOM_ERR)
+	@$(CC) -o tst_getsize tst_getsize.o getsize.o $(ALL_CFLAGS) \
+		$(STATIC_LIBEXT2FS) $(LIBCOM_ERR)
=20
 tst_ismounted: $(srcdir)/ismounted.c $(STATIC_LIBEXT2FS)
 	@echo "	LD $@"
@@ -207,8 +207,8 @@
=20
 tst_byteswap: tst_byteswap.o bitops.o $(STATIC_LIBEXT2FS)
 	@echo "	LD $@"
=2D	@$(CC) -o tst_byteswap tst_byteswap.o bitops.o $(STATIC_LIBEXT2FS) \
=2D		$(LIBCOM_ERR)
+	@$(CC) -o tst_byteswap tst_byteswap.o bitops.o $(ALL_CFLAGS) \
+		$(STATIC_LIBEXT2FS) $(LIBCOM_ERR)
=20
 tst_bitops: tst_bitops.o inline.o $(STATIC_LIBEXT2FS)
 	@echo "	LD $@"
@@ -218,11 +218,11 @@
 tst_getsectsize: tst_getsectsize.o getsectsize.o $(STATIC_LIBEXT2FS)
 	@echo "	LD $@"
 	@$(CC) -o tst_sectgetsize tst_getsectsize.o getsectsize.o \
=2D		$(STATIC_LIBEXT2FS) $(LIBCOM_ERR)
+		$(ALL_CFLAGS) $(STATIC_LIBEXT2FS) $(LIBCOM_ERR)
=20
 tst_types: tst_types.o ext2_types.h=20
 	@echo "	LD $@"
=2D	@$(CC) -o tst_types tst_types.o=20
+	@$(CC) -o tst_types tst_types.o $(ALL_CFLAGS)=20
=20
 mkjournal: mkjournal.c $(STATIC_LIBEXT2FS)
 	@echo "	LD $@"
=2D-- e2fsprogs-1.39/lib/blkid/Makefile.in.BAD	2006-07-12 14:03:13.00000000=
0 -0400
+++ e2fsprogs-1.39/lib/blkid/Makefile.in	2006-07-12 14:04:31.000000000 -0400
@@ -114,7 +114,7 @@
=20
 tst_types: tst_types.o blkid_types.h=20
 	@echo "	LD $@"
=2D	@$(CC) -o tst_types tst_types.o=20
+	@$(CC) -o tst_types tst_types.o $(ALL_CFLAGS)
=20
 ../../misc/blkid.o: $(top_srcdir)/misc/blkid.c blkid.h
 	@echo "	CC $@"
@@ -123,7 +123,7 @@
=20
 blkid: ../../misc/blkid.o libblkid.a $(DEPLIBUUID)
 	@echo "	LD $@"
=2D	@$(CC) -o blkid ../../misc/blkid.o libblkid.a $(LIBUUID)
+	@$(CC) -o blkid ../../misc/blkid.o libblkid.a $(LIBUUID) $(ALL_CFLAGS)
=20
 test_probe: test_probe.in Makefile
 	@echo "Creating test_probe..."

--Boundary-01=_ALJPGy2hbPT0+jl--

--nextPart3934245.N5Bl8ZHKCe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGPJLAkSxm47BaWfcRApnmAKCwr2vKbGLobPbiD6R4V55PZRjGygCcCjmK
jwR0jF4aGBXdkbPeaEr8x2o=
=PfC8
-----END PGP SIGNATURE-----

--nextPart3934245.N5Bl8ZHKCe--
