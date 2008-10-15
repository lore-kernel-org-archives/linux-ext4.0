From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: Possible ext3 corruption with 1K block size
Date: Wed, 15 Oct 2008 18:24:31 +0400
Message-ID: <200810151824.36119.arvidjaar@mail.ru>
References: <200810150724.42180.arvidjaar@mail.ru> <48F5E6D4.8080603@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7561009.HbZexBdqDx";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>, pterjan@mandriva.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx34.mail.ru ([194.67.23.200]:4283 "EHLO mx34.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbYJOOYl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Oct 2008 10:24:41 -0400
In-Reply-To: <48F5E6D4.8080603@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--nextPart7561009.HbZexBdqDx
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 15 October 2008, Eric Sandeen wrote:
> Andrey Borzenkov wrote:
> > There is long standing open bug report on Mandriva which is currently
> > beieved to have root cause in file system corruption. It shows itself
> > in RPM DB corruption (at least, there is no other known method to trigg=
er
> > it). So far all reported cases happened on filesystem with 1K block size
> > and stopped when RPM DB was moved to FS with 4K block size.
> >=20
> > There are also similar RH reports as well.
> >=20
> > Here are references:
> >=20
> > https://qa.mandriva.com/show_bug.cgi?id=3D32547
> >=20
> > This one is rather long.=20
>=20
> yep, unfortunately IIRC most of the bug is "me too's" and "how do I do
> the workaround" :)
>=20
> > Interesting bits are probably around
> >=20
> > https://qa.mandriva.com/show_bug.cgi?id=3D32547#c177
> > https://qa.mandriva.com/show_bug.cgi?id=3D32547#c148 (many users report=
ing
> > dumpe2fs)
> >=20
> > https://bugzilla.redhat.com/show_bug.cgi?id=3D230362
> > https://bugzilla.redhat.com/show_bug.cgi?id=3D375931
> > https://bugzilla.redhat.com/show_bug.cgi?id=3D305301
> >=20
> > The Mandriva bugzilla also mentions this mail from Stephen Tweedie=20
> > http://lkml.org/lkml/2007/9/18/232
>=20
> I don't think this is related, in the end... there was some possiblity
> of corruption from that, but I think it's doubtful it'd hit 1k block
> filesystems more, and in any case, the corruption has been seen since
> then if I read it right.
>=20
> > which indicates some issues with 1K blocks, but according to last comme=
nt:
> > https://qa.mandriva.com/show_bug.cgi?id=3D32547#c300
> >=20
> > it is still present in 2.6.27 (at least was present on -rc6)
> >=20
> > There was a kernel bug report http://bugzilla.kernel.org/show_bug.cgi?i=
d=3D11564,
> > but in this case it was identified as hardware issue.
>=20
> My kingdom for a testcase... does anyone have simple steps to reproduce
> this?  Or do they all start with "install mandriva on a 1k block size
> system?"  :)
>=20

May be RH will do? :)

As indicated by last comment, Pascal has some ways to trigger it; I
forgot to Cc to him initially; doing it now.

--nextPart7561009.HbZexBdqDx
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkj1/SAACgkQR6LMutpd94x0UQCfe0q3Q0MaVtXbHzjwEJLowWv4
NbsAn1cMjhDXyXvOqCGCISe/xNEVjBIn
=yphD
-----END PGP SIGNATURE-----

--nextPart7561009.HbZexBdqDx--
