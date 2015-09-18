From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH e2fsprogs] subst: use 0644 perms
Date: Fri, 18 Sep 2015 14:08:24 -0400
Message-ID: <20150918180824.GE2213@vapier.lan>
References: <1442562858-862-1-git-send-email-vapier@gentoo.org>
 <E093072B-F995-496D-BE3D-B14EB5A1C27A@dilger.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="GxcwvYAGnODwn7V8"
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:46427 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbbIRSIZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Sep 2015 14:08:25 -0400
Content-Disposition: inline
In-Reply-To: <E093072B-F995-496D-BE3D-B14EB5A1C27A@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--GxcwvYAGnODwn7V8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18 Sep 2015 10:52, Andreas Dilger wrote:
> On Sep 18, 2015, at 01:54, Mike Frysinger <vapier@gentoo.org> wrote:
> > When running on NFS, opening files with 0444 perms for writing can
> > sometimes fail.  Since there's no real reason for these files to be
> > read-only, give the owner write permission.
>=20
> Actually, there IS a reason for subst to make these files read-only. They=
 are auto-generated and any edits to these files can be overwritten and los=
t if their origin files are modified.=20
>=20
> I'd lost edits to these auto generated files many time because they are t=
he ones that "tags" or "cscope" will jump to when searching for symbols.=20
>=20
> There really isn't any reason for them to be writable, so the fact that y=
ou are getting an error trying to open them for writing is a hint that you =
are doing, or going to do, the wrong thing and the read-only nature of the =
file is preventing you from going down the wrong path.=20

i think you misread my report.  this has nothing to do with people trying
to modify the files after the fact.  NFS can (and sometimes does) throw an
error at the time of the *open* call even if the file doesn't exist.

if you want to try to "protect" people, then it needs to be a chmod after
all the data has been written & closed.  this is how it used to behave,
but commit 2873927d15ffb9ee9ed0e2700791a0e519c715aa changed it.
-mike

--GxcwvYAGnODwn7V8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJV/FMYAAoJEEFjO5/oN/WBz/UP/0oKL3uoK6Vo9vR4gZH9pkNr
1lsc3krUQscZM+GurId1tExL2NlGskAVCIWPylKBIOMGHvMPmT2REq6ty8eRNrlI
KPXbgGrOK1k/I8/OAgY+J8H7rkkK8mZr7ewGCDj2tdlVyS3ZVECjVECEXAixXkUj
NEvyc1CJ1iVvUPwE6s2lUhwecxFQxlAi6U7thhe2hEihk7+QAS/SiQC3gW5euPwU
SsuIaAM7M7joIVWnRWz4QTe3kGoxiNUalAIiskFKXDOndF1HWXhv4R4xW+7/yetL
y/YYXyE5jugspmqSaiX0VUkiJ/6VbK3x32hL2yu47K7MTY7lFwlRLHA9NB11PUHL
8Ff2WLZScGVK79lNM6q+EH5OMuyy+EkxHf2B6jztZBDf/Kqm51kmyhhofURgIsq+
d7yj5+loIt0uaCBgnrbbGGgJK3IFtKQxD0n+WpVkbKz06bEEj9OkP7mfwyw8dmd9
xqHKvlehl4jhdZywbZx7p9rXpFVo/FE1M58YLcUa0dMCv7T/pcJ2I5KTSzqE7Z1s
AQqPt0p2okkmVkZY9713m+5Dd+Xd+Jb65vu3TJaNaoeQ9lGTyIE4w9NzOMtQEsYm
DjHgXrCoJWjmcOBNAQt1eEq0j8skfQCr6xRK9LEj7pu/iRjaL3Z/AWSSjrNCDQDK
84KTJd+w3CAjNlRURMA6
=5TEz
-----END PGP SIGNATURE-----

--GxcwvYAGnODwn7V8--
