From: Tyler Hicks <tyhicks@canonical.com>
Subject: Re: Separate mailing list for xfstests
Date: Wed, 14 May 2014 11:50:49 -0500
Message-ID: <20140514165048.GA20454@boyd>
References: <alpine.LFD.2.00.1405141508150.9727@localhost.localdomain>
 <53738316.20601@redhat.com>
 <53738597.70305@fb.com>
 <20140514160447.GA3974@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Cc: Chris Mason <clm@fb.com>, Eric Sandeen <sandeen@redhat.com>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	dchinner@redhat.com, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34076 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352AbaENQvA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 May 2014 12:51:00 -0400
Content-Disposition: inline
In-Reply-To: <20140514160447.GA3974@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2014-05-14 16:04:47, tytso@mit.edu wrote:
> On Wed, May 14, 2014 at 11:02:47AM -0400, Chris Mason wrote:
> > >> linux-fsdevel might seem as a good candidate for it, but still I
> > >> think that it deserves a separate ML to point people to.
>=20
> I'm personally in favor of using linux-fsdevel since it might
> encourage more fs developers who aren't using xfstests yet to start
> using it.
>=20
> For example, we started investigating using xfstests to test unionfs,
> and pretty quickly found problems.  (I suspect the same problem exists
> in AUFS, BTW, but I've been focusing on unionfs because it's simpler
> and less scary.)  The patches to enable the use of xfstests to test
> unionfs are still pretty rough, but hopefully we'll get those sent to
> Dave once they are cleaned up a bit.

Oh, that sounds interesting. I haven't seen these patches, but I expect
they would be pretty easy for me to extend for testing eCryptfs. That
has been on my todo list for a long time but I haven't spent much time
working on eCryptfs lately.

BTW, you can use this email as a supporting data point for your first
paragraph. :)

Tyler

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTc57oAAoJENaSAD2qAscKHiQP/jMiLT4iqu2Fovh9zqIInjpe
tlw+SIdM5e9/s/mG9Gys706Ktvy/LyDAkYcBCNVePu5VlV6BTrXIlkkJwaW2F4wB
zzLm02xzPzq5Z+xnWRpNcscmEz68rzA2ciFVd1PuOqw1TscTNVmfoUUAsMXXUZgv
SD7M43OBHql0mTdPX65xmT2HhyYhnaL2KU1qqRvWcNT1MIuVIJ9GbkrD8sH2GzVn
cM9yvgEIopbijtuLlCTxXIwzPTFZq3oVcX9awEr0Tx1tVB7qM7Bw0OK+jt/wRpDH
NO0KCxGYqs7R223W1E9/pvzFs+A50n9rQihtoZEoieb6u4S/zMhmaSXTT2spOyoJ
t9AkeUJLITrFyzE9V7z3KIumC9de7s1VwhYCx/CjLM+ASVPx19kCH0CnmRapiO6v
zEMTabX23QV6noOI0C8CHpQ8ludLsUwbTKWpLYL6Z0qLCJeBwsVxXOlelDeKO0/6
yD998a6K9ziuJOGg4KjpGuur0QavFApt33D0c7tlRngFv/zT9pUxRSiSD0hjv2yl
vKm7uz60I4OOa6b31OYZrg9S4/0vTOyr1R6PEuBd7Jp8aQ/teUOz1mC7n/nnWlew
2BY8jZZRM3AVRI/Uq+K1axMjwgNUW9Zght1Px4Bd/zszE5yONro8MX18rkTf9HNL
uOmxQlf/VmP0cMFUXd+D
=+lOS
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
