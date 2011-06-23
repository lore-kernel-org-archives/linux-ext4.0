From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH v2] ext4: avoid eh_entries overflow before insert extent_idx
Date: Thu, 23 Jun 2011 17:00:38 +0800
Message-ID: <BANLkTimwAyb5AA5YfG92mXbkRBgAd5dKiQ@mail.gmail.com>
References: <1308818837-5243-1-git-send-email-sanbai@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35236 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab1FWJAi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jun 2011 05:00:38 -0400
Received: by pvg12 with SMTP id 12so1017476pvg.19
        for <linux-ext4@vger.kernel.org>; Thu, 23 Jun 2011 02:00:38 -0700 (PDT)
In-Reply-To: <1308818837-5243-1-git-send-email-sanbai@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 23, 2011 at 4:47 PM, Robin Dong <hao.bigrat@gmail.com> wrot=
e:
> If eh_entries is equal to (or greater than) eh_max, the operation of
> inserting new extent_idx will make number of entries overflow.
> So check eh_entries before inserting the new extent_idx.
>
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> ---
> =A0fs/ext4/extents.c | =A0 18 ++++++++++--------
> =A01 files changed, 10 insertions(+), 8 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index eb63c7b..792e77e 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -776,6 +776,16 @@ static int ext4_ext_insert_index(handle_t *handl=
e, struct inode *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 logic=
al, le32_to_cpu(curp->p_idx->ei_block));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EIO;
> =A0 =A0 =A0 =A0}
> +
> + =A0 =A0 =A0 if (unlikely(le16_to_cpu(curp->p_hdr->eh_entries)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0>=3D le16_to=
_cpu(curp->p_hdr->eh_max))) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_ERROR_INODE(inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"eh_=
entries %d >=3D eh_max %d!",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0le16=
_to_cpu(curp->p_hdr->eh_entries),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0le16=
_to_cpu(curp->p_hdr->eh_max));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0len =3D EXT_MAX_INDEX(curp->p_hdr) - curp->p_idx;
> =A0 =A0 =A0 =A0if (logical > le32_to_cpu(curp->p_idx->ei_block)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* insert after */
> @@ -805,14 +815,6 @@ static int ext4_ext_insert_index(handle_t *handl=
e, struct inode *inode,
> =A0 =A0 =A0 =A0ext4_idx_store_pblock(ix, ptr);
> =A0 =A0 =A0 =A0le16_add_cpu(&curp->p_hdr->eh_entries, 1);
>
> - =A0 =A0 =A0 if (unlikely(le16_to_cpu(curp->p_hdr->eh_entries)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0> le16_to_cp=
u(curp->p_hdr->eh_max))) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_ERROR_INODE(inode,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"eh_=
entries %d > eh_max %d!",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0le16=
_to_cpu(curp->p_hdr->eh_entries),
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0le16=
_to_cpu(curp->p_hdr->eh_max));
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> - =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0if (unlikely(ix > EXT_LAST_INDEX(curp->p_hdr))) {
condition ix > EXT_LAST_INDEX(curp->p_hdr) can not be true.  Right?
May be we can remove this if-statement in this patch.

Yongqiang.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_ERROR_INODE(inode, "ix > EXT_LAST=
_INDEX!");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EIO;
> --
> 1.7.1
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
