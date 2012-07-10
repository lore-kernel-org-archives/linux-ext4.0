From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCHv4 3/5] ext4: remove unnecessary superblock dirtying
Date: Tue, 10 Jul 2012 13:35:36 +0300
Message-ID: <1341916536.2963.61.camel@sauron>
References: <1341404514-13660-1-git-send-email-dedekind1@gmail.com>
	 <1341404514-13660-4-git-send-email-dedekind1@gmail.com>
	 <20120704131124.GA29954@quack.suse.cz>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-5PfY+T1PONxy8KaD45Uz"
Cc: Theodore Tso <tytso@mit.edu>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:29927 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247Ab2GJKbX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jul 2012 06:31:23 -0400
In-Reply-To: <20120704131124.GA29954@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-5PfY+T1PONxy8KaD45Uz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-07-04 at 15:11 +0200, Jan Kara wrote:
> On Wed 04-07-12 15:21:52, Artem Bityutskiy wrote:
> > From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> >=20
> > This patch changes the '__ext4_handle_dirty_super()' function which is =
used
> > by ext4 to update the superblock via the journal in the following cases=
:
> >=20
> > 1. When creating the first large file on a file system without
> >    EXT4_FEATURE_RO_COMPAT_LARGE_FILE feature.
> > 2. When re-sizing the file-system.
> > 3. When creating an xattr on a file-system without the
> >    EXT4_FEATURE_COMPAT_EXT_ATTR feature.
> > 4. When adding or deleting an orphan (because we update the 's_last_orp=
han'
> >    superblock field).
> >=20
> > This function, however, falls back to just marking the superblock as di=
rty
> > if the file-system has no journal. This means that we delay the actual
> > superblock I/O submission by 5 seconds (roughly speaking). Namely, the
> > 'sync_supers()' kernel thread will call 'ext4_write_super()' later, whe=
re
> > we actually will submit the superblock down to the media.
> >=20
> > However:
> > 1. For cases 1-3 it does not add any value to delay the I/O submission.=
 These
> >    events are rare and we may just commit submit the superblock for
> >    asynchronous I/O right away.
> > 2. For case 4 - similarly, not terribly frequent event in most of workl=
oads.
> >    It should be good enough to just submit asynchronous superblock writ=
e-out.
>   Well, it happens for every inode being truncated / deleted to it can be
> rather frequent. That's why I wanted to have now =3D=3D 1 case everywhere=
 -
> i.e. just recompute the checksum and do mark_buffer_dirty(). I'd just
> remove the 'now' test in this patch and then in patch 5 remove the now
> argument from the function and callers as you did.

I am a bit confused.

It seems you consider that 'ext4_commit_super()' is a considerably
slower than just marking the buffer as dirty right away. But I do not
really understand why - all it does - it just updates a couple of
superblock fields and then marks the buffer as dirty (I assume sync =3D=3D
0). So from my POW they are almost the same. And when csum is enabled -
re-calculating csum will probably be the longest part.

More important is that we dirty the superblock on every deletion - this
mean that with my change we will re-calculate checsum on every deletion
and I am not sure it is nice. Ideally, we should be able to calculate
the checksum just before sending the buffer to the IO queue...

I'll prepare a new patch-set and send it to you. Thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-5PfY+T1PONxy8KaD45Uz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP/AV4AAoJECmIfjd9wqK0sZoP/0TFhM8VzKh3Mo16ymBj9JI2
wRRm6envCvDLvbcjcdvZgEq+a9eS1VybZGHDSZVc/6xsqOK30HThT41Tc3flQbMc
DdCQC11tdUijlgh1nth6YfyLh+5TMfB/CQQTiI14wgV+57brjAme7gTCl74mCEEE
lwSyFGIFJO8kSjj49d1jv3PbC38XdlrWghCMq3qIeGydbGr+FqVQQ36Lk4lM54bu
AaOUnZl6Ydir6svCL/AJpCeQwgJVUi5WjtYOHUIzFwaJF6l4j5QBQii0kGtEF64w
/IYYvb/TlzhXkyltOfsrBBdpNLcnoQIlhBA9fPeaJu96ZwK++YIzWk1cDyvTKsxs
m0sySLnQEpsgQq/UXqeFh8oEwkmM45bX+e2it8cZek+UW74wX0j8Ka2UFR7G7X7a
JeRgVhHT5bRPNNlxAUil9VIP4LSSE3taO79TkrEKBGMG0Fx3hGFfn4hpHZP17ayH
vQog3Nz8H3gay8iD1qHmi76vWrIVNOrCwTtdRRlIT+2q1X/FtRiAqB9r10gJsL19
SVoFlFSBARv4Kkkr7OWeXmJXINazfQ9R/0bpJHzN8XCwAKmS+JHuVvjZ6+xg9G3F
StQjBmBs9rotTUulJgI8cdniqzeeMx187LWz0/t0P/80y7T//m00Hjw4TR1jni5i
vg48tZhz0dTaVB1nSxop
=vgoo
-----END PGP SIGNATURE-----

--=-5PfY+T1PONxy8KaD45Uz--

