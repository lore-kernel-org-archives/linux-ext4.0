From: =?windows-1252?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
Subject: Re: [PATCH -v2] ext4: fix fencepost error in lazytime optimization
Date: Sun, 05 Jul 2015 12:04:59 +0200
Message-ID: <5599014B.5050309@web.de>
References: <mn5vitbh@ger.gmane.org> <1436064066-22403-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: stable@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49104 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbbGEKFH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Jul 2015 06:05:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1ZBgnJ-0007vh-GN
	for linux-ext4@vger.kernel.org; Sun, 05 Jul 2015 12:05:05 +0200
Received: from p4fdf09f2.dip0.t-ipconnect.de ([79.223.9.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sun, 05 Jul 2015 12:05:05 +0200
Received: from jvpeetz by p4fdf09f2.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sun, 05 Jul 2015 12:05:05 +0200
In-Reply-To: <1436064066-22403-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Theodore Ts'o wrote on 07/05/2015 04:41:
> Commit 8f4d8558391: "ext4: fix lazytime optimization" was not a
> complete fix.  In the case where the inode number is a multiple of 16=
,
> and we could still end up updating an inode with dirty timestamps
> written to the wrong inode on disk.  Oops.
>=20
> This can be easily reproduced by using generic/005 with a file system
> with metadata_csum and lazytime enabled.
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@vger.kernel.org
> ---
>  fs/ext4/inode.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index e057c6f..4ad73d3 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4348,7 +4348,12 @@ static void ext4_update_other_inodes_time(stru=
ct super_block *sb,
>  	int inode_size =3D EXT4_INODE_SIZE(sb);
> =20
>  	oi.orig_ino =3D orig_ino;
> -	ino =3D (orig_ino & ~(inodes_per_block - 1)) + 1;
> +	/*
> +	 * Calculate the first inode in the inode table block.  Inode
> +	 * numbers are one-based.  That is, the first inode in a block
> +	 * (assuming 4k blocks and 256 byte inodes) is (n*16 + 1).
> +	 */
> +	ino =3D ((orig_ino - 1) & ~(inodes_per_block - 1)) + 1;
>  	for (i =3D 0; i < inodes_per_block; i++, ino++, buf +=3D inode_size=
) {
>  		if (ino =3D=3D orig_ino)
>  			continue;
>=20
thank you very much for the explanation. Now I think I understand:

/*
 * Calculate the first inode in the original inode's inode table
 * block. Inode numbers are one-based. That is, the first inode
 * in a block is one plus the next-lowest to (orig_ino - 1)
 * integral multiple of inodes_per_block. This can be calculated
 * efficiently by bit masking since inodes_per_block is a power
 * of 2 (assuming 4k blocks and 256 byte inodes).
*/

Regards,
J=F6rg.


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
