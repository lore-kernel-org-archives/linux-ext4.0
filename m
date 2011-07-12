From: Robin Dong <hao.bigrat@gmail.com>
Subject: Re: [PATCH 2/2] ext4: avoid finding next leaf if newext->ee_block
 smaller than fex->ee_block
Date: Tue, 12 Jul 2011 09:33:26 +0800
Message-ID: <CAFZ0FUXnxdOhLzaACGA80AmbsxteCZPo09JuocGRr1=9aZZYUA@mail.gmail.com>
References: <1309421014-6148-1-git-send-email-sanbai@taobao.com>
	<1309421014-6148-2-git-send-email-sanbai@taobao.com>
	<BANLkTikeMA72P2-6eSv=2cqOtvEaHRbsZA@mail.gmail.com>
	<20110711195211.GQ28763@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36107 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab1GLBd1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Jul 2011 21:33:27 -0400
Received: by iwn6 with SMTP id 6so4203288iwn.19
        for <linux-ext4@vger.kernel.org>; Mon, 11 Jul 2011 18:33:27 -0700 (PDT)
In-Reply-To: <20110711195211.GQ28763@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/7/12 Ted Ts'o <tytso@mit.edu>:
> On Thu, Jun 30, 2011 at 04:42:31PM +0800, Yongqiang Yang wrote:
>> How about:
>> =A0 =A0 =A0 =A0 =A0 =A0next =3D EXT_MAX_BLOCKS;
>> =A0 =A0 =A0 =A0 =A0 =A0if (le32_to_cpu(newext->ee_block) > le32_to_c=
pu(fex->ee_block)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0next =3D ext4_ext_next_leaf_b=
lock(inode, path);
>> =A0 =A0 =A0 =A0 =A0 =A0if (next !=3D EXT_MAX_BLOCKS) {
>
> Agreed, that's a better way of doing things. =A0Also, Robin, please
> compare and contrast your description with mine. =A0The commit
> description shouldn't just be a textual description of the change. =A0=
It
> should give the larger context of the change and why it's important.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 - Ted
>
> commit 2a3f7e0e0e55f8817fbe92d111ef2a06e6b8ef18
> Author: Robin Dong <sanbai@taobao.com>
> Date: =A0 Mon Jul 11 15:43:38 2011 -0400
>
> =A0 =A0ext4: avoid unneeded ext4_ext_next_leaf_block() while insertin=
g extents
>
> =A0 =A0Optimize ext4_exT_insert_extent() by avoiding
> =A0 =A0ext4_ext_next_leaf_block() when the result is not used/needed.
>
> =A0 =A0Signed-off-by: Robin Dong <sanbai@taobao.com>
> =A0 =A0Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 9cbdcb2..f1c538e 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1730,9 +1730,10 @@ int ext4_ext_insert_extent(handle_t *handle, s=
truct inode *inode,
>
> =A0 =A0 =A0 =A0/* probably next leaf has space for us? */
> =A0 =A0 =A0 =A0fex =3D EXT_LAST_EXTENT(eh);
> - =A0 =A0 =A0 next =3D ext4_ext_next_leaf_block(inode, path);
> - =A0 =A0 =A0 if (le32_to_cpu(newext->ee_block) > le32_to_cpu(fex->ee=
_block)
> - =A0 =A0 =A0 =A0 =A0 && next !=3D EXT_MAX_BLOCKS) {
> + =A0 =A0 =A0 next =3D EXT_MAX_BLOCKS;
> + =A0 =A0 =A0 if (le32_to_cpu(newext->ee_block) > le32_to_cpu(fex->ee=
_block))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 next =3D ext4_ext_next_leaf_block(inode=
, path);
> + =A0 =A0 =A0 if (next !=3D EXT_MAX_BLOCKS) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext_debug("next leaf block - %d\n", ne=
xt);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(npath !=3D NULL);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0npath =3D ext4_ext_find_extent(inode, =
next, NULL);
>

It seems much better than my description. Thanks!

--=20
--
Best Regard
Robin Dong
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
