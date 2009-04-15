From: Kan-Ru Chen <ckanru@gmail.com>
Subject: Recover damaged ext4 volume
Date: Wed, 15 Apr 2009 13:18:26 +0800
Message-ID: <87iql6lci5.fsf@kawa.kanru.info>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:47836 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985AbZDOFfI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Apr 2009 01:35:08 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1Ltxm2-0003dp-S1
	for linux-ext4@vger.kernel.org; Wed, 15 Apr 2009 05:35:02 +0000
Received: from 61-228-157-41.dynamic.hinet.net ([61.228.157.41])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2009 05:35:02 +0000
Received: from ckanru by 61-228-157-41.dynamic.hinet.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2009 05:35:02 +0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Transfer-Encoding: quoted-printable

Hi,

It was a LVM lv formated to ext4 that can't mount anymore after
resize. Both e2fsck and dumpe2fs can not find valid superblock or backup
superblock.

However, I can still read and recognize some data from the volume using
hd. Is there any chance that I can get my files back?

Following is the output of findsuper, lines with wrong mount time are
stripped:

byte_offset  byte_start     byte_end  fs_blocks blksz  grp  last_mount_time=
     sb_uuid label
21140751872 21140750848  29059596800    1933312  4096    0  Mon Dec  8 18:2=
7:59 2008 f4890ad8=20
21188896256 21188895232  29107741184    1933312  4096    0  Mon Dec  8 18:2=
7:59 2008 f4890ad8=20
32368412672 32368411648  96792921088   15728640  4096    0  Thu Dec 11 22:5=
7:22 2008 bd5e4f31=20
45592096256 45592095232  45847046656     248976  1024    0  Tue Dec  9 20:1=
6:51 2008 931b7f03=20


=2D Kan

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknlbnMACgkQmNgFODcAfIm19wCffxekf8IRM+CCGi5Jf/w5HW+x
eQEAn0KrIaPsl1wB3h7x2cffCMCYMZkl
=GX5W
-----END PGP SIGNATURE-----
--=-=-=--

