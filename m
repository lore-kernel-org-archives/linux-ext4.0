From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] remove write-only variables from ext4_ordered_write_end
Date: Thu, 31 Jul 2008 11:09:16 -0700
Message-ID: <1217527756.6317.8.camel@mingming-laptop>
References: <4891FD21.2000704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55818 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbYGaSJS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jul 2008 14:09:18 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6VI9HFg012813
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 14:09:17 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6VI9HDZ224928
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 14:09:17 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6VI9HGD028004
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 14:09:17 -0400
In-Reply-To: <4891FD21.2000704@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-07-31=E5=9B=9B=E7=9A=84 12:57 -0500=EF=BC=8CEric Sandeen=
=E5=86=99=E9=81=93=EF=BC=9A
> from & to are unused.
>=20
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Acked-by: Mingming Cao <cmm@us.ibm.com>
>=20
> Index: linux-2.6/fs/ext4/inode.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/fs/ext4/inode.c	2008-07-31 12:38:45.000000000 -050=
0
> +++ linux-2.6/fs/ext4/inode.c	2008-07-31 12:55:59.181165399 -0500
> @@ -1336,12 +1336,8 @@ static int ext4_ordered_write_end(struct
>  {
>  	handle_t *handle =3D ext4_journal_current_handle();
>  	struct inode *inode =3D mapping->host;
> -	unsigned from, to;
>  	int ret =3D 0, ret2;
>=20
> -	from =3D pos & (PAGE_CACHE_SIZE - 1);
> -	to =3D from + len;
> -
>  	ret =3D ext4_jbd2_file_inode(handle, inode);
>=20
>  	if (ret =3D=3D 0) {
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
