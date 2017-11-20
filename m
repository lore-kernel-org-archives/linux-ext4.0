From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2 6/7] quota: swapping s_prj_quota_inum superblock field
Date: Mon, 20 Nov 2017 14:25:58 -0700
Message-ID: <A9C5B4B9-7216-4D13-ACA2-2AC2C301C062@dilger.ca>
References: <20171114070440.79510-1-artem.blagodarenko@gmail.com>
 <20171114070440.79510-7-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_BCA7C42A-CE94-4CB7-B0D5-2A0826110CFF";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:36394 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753121AbdKTV0E (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Nov 2017 16:26:04 -0500
Received: by mail-it0-f65.google.com with SMTP id 187so11293958iti.1
        for <linux-ext4@vger.kernel.org>; Mon, 20 Nov 2017 13:26:03 -0800 (PST)
In-Reply-To: <20171114070440.79510-7-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_BCA7C42A-CE94-4CB7-B0D5-2A0826110CFF
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 14, 2017, at 12:04 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> ext2fs_swap_super() swaps s_usr_quota_inum and
> s_grp_quota_inum fields but not s_prj_quota_inum.
>=20
> This patch adds s_prj_quota_inum swapping.
>=20
> Lustre-bug: https://jira.hpdd.intel.com/browse/LU-9309
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>

You can add my:

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

I would suggest this patch just be submitted separately, since it is a
bug fix that could go into the "maint" branch along with other project
quota functionality, and doesn't really relate to the inode64 feature.

> ---
> lib/ext2fs/swapfs.c | 1 +
> 1 file changed, 1 insertion(+)
>=20
> diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
> index b7c01005..60cdf124 100644
> --- a/lib/ext2fs/swapfs.c
> +++ b/lib/ext2fs/swapfs.c
> @@ -81,6 +81,7 @@ void ext2fs_swap_super(struct ext2_super_block * sb)
> 	sb->s_snapshot_r_blocks_count =3D
> 		ext2fs_swab64(sb->s_snapshot_r_blocks_count);
> 	sb->s_snapshot_list =3D ext2fs_swab32(sb->s_snapshot_list);
> +	sb->s_prj_quota_inum =3D ext2fs_swab32(sb->s_prj_quota_inum);
> 	sb->s_usr_quota_inum =3D ext2fs_swab32(sb->s_usr_quota_inum);
> 	sb->s_grp_quota_inum =3D ext2fs_swab32(sb->s_grp_quota_inum);
> 	sb->s_overhead_blocks =3D ext2fs_swab32(sb->s_overhead_blocks);


Cheers, Andreas






--Apple-Mail=_BCA7C42A-CE94-4CB7-B0D5-2A0826110CFF
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFaE0hnpIg59Q01vtYRAqo/AJ0YQ2U09aGexELORBmMtDMdcSr74ACfc07q
AloYgmSZLcSCtCFUwABdjZE=
=dF06
-----END PGP SIGNATURE-----

--Apple-Mail=_BCA7C42A-CE94-4CB7-B0D5-2A0826110CFF--
