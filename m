From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Why do we initialize block bitmaps in ext4_new_inode()
Date: Mon, 14 Mar 2011 21:13:10 +0200
Message-ID: <AANLkTikcsteV8Fatf-8uydyhYaNXxQgQHSsy3BdhBjXE@mail.gmail.com>
References: <E1PzBop-0007a0-BN@tytso-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37353 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab1CNTNM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Mar 2011 15:13:12 -0400
Received: by qyg14 with SMTP id 14so4662499qyg.19
        for <linux-ext4@vger.kernel.org>; Mon, 14 Mar 2011 12:13:11 -0700 (PDT)
In-Reply-To: <E1PzBop-0007a0-BN@tytso-glaptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 14, 2011 at 7:44 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> Is there some subtle reason why ext4_new_inode() checked for
> uninitialized block bitmaps and initialized the block bitmaps in
> ext4_new_inode(). =A0It's not immediately needed in that function, an=
d I
> don't see any reason why initializing the inode table or inode
> allocation bitmap requires initializing the block bitmap.
>
> Am I missing something?

If you are, then I am missing it too.
Was there ever a time when uninit_bg meant something other than it mean=
s today?
Like wasn't it used by fsck for fast inode scan of ext3?
Does it mater anything for fsck if the block bitmap is not initialized
and the inode bitmap is?



>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0- Ted
>
>
> From ff15031626d5f10ba1256c0c7a3818ca12205b55 Mon Sep 17 00:00:00 200=
1
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Mon, 14 Mar 2011 13:37:36 -0400
> Subject: [PATCH] ext4: Remove block bitmap initialization in ext4_new=
_inode()
>
> We are initializing the block bitmap in ext4_new_inode(), and as far
> as I can tell, there's no reason to do it. =A0So remove it to simplif=
y
> things.
>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> =A0fs/ext4/ialloc.c | =A0 36 ------------------------------------
> =A01 files changed, 0 insertions(+), 36 deletions(-)
>
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 2fd3b0e..f79432a 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -936,42 +936,6 @@ repeat_in_this_group:
> =A0 =A0 =A0 =A0goto out;
>
> =A0got:
> - =A0 =A0 =A0 /* We may have to initialize the block bitmap if it isn=
't already */
> - =A0 =A0 =A0 if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMP=
AT_GDT_CSUM) &&
> - =A0 =A0 =A0 =A0 =A0 gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINI=
T)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct buffer_head *block_bitmap_bh;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 block_bitmap_bh =3D ext4_read_block_bit=
map(sb, group);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUFFER_TRACE(block_bitmap_bh, "get bloc=
k bitmap access");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_journal_get_write_access(h=
andle, block_bitmap_bh);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 brelse(block_bitmap_bh)=
;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 free =3D 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_lock_group(sb, group);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* recheck and clear flag under lock if=
 we still need to */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (gdp->bg_flags & cpu_to_le16(EXT4_BG=
_BLOCK_UNINIT)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 free =3D ext4_free_bloc=
ks_after_init(sb, group, gdp);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 gdp->bg_flags &=3D cpu_=
to_le16(~EXT4_BG_BLOCK_UNINIT);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_free_blks_set(sb, =
gdp, free);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 gdp->bg_checksum =3D ex=
t4_group_desc_csum(sbi, group,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 gdp);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_unlock_group(sb, group);
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Don't need to dirty bitmap block if =
we didn't change it */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (free) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUFFER_TRACE(block_bitm=
ap_bh, "dirty block bitmap");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_handle_dir=
ty_metadata(handle,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NULL, block_bitmap_bh);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 brelse(block_bitmap_bh);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail;
> - =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0BUFFER_TRACE(group_desc_bh, "call ext4_handle_dirty_me=
tadata");
> =A0 =A0 =A0 =A0err =3D ext4_handle_dirty_metadata(handle, NULL, group=
_desc_bh);
> =A0 =A0 =A0 =A0if (err)
> --
> 1.7.3.1
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
