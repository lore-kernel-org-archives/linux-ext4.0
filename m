From: Eric <erpo41@gmail.com>
Subject: Re: [RFC] System calls for online defrag
Date: Wed, 05 Sep 2007 14:31:47 -0700
Message-ID: <1189027907.13189.3.camel@eric-laptop>
References: <20070903180329.GK7524@duck.suse.cz>
	 <20070904180153.GF5377@schatzie.adilger.int>
	 <20070905142438.GB24462@duck.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3/4e5YMjuKNgMeiUnxkC"
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.187]:22364 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbXIEVbx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Sep 2007 17:31:53 -0400
Received: by rv-out-0910.google.com with SMTP id k20so1558313rvb
        for <linux-ext4@vger.kernel.org>; Wed, 05 Sep 2007 14:31:53 -0700 (PDT)
In-Reply-To: <20070905142438.GB24462@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-3/4e5YMjuKNgMeiUnxkC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-09-05 at 16:24 +0200, Jan Kara wrote:
> On Tue 04-09-07 12:01:53, Andreas Dilger wrote:
> > On Sep 03, 2007  20:03 +0200, Jan Kara wrote:
> > >   I've finally got to writing up some proposal how could look system =
calls
> > > allowing for online filesystem defragmentation and generally moving f=
ile
> > > blocks around for improving performance. Comments are welcome.
> > >=20
> > > int sys_movedata(int datafd, int spacefd, loff_t from, size_t len)
> > >    The call takes blocks used to carry data starting at offset @from =
of length
> > > @len in @spacefd and places them instead of corresponding blocks in @=
datafd.
> >=20
> > Calling these "@spacefd" and "@datafd" is a bit confusing.  How about "=
@srcfd"
> > and "@tgtfd" instead?  For defragmentation, are you planning to have @d=
atafd
> > be the "real" inode and "@spacefd" be the temporary inode with defragge=
d data,
> > or the reverse?  It isn't really clear.
>   The idea behind the names was that you move data from @datafd into bloc=
ks
> provided by @spacefd. Calling it @srcfd and @tgtfd has the problem whethe=
r
> you mean source of data or source of blocks...

FWIW, I think @srcfd and @tgtfd are clearer.

When I think about changing the block on the disk that's associated with
a block's worth of data in a file, I think about scooping the file data
out of the source block and setting it down in the destination block. I
do not think about pulling the on-disk block out from under the data and
replacing it with a different on-disk block.

Cheers,

Eric

--=-3/4e5YMjuKNgMeiUnxkC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG3yBBe2L37HVup3ARAhBiAJsFAthP97yK1br0SnB1kiiTar0HQACfaxz8
me8FzU+TXemlzXiFMjzGUY0=
=8LII
-----END PGP SIGNATURE-----

--=-3/4e5YMjuKNgMeiUnxkC--
