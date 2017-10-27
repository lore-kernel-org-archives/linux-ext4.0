From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC PATCH 7/8] quota: swaping s_prj_quota_inum superblock field
Date: Fri, 27 Oct 2017 17:50:21 -0600
Message-ID: <8F7A4EDB-A57E-4BD8-9EF8-16A1D39D49EA@dilger.ca>
References: <20171027172254.14137-1-artem.blagodarenko@gmail.com>
 <20171027172254.14137-8-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_B1DA422A-E13A-42B7-9DA9-82473B4FFD84";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Alexey Lyashkov <alexey.lyashkov@gmail.com>,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:45234 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932327AbdJ0Xu0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Oct 2017 19:50:26 -0400
Received: by mail-io0-f196.google.com with SMTP id i38so16008335iod.2
        for <linux-ext4@vger.kernel.org>; Fri, 27 Oct 2017 16:50:26 -0700 (PDT)
In-Reply-To: <20171027172254.14137-8-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_B1DA422A-E13A-42B7-9DA9-82473B4FFD84
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Oct 27, 2017, at 11:22 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> ext2fs_swap_super() swaps s_usr_quota_inum and
> s_grp_quota_inum fields but not s_prj_quota_inum.
>=20
> This patch adds s_prj_quota_inum swaping.
>=20
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>

This should also go into the maint branch.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

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
> --
> 2.13.5 (Apple Git-94)
>=20


Cheers, Andreas






--Apple-Mail=_B1DA422A-E13A-42B7-9DA9-82473B4FFD84
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZ88Y9pIg59Q01vtYRAsIIAKCjksVkbRPcswDNgMOQUwnajrKSrQCeIf4B
a8c5vXqNstPIdeRILRhq6LA=
=y7Aj
-----END PGP SIGNATURE-----

--Apple-Mail=_B1DA422A-E13A-42B7-9DA9-82473B4FFD84--
