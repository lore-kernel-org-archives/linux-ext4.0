From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 02/37] misc: coverity fixes
Date: Sun, 11 May 2014 18:40:11 -0400
Message-ID: <20140511224011.GD5480@thunk.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
 <20140501231236.31890.46904.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1405021306530.2154@localhost.localdomain>
 <20140505200429.GF8434@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33439 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932523AbaEKWkO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 May 2014 18:40:14 -0400
Content-Disposition: inline
In-Reply-To: <20140505200429.GF8434@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Applied, with Luk=C3=A1=C5=A1's nits addressed.  One comment:

> > > @@ -612,7 +616,7 @@ static errcode_t __populate_fs(ext2_filsys fs=
, ext2_ino_t parent_ino,
> > >  				if (p =3D=3D NULL) {
> > >  					com_err(name, errno,
> > >  						_("Not enough memory"));
> > > -					return errno;
> > > +					goto out;
> >=20
> > same here.
>=20
> Yes.  Thank you for spotting these.

The original code was buggy here, since realloc() doesn't set errno.
I've added:

					retval =3D EXT2_ET_NO_MEMORY;

before the "goto out" line.

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
