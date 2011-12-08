From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH v2] ext4: directly leave out of ext4_find_delalloc_range()
 if filesystem mount with "nodelalloc"
Date: Thu, 8 Dec 2011 16:36:53 +0800
Message-ID: <CAGBYx2Y0hHX4D-AKxvgTpMmPnxYCGrbd2dODZAeiOwnaOFLOeQ@mail.gmail.com>
References: <1323237879-31800-1-git-send-email-hao.bigrat@gmail.com>
	<1323327594-4914-1-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, "Ted Ts'o" <tytso@mit.edu>
To: Robin Dong <sanbai@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42501 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab1LHIgy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Dec 2011 03:36:54 -0500
Received: by ggnr5 with SMTP id r5so1708545ggn.19
        for <linux-ext4@vger.kernel.org>; Thu, 08 Dec 2011 00:36:53 -0800 (PST)
In-Reply-To: <1323327594-4914-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 8, 2011 at 2:59 PM, Robin Dong <hao.bigrat@gmail.com> wrote=
:
> From: Robin Dong <sanbai@taobao.com>
>
> We found performance regression when using bigalloc with "nodelalloc"=
 =A0(1MB cluster size):
>
> 1. mke2fs -C 1048576 -O ^has_journal,bigalloc /dev/sda
> 2. mount -o nodelalloc /dev/sda /test/
> 3. time dd if=3D/dev/zero of=3D/test/io bs=3D1048576 count=3D1024
>
> The "dd" will cost about 2 seconds to finish, but if we mke2fs withou=
t "bigalloc",
> "dd" will only cost lesss than 1 second.
>
> The reason is: =A0when using ext4 with "nodelalloc", it will call ext=
4_find_delalloc_cluster() nearly
> everytime it call ext4_ext_map_blocks(), and ext4_find_delalloc_range=
() will also scan all pages
> in cluster because no buffer is "delayed".
> A cluster has 256 pages (1MB cluster), so it will scan 256 * 256k pag=
s when creating a 1G file. That
> severely hurts the performance.
Looks good to me.

I think delayed extent tree can help a lot when a cluster has hundreds
of pages in delalloc case.

Hi Ted,

Any plans on merging delayed extent tree patches?

Yongqiang.
>
> Therefore, we return out from ext4_find_delalloc_range() when using "=
nodelalloc".
>
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> ---
> =A0fs/ext4/extents.c | =A0 =A03 +++
> =A01 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 61fa9e1..60f5f25 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3282,6 +3282,9 @@ static int ext4_find_delalloc_range(struct inod=
e *inode,
> =A0 =A0 =A0 =A0ext4_lblk_t i, pg_lblk;
> =A0 =A0 =A0 =A0pgoff_t index;
>
> + =A0 =A0 =A0 if (!test_opt(inode->i_sb, DELALLOC))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> +
> =A0 =A0 =A0 =A0/* reverse search wont work if fs block size is less t=
han page size */
> =A0 =A0 =A0 =A0if (inode->i_blkbits < PAGE_CACHE_SHIFT)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0search_hint_reverse =3D 0;
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
