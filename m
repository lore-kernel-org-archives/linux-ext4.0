From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 1/2] [PATCH] ext4: fix ext4_debug format
Date: Thu, 17 Nov 2011 15:47:19 +0800
Message-ID: <CAGBYx2YchtAbkc1b_V2AdEHb=_9sRLKU8W+hjFuTH8VNh1-FHw@mail.gmail.com>
References: <1321514390-14903-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48756 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab1KQHrV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Nov 2011 02:47:21 -0500
Received: by wwe5 with SMTP id 5so2387416wwe.1
        for <linux-ext4@vger.kernel.org>; Wed, 16 Nov 2011 23:47:20 -0800 (PST)
In-Reply-To: <1321514390-14903-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Zheng,

On Thu, Nov 17, 2011 at 3:19 PM, Zheng Liu <gnehzuil.liu@gmail.com> wro=
te:
> Fix ext4_debug format in ext4_ext_handle_uninitialized_extents() and
> ext4_end_io_dio().
>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
> =A0fs/ext4/extents.c | =A0 =A04 ++--
> =A0fs/ext4/inode.c =A0 | =A0 =A02 +-
> =A02 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 61fa9e1..8e2a57c 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3454,8 +3454,8 @@ ext4_ext_handle_uninitialized_extents(handle_t =
*handle, struct inode *inode,
> =A0 =A0 =A0 =A0int err =3D 0;
> =A0 =A0 =A0 =A0ext4_io_end_t *io =3D EXT4_I(inode)->cur_aio_dio;
>
> - =A0 =A0 =A0 ext_debug("ext4_ext_handle_uninitialized_extents: inode=
 %lu, logical"
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "block %llu, max_blocks %u, flags %=
d, allocated %u",
> + =A0 =A0 =A0 ext_debug("ext4_ext_handle_uninitialized_extents: inode=
 %lu, logical "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "block %llu, max_blocks %u, flags %=
d, allocated %u\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode->i_ino, (unsigned long long)=
map->m_lblk, map->m_len,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flags, allocated);
Could you format flags by %x instead of %d?  The output will be more re=
adable.

Yongqiang.
> =A0 =A0 =A0 =A0ext4_ext_show_leaf(inode, path);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 240f6e2..4c037f9 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2775,7 +2775,7 @@ static void ext4_end_io_dio(struct kiocb *iocb,=
 loff_t offset,
> =A0 =A0 =A0 =A0if (!io_end || !size)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>
> - =A0 =A0 =A0 ext_debug("ext4_end_io_dio(): io_end 0x%p"
> + =A0 =A0 =A0 ext_debug("ext4_end_io_dio(): io_end 0x%p "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"for inode %lu, iocb 0x%p, offset =
%llu, size %llu\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0iocb->private, io_end->inode->i_in=
o, iocb, offset,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size);
> --
> 1.7.4.1
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
