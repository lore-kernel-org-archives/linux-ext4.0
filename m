From: Eric <erpo41@gmail.com>
Subject: SOLVED: Re: files mapped funny? (related to online defragmentation)
Date: Mon, 21 May 2007 19:08:05 -0700
Message-ID: <1179799685.5779.7.camel@eric-laptop>
References: <1179755398.389.24.camel@eric-laptop>
	 <1179770459.23003.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1EtC6QAl6Pma0Ym+0W5v"
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:48821 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758000AbXEVCIk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 May 2007 22:08:40 -0400
Received: by py-out-1112.google.com with SMTP id a73so499799pye
        for <linux-ext4@vger.kernel.org>; Mon, 21 May 2007 19:08:39 -0700 (PDT)
In-Reply-To: <1179770459.23003.7.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-1EtC6QAl6Pma0Ym+0W5v
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> > I'm getting strange results when I map out the blocks used in files
> > larger than a several thousand KB. I never seem to get any more than
> > 1024 contiguous data blocks in a row.=20
> >=20
> filefrag command comes with e2fsprogs will print the file fragmentation
> info. I guess you can try filefrag -v command and see if that matches
> what your scripts reported.

Thanks for the pointer. It seems my program only counts data blocks, so
it sees the indirect block for each 1024 data blocks as a space between
extents. I will have to read the filefrag source and account for that.

Cheers,

Eric


--=-1EtC6QAl6Pma0Ym+0W5v
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGUlCFe2L37HVup3ARAkydAJ9gIlgAN8QLO1IHgbc6QQhO113k/ACg/FnH
RjnnXXMnjd2R+NdC2Hb9YFM=
=PHbl
-----END PGP SIGNATURE-----

--=-1EtC6QAl6Pma0Ym+0W5v--
