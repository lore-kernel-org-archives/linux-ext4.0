From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: dump ext4 performance degrades linearly as disk fills
Date: Mon, 16 Jun 2014 15:48:18 -0600
Message-ID: <20B8F5EC-EEA3-4D9E-9A99-21A769B83475@dilger.ca>
References: <539E8401.5000607@josephdwagner.info>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: multipart/signed; boundary="Apple-Mail=_7793DC6E-42E3-42E6-9703-759C295586CA"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org
To: "Joseph D. Wagner" <joe@josephdwagner.info>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:63866 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964AbaFPVsS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jun 2014 17:48:18 -0400
Received: by mail-pd0-f178.google.com with SMTP id r10so4821299pdi.23
        for <linux-ext4@vger.kernel.org>; Mon, 16 Jun 2014 14:48:18 -0700 (PDT)
In-Reply-To: <539E8401.5000607@josephdwagner.info>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_7793DC6E-42E3-42E6-9703-759C295586CA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1

On Jun 15, 2014, at 11:43 PM, Joseph D. Wagner <joe@josephdwagner.info> =
wrote:
> Background:
> - I use lvm snapshots on ext4 for backup.  I use dump to backup the =
snapshots.  The backup goes to an external hard drive over usb 3.0. The =
external hard drive has 1 partition formatted with ext4.
>=20
> Problem:
> - I've noticed the performance of dump to my ext4 backup degrades =
linearly as the disk fills.  In the output, the kbps in the status line =
keeps getting lower as the percent complete keeps getting higher.

One major cause for performance degradation as a disk fills is that the
inner tracks of a disk (higher block addresses) have about 1/2 the
throughput of the outer tracks (lower block addresses).  This means it
is basically impossible to get more than 50% of the performance from
blocks that are allocated on the higher addresses in the filesystem.

You could test this by creating a partition on the low blocks of the =
disk,
one that consumes most of the remaining space, and one at the high =
blocks
of the disk, create filesystems on the low- and high-block partitions, =
and
then running benchmarks on them.

Cheers, Andreas

> My Thoughts So Far:
> - I suspect that either 1) dump is doing something which lowers =
performance as the backup progresses, or 2) the ext4 algorithm for =
finding and allocating free blocks is vulnerable to performance =
degradation as the volume fills.
>=20
> - I haven't tested this thoroughly.  However, performance appears to =
improve when I clear out the external drive and do a fresh, full dump =
(-0), and performance appears to remain degraded on incremental backups =
on a nearly full volume.  This leads me to suspect #2.
>=20
> Help from you:
> - What steps can I take to isolate the cause of the problem?  If =
there's any information I can provide, please let me know.
>=20
> What I've Done:
> - I've run both the short and long SMART tests on the external drive, =
which came back clean.  They also told me the relocated sector count was =
zero.
>=20
> - I also made sure the disk was connecting in usb 3.0 mode.
>=20
> - I changed the external drive ext4 mount from journal=3Dordered to =
journal=3Dwriteback.  The performance difference was nominal.
>=20
> Any insight would be appreciated.
>=20
> Thanks.
>=20
> Joseph D. Wagner
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_7793DC6E-42E3-42E6-9703-759C295586CA
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU59mInKl2rkXzB/gAQIPxw//dax8wwNEE7tu77f/L1GawHvToBdBhpAf
L3op6TVx7jjbGHAfY1Cmvisf3zlvHGjkEfw5EFS5DeD/FrsCbcKseGhut8TNxH56
eCURYv1NefOe/xzuUEOVf8f0LS2OI8J14yuR5Edz39+DIY7jofVrWgUrezwQXGIw
tZS7sKmm14kyKbg62jMmAseABIJBitVFPsVi6qM51b82EScbLofoaN4IfFsRxOoq
hBELrOR/8SiS0hIATg2vdyuvWniD0y0QpeaiK11kR/kzp4C9SwZofqq4dGE4Lq/H
72YgjI8bqbJvLNrcYpqfwFnm5IOdg1NME2qbrG+anuz/J5QpwPuA8cXeqz5wngkR
UftGuTt+INbyXIOYk3Fb63+fzsG5lIBdNm8YosafMIgDbxDggr3IcemMXBJp0cy7
y7VbblJNwKFUCRvExJNHMQPPLYyE7Cdwel7O9rxdlmP/Lb2dyiZ9wtc/2ziSxX/f
aEjsRIUUBzNNNV0IN5E8kQE5dm1KVtMUYD6dEShPgrLkT3DyyfXk+Q1ah+ThEK77
g3L0+pajlC5aVflG9niMHZ/b1QaupkGAVsAISUOhGUW+QcZTjvdObDK9gB3waj47
yuzGbfE9VEgkUjSwhzuxGGJeiaMKThfovQcA+ZqTo4D0Usm0S4Hi5mZeZbjC3j9r
/El6M8aZr6o=
=///X
-----END PGP SIGNATURE-----

--Apple-Mail=_7793DC6E-42E3-42E6-9703-759C295586CA--
