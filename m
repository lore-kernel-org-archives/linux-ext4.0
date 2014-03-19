From: Lubos Uhliarik <uhliarik@seznam.cz>
Subject: Re: [RFC][PATCH 1/1] ext4: Undelete Feature for Ext4
Date: Wed, 19 Mar 2014 14:59:04 +0100
Message-ID: <1395237544.15587.15.camel@zerobox.home>
References: <1395155384.15587.10.camel@zerobox.home>
	 <2C2D46FC-AB12-41F2-BF92-427FD5965C26@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, vojnar@fit.vutbr.cz,
	lczerner@redhat.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.seznam.cz ([77.75.72.43]:56483 "EHLO smtp1.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933817AbaCSOOB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Mar 2014 10:14:01 -0400
In-Reply-To: <2C2D46FC-AB12-41F2-BF92-427FD5965C26@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,

maybe you didn't notice, but I sent comments in email with subject
"[RFC][PATCH 0/1] ext4: Undelete Feature for Ext4". Maybe, I should
mention this in [PATCH 1/1]. In this mail is also link to git repositor=
y
with undelete app (uses ext2fslibs), which demonstrates how to undelete
file with changes in kernel.

I hope, it will help you.

Regards,

Lubos

Andreas Dilger p=C3=AD=C5=A1e v =C3=9At 18. 03. 2014 v 12:23 -0600:
> On Mar 18, 2014, at 9:09 AM, Lubos Uhliarik <uhliarik@seznam.cz> wrot=
e:
> > This patch should make undelete process for deleted files under ext=
4 fs easier.
>=20
> Hi Lubos,
> thanks for the interesting patch.  This does seem like an improvement=
=2E
> It would be good to add more description to your commit comment, sinc=
e
> it should explain what is actually being done in your patch (e.g. sto=
re
> the extent count and depth in the ext4_extent_header eh_generation fi=
eld,
> ...).
>=20
> It would also be good to include a matching patch for e2fsprogs debug=
fs
> in the "undelete" command.  I think one obstacle is the fact that ino=
des
> have their blocks zeroed out by the kernel during truncation.  It wou=
ld
> be necessary to change the kernel slightly to avoid writing out i_blo=
cks
> with zero if the inode is being deleted.  Otherwise, this change is n=
ot
> as useful as it could be.
>=20
> Cheers, Andreas
>=20
> > Signed-off-by: Lubos Uhliarik <uhliarik@seznam.cz>
> > ---
> > fs/ext4/ext4_extents.h | 14 +++++++++++
> > fs/ext4/extents.c      | 67 +++++++++++++++++++++++++++++++++++++++=
++++++-----
> > 2 files changed, 75 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
> > index 5074fe2..22cf2cd 100644
> > --- a/fs/ext4/ext4_extents.h
> > +++ b/fs/ext4/ext4_extents.h
> > @@ -251,6 +251,20 @@ static inline void ext4_ext_store_pblock(struc=
t ext4_extent *ex,
> > 				      0xffff);
> > }
> >=20
> > +static inline void ext4_ext_store_entries(struct ext4_extent_heade=
r *eh,
> > +					  __u16 eh_entries){
> > +	eh->eh_generation &=3D cpu_to_le32((unsigned long) 0x0000ffff);
> > +	eh->eh_generation |=3D cpu_to_le32(((unsigned long) (eh_entries) =
<< 16)
> > +				& 0xffff0000);
> > +}
> > +
> > +static inline void ext4_ext_store_depth(struct ext4_extent_header =
*eh,
> > +					 __u16 eh_depth){
> > +	eh->eh_generation &=3D cpu_to_le32((unsigned long) 0xffff0000);
> > +	eh->eh_generation |=3D cpu_to_le32(((unsigned long) (eh_depth))
> > +				& 0x0000ffff);
> > +}
> > +
> > /*
> >  * ext4_idx_store_pblock:
> >  * stores a large physical block number into an index struct,
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 74bc2d5..f0f3615 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -2565,6 +2565,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct ino=
de *inode,
> > 	ext4_lblk_t ex_ee_block;
> > 	unsigned short ex_ee_len;
> > 	unsigned uninitialized =3D 0;
> > +	unsigned short ex_ee_entries;
> > 	struct ext4_extent *ex;
> > 	ext4_fsblk_t pblk;
> >=20
> > @@ -2584,6 +2585,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct ino=
de *inode,
> >=20
> > 	ex_ee_block =3D le32_to_cpu(ex->ee_block);
> > 	ex_ee_len =3D ext4_ext_get_actual_len(ex);
> > +	ex_ee_entries =3D le16_to_cpu(eh->eh_entries);
> >=20
> > 	trace_ext4_ext_rm_leaf(inode, start, ex, *partial_cluster);
> >=20
> > @@ -2662,11 +2664,9 @@ ext4_ext_rm_leaf(handle_t *handle, struct in=
ode *inode,
> > 		if (err)
> > 			goto out;
> >=20
> > -		if (num =3D=3D 0)
> > -			/* this extent is removed; mark slot entirely unused */
> > -			ext4_ext_store_pblock(ex, 0);
> > +		if (num !=3D 0)
> > +			ex->ee_len =3D cpu_to_le16(num);
> >=20
> > -		ex->ee_len =3D cpu_to_le16(num);
> > 		/*
> > 		 * Do not mark uninitialized if all the blocks in the
> > 		 * extent have been removed.
> > @@ -2726,8 +2726,19 @@ ext4_ext_rm_leaf(handle_t *handle, struct in=
ode *inode,
> >=20
> > 	/* if this leaf is free, then we should
> > 	 * remove it from index block above */
> > -	if (err =3D=3D 0 && eh->eh_entries =3D=3D 0 && path[depth].p_bh !=
=3D NULL)
> > +	if (err =3D=3D 0 && eh->eh_entries =3D=3D 0 && path[depth].p_bh !=
=3D NULL) {
> > +		err =3D ext4_ext_get_access(handle, inode, path + depth);
> > +		if (err)
> > +			goto out;
> > +
> > +		ext4_ext_store_entries(path[depth].p_hdr, ex_ee_entries);
> > +
> > +		err =3D ext4_ext_dirty(handle, inode, path + depth);
> > +		if (err)
> > +			goto out;
> > +
> > 		err =3D ext4_ext_rm_idx(handle, inode, path, depth);
> > +	}
> >=20
> > out:
> > 	return err;
> > @@ -2760,6 +2771,7 @@ int ext4_ext_remove_space(struct inode *inode=
, ext4_lblk_t start,
> > 	struct super_block *sb =3D inode->i_sb;
> > 	int depth =3D ext_depth(inode);
> > 	struct ext4_ext_path *path =3D NULL;
> > +	unsigned short *entries_path =3D NULL;
> > 	long long partial_cluster =3D 0;
> > 	handle_t *handle;
> > 	int i =3D 0, err =3D 0;
> > @@ -2864,6 +2876,18 @@ again:
> > 	}
> > 	err =3D 0;
> >=20
> > +	if (!inode->i_nlink) {
> > +		entries_path =3D kzalloc(sizeof(short) * (depth + 1),
> > +				       GFP_NOFS);
> > +		if (entries_path =3D=3D NULL) {
> > +			kfree(path);
> > +			ext4_journal_stop(handle);
> > +			return -ENOMEM;
> > +		}
> > +
> > +		entries_path[0] =3D le16_to_cpu(ext_inode_hdr(inode)->eh_entries=
);
> > +	}
> > +
> > 	while (i >=3D 0 && err =3D=3D 0) {
> > 		if (i =3D=3D depth) {
> > 			/* this is leaf block */
> > @@ -2890,6 +2914,10 @@ again:
> > 			ext_debug("init index ptr: hdr 0x%p, num %d\n",
> > 				  path[i].p_hdr,
> > 				  le16_to_cpu(path[i].p_hdr->eh_entries));
> > +			if (entries_path !=3D NULL) {
> > +				entries_path[i] =3D le16_to_cpu(
> > +					path[i].p_hdr->eh_entries);
> > +			}
> > 		} else {
> > 			/* we were already here, see at next index */
> > 			path[i].p_idx--;
> > @@ -2928,10 +2956,24 @@ again:
> > 		} else {
> > 			/* we finished processing this index, go up */
> > 			if (path[i].p_hdr->eh_entries =3D=3D 0 && i > 0) {
> > +				if (entries_path !=3D NULL) {
> > +					err =3D ext4_ext_get_access(handle,
> > +						inode, path);
> > +					if (err =3D=3D 0) {
> > +						ext4_ext_store_entries(
> > +							path[i].p_hdr,
> > +							(entries_path[i]));
> > +						err =3D ext4_ext_dirty(handle,
> > +							inode, path);
> > +					}
> > +				}
> > +
> > 				/* index is empty, remove it;
> > 				 * handle must be already prepared by the
> > 				 * truncatei_leaf() */
> > -				err =3D ext4_ext_rm_idx(handle, inode, path, i);
> > +				if (err =3D=3D 0)
> > +					err =3D ext4_ext_rm_idx(handle, inode,
> > +						path, i);
> > 			}
> > 			/* root level has p_bh =3D=3D NULL, brelse() eats this */
> > 			brelse(path[i].p_bh);
> > @@ -2964,6 +3006,17 @@ again:
> > 		 */
> > 		err =3D ext4_ext_get_access(handle, inode, path);
> > 		if (err =3D=3D 0) {
> > +			/* Store depth and entries to eh_generation to make
> > +			 * recovering deleted files easier. */
> > +			if (entries_path !=3D NULL) {
> > +				ext4_ext_store_entries(ext_inode_hdr(inode),
> > +					(entries_path[0]));
> > +
> > +				ext4_ext_store_depth(ext_inode_hdr(inode),
> > +					le16_to_cpu(
> > +					ext_inode_hdr(inode)->eh_depth));
> > +			}
> > +
> > 			ext_inode_hdr(inode)->eh_depth =3D 0;
> > 			ext_inode_hdr(inode)->eh_max =3D
> > 				cpu_to_le16(ext4_ext_space_root(inode, 0));
> > @@ -2973,6 +3026,8 @@ again:
> > out:
> > 	ext4_ext_drop_refs(path);
> > 	kfree(path);
> > +	kfree(entries_path);
> > +
> > 	if (err =3D=3D -EAGAIN) {
> > 		path =3D NULL;
> > 		goto again;
> > --=20
> > 1.8.3.2
> >=20
> >=20
> >=20
> >=20
> >=20
> >=20
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20
> Cheers, Andreas
>=20
>=20
>=20
>=20
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
