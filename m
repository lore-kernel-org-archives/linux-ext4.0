From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC PATCH] mark buffer_head mapping preallocate area as new
	during write_begin with delayed allocation
Date: Mon, 27 Apr 2009 16:04:54 -0700
Message-ID: <1240873494.6775.8.camel@mingming-laptop>
References: <1240859143-31122-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:58082 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbZD0XE6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Apr 2009 19:04:58 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n3RN3PtJ022294
	for <linux-ext4@vger.kernel.org>; Mon, 27 Apr 2009 17:03:25 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3RN4waZ078646
	for <linux-ext4@vger.kernel.org>; Mon, 27 Apr 2009 17:04:58 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3RN4uxr021531
	for <linux-ext4@vger.kernel.org>; Mon, 27 Apr 2009 17:04:57 -0600
In-Reply-To: <1240859143-31122-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2009-04-28=E4=BA=8C=E7=9A=84 00:35 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> We need to mark the  buffer_head mapping prealloc space
> as new during write_begin. Otherwise we don't zero out the
> page cache content properly for a partial write. This will
> cause file corruption with preallocation.
>=20

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>=20
> ---
>  fs/ext4/inode.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c6bd6ce..c7251ec 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2323,6 +2323,8 @@ static int ext4_da_get_block_prep(struct inode =
*inode, sector_t iblock,
>  		set_buffer_delay(bh_result);
>  	} else if (ret > 0) {
>  		bh_result->b_size =3D (ret << inode->i_blkbits);
> +		if (buffer_unwritten(bh_result))
> +			set_buffer_new(bh_result);
>  		ret =3D 0;
>  	}
>=20

Thanks Aneesh.

Just to share with list, I have seen garbage content show up on a
preallocated but later partially written blocks. This only happens with
delayed allocation. The test simply preallocate 2blocks to a new file,
then write a few bytes to the beginning of file(less than a block), and
od shows the first block the written content followed by garbage filled
to the end of the first block.

After examing the code, we did set the buffer as new for nondelalloc, a=
s
the create flag passed to ext4_ext_get_blocks() is 1, while for delallo=
c
case, ext4_get_blocks_prep() calling ext4_ext_get_block() with create
=3D0, which leads to the code path that forget to set the bh as new if =
the
block is preallocated.

This patch is mostly correct except forget to set the bh_result->bdev,
which caused the fs blow out.

The updated patch fixed the problem for me.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>

Index: linux-2.6.28-rc6/fs/ext4/inode.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.28-rc6.orig/fs/ext4/inode.c	2009-03-12 10:21:05.000000000=
 -0700
+++ linux-2.6.28-rc6/fs/ext4/inode.c	2009-04-27 14:35:21.000000000 -070=
0
@@ -2177,7 +2177,10 @@ static int ext4_da_get_block_prep(struct
 		set_buffer_new(bh_result);
 		set_buffer_delay(bh_result);
 	} else if (ret > 0) {
+		if (buffer_unwritten(bh_result))
+			set_buffer_new(bh_result);
 		bh_result->b_size =3D (ret << inode->i_blkbits);
+		bh_result->b_bdev =3D inode->i_sb->s_bdev;
 		ret =3D 0;
 	}
=20



--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
