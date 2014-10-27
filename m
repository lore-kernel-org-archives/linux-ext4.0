From: Sami Liedes <sami.liedes@iki.fi>
Subject: Re: Valgrind-detected issues in e2fsck on corrupted filesystems
Date: Tue, 28 Oct 2014 00:10:57 +0200
Message-ID: <20141027221057.GB31873@sli.dy.fi>
References: <20141018232320.GA4392@sli.dy.fi>
 <20141020205736.GB13081@birch.djwong.org>
 <20141026104708.GA31873@sli.dy.fi>
 <20141027171000.GA10057@birch.djwong.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="PmA2V3Z32TCmWXqI"
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:59650 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbaJ0WLD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2014 18:11:03 -0400
Content-Disposition: inline
In-Reply-To: <20141027171000.GA10057@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--PmA2V3Z32TCmWXqI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2014 at 10:10:00AM -0700, Darrick J. Wong wrote:
> On Sun, Oct 26, 2014 at 12:47:09PM +0200, Sami Liedes wrote:
> > On Mon, Oct 20, 2014 at 01:57:36PM -0700, Darrick J. Wong wrote:
> > > Thanks for catching these!  I'll have patches out shortly.
> >=20
> > Great! With your patches applied I could no longer get any valgrind
> > errors on ext4 during overnight fuzz testing.
> >=20
> > Here's one more I found which only shows on ext[23], with or without
> > your recent patches. It seems that the error message "Unexpected block
> > in HTREE directory inode %d (%q)" is printed with uninitialized values
> > for both the %d and the %q conversions.
>=20
> I think the following patch fixes this problem; can you give it a spin?

Yeah, that seems to fix it.

	Sami

--PmA2V3Z32TCmWXqI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUTsLxAAoJEKLT589SE0a01bIQAJYHiROFU4KtEPYzPRxZB+0O
UrrXJt3BjBaQSnOkVDDP3wZvmwAyb6QCtWI10wifveWnp/lHFfolhdN5vp/ZQyKX
OespqZNN7p65Q+T35vEP9r1eG5cqJSq6kqg4gRhDc2knkf4ti54pCt/d8a178aJY
tFdXBiEnNGIzfBoY5v3c3oSdCYG5HRcliGmFXxeRl6b6zS9/woR3Uh4eNfJqC2+C
fqhrQH/2eNPar70xs6sxxFhUcD+yJTirmdMdjFjAvPb6xWIbvpqRm/tlckF+Cck3
oBoIaUOkj5d6WQCMziSUBdNIzCo5ZzRy048eRDyljdqGQwLCpNbddeqprLuvk1/0
ZSQj2VrRgQfdEaRS19NPaSI3pkkCToV08Qn0ulxHlprrW7UDQ0JkNkzGhPS4iKpf
HM63mBjqwK+pDLFgL/AEO1o6+oYQYupqU5LiQRnf4cLXuMg47lN1NYrsV393VA5t
mlk+7lvWh1FvbwJuq+0h/xw9uHDg6rXklb8eFbfzuk7pq3LuuxrkBLI05LVKON8A
PlRVxh1wJi8elnKJGwYsApH/3OnmRtXBjxDaiAS06Y+lAuSCQkICXNiVp+Nuo+BM
nvUqIip73Sy2U76f3vD0lQitope/JO2i6PcRI+4qFvrTnyczqZUnZjoXWDapEFo8
2mtPmRuGXIwsLdaVSd/j
=GqnD
-----END PGP SIGNATURE-----

--PmA2V3Z32TCmWXqI--
