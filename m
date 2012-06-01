From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH v2 1/4] ext4: Remove useless marking of superblock dirty
Date: Fri, 01 Jun 2012 16:53:40 +0300
Message-ID: <1338558820.2536.151.camel@sauron.fi.intel.com>
References: <1333367140-28370-1-git-send-email-artem.bityutskiy@linux.intel.com>
	 <1333367140-28370-2-git-send-email-artem.bityutskiy@linux.intel.com>
	 <1334215249.13842.36.camel@sauron.fi.intel.com>
	 <1335775045.2584.3.camel@sauron.fi.intel.com>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ex1tRbia+Ilk+vJGeclS"
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:42280 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759876Ab2FANt5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Jun 2012 09:49:57 -0400
In-Reply-To: <1335775045.2584.3.camel@sauron.fi.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-ex1tRbia+Ilk+vJGeclS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-04-30 at 11:37 +0300, Artem Bityutskiy wrote:
> On Thu, 2012-04-12 at 10:20 +0300, Artem Bityutskiy wrote:
> > On Mon, 2012-04-02 at 14:45 +0300, Artem Bityutskiy wrote:
> > > From: Jan Kara <jack@suse.cz>
> > >=20
> > > Commit a0375156 properly notes that superblock doesn't need to be mar=
ked
> > > as dirty when only number of free inodes / blocks / number of directo=
ries
> > > changes since that is recomputed on each mount anyway. However that c=
omment
> > > leaves some unnecessary markings as dirty in place. Remove these.
> > >=20
> > > Artem: tested using xfstests for both journalled and non-journalled e=
xt4.
> >=20
> > Hi Ted, what would be the fate of this patch-set?
>=20
> Hi Ted, I am sorry for being annoying, but what do you think about these
> patches?

Hi Ted, any chance for this stuff to hit 3.4?

--=20
Best Regards,
Artem Bityutskiy

--=-ex1tRbia+Ilk+vJGeclS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPyMlkAAoJECmIfjd9wqK0tEwP/2HWSuQXqbqhZu7Uc38FXQlS
n3qQj2sheNRAA5pENczgiCoSqH/pF3iWYqxOQHwsmNnGetmT7FePrsknG07z72f2
K3vfN+wccfwKoBdLs3EyQzur8/ydHaE90gjAQHsMeRlAHprkfoMncBldXeqm8wAJ
HS8OgyP6EEBV6/5lN+xeCspj3FGC5EPYOL0XyBt7bty4jWdCntUcM16h7N4HQ3kA
0UAj7KtyDu0t3mb6Pg6uTxD0YP1oyEan6KeziMDMk87s0K4LNgs5b7ewv5+plEXH
J+zQ/LtyDJ6LLJ7KNMmc5425NQbCJzOP+uDNJEXL/z5avAzg8aGhPe94vfJ9BzWk
kK6+1BjryyZG6qA9pOoG//3fJbcZ7tG4cRl0n/mDBkqzgp5zuEwfw62XgfBCZ5KS
pz3+Hw2rYHk5F34bND+qCYV5CQL3E54DQeLUUneuoVNQgOSMqYZdkaD2OFrYCabs
6z4gLQRzTRyAKfMEYN9E9UIHtoFG9W8KTpMp3JNQe+EocQ8OKksG0wUFMRVNstil
sqtov8fzlhS0fo0mM3j5rH+1wwHlLxGzqrnhC8uaseTeDSc7UWsXVDwIAoZjeIZ+
oXMM8GBXEM9+oYEmrsabaH5mttJsJ0AzkzUTWTxIs1W6y6YQpe2D9t9DeLb3Qt1L
CFm2+G8E/3NMPv978VSC
=zjXT
-----END PGP SIGNATURE-----

--=-ex1tRbia+Ilk+vJGeclS--

