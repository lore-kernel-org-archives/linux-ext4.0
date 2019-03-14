Return-Path: <SRS0=Ur5Y=RR=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA36BC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Mar 2019 00:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CDF221019
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Mar 2019 00:31:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="WdSwbWIf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfCNAbH (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 13 Mar 2019 20:31:07 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39484 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbfCNAbG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Mar 2019 20:31:06 -0400
Received: by mail-pf1-f193.google.com with SMTP id i20so2565516pfo.6
        for <linux-ext4@vger.kernel.org>; Wed, 13 Mar 2019 17:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=8RTBFpQhu5aaBgvJol3AhPvLs43SNZpedCauEFdD8r8=;
        b=WdSwbWIfvk/TUJqW27OIg5Op4S+9h6xkOmA2AXIS76a5si9AQxU0j3xlsSeUgNrpM1
         92HWlebZq0MKg77JHxVVYTSfTiwxoBStVsDW1qURx5zMEPlZReuCf3BjxtfMaARizb16
         z+EPHCKdLcBcvEOBByLx64OilGAMHHa1Ll9B6PPPfZ63GFxz5dsDzPW7MLhlFVFIiWp5
         tisJCQYLguBp+DU2FXwhJXbX6hQbQEfl9A31Ydr94Z/tpv1auHLbV9BArQlVUbAzBgwG
         9zryVhL+nX6J+a0MhMXUcUovcApqKcnP5cSD5G9HVUQ73rcnsHA93uMm1gEJ8EVwqNq7
         tGnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=8RTBFpQhu5aaBgvJol3AhPvLs43SNZpedCauEFdD8r8=;
        b=iRqARed/jgZD4OhPlLgWXntfPefMkrPxK+ouPGtU9mgseKLeUhCPeUwja/UjoI8KBa
         uCcm0LAembVLsnSXN6PbBXPS4yenndzczT6YKXRB+6kZMZkjrk5RwsK1bKkPvbak7IgT
         t1j/UUdRo3ZnIyTioxw/Biq/2nLtobYxGKem+4bqW6pYx08KDbZW/Xhij2MDW5aMXgWo
         Ct5UTHv/d1vRZu6rc4ISTTof/D+XRTq6lZwM2TfQc8oom2G8yqwCSIiROl/slRRWf7pj
         4KQBCMNePplhUFZC/QLLO152SokXzv0ff6Ns7ZAZJ5Tc9dUTOG7MObb2/IxaQBGg7eCB
         1FFw==
X-Gm-Message-State: APjAAAVi0H6o25FtahV5x0+hiFip9XKlChn/rbVfu2RgdIGn59moqFw7
        W7z9Q81VFSrTWs7abpDD5ecx8Q==
X-Google-Smtp-Source: APXvYqxA7XgyD6egPAY82sL+XhrH2XInVQ8OvrU3EyJffv9vNTOi4/u0ExbpCjlcRVOWWsWU0UpJmQ==
X-Received: by 2002:a62:342:: with SMTP id 63mr2673646pfd.80.1552523465579;
        Wed, 13 Mar 2019 17:31:05 -0700 (PDT)
Received: from cabot-wlan.adilger.int (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id q62sm25004468pga.32.2019.03.13.17.31.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Mar 2019 17:31:04 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <11B3D627-92DC-4EF9-877E-248776B967A6@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_7E2F1EAC-02FF-441C-9BF3-FCF73A17EF62";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v3] ext4: remove code duplication in
 update_ind/bind/tind_extent_range
Date:   Wed, 13 Mar 2019 18:31:01 -0600
In-Reply-To: <3ac55ceb-729c-52f9-1cfe-690a62be85ec@virtuozzo.com>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To:     Vasily Averin <vvs@virtuozzo.com>
References: <3ac55ceb-729c-52f9-1cfe-690a62be85ec@virtuozzo.com>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_7E2F1EAC-02FF-441C-9BF3-FCF73A17EF62
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 12, 2019, at 7:09 AM, Vasily Averin <vvs@virtuozzo.com> wrote:
>=20
> update_ind/bind/tind_extent_page() differs by one variable and can be
> replaced by unified function. These functions are called by similar =
way
> and their caller function can be simplified too.
>=20
> v2: minor style changes, thanks to Andreas Dilger
> v3: rebase to v5.0
>=20
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

Always good to see patches that remove more lines than they add.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/ext4/migrate.c | 112 ++++++++++------------------------------------
> 1 file changed, 24 insertions(+), 88 deletions(-)
>=20
> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index b1e4d359f73b..fde2f1bc96b0 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -109,12 +109,13 @@ static int update_extent_range(handle_t *handle, =
struct inode *inode,
>=20
> static int update_ind_extent_range(handle_t *handle, struct inode =
*inode,
> 				   ext4_fsblk_t pblock,
> -				   struct migrate_struct *lb)
> +				   struct migrate_struct *lb,
> +				   ext4_lblk_t inc)
> {
> 	struct buffer_head *bh;
> 	__le32 *i_data;
> 	int i, retval =3D 0;
> -	unsigned long max_entries =3D inode->i_sb->s_blocksize >> 2;
> +	ext4_lblk_t max_entries =3D inode->i_sb->s_blocksize >> 2;
>=20
> 	bh =3D ext4_sb_bread(inode->i_sb, pblock, 0);
> 	if (IS_ERR(bh))
> @@ -128,67 +129,7 @@ static int update_ind_extent_range(handle_t =
*handle, struct inode *inode,
> 			if (retval)
> 				break;
> 		} else {
> -			lb->curr_block++;
> -		}
> -	}
> -	put_bh(bh);
> -	return retval;
> -
> -}
> -
> -static int update_dind_extent_range(handle_t *handle, struct inode =
*inode,
> -				    ext4_fsblk_t pblock,
> -				    struct migrate_struct *lb)
> -{
> -	struct buffer_head *bh;
> -	__le32 *i_data;
> -	int i, retval =3D 0;
> -	unsigned long max_entries =3D inode->i_sb->s_blocksize >> 2;
> -
> -	bh =3D ext4_sb_bread(inode->i_sb, pblock, 0);
> -	if (IS_ERR(bh))
> -		return PTR_ERR(bh);
> -
> -	i_data =3D (__le32 *)bh->b_data;
> -	for (i =3D 0; i < max_entries; i++) {
> -		if (i_data[i]) {
> -			retval =3D update_ind_extent_range(handle, =
inode,
> -						le32_to_cpu(i_data[i]), =
lb);
> -			if (retval)
> -				break;
> -		} else {
> -			/* Only update the file block number */
> -			lb->curr_block +=3D max_entries;
> -		}
> -	}
> -	put_bh(bh);
> -	return retval;
> -
> -}
> -
> -static int update_tind_extent_range(handle_t *handle, struct inode =
*inode,
> -				    ext4_fsblk_t pblock,
> -				    struct migrate_struct *lb)
> -{
> -	struct buffer_head *bh;
> -	__le32 *i_data;
> -	int i, retval =3D 0;
> -	unsigned long max_entries =3D inode->i_sb->s_blocksize >> 2;
> -
> -	bh =3D ext4_sb_bread(inode->i_sb, pblock, 0);
> -	if (IS_ERR(bh))
> -		return PTR_ERR(bh);
> -
> -	i_data =3D (__le32 *)bh->b_data;
> -	for (i =3D 0; i < max_entries; i++) {
> -		if (i_data[i]) {
> -			retval =3D update_dind_extent_range(handle, =
inode,
> -						le32_to_cpu(i_data[i]), =
lb);
> -			if (retval)
> -				break;
> -		} else {
> -			/* Only update the file block number */
> -			lb->curr_block +=3D max_entries * max_entries;
> +			lb->curr_block +=3D inc;
> 		}
> 	}
> 	put_bh(bh);
> @@ -433,7 +374,7 @@ int ext4_ext_migrate(struct inode *inode)
> 	struct ext4_inode_info *ei;
> 	struct inode *tmp_inode =3D NULL;
> 	struct migrate_struct lb;
> -	unsigned long max_entries;
> +	ext4_lblk_t max_entries, inc, mult;
> 	__u32 goal;
> 	uid_t owner[2];
>=20
> @@ -523,34 +464,29 @@ int ext4_ext_migrate(struct inode *inode)
>=20
> 	/* 32 bit block address 4 bytes */
> 	max_entries =3D inode->i_sb->s_blocksize >> 2;
> -	for (i =3D 0; i < EXT4_NDIR_BLOCKS; i++) {
> +
> +	inc =3D 1; mult =3D 1;
> +	for (i =3D 0; i < EXT4_N_BLOCKS; i++) {
> +		inc *=3D mult;
> +		if (i =3D=3D EXT4_IND_BLOCK)
> +			mult =3D max_entries;
> +
> 		if (i_data[i]) {
> -			retval =3D update_extent_range(handle, =
tmp_inode,
> +			if (i < EXT4_IND_BLOCK)
> +				retval =3D update_extent_range(handle, =
tmp_inode,
> 						le32_to_cpu(i_data[i]), =
&lb);
> +			else
> +				retval =3D =
update_ind_extent_range(handle,
> +						tmp_inode,
> +						le32_to_cpu(i_data[i]),
> +						&lb, inc);
> 			if (retval)
> 				goto err_out;
> -		} else
> -			lb.curr_block++;
> -	}
> -	if (i_data[EXT4_IND_BLOCK]) {
> -		retval =3D update_ind_extent_range(handle, tmp_inode,
> -				le32_to_cpu(i_data[EXT4_IND_BLOCK]), =
&lb);
> -		if (retval)
> -			goto err_out;
> -	} else
> -		lb.curr_block +=3D max_entries;
> -	if (i_data[EXT4_DIND_BLOCK]) {
> -		retval =3D update_dind_extent_range(handle, tmp_inode,
> -				le32_to_cpu(i_data[EXT4_DIND_BLOCK]), =
&lb);
> -		if (retval)
> -			goto err_out;
> -	} else
> -		lb.curr_block +=3D max_entries * max_entries;
> -	if (i_data[EXT4_TIND_BLOCK]) {
> -		retval =3D update_tind_extent_range(handle, tmp_inode,
> -				le32_to_cpu(i_data[EXT4_TIND_BLOCK]), =
&lb);
> -		if (retval)
> -			goto err_out;
> +
> +		} else {
> +			if (i < EXT4_TIND_BLOCK)
> +				lb.curr_block +=3D inc * mult;
> +		}
> 	}
> 	/*
> 	 * Build the last extent
> --
> 2.17.1
>=20


Cheers, Andreas






--Apple-Mail=_7E2F1EAC-02FF-441C-9BF3-FCF73A17EF62
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlyJoMUACgkQcqXauRfM
H+BE+Q/8D8eKKTXuu/ZnuJqRiI1SWyuMX23L567MOksnhO3AcwlRGxGZGjfmEU3d
x8MCzgt3uhL3pXnGRwYzUlO1zDtHquf26jLV9NITyysGt+/cRDPq7vY7h4TQjcKd
praA4lDRUBzJpYfpXX1BFzJgZMM3t6uJluwLrm768cu1U7ndhuQwi1Gw/jkMFjVh
TM/jFzx+GjmNDPOR9pqZfIzFK3e1I4ZobgAVRL5sexEczwxAzklWqXGvS4OLSnDJ
/4b1GSupqed6rKr6J8e3Z9efjJf3ZlrdW+S9+Ba9oHQWalVm1YT/86HIOU7eU4vI
tdhuRt+zQ944cah3+v/Bk63HoRUcgsUQyCQqpEFa2/32m3NPSzKAjKBTf7KCXRLv
TKQQyK2TMGpfihM2qUJFsRBZfDhN5iocZG5Q380Nuf+eJs6vVAHlfrOIIiE0Kt1S
C34zzp/b/oej2Xr7dIyV2V6AjfocBbyauutEEm9IncEWc4gXprrxo7wmteHFKsdW
riCre3/Te5VcG7OPF2+sH25tKPrN2IPsuqkPLtBkY+fnuIgjdJl+1oPqp+bP+TQ3
SqjY9L/7ihfxw5940nEgOrbcjgPgW29msjOnNirkr5zq3E1pSEtucIHnnp5nzjJe
wZvnogkr+59DU0ZfU5+lyPrci01R1seARTjtiUunmNdexZspd+Y=
=LI06
-----END PGP SIGNATURE-----

--Apple-Mail=_7E2F1EAC-02FF-441C-9BF3-FCF73A17EF62--
