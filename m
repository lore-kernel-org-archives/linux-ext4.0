From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/2] Use ext4_ext_next_allocated_block instead of mext_next_extent
Date: Fri, 15 Aug 2014 20:08:53 +0400
Message-ID: <87mwb5d9be.fsf@openvz.org>
References: <1407944711-5025-1-git-send-email-dmonakhov@openvz.org> <alpine.LFD.2.00.1408141659560.2267@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:59704 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaHOQI5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Aug 2014 12:08:57 -0400
Received: by mail-la0-f41.google.com with SMTP id s18so2503539lam.28
        for <linux-ext4@vger.kernel.org>; Fri, 15 Aug 2014 09:08:56 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1408141659560.2267@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 14 Aug 2014 17:03:59 +0200 (CEST), Luk=C3=A1=C5=A1 Czerner <lcz=
erner@redhat.com> wrote:
> On Wed, 13 Aug 2014, Dmitry Monakhov wrote:
>=20
> > Date: Wed, 13 Aug 2014 19:45:10 +0400
> > From: Dmitry Monakhov <dmonakhov@openvz.org>
> > To: linux-ext4@vger.kernel.org
> > Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
> > Subject: [PATCH 1/2] Use ext4_ext_next_allocated_block instead of
> >     mext_next_extent
> >=20
> > This allow to make mext_next_extent static.
> >=20
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > ---
> >  fs/ext4/ext4.h        |    2 --
> >  fs/ext4/extents.c     |   18 ++++++------------
> >  fs/ext4/move_extent.c |    2 +-
> >  3 files changed, 7 insertions(+), 15 deletions(-)
> >=20
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index 5b19760..f8d85f7 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -2739,8 +2739,6 @@ extern void ext4_double_up_write_data_sem(str=
uct inode *orig_inode,
> >  extern int ext4_move_extents(struct file *o_filp, struct file *d_f=
ilp,
> >  			     __u64 start_orig, __u64 start_donor,
> >  			     __u64 len, __u64 *moved_len);
> > -extern int mext_next_extent(struct inode *inode, struct ext4_ext_p=
ath *path,
> > -			    struct ext4_extent **extent);
> > =20
> >  /* page-io.c */
> >  extern int __init ext4_init_pageio(void);
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 76c2df3..2e38ecb 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -5304,7 +5304,7 @@ ext4_ext_shift_extents(struct inode *inode, h=
andle_t *handle,
> >  	struct ext4_ext_path *path;
> >  	int ret =3D 0, depth;
> >  	struct ext4_extent *extent;
> > -	ext4_lblk_t stop_block, current_block;
> > +	ext4_lblk_t stop_block;
> >  	ext4_lblk_t ex_start, ex_end;
> > =20
> >  	/* Let path point to the last extent */
> > @@ -5365,18 +5365,12 @@ ext4_ext_shift_extents(struct inode *inode,=
 handle_t *handle,
> >  					 (unsigned long) start);
> >  			return -EIO;
> >  		}
> > -
> > -		current_block =3D le32_to_cpu(extent->ee_block);
> > -		if (start > current_block) {
> > +		if (start > le32_to_cpu(extent->ee_block)) {
> >  			/* Hole, move to the next extent */
> > -			ret =3D mext_next_extent(inode, path, &extent);
> > -			if (ret !=3D 0) {
> > -				ext4_ext_drop_refs(path);
> > -				kfree(path);
> > -				if (ret =3D=3D 1)
> > -					ret =3D 0;
> > -				break;
> > -			}
> > +			start =3D ext4_ext_next_allocated_block(path);
> > +			ext4_ext_drop_refs(path);
> > +			kfree(path);
> > +			continue;
>=20
> It seems to me that this will affect the performance of the shift as
> we would potentially need to do more iteration, because the current
> code would update the "extents" to the actual next extent and then
> then do the shift right away, while your solution just finds the
> next block and then jumps at the beginning of the loop to generate
> path and find the extent all over again. What do you think ?
Agree,  leaf case must be optimized:
          if (extent < EXT_LAST_EXTENT(path[depth].p_hdr))
                      path[depth].p_ext++;
Will be back with new version.

>=20
> -Lukas
>=20
> >  		}
> >  		ret =3D ext4_ext_shift_path_extents(path, shift, inode,
> >  				handle, &start);
> > diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> > index 671a74b..123a51b 100644
> > --- a/fs/ext4/move_extent.c
> > +++ b/fs/ext4/move_extent.c
> > @@ -76,7 +76,7 @@ copy_extent_status(struct ext4_extent *src, struc=
t ext4_extent *dest)
> >   * ext4_ext_path structure refers to the last extent, or a negativ=
e error
> >   * value on failure.
> >   */
> > -int
> > +static int
> >  mext_next_extent(struct inode *inode, struct ext4_ext_path *path,
> >  		      struct ext4_extent **extent)
> >  {
> >=20
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
