From: "gnehzuil.liu" <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 1/2] ext4: call WARN_ON after the debug message
Date: Fri, 25 Jan 2013 00:44:19 +0800
Message-ID: <5FB53AD3-4F3F-4E63-8827-5DE3970EBD40@gmail.com>
References: <1359045044-31435-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>,
	Lukas Czerner <lczerner@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f45.google.com ([209.85.210.45]:37509 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab3AXQoe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2013 11:44:34 -0500
Received: by mail-da0-f45.google.com with SMTP id w4so4346647dam.32
        for <linux-ext4@vger.kernel.org>; Thu, 24 Jan 2013 08:44:33 -0800 (PST)
In-Reply-To: <1359045044-31435-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=D4=DA 2013-1-25=A3=AC=C9=CF=CE=E712:30=A3=ACLukas Czerner <lczerner@re=
dhat.com> =D0=B4=B5=C0=A3=BA

> In two places we call WARN_ON() before we print out the debug message=
,
> however the custom is to print such messages before we call WARN_ON()=
 so
> change that.
>=20
> Also use ext4_msg() instead of plain printk().
>=20
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Regards,
                                                - Zheng

> ---
> fs/ext4/extents.c |   13 +++++++------
> 1 files changed, 7 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 5ae1674..b23e1aa 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4459,11 +4459,12 @@ retry:
>        ret =3D ext4_map_blocks(handle, inode, &map, flags);
>        if (ret <=3D 0) {
> #ifdef EXT4FS_DEBUG
> -            WARN_ON(ret <=3D 0);
> -            printk(KERN_ERR "%s: ext4_ext_map_blocks "
> -                    "returned error inode#%lu, block=3D%u, "
> -                    "max_blocks=3D%u", __func__,
> -                    inode->i_ino, map.m_lblk, max_blocks);
> +            ext4_msg(inode->i_sb, KERN_ERR,
> +                 "%s:%d: inode #%lu: block %u: len %u: "
> +                 "ext4_ext_map_blocks returned %d",
> +                 __func__, __LINE__, inode->i_ino, map.m_lblk,
> +                 map.m_len, ret);
> +            WARN_ON(1);
> #endif
>            ext4_mark_inode_dirty(handle, inode);
>            ret2 =3D ext4_journal_stop(handle);
> @@ -4537,12 +4538,12 @@ int ext4_convert_unwritten_extents(struct ino=
de *inode, loff_t offset,
>        ret =3D ext4_map_blocks(handle, inode, &map,
>                      EXT4_GET_BLOCKS_IO_CONVERT_EXT);
>        if (ret <=3D 0) {
> -            WARN_ON(ret <=3D 0);
>            ext4_msg(inode->i_sb, KERN_ERR,
>                 "%s:%d: inode #%lu: block %u: len %u: "
>                 "ext4_ext_map_blocks returned %d",
>                 __func__, __LINE__, inode->i_ino, map.m_lblk,
>                 map.m_len, ret);
> +            WARN_ON(1);
>        }
>        ext4_mark_inode_dirty(handle, inode);
>        ret2 =3D ext4_journal_stop(handle);
> --=20
> 1.7.7.6
>=20
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
