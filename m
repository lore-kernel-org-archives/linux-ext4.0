From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH] ext2: Don't export ext2_mask_flags() to user space
Date: Thu, 22 Mar 2012 08:00:41 +0200
Message-ID: <1332396053.3058.2.camel@koala>
References: <1332366608-2695-1-git-send-email-thierry.reding@avionic-design.de>
	 <20120321222357.GB24330@quack.suse.cz> <20120321231651.GC32041@thunk.org>
	 <20120322055354.GA3942@avionic-0098.mockup.avionic-design.de>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-g4Ckn/ZiVNiAM4sXbNMR"
Cc: Ted Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	linux-ext4@vger.kernel.org, stable@vger.kernel.org
To: Thierry Reding <thierry.reding@avionic-design.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62225 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab2CVGA4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Mar 2012 02:00:56 -0400
In-Reply-To: <20120322055354.GA3942@avionic-0098.mockup.avionic-design.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-g4Ckn/ZiVNiAM4sXbNMR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-03-22 at 06:53 +0100, Thierry Reding wrote:
> What's the recommended fix for packages that cannot or will not use
> libext2fs, like busybox? Copy the required parts into a private header
> and use that instead?

The normal way is to just keep a private copy of the whole header file.
Because the on-disk format stays compatible, those programs do not have
to update the header very often - only rarely if they want to support
some new feature.

--=20
Best Regards,
Artem Bityutskiy

--=-g4Ckn/ZiVNiAM4sXbNMR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJPasAJAAoJEJtuLFy+q7feStkH/17W4b8bH+4qfZTy9GxWX6Hi
T+PXFP/VJ2fiJjIkNNsw7DffVtUl1XaM3kTebOUNrBYKCi9U3VlcFumHICpgYCl/
d+GvqvznywdTvlcsxmB6hWq+dUa4CX8MEpep934NSkjCLJqCkpd8nDUMAHK6bU7j
Z3dQ9wZlwb3NPWCXHRfNAJ6Wlrf0okGyWocdKMgiWsn+cOcFP6lLSnB3+yckDeM7
Tm4TBHHhvl576zvuQgwMkC0wLAEGf9A7u3pv9iVCj3mpSoUWIhJVx9Vx7qVVEObe
miWm3xaVL/3q/Kw5q6c78j+KdVRM6KTfy53i68XQ/Odb8MehF6su7ZXpMb2jRz4=
=4qxT
-----END PGP SIGNATURE-----

--=-g4Ckn/ZiVNiAM4sXbNMR--

