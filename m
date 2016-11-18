From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 3/3] ext4: use more strict checks for inodes_per_block on mount
Date: Fri, 18 Nov 2016 02:42:57 -0700
Message-ID: <EAD114AF-8586-437B-9EE3-E21FAF89E11B@dilger.ca>
References: <5ce3de05-2f37-6758-1178-ecf520c87d4f@kyup.com> <20161118042610.13464-1-tytso@mit.edu> <20161118042610.13464-3-tytso@mit.edu>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_A4F0E898-0F2E-4BD3-9A62-8E139F2152AD"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, kernel@kyup.com,
        bp@alien8.de, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33580 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751713AbcKRJll (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Nov 2016 04:41:41 -0500
Received: by mail-pg0-f66.google.com with SMTP id 3so20229264pgd.0
        for <linux-ext4@vger.kernel.org>; Fri, 18 Nov 2016 01:41:40 -0800 (PST)
In-Reply-To: <20161118042610.13464-3-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_A4F0E898-0F2E-4BD3-9A62-8E139F2152AD
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 17, 2016, at 9:26 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>=20
> Centralize the checks for inodes_per_block and be more strict to make
> sure the inodes_per_block_group can't end up being zero.
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> Cc: stable@vger.kernel.org
> ---
> fs/ext4/super.c | 15 ++++++---------
> 1 file changed, 6 insertions(+), 9 deletions(-)
>=20
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 3009c03220d6..6638a0415997 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3666,12 +3666,16 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
>=20
> 	sbi->s_blocks_per_group =3D le32_to_cpu(es->s_blocks_per_group);
> 	sbi->s_inodes_per_group =3D le32_to_cpu(es->s_inodes_per_group);
> -	if (EXT4_INODE_SIZE(sb) =3D=3D 0 || EXT4_INODES_PER_GROUP(sb) =3D=3D=
 0)
> -		goto cantfind_ext4;
>=20
> 	sbi->s_inodes_per_block =3D blocksize / EXT4_INODE_SIZE(sb);
> 	if (sbi->s_inodes_per_block =3D=3D 0)
> 		goto cantfind_ext4;
> +	if (sbi->s_inodes_per_group < sbi->s_inodes_per_block ||
> +	    sbi->s_inodes_per_group > blocksize * 8) {
> +		ext4_msg(sb, KERN_ERR, "invalid inodes per group: =
%lu\n",
> +			 sbi->s_blocks_per_group);
> +		goto failed_mount;
> +	}
> 	sbi->s_itb_per_group =3D sbi->s_inodes_per_group /
> 					sbi->s_inodes_per_block;
> 	sbi->s_desc_per_block =3D blocksize / EXT4_DESC_SIZE(sb);
> @@ -3754,13 +3758,6 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> 	}
> 	sbi->s_cluster_ratio =3D clustersize / blocksize;
>=20
> -	if (sbi->s_inodes_per_group > blocksize * 8) {
> -		ext4_msg(sb, KERN_ERR,
> -		       "#inodes per group too big: %lu",
> -		       sbi->s_inodes_per_group);
> -		goto failed_mount;
> -	}
> -
> 	/* Do we have standard group size of clustersize * 8 blocks ? */
> 	if (sbi->s_blocks_per_group =3D=3D clustersize << 3)
> 		set_opt2(sb, STD_GROUP_SIZE);
> --
> 2.11.0.rc0.7.gbe5a750
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_A4F0E898-0F2E-4BD3-9A62-8E139F2152AD
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWC7NInKl2rkXzB/gAQgl7A//YpYqnVbXz2gT3uJGfK7oJNFbQbkTQkff
RB2mAOtgFgHgIIpUrqN2ZI7aazx5pjUBAfkkF77NUr5GLP55KgmqeCLh8vin7dVS
cAZPaFVcEWYawTQp3u9/7+GOfGz/V4ssOeyi3tja2yB5NJWkEDTZrLSnpucrzvhI
fVMlg8VU39i3gq0rd72pVgBMruc01PFcZjzkaIRTPFxsK8/tXP6SPLKrRQ6I3xx2
Hvy31GZ6zHvme1JrLe4LmNnS4jj7zj+Me+IpGfQ17B1rCJzrZyLtWrjIl8DNty9M
emeAWlgB1It4TLQSrlvoJEb7aZ38oR1W6QxX40l5ubqR1ys4Vv3NhZO592vGrrKW
amyDt2oZpRFdQWPlsgERSRx/E8rR/k6TvNJ6N4rCN4DGFQXT64lz8sIDT4STUkHr
REe5A3WoMXuvbBHUCgIUDizOblVa6aErvi3+rATHTqtr0L90tV+AJFwJj16qlB7T
ffryviZW/Sc576Jj4i/MgQAm+uf5En7kw25gIy22p4l/YeDMudrHtdXDJqdd2P8v
b5JLWQBH3QY0Lki9a8f+T1lMcMgquNt65NqlETvTMsCMjAR+i0UMFGudUUWMLtMW
MJbpk2zVxTBoWh4VS40bWBm82OGOWnO7kWPvhh8jFD6jR6VwRpPl5p1uDiu/b56z
cKJ25NWL2Xc=
=Uftb
-----END PGP SIGNATURE-----

--Apple-Mail=_A4F0E898-0F2E-4BD3-9A62-8E139F2152AD--
