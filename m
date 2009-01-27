From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: [PATCH] ext4: fix oops when online resizing a filesystem with
	flex_bg
Date: Tue, 27 Jan 2009 13:25:40 -0200
Message-ID: <20090127152539.GA3704@vespa.holoscopio.com>
References: <1232743309-3929-1-git-send-email-cascardo@holoscopio.com> <20090127000743.GC10118@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from liberdade.minaslivre.org ([72.232.18.203]:49753 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbZA0PZP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2009 10:25:15 -0500
Content-Disposition: inline
In-Reply-To: <20090127000743.GC10118@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 26, 2009 at 07:07:43PM -0500, Theodore Tso wrote:
> Fortunately having random bits in bg_flags is otherwise mostly
> harmless, but this is clearly a bug.  Can you test and confirm this
> also fixes your failure case?
>=20
> 						- Ted

Yes, it fix my test case. No oops while online resizing anymore with
only your patch applied on top of 2.6.29-rc2.

Best Regards,
Cascardo.

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkl/J3MACgkQyTpryRcqtS1GbQCfVf0aXczdPL0dhEg7DdjshaiZ
sL8AmwVYojqWalhfkP6fXEMYyngN4mQS
=1YcT
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
