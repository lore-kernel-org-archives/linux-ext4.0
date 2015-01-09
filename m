From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: Can one file system be R/W mounted multiple times in Linux?
Date: Fri, 9 Jan 2015 12:01:59 +0000
Message-ID: <20150109120159.GA20300@stefanha-thinkpad.redhat.com>
References: <F792CF86EFE20D4AB8064279AFBA51C61EA72765@SIXPRD3002MB028.064d.mgd.msft.net>
 <20150109035123.GG22149@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Cc: Dexuan Cui <decui@microsoft.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"'linux-ext4'" <linux-ext4@vger.kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150109035123.GG22149@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 09, 2015 at 03:51:23AM +0000, Al Viro wrote:
> On Fri, Jan 09, 2015 at 03:44:16AM +0000, Dexuan Cui wrote:
> > The 'mount' utility allows me to mount 1 file systems multiple times at=
 different
> > mount points, like "mount /dev/sdb1 /a; mount /dev/sdb1 /b".
> >=20
> > I tried to write from /a and /b at the same time and it seems everythin=
g is OK
> > and no data corruption happens.
> > I tried only  ext4 only.
> >=20
> > Can somebody please tell me if this usage is safe?
>=20
> Yes.

Can you explain under what conditions mounting the same file system
twice will work?

I guess the kernel is looking up the block device and then sharing the
superblock if the file system is already mounted on this block device?

If I use two loop devices for the same underlying storage it does not
work:

  # mount -o loop /var/tmp/ext4.img /tmp/a
  # mount -o loop /var/tmp/ext4.img /tmp/b
  # touch /tmp/a/a
  # ls /tmp/b
  lost+found
  # umount /tmp/a
  # umount /tmp/b
  # mount -o loop /var/tmp/ext4.img /tmp/a
  [1078357.297245] EXT4-fs error (device loop0): ext4_lookup:1441: inode #2=
: comm ls: deleted inode referenced: 12

Stefan

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUr8M3AAoJEJykq7OBq3PIxP4H/jUWOiquM4ohjJUvt6PGT2aw
ROTnk8YDVGq8OG2aEh93e8082C7Uaxn1JzF7GYqd3fXNcmUIZ8zthzqNMg8FwJcM
1ygxvWJb4yLP1b5T+Ky+D12UctHVEPf7ksXcGZpfqEXiIFsOEPQQsYKwY+OwMhVd
3XyA1kYfVeA/LH5syDUs12txJUD59lxTIt3jPGJxBOOsHWGpOao/aMJEVxNIKuac
9xQ8k/VYa3jzENy7s+q/w+3W6cd3ZszXp19Eg2DaWsv2lj9eV0BZJUJ3ENrY41Bl
FpG4m0NRc2/Ig49eqLRPwKI6/a76M/0+j7mCCam77+H0pLRW05SsGq+PUJbkcbw=
=zJ54
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
