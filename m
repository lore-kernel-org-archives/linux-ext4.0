From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH] ext2: do not register write_super within VFS
Date: Wed, 11 Apr 2012 18:40:43 +0300
Message-ID: <1334158843.13842.11.camel@sauron.fi.intel.com>
References: <1333446558-28171-1-git-send-email-dedekind1@gmail.com>
	 <20120403223632.GA5288@quack.suse.cz>
	 <1334143474.13842.0.camel@sauron.fi.intel.com>
	 <20120411153054.GA16008@quack.suse.cz>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-bC55gW4uGIYZcfWwCyaK"
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:5871 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755566Ab2DKPhs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Apr 2012 11:37:48 -0400
In-Reply-To: <20120411153054.GA16008@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-bC55gW4uGIYZcfWwCyaK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-04-11 at 17:30 +0200, Jan Kara wrote:
>   Yeah, it's not. So far it was in my for_next_testing and for_testing
> branches. Once the branch (for_testing) passes some compile tests (done)
> and runtime tests with xfstests I will update for_next branch to include
> the patch as well. Because merge window is far, I don't hurry with that
> very much. But if it causes problems for you I can run the tests and upda=
te
> for_next tonight or tomorrow.

I see, thanks. No, I do not have any hurry - I have it in my local tree.

--=20
Best Regards,
Artem Bityutskiy

--=-bC55gW4uGIYZcfWwCyaK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPhaX7AAoJECmIfjd9wqK0RLQQAKSBVBO3fi5bs6JUcG9gzXBq
fCL6cJ28seKPpKglefc+7KS3wP/6SN6TGzOL6dMGbfKo3ghBTZXUJprRvjXBNj+O
v5Zv5jKdz3EoszNTjnrye5JmmI/+LfwzgEW0oxrJaQQhrgwl5qD+qizFDLcLrMt2
WpYi8fo3a5CZFkso/q8M4pHgt0jzxhYfXIza5IKFmnQqn4+KKHWsHyqUPwjMeUA3
T1k+a6iHhVkUc+NmFfoO3v+FqTPI4EeM/CbiPGOYmPper0Me50a5usPH2u8gvd6j
ATDFJz40mB/u/mF676bSWgACcmP1pAsSMlsUfx+1E7E8dJcGqa6CESs+YlozjuYU
FypohhpHAU4jEL+AUp43+iOBQTNE7kFunicuPBPx6IC4Pq7aCndtKfbvEVsgvRtE
HbQhjfPKIwx1PXjHXxejwIPrMxXJy3SP+BNqVMr8m5KyRTmtP74+mGNYIdJHjF5o
/KYZhbkM/jCk4ex+65KNQQr7tVlJZea08W3GKEtB/gl0hdNbDXU7nqUccVl1gOvm
rmNOjSTrPKmM25M0ETxDkU7KG/4hMLwgK9nKkDxO+EJV2oJFaT8Y1B1UPKBxo76G
N8JpVc+E4HAVO7L7vtlEliWQw3FW5iEfhyGW8/3TVXrdJD8gOQZ77LFOQ4QnJa3W
lTbE4/8afsAVyx7UcEQ+
=HMao
-----END PGP SIGNATURE-----

--=-bC55gW4uGIYZcfWwCyaK--

