From: Eric <erpo41@gmail.com>
Subject: Re: Online defragmentation and ext4migrate
Date: Mon, 21 May 2007 06:36:51 -0700
Message-ID: <1179754611.389.10.camel@eric-laptop>
References: <464DA4ED.9040408@linux.vnet.ibm.com>
	 <019c01c79b92$627b3280$4168010a@bsd.tnes.nec.co.jp>
	 <20070521103828.GB29416@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ehRonIVzraqwaNOwZ0hD"
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.233]:64933 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbXEUNg7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 May 2007 09:36:59 -0400
Received: by wr-out-0506.google.com with SMTP id 76so1386221wra
        for <linux-ext4@vger.kernel.org>; Mon, 21 May 2007 06:36:58 -0700 (PDT)
In-Reply-To: <20070521103828.GB29416@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-ehRonIVzraqwaNOwZ0hD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-05-21 at 12:38 +0200, Jan Kara wrote:
>   Yes. On the other hand I believe that some people would like to use
> defragmentation but stay with ext3. For them conversion to extents is
> no-go.
> [...]
>  I've written a patch that defragments non-extent files but after
> discussion with XFS guys I've decided that the interfaces should be made
> more generic, so that XFS and other filesystems can use them too...

I see no reason why the ioctl to convert a file to extents and then
defragment it should be different from the ioctl to defragment a
non-extent file.

After all, whether a file's blocks are tracked as lists of blocks or a
set of extents is just bookkeeping, right? The set of data blocks that
make up the file and their order is the same regardless of whether the
extent flag is set in the inode.

If the user is running the ext2/3 driver or the ext4 driver with the
noextents option, just defragment the file. If the user is running ext4
without the noextents option, convert to extents and then defragment.

The only problem that I can think of is that defragmenting metadata
(including indirect block and/or whatever the equivalent is in
extent-land) presumably has performance benefits too, so maybe a
defragmenter in userspace would want to have some knowledge/control over
this process.

Cheers,

Eric


--=-ehRonIVzraqwaNOwZ0hD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGUaBze2L37HVup3ARAvoHAKDyNHj6xHbflLpKntKCl1A/vshPFACfb2f9
ksR85TeIn5H3BrloODNH6CA=
=c1/R
-----END PGP SIGNATURE-----

--=-ehRonIVzraqwaNOwZ0hD--
