From: Andre Noll <maan@systemlinux.org>
Subject: ext4: (2.6.34-rc4): This should not happen!!  Data will be lost
Date: Fri, 16 Apr 2010 14:35:26 +0200
Message-ID: <20100416123526.GW21495@skl-net.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N86MB5dqKsQMqKm2"
Cc: linux-driver@qlogic.com, Thomas Helle <Helle@tuebingen.mpg.de>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:39373 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab0DPMzq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Apr 2010 08:55:46 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--N86MB5dqKsQMqKm2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi

I'm seeing the following errors when writing to an ext4 file system:

	qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 fa6a73 2002.
	end_request: I/O error, dev sda, sector 7812771880
	Aborting journal on device sda-8.
	EXT4-fs (sda): delayed block allocation failed for inode 752 at logical of=
fset 1982464 with max blocks 17588 with error -30

	This should not happen!!  Data will be lost
	EXT4-fs error (device sda) in ext4_da_writepages: Journal has aborted
	EXT4-fs error (device sda): ext4_journal_start_sb: Detected aborted journal
	EXT4-fs (sda): Remounting filesystem read-only
	EXT4-fs (sda): delayed block allocation failed for inode 756 at logical of=
fset 177656 with max blocks 1205 with error -30
	EXT4-fs error (device sda) in ext4_da_write_end: IO failure

	This should not happen!!  Data will be lost
	EXT4-fs (sda): ext4_da_writepages: jbd2_start: 1205 pages, ino 756; err -30

	EXT4-fs (sda): ext4_da_writepages: jbd2_start: 17588 pages, ino 752; err -=
30

	EXT4-fs (sda): delayed block allocation failed for inode 755 at logical of=
fset 669696 with max blocks 3268 with error -30

	This should not happen!!  Data will be lost
	EXT4-fs (sda): ext4_da_writepages: jbd2_start: 3268 pages, ino 755; err -30

This happened while stress-testing the machine [1] with

	stress -d 5 --hdd-bytes 10G --hdd-noclean

This command is supposed to fill the disk and then exit with "no space
left". Instead, the above errors occured when the fs was 100% full.
There's nothing in the logs of the Raid system.

Is this a known issue? Who's to blame, qla2xxx or ext4?

Thanks
Andre

[1] Vanilla 2.6.34-rc4, a 7.3T ext4 fs on a FC Infortrend hardware
raid, connected to a qlogic hba. Let me know if you need more info.
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--N86MB5dqKsQMqKm2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLyFmOWto1QDEAkw8RAnU7AJ90pitfGS3h3noA4xIH43/GYopI0QCePUKA
ntmKJirTY7nNJLWIU6+ltGE=
=CDI3
-----END PGP SIGNATURE-----

--N86MB5dqKsQMqKm2--
