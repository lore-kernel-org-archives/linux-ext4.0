From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: e2fsprogs - possible regression between 1.42.7 and 1.42.8
Date: Wed, 4 Sep 2013 10:04:44 +0200
Message-ID: <20130904080444.GP5953@pcnci.linuxbox.cz>
References: <20130729083941.GG28871@pcnci.linuxbox.cz>
 <51F694B6.90901@redhat.com>
 <51F87075.2020508@redhat.com>
 <51F8722D.9050707@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I4g3zIzscEHdx6fd"
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gwu.lbox.cz ([62.245.111.132]:50480 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762130Ab3IDIQ2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Sep 2013 04:16:28 -0400
Content-Disposition: inline
In-Reply-To: <51F8722D.9050707@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--I4g3zIzscEHdx6fd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Eric,

I'm very sorry for such a late reply, I was a bit busy with other
projects.. Well, I don't really understand what I should do with the
images now :) But if I understand previous discussion well, my problem
is not caused by code regressions, but new tests which were added
to this new version right? The problems failed tests report are related
to filesystems with 1K block size, so unless I use such filesystems,
I'm safe to skip tests and use this new version, especially since I've
been using 1.42.7 till now, right?

Or is there some git commit fixing those issues I should try?

Thanks a lot for Your time and sorry about my lame questions..

with best regards

nikola ciprich


On Tue, Jul 30, 2013 at 09:10:53PM -0500, Eric Sandeen wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>=20
> On 7/30/13 9:03 PM, Eric Sandeen wrote:
> > On 7/29/13 11:13 AM, Eric Sandeen wrote:
> >> On 7/29/13 3:39 AM, Nikola Ciprich wrote:
> >>> Hi,
> >=20
> >>> trying to compile latest e2fsprogs and running check under RHEL6-comp=
atible
> >>> distro (centos) fails:
> >=20
> >>> r_1024_small_bg: ext2 1024 blocksize with small block groups: failed
> >>> r_ext4_small_bg: ext4 1024 blocksize with small block groups: failed
> >=20
> >>> dunno whether this is known issue... will bisect help?
> >=20
> >>> with regards
> >=20
> >>> nik
> >=20
> >=20
> >> Ted, these are the same ones I saw, plus one I think (working on getti=
ng
> >> all the info).
> >=20
> > Sorry this took a while.  Attached is a qcow image of a broken r_1024_s=
mall_bg
> > filesystem.  Doing resize2fs -M on it twice should corrupt it, even on =
x86_64.
>=20
> Sorry - the image as attached is not broken, but 2 current resize2fs -M's=
 break it.
>=20
> - -Eric
>=20
> > (aside: the test is a bit weird, it does:
> >=20
> > echo $RESIZE2FS $RESIZE2FS_OPTS -d 31 -M $TMPFILE $SIZE_2 >> $LOG 2>&1
> >=20
> > but specifying -M as well as a size doesn't make much sense?)
> >=20
> > -Eric
> >=20
>=20
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
> Comment: GPGTools - http://gpgtools.org
> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
>=20
> iQIcBAEBAgAGBQJR+HIsAAoJECCuFpLhPd7gT3cP/3YLhpclAhU6UHIW4cqyKhIl
> STIwV3ROZmic5qQb8X6l5etc8ALCs2b5LVYjhlMlZWISkN64pXOhL0lz7coSABM9
> wnZU2y3LntcyGFEg7aEs+sXe2mXqX139NkoNwKfBBPidQ/HdwpnnTdlu4FZeTyrj
> aDHIUGPs2YBbp2QaBhmzl5b7xwEoHCq/XtrH7v7+SHyHEGzIYTn3w96vyXqVYTjs
> csUgeMhFFw58Hq+/03UE13Ig/Et8AqSgonnaEiG3ZKXsDIxhjFxqQPGsdD2BleGd
> Rb/fxnkM0RKhr7xSK3CFWnLQ8LkaUtexazxvr+7BmmgRx8jyQhQj8ASYXzmUuh/S
> RtbnZ3wioxEwCRhr3FP0ZpoOZwbkDWd/UBy407ZBblxVafjLSYbsMHDM7rPrQHoz
> oSo1W4c7sy85pNfCgMnQYyuqik5KVDuQNk/nqEkv6tE1YOb5zXTrpDKjEFgBKYVd
> FpLRk9f0rhoxcwyfZsIY6Wx/4h4rWKnhK6jqL5unDLJitPv405KlNfY28AoFNme4
> ZxwDSddausNm+8u9sZON7cuyhAb70Q8N0W6ECPX8+ie8fvXwPDRSJYPpMXqOBK06
> 35SPqxKlCpT7BGMAqr7+h8qemYdcTS0z7ag2im+MRS1t58AFSsuIyj+IirPWwTUM
> SQRtuG3mOsWE7l93c8bc
> =3D96jm
> -----END PGP SIGNATURE-----
>=20

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28.rijna 168, 709 00 Ostrava

tel.:   +420 591 166 214
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--I4g3zIzscEHdx6fd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlIm6ZwACgkQ3xdJJrLygV7/ogCgtrspZ6IqSy3VJvfK8cEwa6AC
pq8AmwU5B32VMWjQQ+cK7rsAprl3pzU7
=wYO7
-----END PGP SIGNATURE-----

--I4g3zIzscEHdx6fd--
