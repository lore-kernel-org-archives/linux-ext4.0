From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/3] ext4: remove block bitmap initialization in ext4_new_inode()
Date: Sat, 14 Jan 2012 20:41:50 +0200
Message-ID: <CAOQ4uxhwTOvibaVEKZ9OONCtJcVbAmYMYmVMvOX8=8KheUF2HQ@mail.gmail.com>
References: <1326490249-1685-1-git-send-email-tytso@mit.edu>
	<1326490249-1685-2-git-send-email-tytso@mit.edu>
	<00C2AC6D-7D45-4FFF-B509-77BFD21BC093@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43608 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752306Ab2ANSlw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 Jan 2012 13:41:52 -0500
Received: by lahc1 with SMTP id c1so232604lah.19
        for <linux-ext4@vger.kernel.org>; Sat, 14 Jan 2012 10:41:50 -0800 (PST)
In-Reply-To: <00C2AC6D-7D45-4FFF-B509-77BFD21BC093@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 14, 2012 at 7:02 AM, Andreas Dilger <adilger@dilger.ca> wro=
te:
>
> On 2012-01-13, at 2:30 PM, Theodore Ts'o wrote:
> > We don't need to initialize the block bitmap when we allocate a new
> > inode.
>
> The reason the block bitmap is initialized when an inode is allocated
> in that group is to indicate that the inode bitmap is in use, and the
> inode table blocks are also in use.

but the inode table blocks will not be from this block group when flex_=
bg
is used and if it's the first group of a flex_bg group, then it's bitma=
ps
are already initialized by mkfs/resize.

>
> > This is old code from the very early days that is just
> > confusing things, and also has the problem of modifying the block
> > group descriptor without obeying the ext4_journal_get_write_access(=
) /
> > ext4_handle_dirty_metadata() modification protocols.
>
> The group descriptor was already modified earlier on when the inode w=
as
> being allocated from the group, so the group descriptor block was alr=
eady
> accounted for in the transaction credits after "repeat_in_this_group:=
"
>
> repeat_in_this_group:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ino =3D ext4_find_next_zero_bit((unsig=
ned long *)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0inode_bitmap_bh->b_data,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0EXT4_INODES_PER_GROUP(sb), ino);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ino < EXT4_INODES_PER_GROUP(sb)) {
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUFFER_TRACE(inode_bit=
map_bh, "get_write_access");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D ext4_journal_g=
et_write_access(handle,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode_bitmap_bh);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto f=
ail;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUFFER_TRACE(group_des=
c_bh, "get_write_access");
> *****>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D ext4_journal_get_write_=
access(handle,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0group_desc_bh);
>
> That is why ext4_handle_dirty_metadata() isn't called until after the=
 group
> descriptor is modified during the block bitmap initialization.
>
>
> I'm not wholly against removing this code, but we have to do it with =
the
> clear understanding that we will have inodes in use for which the blo=
ck
> bitmap is showing that the in-use blocks are free. =A0This doesn't se=
em like
> a great situation to me.
>
>
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> > ---
> > fs/ext4/ialloc.c | =A0 31 -------------------------------
> > 1 files changed, 0 insertions(+), 31 deletions(-)
> >
> > diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> > index 72fc989..a4ce10f 100644
> > --- a/fs/ext4/ialloc.c
> > +++ b/fs/ext4/ialloc.c
> > @@ -807,37 +807,6 @@ repeat_in_this_group:
> > =A0 =A0 =A0 goto out;
> >
> > got:
> > - =A0 =A0 /* We may have to initialize the block bitmap if it isn't=
 already */
> > - =A0 =A0 if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT=
_GDT_CSUM) &&
> > - =A0 =A0 =A0 =A0 gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)=
) {
> > - =A0 =A0 =A0 =A0 =A0 =A0 struct buffer_head *block_bitmap_bh;
> > -
> > - =A0 =A0 =A0 =A0 =A0 =A0 block_bitmap_bh =3D ext4_read_block_bitma=
p(sb, group);
> > - =A0 =A0 =A0 =A0 =A0 =A0 BUFFER_TRACE(block_bitmap_bh, "get block =
bitmap access");
> > - =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_journal_get_write_access(han=
dle, block_bitmap_bh);
> > - =A0 =A0 =A0 =A0 =A0 =A0 if (err) {
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 brelse(block_bitmap_bh);
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail;
> > - =A0 =A0 =A0 =A0 =A0 =A0 }
> > -
> > - =A0 =A0 =A0 =A0 =A0 =A0 BUFFER_TRACE(block_bitmap_bh, "dirty bloc=
k bitmap");
> > - =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_handle_dirty_metadata(handle=
, NULL, block_bitmap_bh);
> > - =A0 =A0 =A0 =A0 =A0 =A0 brelse(block_bitmap_bh);
> > -
> > - =A0 =A0 =A0 =A0 =A0 =A0 /* recheck and clear flag under lock if w=
e still need to */
> > - =A0 =A0 =A0 =A0 =A0 =A0 ext4_lock_group(sb, group);
> > - =A0 =A0 =A0 =A0 =A0 =A0 if (gdp->bg_flags & cpu_to_le16(EXT4_BG_B=
LOCK_UNINIT)) {
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 gdp->bg_flags &=3D cpu_to=
_le16(~EXT4_BG_BLOCK_UNINIT);
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_free_group_clusters_=
set(sb, gdp,
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_free=
_clusters_after_init(sb, group, gdp));
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 gdp->bg_checksum =3D ext4=
_group_desc_csum(sbi, group,
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 gdp);
> > - =A0 =A0 =A0 =A0 =A0 =A0 }
> > - =A0 =A0 =A0 =A0 =A0 =A0 ext4_unlock_group(sb, group);
> > -
> > - =A0 =A0 =A0 =A0 =A0 =A0 if (err)
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail;
> > - =A0 =A0 }
> > =A0 =A0 =A0 BUFFER_TRACE(group_desc_bh, "call ext4_handle_dirty_met=
adata");
> > =A0 =A0 =A0 err =3D ext4_handle_dirty_metadata(handle, NULL, group_=
desc_bh);
> > =A0 =A0 =A0 if (err)
> > --
> > 1.7.8.11.gefc1f.dirty
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>
>
> Cheers, Andreas
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
