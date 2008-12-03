From: Andre Noll <maan@systemlinux.org>
Subject: Problems with checking corrupted large ext3 file system
Date: Wed, 3 Dec 2008 11:11:00 +0100
Message-ID: <20081203101100.GO17966@skl-net.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s9kDAZ2EyO0AcRYa"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:42354 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbYLCKwL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 05:52:11 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--s9kDAZ2EyO0AcRYa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I've some trouble checking a corrupted 9T large ext3 fs which resides
on a logical volume. The underlying physical volumes are three hardware
raid systems, one of which started to crash frequently. I was able
to pvmove away the data from the buggy system, so everything is fine
now on the hardware side.

However, the crashes left me with a seriously corrupted file system
=66rom which I'm trying to recover as much as possible. First step was
to unmount the file system after users reported I/O errors when trying
to open files. The system log contained many messages like

	[102445.420125] EXT3-fs error (device dm-2): ext3_free_blocks_sb: bit alre=
ady cleared for block 544108393                                            =
 =20

and some of the form

	[160301.277477] EXT3-fs error (device dm-2): htree_dirblock_to_tree: bad e=
ntry in directory #153542738: rec_len % 4 !=3D 0 - offset=3D0, inode=3D1381=
653864, +rec_len=3D26709, name_len=3D79

So I compiled the master branch of the e2fsprogs git repo as of
Dec 1 (tip: 8680b4) and executed

	./e2fsck -y -C0 /dev/mapper/abel-abt6_projects

This ran for a while and then started to output a couple of these:

	Inode table for group 68217 is not in group.  (block 825373744)
	WARNING: SEVERE DATA LOSS POSSIBLE.

along with many lines of the form

	Illegal block #3036172 (4233778405) in inode 115335438.                   =
                                                                           =
 =20
        CLEARED.

But then it continued just fine without printing further
messsages. After about 4 hours it completed but decided to re-run from
the beginning and this is where the real trouble seems to start. The
next day I found thousands of lines like this on the console:

        /backup/data/solexa_analysis/ATH/MA/MA-30-29/run_30/4/length_42/rea=
ds_0.fl (inode #145326082, mod time Tue Jan 22 05:09:36 2008)

followed by

	Clone multiply-claimed blocks? yes

At this point the fsck seems to hang. No further messages, no progress
bar for at least 17 hours. The lights on the raid system aren't
flashing but there seems to be a bit of I/O going on as stracing the
e2fsck process yields

	lseek(3, 6206310776832, SEEK_SET)       =3D 6206310776832
	read(3, "002107740635\tD\t2\t169\t35\t0\thhhhhh"..., 4096) =3D 4096
	lseek(3, 1263113973760, SEEK_SET)       =3D 1263113973760
	write(3, "B9K@=3D?4C=3DL-F77F4:CGGK\n3\t14221118"..., 4096) =3D 4096
	lseek(3, 5861641846784, SEEK_SET)       =3D 5861641846784
	read(3, "hhhhhh\tIIIIIIIIIIIIIIIIIIIIIIIII"..., 4096) =3D 4096
	lseek(3, 1263113977856, SEEK_SET)       =3D 1263113977856
	write(3, "\t1.00\t0.46\t19\t4\t2\t0\t1\tA\t33\t31\t0\t"..., 4096) =3D 4096

There's about only one read per second, so the fsck might take rather
long if it continues to run at this speed ;)

It's running for 34 hours now and I don't know what to do, so here are
a couple of questions for you ext3 gurus:

	Is there any hope this will ever complete?

	Should I abort the fsck and restart?

	Do things get even worse if I abort it and mount the file
	system r/o so that I can see whether important files are
	still there?

	Are there any magic e2fsck command line options I should try?

The box is a 2xQuad Core Intel machine with 32G Ram and is running
a vanilla 2.6.25.20 kernel. Any help is greatly appreciated.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--s9kDAZ2EyO0AcRYa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJNls0Wto1QDEAkw8RAkDgAKCSXgHhiZ+a2dwxAdSTqPgOIqf1SACfQA2V
TVb23YvMjiFSVl+JNQPGuz0=
=jzWg
-----END PGP SIGNATURE-----

--s9kDAZ2EyO0AcRYa--
