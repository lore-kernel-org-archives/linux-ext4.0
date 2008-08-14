From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH, RFC] ext4-use-generic-discard-reservations-call
Date: Thu, 14 Aug 2008 16:09:40 -0700
Message-ID: <1218755380.6362.43.camel@mingming-laptop>
References: <E1KTiuD-0000ej-JZ@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45229 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbYHNXJo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Aug 2008 19:09:44 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7EN9fk7011997
	for <linux-ext4@vger.kernel.org>; Thu, 14 Aug 2008 19:09:41 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7EN9fWu238404
	for <linux-ext4@vger.kernel.org>; Thu, 14 Aug 2008 19:09:41 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7EN9elt023857
	for <linux-ext4@vger.kernel.org>; Thu, 14 Aug 2008 19:09:40 -0400
In-Reply-To: <E1KTiuD-0000ej-JZ@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-14=E5=9B=9B=E7=9A=84 15:54 -0400=EF=BC=8CTheodore Ts'=
o=E5=86=99=E9=81=93=EF=BC=9A
> Does this patch make sense?  I noticed that in the extents version of
> the truncate, we call the mballoc-specific version of
> ext4_discard_reservation(), instead of ext4_discard_reservation()
> directly.  As a result, if the filesystem is mounted -o nomballoc, we
> won't throw away the reservation window when truncating or unlinking =
an
> extents-based file.   We are using ext4_discard_reservation() in
> non-extent truncate code, which is what made me notice this.
>=20
> 	   	    	  	   	- Ted
>=20

Agreed.

Reviewed-by: Mingming Cao <cmm@us.ibm.com>

> ext4: Use ext4_discard_reservations instead of mballoc-specific call
>=20
> In ext4_ext_truncate(), we should use the more generic
> ext4_discard_reservations() call so we do the right thing when the
> filesystem is mounted with the nomballoc option.
>=20
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 3c82ab1..30a59b8 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2963,7 +2963,7 @@ void ext4_ext_truncate(struct inode *inode)
>  	down_write(&EXT4_I(inode)->i_data_sem);
>  	ext4_ext_invalidate_cache(inode);
>=20
> -	ext4_mb_discard_inode_preallocations(inode);
> +	ext4_discard_reservation(inode);
>=20
>  	/*
>  	 * TODO: optimization is possible here.
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
