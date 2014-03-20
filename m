From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Bug#738758: [PATCH] ext4: kill i_version support for
 Hurd-castrated file systems
Date: Thu, 20 Mar 2014 17:30:32 +0000
Message-ID: <1395336632.2770.13.camel@deadeye.wl.decadent.org.uk>
References: <20140319202009.GA21361@jessie01>
	 <1395290051-25682-1-git-send-email-tytso@mit.edu>
	 <3DF297F8-04E0-4EE6-8CD5-127997293D5A@dilger.ca>
	 <20140320081048.GA21164@infradead.org> <20140320144456.GA20618@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-gkPzyt+xZB42QZbNI0An"
Cc: Christoph Hellwig <hch@infradead.org>,
	Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"1o5g4r8o@gmail.com" <1o5g4r8o@gmail.com>
To: tytso@mit.edu, 738758@bugs.debian.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59340 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757710AbaCTRat (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Mar 2014 13:30:49 -0400
In-Reply-To: <20140320144456.GA20618@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-gkPzyt+xZB42QZbNI0An
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-03-20 at 10:44 -0400, tytso@mit.edu wrote:
> On Thu, Mar 20, 2014 at 01:10:48AM -0700, Christoph Hellwig wrote:
> > On Wed, Mar 19, 2014 at 11:27:57PM -0600, Andreas Dilger wrote:
> > > Probably worthwhile to make those !EXT4_OS_HURD checks likely()?
>=20
> Yes, and I was planning on optimizing the checks a bit more, but it
> makes sense to do that in a separate patch, since this is not the only
> place where we are making EXT4_OS_HURD checks.
>=20
> >=20
> > Does it make sense to support the format at all given that it's unlikel=
y
> > to get any testing?
>=20
> There are some crazy people still trying to make the Hurd a viable
> file system.  There's even a Debian port for it.  :-) The problem is
> that some of the folks who are still trying to make the Hurd real want
> to use ext2 as an interchange format between Linux and Hurd, and
> presumably that's how they ran across this particular bug.
[...]

That, plus we turned on CONFIG_EXT4_USE_FOR_EXT23 for Debian kernel
packages starting with Linux 3.11.

It looks like ext2 and ext3 would always initialise i_version to 1 in
memory; does it matter that you're changing that to 0 for Hurd
filesystems?

Ben.

--=20
Ben Hutchings
One of the nice things about standards is that there are so many of them.

--=-gkPzyt+xZB42QZbNI0An
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUysluOe/yOyVhhEJAQpYIhAAzPBb8WnbRX+XQKaWVEkQji4RYlMCkFkr
+zxKhufu9RB/75qp+37u05uOL3fK5QyxqBFDbil4CBRstfgxzRiCF8Q00UInnRUE
+zjRw8eaY4bhUR5AeceOvFMutmPAq00/PpvEhNVc9IsNAAQzho6BrV7ikdPDO6Xj
3PjO/F3oQuDFSDuIot51dm1LehR8EnZsuQF2557XcaKooF2zEHAGOiJq16an8dZt
6rVLBDf0+YDPjw4xukFpySHrAc19rlj8aQdZUIKE7EMp99uMfgQVOc9UEYx0ga0+
HaTssRVJn1Kmo1dh71JH154uzShbHx1mW8kkMAWePIC5y7vUV9OIPoHGXnyTbwIk
XqvDnFnQ9vJ5+WVd0Yhc7ZPhDHBkGb+atYEs9oAi1SxZYdHdiD2dMFnbNnIE5Bhh
i6yzgKYjNgvNZRHdR2yZhJNx2P2uyf+G+8Xp8hKcthPJg4MuCT+goQKC+zujz8T6
1c6bQJtoZsKb3BEkeYKGdUoheasVNr5f/7eIBAF01MylVE2/LBQo4T0tQZMC6thJ
ToSbOo6x/nhM8y13wUOSx2i1No1Pkc2lDvl3xG3BGHEBeW67sqgff0bEd9RzERQq
74lJ+9xf37c6MkdM60nClEAXusPbXSHWRSjcIyBctRw8TeNNtwCKkAZG+iXgv8yA
vBILPW7uk/0=
=Z+IF
-----END PGP SIGNATURE-----

--=-gkPzyt+xZB42QZbNI0An--
