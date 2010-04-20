From: Andre Noll <maan@systemlinux.org>
Subject: Re: ext4: (2.6.34-rc4): This should not happen!!  Data will be lost
Date: Tue, 20 Apr 2010 17:37:23 +0200
Message-ID: <20100420153723.GE25507@skl-net.de>
References: <20100416123526.GW21495@skl-net.de> <20100416163654.GD58339@plapa.qlogic.org> <20100416170707.GB25507@skl-net.de> <201004171855.36874.bernd.schubert@fastmail.fm> <4BCA1DFB.5030501@redhat.com> <20100417223854.GD25507@skl-net.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f9lFb+Z4UT82L8vr"
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>,
	Andrew Vasquez <andrew.vasquez@qlogic.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Driver <Linux-Driver@qlogic.com>,
	Thomas Helle <Helle@tuebingen.mpg.de>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:58917 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab0DTPhy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Apr 2010 11:37:54 -0400
Content-Disposition: inline
In-Reply-To: <20100417223854.GD25507@skl-net.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--f9lFb+Z4UT82L8vr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 00:38, Andre Noll wrote:
> > I still don't think it's likely a filesystem problem but maybe you can
> > pinpoint the fs behavior that triggers it.
>=20
> I'll try to reproduce the problem using different timeout values and the
> ext4 options you suggest. If I can find a reliable reproducer, I'll run
> blktrace and post the results.

Here are some results. Prior to running the tests I wrote a bunch of
10G files and then filled the fs completely with 2T files containing
zeros.  Each of the tests below consisted of three runs of

	- remove 5 of the above 10G files to make 50G space available
	- run stress -d 5 --hdd-bytes 10G --hdd-noclean until it dies
	- run fsck if any fs errors occured

Summary: Increasing the device timeout to 60s _or_ disabling barriers
makes the problem go away. Deactivating delayed allocation makes the
problem worse.

- device timeout 60s, default ext4 parameters
	No problems at all, all three runs OK

- device timeout 30s, default ext4 parameters
	1. OK
	2. dmesg:
		qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 2ea270b 2002.
		end_request: I/O error, dev sda, sector 7812889640
		Aborting journal on device sda-8.
		EXT4-fs error (device sda): ext4_journal_start_sb: Detected aborted journ=
al
		EXT4-fs (sda): Remounting filesystem read-only

	fsck:
			Inode 287, i_blocks is 4294918568, should be 416.  Fix? yes
			Inode 288, i_size is 2198897426432, should be 2199023251456.  Fix? yes
			Inode 288, i_blocks is 4294721960, should be 416.  Fix? yes

	3.
		qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 2ece6a8 2002.
		qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 2ece6dc 2002.
		end_request: I/O error, dev sda, sector 7812690136
		Aborting journal on device sda-8.
		EXT4-fs error (device sda) in ext4_free_blocks: Journal has aborted
		EXT4-fs error (device sda) in ext4_ext_remove_space: Journal has aborted
		EXT4-fs error (device sda) in ext4_reserve_inode_write: Journal has abort=
ed
		EXT4-fs error (device sda) in ext4_ext_truncate: Journal has aborted
		EXT4-fs error (device sda) in ext4_reserve_inode_write: Journal has abort=
ed
		EXT4-fs error (device sda) in ext4_orphan_del: Journal has aborted
		EXT4-fs error (device sda) in ext4_reserve_inode_write: Journal has abort=
ed
		EXT4-fs error (device sda) in ext4_delete_inode: Journal has aborted
		EXT4-fs error (device sda): ext4_journal_start_sb: Detected aborted journ=
al
		EXT4-fs (sda): Remounting filesystem read-only

		fsck:
			e2fsck 1.41.10 (10-Feb-2009)
			/dev/sda: recovering journal
			Clearing orphaned inode 179 (uid=3D0, gid=3D0, mode=3D0100600, size=3D0)
			/dev/sda: clean, 301/244158464 files, 1935004235/1953247232 blocks


- device timeout 30s, nodelalloc

	This seems to trigger the problem more reliably:

	1.
		dmesg: same qla, ext4 errors as above
		fsck: orphaned inodes as above
	2. and 3.
		errors already while removing files:
			rm: cannot remove `stress.98q1gG': Read-only file system
		dmesg: same qla/ext4 errors, but also
			JBD2: Detected IO errors while flushing file data on sda-8
		fsck: clean

- device timeout 30s, nobarrier
	No problem at all, all three runs OK.

Eric, are you still interested in seeing the blktrace output? Suppose,
I should use a 30s timeout, nodealloc and barriers=3D1 as this triggers
the problem within minutes.


Regards
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--f9lFb+Z4UT82L8vr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLzcozWto1QDEAkw8RAgYUAJ9Y1JI6cfNGCcZUajNGJ8KNKR80SQCfbcLO
L3OJihSR+oARKy1ghW8HKFk=
=I2uo
-----END PGP SIGNATURE-----

--f9lFb+Z4UT82L8vr--
