From: Andre Noll <maan@systemlinux.org>
Subject: Re: ext4: (2.6.34-rc4): This should not happen!!  Data will be lost
Date: Thu, 22 Apr 2010 10:21:23 +0200
Message-ID: <20100422082123.GC21495@skl-net.de>
References: <20100416123526.GW21495@skl-net.de> <20100416163654.GD58339@plapa.qlogic.org> <20100416170707.GB25507@skl-net.de> <201004171855.36874.bernd.schubert@fastmail.fm> <4BCA1DFB.5030501@redhat.com> <20100417223854.GD25507@skl-net.de> <20100420153723.GE25507@skl-net.de> <4BCDDB7F.6040903@redhat.com> <20100420174610.GZ21495@skl-net.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tZ7UtMhm9kWBoSQe"
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>,
	Andrew Vasquez <andrew.vasquez@qlogic.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Driver <Linux-Driver@qlogic.com>,
	Thomas Helle <Helle@tuebingen.mpg.de>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:51876 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab0DVIVx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Apr 2010 04:21:53 -0400
Content-Disposition: inline
In-Reply-To: <20100420174610.GZ21495@skl-net.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--tZ7UtMhm9kWBoSQe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 19:46, Andre Noll wrote:
> > To be honest I'm not sure what I would do with the blktrace data now,
> > but perhaps someone might be interested to see it; I'd at least gather =
it.
>=20
> OK, will send it tomorrow.

Here we go.

mount | grep sda:

        /dev/sda on /mnt type ext4 (ro,relatime,barrier=3D1,data=3Dordered)

command:

        ls stress.* | head -n 5 | xargs rm && stress -d 5 --hdd-noclean --h=
dd-bytes 10G

dmesg:

        EXT4-fs (sda): mounted filesystem with ordered data mode
        qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 2f82d1=
 2002.
        qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 2f82d3=
 2002.
        end_request: I/O error, dev sda, sector 7812689752
        Aborting journal on device sda-8.
        qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 2f82d8=
 2002.
        EXT4-fs (sda): delayed block allocation failed for inode 4198406 at=
 logical offset 0 with max blocks 32768 with error -30

        This should not happen!!  Data will be lost
        EXT4-fs error (device sda) in ext4_da_writepages: Journal has abort=
ed
        qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 2f82da=
 2002.
        qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 2f82db=
 2002.
        EXT4-fs (sda): delayed block allocation failed for inode 4198435 at=
 logical offset 0 with max blocks 32768 with error -30

        This should not happen!!  Data will be lost
        EXT4-fs error (device sda): ext4_journal_start_sb: Detected aborted=
 journal
        EXT4-fs (sda): Remounting filesystem read-only
        EXT4-fs (sda): ext4_da_writepages: jbd2_start: 32768 pages, ino 419=
8406; err -30

        EXT4-fs (sda): ext4_da_writepages: jbd2_start: 32768 pages, ino 419=
8435; err -30

        qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 2f82df=
 2002.
        EXT4-fs (sda): delayed block allocation failed for inode 4198433 at=
 logical offset 0 with max blocks 32768 with error -30

        This should not happen!!  Data will be lost
        EXT4-fs (sda): delayed block allocation failed for inode 4198437 at=
 logical offset 0 with max blocks 32768 with error -30

        This should not happen!!  Data will be lost
        EXT4-fs (sda): ext4_da_writepages: jbd2_start: 32768 pages, ino 419=
8433; err -30

        EXT4-fs (sda): ext4_da_writepages: jbd2_start: 32768 pages, ino 419=
8437; err -30

        qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 2f82e2=
 2002.
        ...

The output of "btrace /dev/sda" during the above command is 1.7M
large. It's at

        http://systemlinux.org/~maan/btrace.sda

I'll run further tests with barrier=3D0 and 60s timeout.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--tZ7UtMhm9kWBoSQe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFL0AcDWto1QDEAkw8RAv8NAKCInPMiSy/Gs2ADyp2MnJESS55NhwCeP54Y
at+zge03jqj2pWEo7dzlZ6o=
=vqYd
-----END PGP SIGNATURE-----

--tZ7UtMhm9kWBoSQe--
