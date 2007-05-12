From: Eric <erpo41@gmail.com>
Subject: Re: [RFC] store RAID stride in superblock
Date: Sat, 12 May 2007 09:14:17 -0700
Message-ID: <1178986457.6021.22.camel@eric-laptop>
References: <20070512020248.GQ6375@schatzie.adilger.int>
	 <1178957506.20145.41.camel@eric-laptop>  <46457BD5.8040301@clusterfs.com>
	 <1178962364.20145.99.camel@eric-laptop>  <46458AF9.404@clusterfs.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-g62yQdXnMXUradmMIT6U"
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:24675 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbXELQOW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 May 2007 12:14:22 -0400
Received: by an-out-0708.google.com with SMTP id d18so308722and
        for <linux-ext4@vger.kernel.org>; Sat, 12 May 2007 09:14:21 -0700 (PDT)
In-Reply-To: <46458AF9.404@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-g62yQdXnMXUradmMIT6U
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> > Perhaps the filesystem driver or mkfs could
> > probe for the stride in those cases? If the code asks for, say, 10MiB o=
f
> > data from the block device and it gets back sectors that are spaced
> > 128KiB apart before it gets the rest of the data, it can make an
> > intelligent guess about the stride.
>
> do you mean incorporation
> storage benchmark in the mount procedure?

Yes. If the benefits of automatically aligning on-disk data structures
to the stride of the array are great enough, then a storage
mini-benchmark may be of use.

For example, suppose we have an array with a stride of 1MiB and the
filesystem driver requests 10MiB of contiguous data from the start of
the block device. Then the data at +0MiB from the start of the device,
the data at +1MiB, the data at +2MiB, and so on ought to arrive earlier
the data at, say, +0.5MiB, +1.5MiB and +2.5MiB. This would allow the
filesystem driver to detect the stride even when the striping isn't
being done by the MD or LVM/DM drivers in Linux (which, apparently, have
well-defined interfaces for discovering the stride in software).

I imagine this would work well for a run-of-the-mill hardware RAID card
in a PC. However, as you pointed out in your original email, there are
SANs to be considered. If another host is putting load on the SAN, it
could throw off the read timings and cause the filesystem driver to make
a bad guess.

Cheers,

Eric


--=-g62yQdXnMXUradmMIT6U
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGRefZe2L37HVup3ARApjjAJ44duesS2O1YpleRu3ECYAwb4eQZgCfeAFQ
vbbLNge0vPlSV8YlLv+UYNw=
=Uu8/
-----END PGP SIGNATURE-----

--=-g62yQdXnMXUradmMIT6U--
