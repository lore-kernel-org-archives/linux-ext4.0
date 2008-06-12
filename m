From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: fix online resize group descriptors corruption
Date: Thu, 12 Jun 2008 04:59:45 -0600
Message-ID: <20080612105945.GB3726@webber.adilger.int>
References: <1213263754.6549.45.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: =?utf-8?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:50467 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412AbYFLK7s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2008 06:59:48 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m5CAxlAY022814
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 03:59:47 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K2C00801JTLC900@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 12 Jun 2008 03:59:47 -0700 (PDT)
In-reply-to: <1213263754.6549.45.camel@localhost>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 12, 2008  11:42 +0200, Fr=EF=BF=BDd=EF=BF=BDric Boh=EF=BF=BD wro=
te:
> From: Frederic Bohe <frederic.bohe@bull.net>
>=20
> This is the patch for the group descriptor table corruption during
> online resize pointed out by Theodore Tso.
> The issue was due to the ext4 group descriptor which can be either
> 32 or 64 bytes long.
> Only the 64 bytes structure was taken into account.
>=20
> diff -rup a/fs/ext4/resize.c b/fs/ext4/resize.c
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -855,7 +855,8 @@ int ext4_group_add(struct super_block *s
>  	 */
> =20
>  	/* Update group descriptor block for new group */
> -	gdp =3D (struct ext4_group_desc *)primary->b_data + gdb_off;
> +	gdp =3D (struct ext4_group_desc *)(
> +	       (__u8 *)primary->b_data + gdb_off * EXT4_DESC_SIZE(sb));

Normally pointer arithmetic is done by casting to (char *)...
Otherwise, patch looks sensible, though it could be reformatted to=20
match the normal coding style a bit better:

	gdp =3D (struct ext4_group_desc *)((char *)primary->b_data +
					 gdb_off * EXT4_DESC_SIZE(sb));

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
