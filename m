From: Timo Sirainen <tss@iki.fi>
Subject: 2.6.20 ext3 rename() returns success but doesn't unlink the source
Date: Fri, 23 Mar 2007 19:15:27 +0200
Message-ID: <1174670127.10004.14.camel@hurina>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4CJToNH7pGCd2JgWduBo"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dovecot.org ([213.157.71.38]:53428 "EHLO dovecot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932764AbXCWRdv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Mar 2007 13:33:51 -0400
Received: from hurina (82-203-162-146.dsl.gohome.fi [82.203.162.146])
	by dovecot.org (Postfix) with ESMTP id A0BB9F0C4D
	for <linux-ext4@vger.kernel.org>; Fri, 23 Mar 2007 19:15:27 +0200 (EET)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-4CJToNH7pGCd2JgWduBo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

The problem happened when I was stress testing my IMAP server using a
ext3 filesystem created inside 1GB file in XFS.

The ext3 image can be downloaded from
http://dovecot.org/tmp/broken-ext3fs.gz

Then do:

	rename("/mnt/Maildir/.Trash/new/1174635781.P25986Q0M341350.hurina",
	       "/mnt/Maildir/.Trash/cur/1174635781.P25986Q0M341350.hurina:2,");

You'll see that the source file won't get unlinked from new/ directory,
even though rename() returns 0. (Don't use /bin/mv for testing, it'll
unlink(), not rename()).

This is fully reproduceable with me. Vanilla 2.6.20 kernel, x86-64 SMP.

Other renames that are broken:

/mnt/Maildir/.Trash/cur/1174634032.P23859Q0M8966.hurina:2,FR -> /mnt/Maildi=
r/.Trash/cur/1174634032.P23859Q0M8966.hurina:2,RSe
/mnt/Maildir/.Trash/cur/1174655534.P24036Q0M568306.hurina:2, -> /mnt/Maildi=
r/.Trash/cur/1174655534.P24036Q0M568306.hurina:2,FRde
/mnt/Maildir/.Trash/cur/1174634141.P26381Q0M456574.hurina:2,DRce -> /mnt/Ma=
ildir/.Trash/cur/1174634141.P26381Q0M456574.hurina:2,DFRce
/mnt/Maildir/.Trash/cur/1174634674.P4936Q0M158888.hurina:2,b -> /mnt/Maildi=
r/.Trash/cur/1174634674.P4936Q0M158888.hurina:2,Dae
/mnt/Maildir/.Trash/cur/1174635529.P21439Q0M369287.hurina:2,FRabd -> /mnt/M=
aildir/.Trash/cur/1174635529.P21439Q0M369287.hurina:2,Sab
/mnt/Maildir/.Trash/cur/1174633952.P22125Q1M462390.hurina:2,Sbc -> /mnt/Mai=
ldir/.Trash/cur/1174633952.P22125Q1M462390.hurina:2,DFRSbc
/mnt/Maildir/.Trash/cur/1174635536.P21699Q0M303872.hurina:2,FRSde -> /mnt/M=
aildir/.Trash/cur/1174635536.P21699Q0M303872.hurina:2,Sab
/mnt/Maildir/.Trash/cur/1174634168.P26948Q0M641713.hurina:2,bdc -> /mnt/Mai=
ldir/.Trash/cur/1174634168.P26948Q0M641713.hurina:2,Rbdc
/mnt/Maildir/.Trash/cur/1174635988.P29139Q0M957075.hurina:2,DRd -> /mnt/Mai=
ldir/.Trash/cur/1174635988.P29139Q0M957075.hurina:2,be
/mnt/Maildir/.Trash/cur/1174635746.P25391Q0M231431.hurina:2, -> /mnt/Maildi=
r/.Trash/cur/1174635746.P25391Q0M231431.hurina:2,abe
/mnt/Maildir/.Trash/cur/1174634129.P26063Q0M629252.hurina:2,DRde -> /mnt/Ma=
ildir/.Trash/cur/1174634129.P26063Q0M629252.hurina:2,DRd
/mnt/Maildir/.Trash/cur/1174635744.P25345Q0M695919.hurina:2,c -> /mnt/Maild=
ir/.Trash/cur/1174635744.P25345Q0M695919.hurina:2,abc
/mnt/Maildir/.Trash/cur/1174634548.P2478Q0M911503.hurina:2,DFSad -> /mnt/Ma=
ildir/.Trash/cur/1174634548.P2478Q0M911503.hurina:2,DSa
/mnt/Maildir/.Trash/cur/1174635164.P14762Q0M158308.hurina:2, -> /mnt/Maildi=
r/.Trash/cur/1174635164.P14762Q0M158308.hurina
/mnt/Maildir/.Trash/cur/1174634671.P4940Q0M644537.hurina:2,Re -> /mnt/Maild=
ir/.Trash/cur/1174634671.P4940Q0M644537.hurina:2,bd
/mnt/Maildir/.Trash/cur/1174634633.P3937Q0M292724.hurina:2,FRSd -> /mnt/Mai=
ldir/.Trash/cur/1174634633.P3937Q0M292724.hurina:2,FRSabdce
/mnt/Maildir/.Trash/cur/1174633952.P22146Q0M723956.hurina:2,Rbde -> /mnt/Ma=
ildir/.Trash/cur/1174633952.P22146Q0M723956.hurina:2,Sbde
/mnt/Maildir/.Trash/cur/1174635616.P23078Q4.hurina:2,DFR -> /mnt/Maildir/.T=
rash/cur/1174635616.P23078Q4.hurina:2,Rb


--=-4CJToNH7pGCd2JgWduBo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGBAsvyUhSUUBViskRAmRCAKCl1XKoYRhMYbKjhgSn0OWhdDOeygCZAX9q
Y6yTrUNWZbJF22J7BR+2ijo=
=nYGW
-----END PGP SIGNATURE-----

--=-4CJToNH7pGCd2JgWduBo--
