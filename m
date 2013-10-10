From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 22/31] libext2fs: During punch, only free a cluster if
 we're sure that all blocks in the cluster are being punched
Date: Thu, 10 Oct 2013 12:29:09 -0700
Message-ID: <20131010192909.GP6860@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012903.28415.39499.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1310101737351.1925@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51233 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979Ab3JJT3T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Oct 2013 15:29:19 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1310101737351.1925@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 10, 2013 at 05:53:37PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Mon, 30 Sep 2013, Darrick J. Wong wrote:
>=20
> > Date: Mon, 30 Sep 2013 18:29:03 -0700
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > To: tytso@mit.edu, darrick.wong@oracle.com
> > Cc: linux-ext4@vger.kernel.org
> > Subject: [PATCH 22/31] libext2fs: During punch,
> >     only free a cluster if we're sure that all blocks in the cluste=
r are being
> >      punched
> >=20
> > When bigalloc is enabled, using ext2fs_block_alloc_stats2() to free=
 any block
> > in a cluster has the effect of freeing the entire cluster.  This is=
 problematic
> > if a caller instructs us to punch, say, blocks 12-15 of a 16-block =
cluster,
> > because blocks 0-11 now point to a "free" cluster.
> >=20
> > The naive way to solve this problem is to see if any of the other b=
locks in
> > this logical cluster map to a physical cluster.  If so, then we kno=
w that the
> > cluster is still in use and it mustn't be freed.  Otherwise, we are=
 punching
> > the last mapped block in this cluster, so we can free the cluster.
> >=20
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  lib/ext2fs/bmap.c   |   28 ++++++++++++++++++++++++++++
> >  lib/ext2fs/ext2fs.h |    3 +++
> >  lib/ext2fs/punch.c  |   30 +++++++++++++++++++++++++-----
> >  3 files changed, 56 insertions(+), 5 deletions(-)
> >=20
> >=20
> > diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
> > index 5074587..a6e35a9 100644
> > --- a/lib/ext2fs/bmap.c
> > +++ b/lib/ext2fs/bmap.c
> > @@ -173,6 +173,34 @@ static errcode_t implied_cluster_alloc(ext2_fi=
lsys fs, ext2_ino_t ino,
> >  	return 0;
> >  }
> > =20
> > +errcode_t ext2fs_map_cluster_block(ext2_filsys fs, ext2_ino_t ino,
> > +				   struct ext2_inode *inode, blk64_t lblk,
> > +				   blk64_t *pblk)
> > +{
> > +	ext2_extent_handle_t handle;
> > +	errcode_t retval;
> > +
> > +	/* Need bigalloc and extents to be enabled */
> > +	*pblk =3D 0;
> > +	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
> > +					EXT4_FEATURE_RO_COMPAT_BIGALLOC) ||
> > +	    !(inode->i_flags & EXT4_EXTENTS_FL))
> > +		return 0;
> > +
> > +	retval =3D ext2fs_extent_open2(fs, ino, inode, &handle);
> > +	if (retval)
> > +		goto out;
> > +
> > +	retval =3D implied_cluster_alloc(fs, ino, inode, handle, lblk, pb=
lk);
> > +	if (retval)
> > +		goto out2;
> > +
> > +out2:
> > +	ext2fs_extent_free(handle);
> > +out:
> > +	return retval;
> > +}
> > +
> >  static errcode_t extent_bmap(ext2_filsys fs, ext2_ino_t ino,
> >  			     struct ext2_inode *inode,
> >  			     ext2_extent_handle_t handle,
> > diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> > index 9fef6d3..88da8db 100644
> > --- a/lib/ext2fs/ext2fs.h
> > +++ b/lib/ext2fs/ext2fs.h
> > @@ -925,6 +925,9 @@ extern errcode_t ext2fs_bmap2(ext2_filsys fs, e=
xt2_ino_t ino,
> >  			      struct ext2_inode *inode,
> >  			      char *block_buf, int bmap_flags, blk64_t block,
> >  			      int *ret_flags, blk64_t *phys_blk);
> > +errcode_t ext2fs_map_cluster_block(ext2_filsys fs, ext2_ino_t ino,
> > +				   struct ext2_inode *inode, blk64_t lblk,
> > +				   blk64_t *pblk);
> > =20
> >  #if 0
> >  /* bmove.c */
> > diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
> > index 4471f46..e0193b0 100644
> > --- a/lib/ext2fs/punch.c
> > +++ b/lib/ext2fs/punch.c
> > @@ -183,8 +183,8 @@ static errcode_t ext2fs_punch_extent(ext2_filsy=
s fs, ext2_ino_t ino,
> >  	ext2_extent_handle_t	handle =3D 0;
> >  	struct ext2fs_extent	extent;
> >  	errcode_t		retval;
> > -	blk64_t			free_start, next;
> > -	__u32			free_count, newlen;
> > +	blk64_t			free_start, next, lfree_start, pblk;
> > +	__u32			free_count, newlen, cluster_freed;
> >  	int			freed =3D 0;
> >  	int			op;
> > =20
> > @@ -210,6 +210,7 @@ static errcode_t ext2fs_punch_extent(ext2_filsy=
s fs, ext2_ino_t ino,
> >  			/* Start of deleted region before extent;=20
> >  			   adjust beginning of extent */
> >  			free_start =3D extent.e_pblk;
> > +			lfree_start =3D extent.e_lblk;
> >  			if (next > end)
> >  				free_count =3D end - extent.e_lblk + 1;
> >  			else
> > @@ -225,6 +226,7 @@ static errcode_t ext2fs_punch_extent(ext2_filsy=
s fs, ext2_ino_t ino,
> >  			dbg_printf("Case #%d\n", 2);
> >  			newlen =3D start - extent.e_lblk;
> >  			free_start =3D extent.e_pblk + newlen;
> > +			lfree_start =3D extent.e_lblk + newlen;
> >  			free_count =3D extent.e_len - newlen;
> >  			extent.e_len =3D newlen;
> >  		} else {
> > @@ -240,6 +242,7 @@ static errcode_t ext2fs_punch_extent(ext2_filsy=
s fs, ext2_ino_t ino,
> > =20
> >  			extent.e_len =3D start - extent.e_lblk;
> >  			free_start =3D extent.e_pblk + extent.e_len;
> > +			lfree_start =3D extent.e_lblk + extent.e_len;
> >  			free_count =3D end - start + 1;
> > =20
> >  			dbg_print_extent("inserting", &newex);
> > @@ -280,9 +283,26 @@ static errcode_t ext2fs_punch_extent(ext2_fils=
ys fs, ext2_ino_t ino,
> >  			goto errout;
> >  		dbg_printf("Free start %llu, free count =3D %u\n",
> >  		       free_start, free_count);
> > -		while (free_count-- > 0) {
> > -			ext2fs_block_alloc_stats2(fs, free_start++, -1);
> > -			freed++;
> > +		while (free_count > 0) {
> > +			retval =3D ext2fs_map_cluster_block(fs, ino, inode,
> > +							  lfree_start, &pblk);
> > +			if (retval)
> > +				goto errout;
> > +			if (!pblk) {
> > +				ext2fs_block_alloc_stats2(fs, free_start, -1);
> > +				freed++;
> > +				cluster_freed =3D EXT2FS_CLUSTER_RATIO(fs) -
> > +					(free_start & EXT2FS_CLUSTER_MASK(fs));
> > +				if (cluster_freed > free_count)
> > +					cluster_freed =3D free_count;
> > +				free_count -=3D cluster_freed;
> > +				free_start +=3D cluster_freed;
> > +				lfree_start +=3D cluster_freed;
> > +				continue;
> > +			}
> > +			free_count--;
> > +			free_start++;
> > +			lfree_start++;
>=20
> I think that this is a little bit excessive. What I think we should
> do here is to identify first and last partial cluster and possibly
> call ext2fs_map_cluster_block() for those since we might or might
> not want to free then depending on whether there are other blocks in
> it in-use.
>=20
> Then just iterate over the whole clusters in between and free them
> all. Having to call ext2fs_map_cluster_block() for every single
> block we're freeing from the extent tree is not really necessary I th=
ink
> especially since we really need to get this information for those
> possibly partial clusters at the start and end of the extent.

Hmm.  I think I could eliminate the middle ext2fs_map_cluster_block() c=
alls by
only calling it if free_start is within cluster_ratio blocks of the pre=
-loop
value of free_start, or if free_count < cluster_ratio.  I can also spli=
t the
whole thing into three loops (pre-cluster, clusters, and post-cluster),=
 though
for the non-bigalloc case I'd skip to the middle loop.

--D
>=20
> Thanks!
> -Lukas
>=20
>=20
> >  		}
> >  	next_extent:
> >  		retval =3D ext2fs_extent_get(handle, op,
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
