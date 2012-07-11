From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCHv6 3/5] ext4: remove unnecessary superblock dirtying
Date: Wed, 11 Jul 2012 16:36:16 +0300
Message-ID: <1342013776.18274.52.camel@sauron.fi.intel.com>
References: <1342000698-13556-1-git-send-email-dedekind1@gmail.com>
	 <1342000698-13556-4-git-send-email-dedekind1@gmail.com>
	 <20120711100726.GE1316@quack.suse.cz> <20120711101150.GH1316@quack.suse.cz>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-M09F2wkXjz6TraIu71G9"
Cc: Theodore Tso <tytso@mit.edu>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:62981 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932Ab2GKNcA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jul 2012 09:32:00 -0400
In-Reply-To: <20120711101150.GH1316@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-M09F2wkXjz6TraIu71G9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-07-11 at 12:11 +0200, Jan Kara wrote:
> > > So case 2.b is a bit controversial, but I think it is acceptable. Aft=
er all, by
> > > enabling checksumming we already sign up for paying the price of calc=
ulating
> > > it. The way to improve checksumming performance globally would be to =
calculate
> > > it just before sending buffers to the I/O queue. We'd need some kind =
of
> > > call-back which could be registered by file-systems.
>   Actually, the most common case of adding orphan inode used
> ext4_handle_dirty_super_now() so for that case there is no difference. An=
d
> other cases are so rare it really does not matter... So there shouldn't b=
e
> any measurable difference.

Actually, the entire "orphan" case uses 'ext4_handle_dirty_super_now()',
so this code-path is actually unaffected by my patch-set, so I do not
have to even worry about it. My changes affect only the
'ext4_handle_dirty_super()' users, and there are only 3 of them, and
they are extremely rare one-time events.

--=20
Best Regards,
Artem Bityutskiy

--=-M09F2wkXjz6TraIu71G9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP/YFQAAoJECmIfjd9wqK0ux4QAL3OCUVT3fbTMwzacISAGrMW
c0Ak/XyQy8ecXA6nAsiZPvTpuUg8LuVkvsq5v1YcOooL4TVJHxTvxHwo72sPSNEo
RdVf5XxnEUJasKecAz7aBB7U5DIrVQPi3UrWW3aEWwARiXzE7X3Wix68cq5hykm5
XCVgGBcREqj3P57hInyMWQF9ev/aR/OtOehNNA086XOd75RXfd8T6HgbGJ7G83nM
ItZcRHxDWjwtZ5/+5olh7ayouxA3tPfg45hudY9i9dUeEwqH4XYsxEHGfDCL6qT3
8PXmF5dnWnz/13EXQajs27sUpdFqMtQqeqFjpcWQc2/qwwPAjF+7OxsHoxICZZZA
T8pUez+ER/WKzgKdMCKN5aequM0VeSciXdum9ylBPK7+kozrd2TONBxyk53/dOBJ
RLC7vTFIfYIWQ7KbqR4OTVhYACJos/Rl5/IscsABRYFoIDhfXfxXly1oW0RSGhD4
z6MDKRWvH6i+UCKlM4+cZSUSfUR7xanU/DETp2AQYoyZoPQ3apuBvlyIbE1+D9Rq
hBMESsIJ2N6cZrBJjyKxO9njglU4z1JN4QPf7hWwc3PYrIHx2NaU9bMohvR9vQc+
fFgphFnyw/KbveF1Ahku3lfryZbsgvzTZoBUPxPqEpR0Yz1/oxFUyWKJuy64vgOD
75zgfpqE7EQTpJ1Oup2L
=vHqr
-----END PGP SIGNATURE-----

--=-M09F2wkXjz6TraIu71G9--

