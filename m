From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH v1 0/9] do not use s_dirt in ext4
Date: Thu, 22 Mar 2012 15:56:25 +0200
Message-ID: <1332424585.18717.34.camel@sauron.fi.intel.com>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
	 <20120322133521.GA25897@thunk.org>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ytg7KFuShKKG6Wjql7yG"
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56770 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756293Ab2CVNxe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Mar 2012 09:53:34 -0400
In-Reply-To: <20120322133521.GA25897@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-ytg7KFuShKKG6Wjql7yG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-03-22 at 09:35 -0400, Ted Ts'o wrote:
> Just as a quick FYI, I tried applying your patch series on top of my
> development tree, and ran into problems when I ran the regression test
> (using xfstests).  When I backed out your changes and reran, the tests
> completed without any problems.

Thanks Ted, I'll take a look at xfstests and run them next time before
sending out v2.

> I'm rerunning the tests since the first failure looks like it might
> not be related to your patch series (and yet it went away once I
> backed out your patch).  The second failure however looks definitely
> related to your changes.  It looks like you don't wait to make sure
> the workqueue is flushed out before the file system gets unmounted,
> and that can lead to a panic.

Hmm, I thought the whole DIO workqueue would be flushed so I do not have
to do anything. I'll take a look.

> Since we're already in the 3.3 has already been released, I suspect
> this patch series will probably need to wait until the next merge
> window.  We might be able to pull in some of the obviously safe
> patches, however.

Sure, that's fine.

But I wonder, since this is cross-FS story, where I need to first do
small VFS change (export the variable), then change all file-systems,
and then remove whole 's_dirt'/'write_supers()' stuff from VFS, how this
would be handled?

IMO, the best way would be to make everything go in via one single tree,
granted I could get all the acks, do you feel like ext4 tree could be
the one?

Also, I am working on top of vanilla 3.3, do you prefer me to work with
your tree instead? I guess this tree:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git

but which branch?

--=20
Best Regards,
Artem Bityutskiy

--=-ytg7KFuShKKG6Wjql7yG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPay+JAAoJECmIfjd9wqK0SBQP/ivGQ2rENpj4UVAl10mM3l2M
IBES4BhG7SrlCb4QfmFfJyHP8RG0UqKkf+srfnhon0SPe8UDz9mvaZ7ga41SGlRv
n2YQW2sip+MWZDpSi4zjmr1kKhFXIfduAE24d9YEXjJ7LF8tBkVfxVgX5pcfn3Ka
PfdvFC3CM+tHDjQfgvkGJX8YXZLOnPcNTMokQvmWeBX+yCO4E+pHPVgpGN9+rJY3
ny553dak8y8n4EWYGSa4e3LtiVeqheDSupYVrn2zG1AlS1pTuIjqpSeEF5hQlaha
6UpigId3/5etugK0NFzdfeWvdFmpHP02yHwkRzM125qiek7jAi984ScJO9lpSNma
1+0zOKpIcongnqTM3kNMl+tucBDozPCuFQ81papg+4ttdDg92ma4gAg97zVT6fda
rrhpaRXPVUu0mjFt3gel8gPcMPh1a4nOWuhY8unp+ww1h/eJ0HBkq1a0X2U+Z9/9
IhyVl9QYpV2S6aLpPY42GjrbFhUZzk6M4TkBlKFSHK08MAtSF2dNxf4PrJ6cqHz+
k4xc1NcbAN9xn5ngVjgkjfrVe7VzFH/FVG282cVpQ5aRt3vilgUYtBGraoRCZbIa
/p1s0oDYR3htlCOP7g8qtttBUjuUjQ6qFqdzWQlNBUZ5TfIpyfUpEPciyGJZR9tm
zO27tq5pEFTfsL2/NKdE
=FdDl
-----END PGP SIGNATURE-----

--=-ytg7KFuShKKG6Wjql7yG--

