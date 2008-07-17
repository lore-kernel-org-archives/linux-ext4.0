From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH][e2fsprogs] Fix inode table allocation with flexbg
Date: Thu, 17 Jul 2008 08:47:51 -0500
Message-ID: <20080717084751.65ea6d57@ichigo>
References: <20080701084357.819339274@bull.net>
	<1216294481.3136.18.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: =?UTF-8?B?RnLDqWTDqXJpYyBCb2jDqQ==?= <frederic.bohe@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60164 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757190AbYGQNsO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jul 2008 09:48:14 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6HDoT9x008298
	for <linux-ext4@vger.kernel.org>; Thu, 17 Jul 2008 09:50:29 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6HDlrW8184750
	for <linux-ext4@vger.kernel.org>; Thu, 17 Jul 2008 09:47:53 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6HDlrYW010358
	for <linux-ext4@vger.kernel.org>; Thu, 17 Jul 2008 09:47:53 -0400
In-Reply-To: <1216294481.3136.18.camel@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 17 Jul 2008 13:34:41 +0200
=46r=C3=A9d=C3=A9ric Boh=C3=A9 <frederic.bohe@bull.net> wrote:

> From: Frederic Bohe <frederic.bohe@bull.net>
>=20
> Disordered inode tables may appear when inode_blocks_per_group is les=
ser
> or equal to the number of groups in a flex group.
>=20

Acked-by: Jose R. Santos <jrs@us.ibm.com>    with some comments bellow=20

> Signed-off-by: Frederic Bohe <frederic.bohe@bull.net>
> ---
> This bug can be reproduced with:
>  mkfs.ext4 -t ext4dev -G512 70G
>=20
> In that case, you can see with dump2fs that inode tables for groups 5=
10
> and 511 are placed just after group 51's inode table instead of being=
=20
> placed after group 509's inode table.
>=20
>  alloc_tables.c |   16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
>=20
> Index: e2fsprogs/lib/ext2fs/alloc_tables.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- e2fsprogs.orig/lib/ext2fs/alloc_tables.c	2008-07-17 10:33:56.0000=
00000 +0200
> +++ e2fsprogs/lib/ext2fs/alloc_tables.c	2008-07-17 10:46:49.000000000=
 +0200
> @@ -34,9 +34,10 @@
>   * tables can be allocated continously and in order.
>   */
>  static blk_t flexbg_offset(ext2_filsys fs, dgrp_t group, blk_t start=
_blk,
> -			   ext2fs_block_bitmap bmap, int offset, int size)
> +			   ext2fs_block_bitmap bmap, int offset, int size,
> +			   int elem_size)

While there is nothing technically wrong with the patch I think it
exposes an issue with the original flexbg_offset function.  The routine
right now requires to many arguments and you need to do some
calculations within some of the arguments which make this look ugly
and error prone if someone decides to modify this code later on.

I've been thinking about rewriting this function so it looks something
like this:

static blk64_t flexbg_offset(ext2_filsys fs, ext2fs_block_bitmap bmap,=20
				dgrp_t group, unsigned int type)

and do all the offset, start_blk, size, elem_size calculations inside
the routine.  I need to make a long term fix for this issue since I
think 7 args for this routine is just to much.

-JRS
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
