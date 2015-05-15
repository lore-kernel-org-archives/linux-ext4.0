From: =?windows-1252?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
Subject: Re: ext4 lazytime: ctime of some files changed
Date: Fri, 15 May 2015 17:14:10 +0200
Message-ID: <55560D42.2060402@web.de>
References: <55531AE3.7030704@web.de> <mivtkj$fhi$1@ger.gmane.org> <20150514222044.GA3901@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout01.t-online.de ([194.25.134.80]:56175 "EHLO
	mailout01.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377AbbEOPOR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 May 2015 11:14:17 -0400
In-Reply-To: <20150514222044.GA3901@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote on 05/15/2015 00:20:
> On Wed, May 13, 2015 at 06:20:35PM +0200, J=F6rg-Volker Peetz wrote:
>>
>> Thereafter, the two emacs package files again had a wrong mtime (whi=
ch by the
>> way shows when I start emacs).
>>
>> Could this be due to the lazytime mount option?
>=20
> I think I found the problem.  My bad.  Can you verify that this solve=
s
> the problem for you?
>=20
Meanwhile I've kernel version 4.0.3 with your patch on top and

$ grep -E '(root|sda)' /proc/mounts
/dev/root / ext4 rw,lazytime,nobarrier,errors=3Dremount-ro 0 0
/dev/sda2 /home ext4 rw,lazytime,nobarrier,errors=3Dremount-ro 0 0

running nearly two hours without any file timestamp related anomalies w=
hile
doing some file activity and a sync from time to time :-)
Thanks for caring.

> From 8f4d855839179f410fa910a26eb81d646d628f26 Mon Sep 17 00:00:00 200=
1
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Thu, 14 May 2015 18:19:01 -0400
> Subject: [PATCH] ext4: fix lazytime optimization
>=20
> We had a fencepost error in the lazytime optimization which means tha=
t
> timestamp would get written to the wrong inode.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  fs/ext4/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 55b187c..0554b0b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4345,7 +4345,7 @@ static void ext4_update_other_inodes_time(struc=
t super_block *sb,
>  	int inode_size =3D EXT4_INODE_SIZE(sb);
> =20
>  	oi.orig_ino =3D orig_ino;
> -	ino =3D orig_ino & ~(inodes_per_block - 1);
> +	ino =3D (orig_ino & ~(inodes_per_block - 1)) + 1;
>  	for (i =3D 0; i < inodes_per_block; i++, ino++, buf +=3D inode_size=
) {
>  		if (ino =3D=3D orig_ino)
>  			continue;
>=20
--=20
Regards,
J=F6rg.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
