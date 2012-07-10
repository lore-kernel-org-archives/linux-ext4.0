From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCHv4 3/5] ext4: remove unnecessary superblock dirtying
Date: Tue, 10 Jul 2012 15:17:29 +0300
Message-ID: <1341922649.2963.94.camel@sauron>
References: <1341404514-13660-1-git-send-email-dedekind1@gmail.com>
	 <1341404514-13660-4-git-send-email-dedekind1@gmail.com>
	 <20120704131124.GA29954@quack.suse.cz>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-g8v1ShFN8TOJjY8zEqUL"
Cc: Theodore Tso <tytso@mit.edu>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120704131124.GA29954@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-g8v1ShFN8TOJjY8zEqUL
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

It looked logical to me to use 'ext4_commit_super()' always and remove
'now' and marking the buffer dirty directly. Just because I thought the
speed difference should be nearly 0, and 'ext4_commit_super()' is doing
some error checking. But you seem to suggest to do the opposite, and I
do not understand why would that be better. So I dropped this change so
far.

I've sent v5 where I basically only changed the commit message in patch
3 and dropped patch 5. In patch 3 I've explicitly indicated that we'll
do more checksum calculations, but I think this is OK acceptable.

Thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-g8v1ShFN8TOJjY8zEqUL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP/B1ZAAoJECmIfjd9wqK0TREP/1CdrYyy7/NnH/ymCVj78GVZ
JNxTsZb5t1Pg9nPNksqbjyXgclsE/anvopAwif81XiMZVkFhI63sg5ona8p5rb7N
L70B1mZ6KJT3OKNGYFa/Hku6/lCks2HcKM0UbYXMzYQqi7Mi3WtTTeHUxe3eo0O3
PE/T8wo7BA2pnPj+CJLELyPitnm671BlZERjb25JPOFoJ5PQNopyb5q11fADf+6a
2H03r7PzcQZ0emkRMNoIKX3MYseUEGmffbUjT0JwoPD8oG0qsGdxOoa0DoZ7R3QS
hwyh2xtb/SN4qisZX+UFM9OaUGuSMCep6iCvuQES6/ggFU+gtA88MUCN/ODqVINv
DYcV6iM3REjU0aMrAxk8xRn/5EzDyWs0dcopwjzzxN+jmN5vCXLmHN7MWfu2UkOt
EOo2kQz4XwesnWfzO5Oab0fCOQz4O9EqtFUQCQE7H3rVZQX5yBrurRrP0EjDqNQh
UoVgkaoUco2pD/8bN95XItUw7tnrcp3rudYjZZO6/bvyZFEXQPnM9qiN1uiel8jt
/RMflJ+RFhNgXUPg1xPj5NFA7CMRRJXC+g1PHP4TtwtygR86a53t8vSFDa1Hd58A
zYaynfsQWL4spGnIG8uKTbVv3KA6Et4WByx98JfbGeo4pv5WDhq1Mn9XvKIcvjM0
Q3fmwbDlp6zAE+RLMmIe
=CcLr
-----END PGP SIGNATURE-----

--=-g8v1ShFN8TOJjY8zEqUL--
