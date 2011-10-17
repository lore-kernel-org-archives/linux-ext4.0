From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH] ext4: Check extent overflow with the right range.
Date: Mon, 17 Oct 2011 17:10:14 +0800
Message-ID: <CAGBYx2bTHT9BNYK6=tGzJd3neXR6WAOjvWLSzv5XpTYcTUeCnA@mail.gmail.com>
References: <20111017081036.GN30887@longonot.mountain>
	<1318841128-4540-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, dan.carpenter@oracle.com,
	"Theodore Ts'o" <tytso@mit.edu>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57934 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab1JQJKP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Oct 2011 05:10:15 -0400
Received: by ggnb1 with SMTP id b1so2022829ggn.19
        for <linux-ext4@vger.kernel.org>; Mon, 17 Oct 2011 02:10:15 -0700 (PDT)
In-Reply-To: <1318841128-4540-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 17, 2011 at 4:45 PM, Tao Ma <tm@tao.ma> wrote:
> From: Tao Ma <boyu.mt@taobao.com>
>
> In 4fd30c033, we move the range check before we change ix to avoid th=
e memory stamp.
> But actually we should check against the EXT_MAX_INDEX, not EXT_LAST_=
INDEX.
>
> So this patch revert the old patch and adds a new check before we set=
ting ix.
>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
> Ted, since 4fd30c033 is in your dev branch, I am fine to integrate th=
ese 2 patches to one.
>
> =A0fs/ext4/extents.c | =A0 =A09 +++++++--
> =A01 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 2dff31e..5c48612 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -779,8 +779,8 @@ static int ext4_ext_insert_index(handle_t *handle=
, struct inode *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ix =3D curp->p_idx;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 if (unlikely(ix > EXT_LAST_INDEX(curp->p_hdr))) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_ERROR_INODE(inode, "ix > EXT_LAST_=
INDEX!");
> + =A0 =A0 =A0 if (unlikely(ix > EXT_MAX_INDEX(curp->p_hdr))) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_ERROR_INODE(inode, "ix > EXT_MAX_I=
NDEX!");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EIO;
> =A0 =A0 =A0 =A0}
Hi Tao,

I think original LAST_INDEX check aims to verify all index entries are
contiguous, because max entries bas been checked by eh_entries >=3D
ex_max in previous code.
>
> @@ -788,6 +788,11 @@ static int ext4_ext_insert_index(handle_t *handl=
e, struct inode *inode,
> =A0 =A0 =A0 =A0ext4_idx_store_pblock(ix, ptr);
> =A0 =A0 =A0 =A0le16_add_cpu(&curp->p_hdr->eh_entries, 1);
>
> + =A0 =A0 =A0 if (unlikely(ix > EXT_LAST_INDEX(curp->p_hdr))) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_ERROR_INODE(inode, "ix > EXT_LAST_=
INDEX!");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> + =A0 =A0 =A0 }
> +
Actually I do not think we need a verification here.  The code is
short and we know that index entries are contiguous.


Yongqiang.
> =A0 =A0 =A0 =A0err =3D ext4_ext_dirty(handle, inode, curp);
> =A0 =A0 =A0 =A0ext4_std_error(inode->i_sb, err);
>
> --
> 1.6.3.3.334.g916e1.dirty
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
