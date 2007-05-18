From: Eric <erpo41@gmail.com>
Subject: Re: Online defragmentation and ext4migrate
Date: Fri, 18 May 2007 13:19:54 -0700
Message-ID: <1179519594.6109.40.camel@eric-laptop>
References: <464DA4ED.9040408@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-x9o6fVgXveCX9yctDWHh"
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.233]:25261 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbXERUT7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 May 2007 16:19:59 -0400
Received: by wr-out-0506.google.com with SMTP id 76so1129656wra
        for <linux-ext4@vger.kernel.org>; Fri, 18 May 2007 13:19:55 -0700 (PDT)
In-Reply-To: <464DA4ED.9040408@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-x9o6fVgXveCX9yctDWHh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-05-18 at 18:36 +0530, Aneesh Kumar K.V wrote:
> The reason why i am asking this is to understand the
> usefulness of doing a ext4migrate followed by defrag.=20
> [...]
> Also looking at the version 0.4 I see that defrag ioctl only work if we=20
> have EXT4_EXTENTS_FL flag set.=20

ext4migrate is necessary because the current ext4 defrag routines will
only defragment files stored as extents. AFAIK, converting a file to
extents does not allow the defrag routine to defragment it "better" than
an indirect block map inode, but converting any file to extents has
performance benefits regardless of whether it is later defragmented.

> What are the plans for making defrag work=20
> with indirect block map inode ?

I think there is a second set of patches to defragment non-extent
files.=20

When I started investigating this topic, I would have preferred a defrag
routine for indirect block map inodes since it would work with the
filesystems that I and others are using right now. However, as I read
more code and documentation, I'm beginning to warm up to extents.

A defragmentation routine makes files contiguous on disk. A better
defragmentation routine intelligently locates data structures on the
disk so that files and directories are placed to minimize latency and
maximize throughput now, AND so that this will continue to happen in the
future. Typically this means not only making files contiguous, but also
consolidating free space at the end of the volume so that the block
allocator can pick contiguous blocks for new files. An even better
defragmentation routine knows how to balance the time lost to
defragmentation with the performance gained from a defragmented
filesystem. IMHO, this requires detailed knowledge of the layout of a
file's blocks on the disk. Right now, we get this information by looping
over the FIBMAP ioctl, which I understand can take quite a long time.
But on an extent file there is a logical, high-performance mapping
between the on-disk structures that keep track of which blocks belong to
which files and the data returned by the as-yet-to-be-implemented FIEMAP
ioctl, which could make defragging faster and more fun.

http://www.mail-archive.com/linux-ext4@vger.kernel.org/msg01434.html

Cheers,

Eric


--=-x9o6fVgXveCX9yctDWHh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGTgpqe2L37HVup3ARAnKEAKCg3M5nmR0j4POZxP2FcPRI+1yyEACbBjZu
YyOLGSam2rDMoVGJSUmrR5E=
=p09w
-----END PGP SIGNATURE-----

--=-x9o6fVgXveCX9yctDWHh--
