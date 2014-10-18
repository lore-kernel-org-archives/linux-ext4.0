From: Sami Liedes <sami.liedes@iki.fi>
Subject: Valgrind-detected issues in e2fsck on corrupted filesystems
Date: Sun, 19 Oct 2014 02:23:21 +0300
Message-ID: <20141018232320.GA4392@sli.dy.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw02.mail.saunalahti.fi ([195.197.172.116]:46535 "EHLO
	gw02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaJRXXZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 Oct 2014 19:23:25 -0400
Received: from sli.dy.fi (a91-156-209-44.elisa-laajakaista.fi [91.156.209.44])
	by gw02.mail.saunalahti.fi (Postfix) with ESMTP id 7421F4001F
	for <linux-ext4@vger.kernel.org>; Sun, 19 Oct 2014 02:23:22 +0300 (EEST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Here are some issues that fuzz testing and running under valgrind
discovered on e2fsck. All of them are from current master branch of
e2fsprogs (commit 6a0f113535cdc4937b60f763667a545183b98c85).

The pristine image is

   http://www.niksula.hut.fi/~sliedes/ext4/testimg.ext4.pristine.bz2

The broken images are minimally different from the pristine in the
sense that after un-flipping any of the flipped bits I could no longer
reproduce the issue.

All were produced by running

  valgrind e2fsck -f -y image

using an e2fsck compiled with -g -O0.


1. memcpy with dest=3D=3Dsrc
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Image: http://www.niksula.hut.fi/~sliedes/e2fsck/testimg.ext4.1.min.bz2

1-bit diff from pristine:

  http://www.niksula.hut.fi/~sliedes/e2fsck/testimg.ext4.1.min.diff

Valgrind output:

  Source and destination overlap in memcpy(0x5608c00, 0x5608c00, 1024)
     at 0x4C2D75D: memcpy@@GLIBC_2.14 (vg_replace_strmem.c:915)
     by 0x46D4C8: unix_write_blk64 (unix_io.c:826)
     by 0x45CFAB: io_channel_write_blk64 (io_manager.c:94)
     by 0x431C01: e2fsck_handle_read_error (ehandler.c:63)
     by 0x46C1CD: raw_read_blk (unix_io.c:201)
     by 0x46D1EF: unix_read_blk64 (unix_io.c:743)
     by 0x45CF1B: io_channel_read_blk64 (io_manager.c:78)
     by 0x44B609: ext2fs_read_dir_block4 (dirblock.c:30)
     by 0x44C523: ext2fs_process_dir_block (dir_iterate.c:211)
     by 0x4465C3: ext2fs_block_iterate3 (block.c:526)
     by 0x44C370: ext2fs_dir_iterate2 (dir_iterate.c:126)

Full log: http://www.niksula.hut.fi/~sliedes/e2fsck/testimg.ext4.1.min.log


2. Out-of-bounds read
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Image: http://www.niksula.hut.fi/~sliedes/e2fsck/testimg.ext4.33.min.bz2

2-bit diff: http://www.niksula.hut.fi/~sliedes/e2fsck/testimg.ext4.33.min.d=
iff

Valgrind output:

  Invalid read of size 2
     at 0x44C0D7: ext2fs_get_rec_len (dir_iterate.c:31)
     by 0x44C5A4: ext2fs_process_dir_block (dir_iterate.c:227)
     by 0x44644F: ext2fs_block_iterate3 (block.c:492)
     by 0x44C370: ext2fs_dir_iterate2 (dir_iterate.c:126)
     by 0x44C45C: ext2fs_dir_iterate (dir_iterate.c:174)
     by 0x456A52: ext2fs_get_pathname_int (get_pathname.c:100)
     by 0x456D56: ext2fs_get_pathname (get_pathname.c:167)
     by 0x4329C2: print_pathname (message.c:209)
     by 0x4334A4: expand_percent_expression (message.c:473)
     by 0x433817: print_e2fsck_message (message.c:552)
     by 0x432B81: expand_at_expression (message.c:259)
     by 0x433717: print_e2fsck_message (message.c:536)
   Address 0x5719840 is 0 bytes after a block of size 1,024 alloc'd
     at 0x4C28C20: malloc (vg_replace_malloc.c:296)
     by 0x45911B: ext2fs_get_mem (ext2fs.h:1694)
     by 0x456D11: ext2fs_get_pathname (get_pathname.c:162)
     by 0x4329C2: print_pathname (message.c:209)
     by 0x4334A4: expand_percent_expression (message.c:473)
     by 0x433817: print_e2fsck_message (message.c:552)
     by 0x432B81: expand_at_expression (message.c:259)
     by 0x433717: print_e2fsck_message (message.c:536)
     by 0x4325D1: fix_problem (problem.c:2130)
     by 0x4254D0: check_dir_block (pass2.c:1286)
     by 0x44AF96: ext2fs_dblist_iterate2 (dblist.c:211)
     by 0x422E34: e2fsck_pass2 (pass2.c:149)

Full log: http://www.niksula.hut.fi/~sliedes/e2fsck/testimg.ext4.33.min.log


3. Use after free
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Image: http://www.niksula.hut.fi/~sliedes/e2fsck/testimg.ext4.56745.min.bz2

6-bit diff: http://www.niksula.hut.fi/~sliedes/e2fsck/testimg.ext4.56745.mi=
n.diff

Valgrind output:

  Invalid read of size 4
     at 0x430D20: e2fsck_get_dir_info (dirinfo.c:230)
     by 0x43139F: e2fsck_dir_info_set_dotdot (dirinfo.c:422)
     by 0x428644: fix_dotdot (pass3.c:739)
     by 0x4275AB: check_directory (pass3.c:322)
     by 0x426E3F: e2fsck_pass3 (pass3.c:108)
     by 0x4149DF: e2fsck_run (e2fsck.c:230)
     by 0x4139E6: main (unix.c:1649)
   Address 0x599d54c is 12 bytes inside a block of size 4,428 free'd
     at 0x4C2AF2E: realloc (vg_replace_malloc.c:692)
     by 0x4592CA: ext2fs_resize_mem (ext2fs.h:1759)
     by 0x4309C0: e2fsck_add_dir_info (dirinfo.c:139)
     by 0x427EA6: e2fsck_get_lost_and_found (pass3.c:550)
     by 0x427FE0: e2fsck_reconnect_file (pass3.c:579)
     by 0x42757A: check_directory (pass3.c:319)
     by 0x426E3F: e2fsck_pass3 (pass3.c:108)
     by 0x4149DF: e2fsck_run (e2fsck.c:230)
     by 0x4139E6: main (unix.c:1649)
 =20
  Invalid write of size 4
     at 0x4313B9: e2fsck_dir_info_set_dotdot (dirinfo.c:425)
     by 0x428644: fix_dotdot (pass3.c:739)
     by 0x4275AB: check_directory (pass3.c:322)
     by 0x426E3F: e2fsck_pass3 (pass3.c:108)
     by 0x4149DF: e2fsck_run (e2fsck.c:230)
     by 0x4139E6: main (unix.c:1649)
   Address 0x599d550 is 16 bytes inside a block of size 4,428 free'd
     at 0x4C2AF2E: realloc (vg_replace_malloc.c:692)
     by 0x4592CA: ext2fs_resize_mem (ext2fs.h:1759)
     by 0x4309C0: e2fsck_add_dir_info (dirinfo.c:139)
     by 0x427EA6: e2fsck_get_lost_and_found (pass3.c:550)
     by 0x427FE0: e2fsck_reconnect_file (pass3.c:579)
     by 0x42757A: check_directory (pass3.c:319)
     by 0x426E3F: e2fsck_pass3 (pass3.c:108)
     by 0x4149DF: e2fsck_run (e2fsck.c:230)
     by 0x4139E6: main (unix.c:1649)

  [... 6 more similar errors]

Full log: http://www.niksula.hut.fi/~sliedes/e2fsck/testimg.ext4.56745.min.=
log


4. Writing uninitialized data
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D

Image: http://www.niksula.hut.fi/~sliedes/e2fsck/testimg.ext4.12340.min.bz2

2-bit diff: http://www.niksula.hut.fi/~sliedes/e2fsck/testimg.ext4.12340.mi=
n.diff

Valgrind output:

  Syscall param pwrite64(buf) points to uninitialised byte(s)
     at 0x4E442F3: __pwrite_nocancel (syscall-template.S:81)
     by 0x46C2DC: raw_write_blk (unix_io.c:234)
     by 0x46C7E4: reuse_cache (unix_io.c:395)
     by 0x46D1CC: unix_read_blk64 (unix_io.c:742)
     by 0x45CF1B: io_channel_read_blk64 (io_manager.c:78)
     by 0x44B609: ext2fs_read_dir_block4 (dirblock.c:30)
     by 0x424895: check_dir_block (pass2.c:937)
     by 0x44AF96: ext2fs_dblist_iterate2 (dblist.c:211)
     by 0x422E34: e2fsck_pass2 (pass2.c:149)
     by 0x4149DF: e2fsck_run (e2fsck.c:230)
     by 0x4139E6: main (unix.c:1649)
   Address 0x560904c is 12 bytes inside a block of size 1,024 alloc'd
     at 0x4C28C20: malloc (vg_replace_malloc.c:296)
     by 0x45911B: ext2fs_get_mem (ext2fs.h:1694)
     by 0x45D0D0: io_channel_alloc_buf (io_manager.c:129)
     by 0x46C583: alloc_cache (unix_io.c:324)
     by 0x46CC9D: unix_open (unix_io.c:576)
     by 0x4606C9: ext2fs_open2 (openfs.c:159)
     by 0x4121D3: try_open_fs (unix.c:1073)
     by 0x412A54: main (unix.c:1286)

Full log: http://www.niksula.hut.fi/~sliedes/e2fsck/testimg.ext4.12340.min.=
log

	Sami

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUQvZoAAoJEKLT589SE0a0zfQP/2MQqPI7H2svZiVn5DxL4GTA
RuvI/UtNWjirmM1/WBRpFNedbs/nKPeTR1o1KyWkBrGjhGY84hu4J3WnrIi2H468
O4vqA8XCyjeX8l/bJxNCXzH/LwnT+2N55GOkWIZpWH8UQTC2A4T/zNgbevylUc6Y
hXYSHyMkT1kPqu8ygmFCWd2HPapFY245X5dcQ54OoiiyieNG8lk2cn0gkf4HbLOp
NmIFv53JkxpyFbQWpKdxk5P9JFmZ466M/RPMOxYUfm74NMG6rlLY8ibsFPJR9Rx/
nphH6mN6Sj6rrzMLdDIeUXPzouWb3VVi+6THwK1WdS98eQdQYZzJLiu48MdI+LsP
hg2kA+OGAm07I5DFJTFE0fccbngkMTbNoTOJgCd5uj+sAN4BnSPNdCNOJVZCuDjp
lNZJPAgVn8j38WZAZjsupOX+1Yk4JSZMYTweGD7WEpWbz7c6HgXVxRkcO+i4PQ8x
+IVIKitCJ2U0VTpfRCBV/He6UBDBYgMfQi2OiXFTtgFHF6bw9SHW/yD/GHZm2PFD
sDFvG0D8FJ3jCdIboKFuZ55FG2tZiaZPcAXbuKZdi4T+jwiHMOMd24njNN0bM/2m
5LmAEWeaItYL+dCv5aat4xMhYb/VXDRAfQTuzqpwAVbbNSEzM2L7iGq/rTOeYTcJ
ZK/TS9LVl4AkoJz0osBL
=pxvP
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
