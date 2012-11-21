From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 4/4] ext3: Warn if mounting rw on a disk requiring
 stable page writes
Date: Thu, 22 Nov 2012 08:47:13 +1100
Message-ID: <20121122084713.69e5b1fc@notabene.brown>
References: <20121121020027.10225.43206.stgit@blackbox.djwong.org>
	<20121121020056.10225.15220.stgit@blackbox.djwong.org>
	<20121121021543.GI10507@quack.suse.cz>
	<20121121211319.GA32202@blackbox.djwong.org>
	<20121121213333.GF30250@quack.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/h.yWshvrZGapGhRWIvU.Aq/"; protocol="application/pgp-signature"
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, axboe@kernel.dk,
	lucho@ionkov.net, ericvh@gmail.com, tytso@mit.edu,
	rminnich@sandia.gov, viro@zeniv.linux.org.uk,
	martin.petersen@oracle.com, david@fromorbit.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121121213333.GF30250@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--Sig_/h.yWshvrZGapGhRWIvU.Aq/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Nov 2012 22:33:33 +0100 Jan Kara <jack@suse.cz> wrote:

> On Wed 21-11-12 13:13:19, Darrick J. Wong wrote:
> > On Wed, Nov 21, 2012 at 03:15:43AM +0100, Jan Kara wrote:
> > > On Tue 20-11-12 18:00:56, Darrick J. Wong wrote:
> > > > ext3 doesn't properly isolate pages from changes during writeback. =
 Since the
> > > > recommended fix is to use ext4, for now we'll just print a warning =
if the user
> > > > tries to mount in write mode.
> > > >=20
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  fs/ext3/super.c |    8 ++++++++
> > > >  1 file changed, 8 insertions(+)
> > > >=20
> > > >=20
> > > > diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> > > > index 5366393..5b3725d 100644
> > > > --- a/fs/ext3/super.c
> > > > +++ b/fs/ext3/super.c
> > > > @@ -1325,6 +1325,14 @@ static int ext3_setup_super(struct super_blo=
ck *sb, struct ext3_super_block *es,
> > > >  			"forcing read-only mode");
> > > >  		res =3D MS_RDONLY;
> > > >  	}
> > > > +	if (!read_only &&
> > > > +	    queue_requires_stable_pages(bdev_get_queue(sb->s_bdev))) {
> > > > +		ext3_msg(sb, KERN_ERR,
> > > > +			"error: ext3 cannot safely write data to a disk "
> > > > +			"requiring stable pages writes; forcing read-only "
> > > > +			"mode.  Upgrading to ext4 is recommended.");
> > > > +		res =3D MS_RDONLY;
> > > > +	}
> > > >  	if (read_only)
> > > >  		return res;
> > > >  	if (!(sbi->s_mount_state & EXT3_VALID_FS))
> > >   Why this? ext3 should be fixed by your change to
> > > filemap_page_mkwrite()... Or does testing show otherwise?
> >=20
> > Yes, it's still broken even with this new set of changes.  Now that I t=
hink
> > about it a little more, I recall that writeback mode was actually fine,=
 so this
> > is a little harsh.
> >=20
> > Hm... looking at the ordered code a little more, it looks like
> > ext3_ordered_write_end is calling journal_dirty_data_fn, which (I guess=
?) tries
> > to write mapped buffers back through the journal?  Taking it out seems =
to fix
> > ordered mode, though I have a suspicion that it might very well break o=
rdered
> > mode too.
>   Oh, right. kjournald writing buffers directly (without setting
> PageWriteback) will break things. So please, change warning to:
>=20
> 	/*
> 	 * In data=3Dordered mode, kjournald writes buffers without setting
> 	 * PageWriteback bit thus generic code does not properly wait for
> 	 * writeback of those buffers to finish.
> 	 */
> 	if (!read_only &&
> 	    test_opt(sb, DATA_FLAGS) =3D=3D EXT3_MOUNT_ORDERED_DATA &&
> 	    queue_requires_stable_pages(bdev_get_queue(sb->s_bdev))) {
> 		ext3_msg(sb, KERN_ERR,
> 			"error: data=3Dordered mode does not support stable "
> 			"page writes required by the disk; forcing read-only "
> 			"mode. Upgrading to ext4 is recommended.");
> 		res =3D MS_RDONLY;
> 	}
>=20
> then you need a similar check in ext3_remount() so that filesystem cannot
> be remounted read-write.
>=20
> 								Honza

Given this restriction, there is no way that I can change md/raid5 to set t=
he
"stable pages" flag and stop copying pages into the stripe-cache.  ext3 on
raid5 will be much too common to allow this breakage.

I would really like to be able to say "I prefer stable pages, but they aren=
't
a requirement as long as I know which is which" ....

NeilBrown

--Sig_/h.yWshvrZGapGhRWIvU.Aq/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUK1L4Tnsnt1WYoG5AQLJCQ//Uw6VPkA7iwwa3Zg4zx8wQ6UUZfQE3wmn
Rlpvef+TjXzNfg+JcZ56qQFlXLEbQtT7cWTqzRrlJqR24UJsY0UN/ybFnTcNgMg0
nT0tv6Fw3KegyuAwFFpa6F3oqPEdUcSsduAGDdAwGsa0PiGX+4dOlroOwD0zn501
hUbmM4SBGDVumLle8IgTdwliaFc7JEDoxLzO8zHaSpeALsj28mOOrGfSsTrwD7kn
RsT2jAa5uQCXws+tLI4WwRgHJ32LP1KWbpPWqNWs9m0WG95wqXlZe6lBUmgr9ie1
dXtJ6/pYFI4MeBBCju8Qsg5q2CWfMQjNKRRWdDj7dz09dvR7EM4Xz93M1c6svMor
eASbQyrvBNaQ+ypQwP46vTZJaC3/SXEXePbuyWfqvclzXTpkq7O5zdMwPUkxBLgl
bqNBZ6EQylZ5ME/+wX9RiLeT8WqogVeDxXzEyqpy6AwdnYCxVi9cqEm9X/u2Zqi/
8Qd49C+mN/aKBBVlEHwa+rTwOu22VrpdXNpg+6kMSCVB9ZZCwG8rpbNmA9eNz4J/
Fa28rGgPmKRUIQ/X6YSKtA4fGjXx4FjVTVxNzDdCFfGVpW5H7QL+T0QuCfw5H+IJ
UrSVdN3zNexXh8Tth2EiVIkYWWxElM62MFA40DoQez1tq6FSEo7DmDNQyW3UPMD9
g8vE50Nmqns=
=xECc
-----END PGP SIGNATURE-----

--Sig_/h.yWshvrZGapGhRWIvU.Aq/--
