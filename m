Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36B13ACA52
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2026 22:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779920805; cv=none; b=EHJ4FEuOJCjpwOIqRM46bLyTu5uGoF+lLyH3+Dni05Ju5vf7MO/mYyOien0u8zvS6S7r5SczdwjqVT/3brok1SXfBl5wOA70bgcbC6X1zWNWFhWFEtYb2WM3bk+y4AXSMbgQ5Ep4DwGye0TlLXIZTl/6LKDGfroKcoqYYSlyu+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779920805; c=relaxed/simple;
	bh=iyj+JZLzutz+8eAbzxvof1TDAlIzH6WhRaGKOjULg1I=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=gc1vOERkuuk/DGJd4ab+YehexqkXsIB+1j2SC9xf+Q/lvOpFB/rjAFYFoi6HqXj1+YjdMokXADVXPOtjg1nToAbOL+mruELoEtlh5hTrvPhxS0Z32Een9wRDUmlIqvIDaK/ObfNeWtsqMejL6Te1SdF11yUUe3+O/8D55yT8e9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=GRbwlTsF; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="GRbwlTsF"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-83945063f70so5993006b3a.0
        for <linux-ext4@vger.kernel.org>; Wed, 27 May 2026 15:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1779920803; x=1780525603; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fxqXSZdONDZoVb0F7b5qztzVPVp/m7Tlj5aDQv6uI18=;
        b=GRbwlTsFCik1WS0JrjrnXjGaSXhMPBdOiYwUEJoIEedmoVYHflsYxgg8MnhiUzcjtL
         DQCRh5tbJUqCAJbpf6SrYHlS/9JbmC1XQJo3e5HPYiHieXOgTMYfvs1Fy95u+tlv3sIX
         4fvf19cy4gUdGXYLh5Tc8T7zhGAlWB69jyKaqlPElIwmIwET769dBy3N1icU4vY0XycT
         EDBMCVE78Q7BJF+RgNB3Bkh26hX/fVjNMBnR1rqhYew2Db9m9+SOssnAxi5aiUtcQiDK
         3uHmZPYsEsto5Cr1R+oQxcLTHmgOeZRGnHrOcmYuLllvVhEGlELms1N4P8euZivbfWam
         5Agw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779920803; x=1780525603;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fxqXSZdONDZoVb0F7b5qztzVPVp/m7Tlj5aDQv6uI18=;
        b=P6JHyHfzCq/qqGM3WY/Yf6/ZOM3nPAQCgm0BS4jewnV1mKbrBPXsbNcy4OtY96nW+a
         qM/RHKrBZJbhK+j7+ihJuAVa3eso/hTdohlNETIycvGfCZ5+j+3+0SDWYlm3VBX1bGDo
         9V10E3dwnDKRxAoa5k8pu6T9apX/8GKTqoK3r4I2P+rVdeRerj3L340gpAiwnjVzZbPo
         8sYHjGcv2BEx8yA4W9uz2KT0Gvjx3iadP3fbV25YeFjKTCTDfOIZ6jSKbLvj81Emjaui
         gQ5CMzfMfUadWKUEMOoDJ7GrZIE1+0+mJLZcuk+Dr/3ftvLKd9YySfTp8plFdS/f1Kt6
         bzhQ==
X-Gm-Message-State: AOJu0Yzi1rd6FgeN83lFJLXDzavglxHB4C0yu6opvQOFHaKCQxVx6ZJl
	dRmppVchUibsIS9Kn+kqjXII3YDgN8OXoLSNhv2wUa9hSbNpuYPbtyW6mBN4eEqLfxk=
X-Gm-Gg: Acq92OFCyyNWih+/C212xlHjFLaUzTHAwmpvjZrL3Ae/WPrzSgdzgOJY8ShVtkwl6um
	iliST5KqxmThy7aWbGWT8JarJD6DHs1vtqXGrk8gC+g1pvhAWzcHAPeyglZXe/dJIx03n4+HPZT
	Wg7bR1msSyC8ztjSlSOkFET6d3heJcDVBUZOeK64JxTVf297iC3+S44VsVULIZvIjEkIO15BkWT
	7IvKMkhDCvH6iFw/U2vUeU4JdgzlEixty7qbcDWQXPs0yy/c28EHXK8wmpdNKd57v6kOhq0Hmct
	3DafwmmLChM5x/XCWK0RQ811p8YXd+ifKdnOsAfQ0yJAffi0WD7EjkcO9e/NBK+gHB7vkQYVDsa
	UmKPX3zVeZneFwPM3WtoY27M89y3y74F1kWGt287fnNni1KvblufdybB5uiiyp6KVWngVCp61ZJ
	xJ+iqQDiB/doYwnYRgRo+yqEEiSwWpcA+ICFT65V0jfLwM4sT4CPBvXVJfpKBimPxawPw3EfxL7
	XWgG7THrVhcZEqz
X-Received: by 2002:a05:6a00:9084:b0:82f:3774:4fdc with SMTP id d2e1a72fcca58-84160b83b91mr18178209b3a.1.1779920803069;
        Wed, 27 May 2026 15:26:43 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841d730af8fsm3137247b3a.60.2026.05.27.15.26.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 May 2026 15:26:42 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH] ext4: add ext4_dir_entry_is_tail()
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260526233816.7654-1-ablagodarenko@thelustrecollective.com>
Date: Wed, 27 May 2026 16:26:31 -0600
Cc: linux-ext4@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <575C3642-AB82-4BE7-8A27-1A16F97571EC@dilger.ca>
References: <20260526233816.7654-1-ablagodarenko@thelustrecollective.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On May 26, 2026, at 17:38, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
>=20
> Replace open-coded checks for directory tail entries with a call
> to ext4_dir_entry_is_tail(). This helper will also be used by
> upcoming changes.
>=20
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca =
<mailto:adilger@dilger.ca>>

> ---
> fs/ext4/ext4.h  | 16 ++++++++++++++++
> fs/ext4/namei.c |  7 +------
> 2 files changed, 17 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 94283a991e5c..01b1222b1454 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3917,6 +3917,22 @@ static inline void =
ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
>  	io_end->flag &=3D ~EXT4_IO_END_UNWRITTEN;
>  }
> =20
> +/*
> + * ext4_dir_entry_is_tail() - Check if a directory entry is a tail =
entry.
> + * @de: directory entry to check
> + *
> + * Returns true if @de is a directory block tail entry (checksum =
record).
> + */
> +static inline bool ext4_dir_entry_is_tail(struct ext4_dir_entry_2 =
*de)
> +{
> +	struct ext4_dir_entry_tail *t =3D (struct ext4_dir_entry_tail =
*)de;
> +
> +	return !t->det_reserved_zero1 &&
> +	      le16_to_cpu(t->det_rec_len) =3D=3D sizeof(*t) &&
> +	      !t->det_reserved_zero2 &&
> +	      t->det_reserved_ft =3D=3D EXT4_FT_DIR_CSUM;
> +}
> +
>  extern const struct iomap_ops ext4_iomap_ops;
>  extern const struct iomap_ops ext4_iomap_report_ops;
> =20
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 4a47fbd8dd30..accf63fbbc79 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -314,7 +314,6 @@ static struct ext4_dir_entry_tail =
*get_dirent_tail(struct inode *inode,
>   struct buffer_head *bh)
>  {
>  	struct ext4_dir_entry_tail *t;
> -	int blocksize =3D EXT4_BLOCK_SIZE(inode->i_sb);
> =20
>  #ifdef PARANOID
>  	struct ext4_dir_entry *d, *top;
> @@ -334,11 +333,7 @@ static struct ext4_dir_entry_tail =
*get_dirent_tail(struct inode *inode,
>  	t =3D EXT4_DIRENT_TAIL(bh->b_data, =
EXT4_BLOCK_SIZE(inode->i_sb));
>  #endif
> =20
> -	if (t->det_reserved_zero1 ||
> -		   (ext4_rec_len_from_disk(t->det_rec_len, blocksize) !=3D=

> -		    sizeof(struct ext4_dir_entry_tail)) ||
> -		   t->det_reserved_zero2 ||
> -		   t->det_reserved_ft !=3D EXT4_FT_DIR_CSUM)
> +	if (!ext4_dir_entry_is_tail((struct ext4_dir_entry_2 *)t))
>  		return NULL;
> =20
>  	return t;
> --=20
> 2.43.7
>=20


Cheers, Andreas





