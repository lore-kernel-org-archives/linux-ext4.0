From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] quota: swapping s_prj_quota_inum superblock field
Date: Wed, 13 Dec 2017 16:46:30 -0700
Message-ID: <86D022B8-87CE-4399-88CB-ECAA3854363A@dilger.ca>
References: <20171213122018.27932-1-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_6627FFF8-9BEE-43B1-BEB2-01B240CBC860";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Wang Shilong <wshilong@ddn.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:36651 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750785AbdLMXqh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Dec 2017 18:46:37 -0500
Received: by mail-it0-f65.google.com with SMTP id d16so6929327itj.1
        for <linux-ext4@vger.kernel.org>; Wed, 13 Dec 2017 15:46:37 -0800 (PST)
In-Reply-To: <20171213122018.27932-1-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_6627FFF8-9BEE-43B1-BEB2-01B240CBC860
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Dec 13, 2017, at 5:20 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> ext2fs_swap_super() swaps s_usr_quota_inum and
> s_grp_quota_inum fields but not s_prj_quota_inum.
>=20
> This patch adds s_prj_quota_inum swapping.
>=20
> Lustre-bug: https://jira.hpdd.intel.com/browse/LU-9309
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>

I was going to give this a Reviewed-by: but two things bothered me:
- the swabbing should be done in field declaration order, so that it
  is easier to see that all of the fields have been handled properly
- looking to see what other fields might not have proper swabbing, it
  turns out there are several other fields that are not being swabbed:

  s_raid_stride, s_raid_stripe_width, s_{first,last}_error_*, s_lpf_ino

So instead of this one-line fix I'm going to push a patch that fixes all
of these in a consistent manner, and adds some build-time checking to
ext2fs_swap_super(), ext2fs_swap_group_desc2() and =
ext2fs_swap_inode_large()
to try and catch future cases where we are not adding swabbing.

Cheers, Andreas

> ---
> lib/ext2fs/swapfs.c | 1 +
> 1 file changed, 1 insertion(+)
>=20
> diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
> index b9d8f557..c1da8509 100644
> --- a/lib/ext2fs/swapfs.c
> +++ b/lib/ext2fs/swapfs.c
> @@ -79,6 +79,7 @@ void ext2fs_swap_super(struct ext2_super_block * sb)
> 	sb->s_snapshot_r_blocks_count =3D
> 		ext2fs_swab64(sb->s_snapshot_r_blocks_count);
> 	sb->s_snapshot_list =3D ext2fs_swab32(sb->s_snapshot_list);
> +	sb->s_prj_quota_inum =3D ext2fs_swab32(sb->s_prj_quota_inum);
> 	sb->s_usr_quota_inum =3D ext2fs_swab32(sb->s_usr_quota_inum);
> 	sb->s_grp_quota_inum =3D ext2fs_swab32(sb->s_grp_quota_inum);
> 	sb->s_overhead_blocks =3D ext2fs_swab32(sb->s_overhead_blocks);
> --
> 2.14.3 (Apple Git-98)
>=20


Cheers, Andreas






--Apple-Mail=_6627FFF8-9BEE-43B1-BEB2-01B240CBC860
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFaMbvYpIg59Q01vtYRAtIAAKCtPYLQLTEOEy69tDgeUtJ0Oa1xywCfVgHU
ynKAR+4W4dRJdVsXLsj+pGk=
=Aal9
-----END PGP SIGNATURE-----

--Apple-Mail=_6627FFF8-9BEE-43B1-BEB2-01B240CBC860--
