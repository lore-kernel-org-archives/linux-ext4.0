From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] missing journal_stop in ext4_da_write_begin error case
Date: Thu, 31 Jul 2008 11:09:45 -0700
Message-ID: <1217527785.6317.10.camel@mingming-laptop>
References: <4891F527.4060007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56559 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbYGaSJr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jul 2008 14:09:47 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6VI9kYc013593
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 14:09:46 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6VI9kTl186524
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 14:09:46 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6VI9k6D029435
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 14:09:46 -0400
In-Reply-To: <4891F527.4060007@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-07-31=E5=9B=9B=E7=9A=84 12:23 -0500=EF=BC=8CEric Sandeen=
=E5=86=99=E9=81=93=EF=BC=9A
> ext4_da_write_begin needs to call journal_stop before returning,
> if the page allocation fails.
>=20
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Ackd-by: Mingming Cao <cmm@us.ibm.com>

> ---
>=20
> Index: linux-2.6/fs/ext4/inode.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/fs/ext4/inode.c	2008-07-29 17:18:26.000000000 -050=
0
> +++ linux-2.6/fs/ext4/inode.c	2008-07-31 12:21:03.866229084 -0500
> @@ -2280,8 +2280,11 @@ retry:
>  	}
>=20
>  	page =3D __grab_cache_page(mapping, index);
> -	if (!page)
> -		return -ENOMEM;
> +	if (!page) {
> +		ext4_journal_stop(handle);
> +		ret =3D -ENOMEM;
> +		goto out;
> +	}
>  	*pagep =3D page;
>=20
>  	ret =3D block_write_begin(file, mapping, pos, len, flags, pagep, fs=
data,
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
