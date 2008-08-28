From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH -V3 07/11] ext4: request for blocks with
	ar.excepted_group = -1
Date: Thu, 28 Aug 2008 14:03:33 -0700
Message-ID: <1219957413.6384.26.camel@mingming-laptop>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:52238 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989AbYH1VDp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2008 17:03:45 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7SL3hvI012607
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 17:03:43 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7SL3YnW223876
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 15:03:37 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7SL3XOO011706
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 15:03:34 -0600
In-Reply-To: <1219850916-8986-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-27=E4=B8=89=E7=9A=84 20:58 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> Otherwise we skip group 0 during block allocation.
> This cause ENOSPC even if we have free blocks in
> group 0. This should be merged with defrag. The
> expected_group changes are introduced by defrag patches.
>=20
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---

Added to patch queue.

Mingming
>  fs/ext4/balloc.c  |    1 +
>  fs/ext4/extents.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index b19346a..53fdb05 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -2023,6 +2023,7 @@ static ext4_fsblk_t do_blk_alloc(handle_t *hand=
le, struct inode *inode,
>  	ar.goal =3D goal;
>  	ar.len =3D *count;
>  	ar.logical =3D iblock;
> +	ar.excepted_group =3D -1;
>=20
>  	if (S_ISREG(inode->i_mode) && !(flags & EXT4_META_BLOCK))
>  		/* enable in-core preallocation for data block allocation */
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index bf612a7..268e96d 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2879,6 +2879,7 @@ int ext4_ext_get_blocks(handle_t *handle, struc=
t inode *inode,
>  	ar.goal =3D ext4_ext_find_goal(inode, path, iblock);
>  	ar.logical =3D iblock;
>  	ar.len =3D allocated;
> +	ar.excepted_group =3D -1;
>  	if (S_ISREG(inode->i_mode))
>  		ar.flags =3D EXT4_MB_HINT_DATA;
>  	else

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
