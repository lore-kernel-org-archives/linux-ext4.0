From: Sami Liedes <sami.liedes@iki.fi>
Subject: Re: Valgrind-detected issues in e2fsck on corrupted filesystems
Date: Sun, 26 Oct 2014 12:47:09 +0200
Message-ID: <20141026104708.GA31873@sli.dy.fi>
References: <20141018232320.GA4392@sli.dy.fi>
 <20141020205736.GB13081@birch.djwong.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw02.mail.saunalahti.fi ([195.197.172.116]:35509 "EHLO
	gw02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaJZKrP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 26 Oct 2014 06:47:15 -0400
Content-Disposition: inline
In-Reply-To: <20141020205736.GB13081@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2014 at 01:57:36PM -0700, Darrick J. Wong wrote:
> Thanks for catching these!  I'll have patches out shortly.

Great! With your patches applied I could no longer get any valgrind
errors on ext4 during overnight fuzz testing.

Here's one more I found which only shows on ext[23], with or without
your recent patches. It seems that the error message "Unexpected block
in HTREE directory inode %d (%q)" is printed with uninitialized values
for both the %d and the %q conversions.

Pristine: http://www.niksula.hut.fi/~sliedes/e2fsck/testimg.ext2.bz2
Fuzzed: http://www.niksula.hut.fi/~sliedes/e2fsck/testimg.ext2.78.min.bz2

1-bit diff:

--- /dev/fd/63  2014-10-26 12:33:05.879722761 +0200
+++ /dev/fd/62  2014-10-26 12:33:05.880722761 +0200
@@ -9032,6 +9032,9 @@
 0013fc10  0a 05 00 00 0b 05 00 00  2b 05 00 00 00 00 00 00  |........+....=
=2E..|
 0013fc20  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |.............=
=2E..|
 *
+0013fcb0  00 00 00 00 00 00 00 00  00 00 04 00 00 00 00 00  |.............=
=2E..|
+0013fcc0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |.............=
=2E..|
+*
 00140000  34 02 00 00 30 00 26 07  5c 78 32 66 64 65 76 69  |4...0.&.\x2fd=
evi|
 00140010  63 65 73 5c 78 32 66 76  69 72 74 75 61 6c 5c 78  |ces\x2fvirtua=
l\x|
 00140020  32 66 74 74 79 5c 78 32  66 74 74 79 35 33 00 00  |2ftty\x2ftty5=
3..|

Output:

------------------------------------------------------------
e2fsck 1.43-WIP (29-Aug-2014)
Pass 1: Checking inodes, blocks, and sizes
Inode 426 has illegal block(s).  Clear? yes

Illegal block #58 (262144) in inode 426.  CLEARED.
Pass 2: Checking directory structure
Directory inode 426 has an unallocated block #19.  Allocate? yes

Unexpected block in HTREE directory inode =3D=3D17310=3D=3D Use of uninitia=
lised value of size 8
=3D=3D17310=3D=3D    at 0x529C0FB: _itoa_word (_itoa.c:179)
=3D=3D17310=3D=3D    by 0x529FB02: vfprintf (vfprintf.c:1635)
=3D=3D17310=3D=3D    by 0x52A1340: buffered_vfprintf (vfprintf.c:2312)
=3D=3D17310=3D=3D    by 0x529C3DD: vfprintf (vfprintf.c:1290)
=3D=3D17310=3D=3D    by 0x52A6526: fprintf (fprintf.c:32)
=3D=3D17310=3D=3D    by 0x4333BB: expand_percent_expression (message.c:451)
=3D=3D17310=3D=3D    by 0x433817: print_e2fsck_message (message.c:552)
=3D=3D17310=3D=3D    by 0x4325D1: fix_problem (problem.c:2130)
=3D=3D17310=3D=3D    by 0x424A8B: check_dir_block (pass2.c:973)
=3D=3D17310=3D=3D    by 0x44AF96: ext2fs_dblist_iterate2 (dblist.c:211)
=3D=3D17310=3D=3D    by 0x422E34: e2fsck_pass2 (pass2.c:149)
=3D=3D17310=3D=3D    by 0x4149DF: e2fsck_run (e2fsck.c:230)
[...]
87815056 (=3D=3D17310=3D=3D Conditional jump or move depends on uninitialis=
ed value(s)
=3D=3D17310=3D=3D    at 0x432977: print_pathname (message.c:203)
=3D=3D17310=3D=3D    by 0x4334FE: expand_percent_expression (message.c:480)
=3D=3D17310=3D=3D    by 0x433817: print_e2fsck_message (message.c:552)
=3D=3D17310=3D=3D    by 0x4325D1: fix_problem (problem.c:2130)
=3D=3D17310=3D=3D    by 0x424A8B: check_dir_block (pass2.c:973)
=3D=3D17310=3D=3D    by 0x44AF96: ext2fs_dblist_iterate2 (dblist.c:211)
=3D=3D17310=3D=3D    by 0x422E34: e2fsck_pass2 (pass2.c:149)
=3D=3D17310=3D=3D    by 0x4149DF: e2fsck_run (e2fsck.c:230)
=3D=3D17310=3D=3D    by 0x4139E6: main (unix.c:1649)
=3D=3D17310=3D=3D=20
=3D=3D17310=3D=3D Conditional jump or move depends on uninitialised value(s)
=3D=3D17310=3D=3D    at 0x456D29: ext2fs_get_pathname (get_pathname.c:165)
=3D=3D17310=3D=3D    by 0x4329C2: print_pathname (message.c:209)
=3D=3D17310=3D=3D    by 0x4334FE: expand_percent_expression (message.c:480)
=3D=3D17310=3D=3D    by 0x433817: print_e2fsck_message (message.c:552)
=3D=3D17310=3D=3D    by 0x4325D1: fix_problem (problem.c:2130)
=3D=3D17310=3D=3D    by 0x424A8B: check_dir_block (pass2.c:973)
=3D=3D17310=3D=3D    by 0x44AF96: ext2fs_dblist_iterate2 (dblist.c:211)
=3D=3D17310=3D=3D    by 0x422E34: e2fsck_pass2 (pass2.c:149)
=3D=3D17310=3D=3D    by 0x4149DF: e2fsck_run (e2fsck.c:230)
=3D=3D17310=3D=3D    by 0x4139E6: main (unix.c:1649)
[...]
???).
------------------------------------------------------------

	Sami

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUTNEsAAoJEKLT589SE0a0EjQP/0/ZBPoMcELSqn654TdGY4cR
S/4HhoKvLTnmTB8dwxJAurRAWFcS+sZkURWNpjssXMxAWvOa9OyItN5tubPlx3h/
rGhudpKKgOOdfFqNK/CsoRKK5mToO59DR7po2zcRa9Uamjth0Cl5GSplC4N8ZLgS
gbQ6+g304Q/hJbe541OZ5cfBTUI48eVntckPOTXFGQR49uryKJmcwtrq2B3QRNAD
58YfpiyUxvj7f9twYm6QD4l7fgse6u/xRTOHtbc062wsH+hdJyldgyjEf/KCkhpL
l/zQo1Xjtet8pdwulJLTVdDUKNvQCSQQjxVmgdllUDLo8TBzpTvbFzuRJSNs/v5h
7p0D2pWdSce87rdY4suPIJbuX43JLZEwzoowf0hGQovD5847Thd+tlX4aGriFaGO
pSA+5FrqSLXk+q33ZW1RwtDBI/sAKPOBXtCWC860klNt0KI4S/ItwrP5Ue1vedil
zsDRCalVDYfZLgXweFKS2QxJhAYXMLiEAeZ5XBSTjH8TZHRd4/G8TfMKW0QFRqgk
910z0bqbwmxX6VYH3GIcwbGbCEoR2D09Bdt5i02UcLLrjxpe2SUNFCihmTJ0tgUU
V9vXcGbYbtXfRWw/Ai/PHoH185DbyWe4iwPM9Io50pLAyFR2cMSi47WUC22DRV57
aknB7YTK4H4E1h0a6EbP
=NGEV
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
