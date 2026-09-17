Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46844E06E5
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2026 19:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789674403; cv=none; b=YyuPN5zL5v8q3xMnmxK6jTalS0/ucNt8GkPUOXY7bwX7oAXNinIO+K9wObAgMU0qwJQm8PkdJYUGwXURJISvd0lDKxoZcHS91X5Fg4bmU53mW+3w4jbI6pM1xlKLsh3meqAwiyna79k0PrjlZVBQNR4LzSJmz65n9xsTl0eMRY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789674403; c=relaxed/simple;
	bh=J395OdcAvINDFH5EsNPp9eX/ISxP92k+SNBgpqBwGhE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=FYVf3r+Oj5ti7Xj1e6sO3dojnxLa59CjFeaz64Zdt2KMVgWI2cHZwcPDo12soz/8n1EHSxNRJ7iD1VJoZeTiLbvEB59JSVuL2qur+/Vx9KJb8YecawO6lYrLf1WIvzgkoh1aOzOaPqV/C//vmIBDwYmbBWsUbAX61+vDT8DrbSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=h/XHEk8Z; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="h/XHEk8Z"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d91ede8035so135945ad.3
        for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2026 12:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1789674399; x=1790279199; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7caSD0RrDJs9mmxp2S1vWD9pRdslsdHGImymqLKFUPw=;
        b=h/XHEk8Z3/1tdJgDIzANyEW/O5ym/QPMh1dOgRMsqHoRALBER+93dt4xphpkqaRP7z
         vP6PAPI7pMO89VJXYWPEPf3hPlwVFszekNQ8kXs8r8NVQI+fTeTGDaOiHKkSifhvsmRb
         pPfT1LAdoaww457jpIPERS5xTldAXc6Q2vOLRVEjRa1L5iksB9vS5MVnopX/m7/GgPJc
         vIRtGdegx7VKZ388b8Ifta2tcum4AC75+9FC+sQ92d8CA0QMjzLQLCgTlTyh/kCNcdXJ
         PaDQNBJUqJj6lCGvQkRRhmb1RS84oCNHN/GBJIgjXy7IMHVUovhsi4Spv9VZgTSmSa0y
         +8Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789674399; x=1790279199;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7caSD0RrDJs9mmxp2S1vWD9pRdslsdHGImymqLKFUPw=;
        b=RRmro358nduBmFqHueCx7g7ykssgy9bSfjDDKkgsdE2dwjgvpUNI9kYqV/rPiJM4sd
         2niOovFpCiD7EeWX/YJ6WjkxMeEyuSTFGK1F0aqVOEW9jebrk0E8bGvIXgKz1SiK8SuQ
         cqRGIgs3kIc4XOq4qW4Vf2o6n4DNwgSaplyRFJHhw7R0L/Xi7UtqYxuWWQQY+SJTZyyF
         kcBv+1Sw+g7poA+r/8/+ADYV5q5xVLcqclo3Zj5N4dzZHwBzH7LfCiwgsCjmm3d8xDx1
         1ITAN9GnnvWhHXswdgoSMTmL7Re302B4VFg+sT59gZCkARQYMSlVOMXJoFOA+Jm+stP8
         HZ6g==
X-Gm-Message-State: AFuF++kRS1zYr5tUHiM+UvSPUA9vVbB9U1VVWTrZ3YlNTXuCNhZdTb3x
	f5AOASmLHpvxtvoT4fWlISgjjLzojuspA+M2eHsUIKA0yS9C9AZ8+yhqumXzHXvXPlU=
X-Gm-Gg: AYBFou2DEAD0gBLuOQQB/zKYQFJkzOY35njcLuHR++lXmSEp2nvjV0/4vkjc/rzp88n
	bvNrTjbe0JWOuitpXWxk+CBap7Rb2Aq/lN5xiCevi+u6mnl7bVABfvuLQpig70/2olDs9/mElpz
	EOBVQiovtL5Q8BUxKRRHRwdDcfU1Dwso8Kf8v6z8w4Zc4QtMjue8Hk2bXEpAjG/0I2Afr0+F9zK
	sD//QCexIIvqeEpgO9+k3iHoLwNpMsI97LTfimpGg1xPfq1O3SV8ZJmJ1gY9DoFqx+bQDy6N5/M
	Wly4/9wfUmFhAi27UqIgga43XqfpgwO7l+J0ZvQU0F4NkR+beEfzPIQsWMrjA2qRdCZvwH6h1+3
	Y/vbDecvTbKuC3lxETqAhZE2bUk6m2DQPx3SPrWd8JToNVsgq5+z++FbGUs9Q7VvnWygRwjTwUe
	ueFUwV61dNwELy/IRsKWjHNE/erc4hB4GezIvO70U1zVTBTRKQpsLI4+2emw3rBzYUji+omwg6X
	cIDR28vzz2wn4o0B/Kw7ZA/ISu2q2GkcOMJlrTDngJMLaW4f9ptTA==
X-Received: by 2002:a17:902:f687:b0:2db:2413:87d2 with SMTP id d9443c01a7336-2ddb1ac954dmr5277545ad.4.1789674399407;
        Thu, 17 Sep 2026 12:46:39 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dda9cf4c4dsm9457035ad.30.2026.09.17.12.46.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2026 12:46:38 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.3\))
Subject: Re: [PATCH] ext4: don't read past the UAPI struct in
 EXT4_IOC_GROUP_ADD
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260917151949.415967-1-kaixuan.li@ntu.edu.sg>
Date: Thu, 17 Sep 2026 13:46:26 -0600
Cc: linux-ext4@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C988F080-1069-4584-AAC8-A9476B699208@dilger.ca>
References: <20260917151949.415967-1-kaixuan.li@ntu.edu.sg>
To: MarkLee131 <kaixuanli0131@gmail.com>
X-Mailer: Apple Mail (2.3864.700.51.1.3)

On Sep 17, 2026, at 09:19, MarkLee131 <kaixuanli0131@gmail.com> wrote:
>=20
> From: Kaixuan Li <kaixuanli0131@gmail.com>
>=20
> EXT4_IOC_GROUP_ADD casts the user pointer to struct =
ext4_new_group_input,
> its UAPI type, but sizes the copy by struct ext4_new_group_data, the
> internal type:
>=20
> struct ext4_new_group_data input;
>=20
> if (copy_from_user(&input, (struct ext4_new_group_input __user *)arg,
> sizeof(input)))
>=20
> The UAPI struct is 40 bytes, the internal one 48.  A caller that =
follows
> the UAPI and allocates 40 bytes gets 8 bytes read past its object, and =
the
> ioctl returns EFAULT when those bytes are unmapped.  The internal =
struct
> has carried the extra fields since ext4 was split from ext3, so the =
copy
> has always over-read the UAPI object.
>=20
> The two extra fields are not used from this path: free_clusters_count =
is
> overwritten by verify_group_input(), and mdata_blocks is used only by
> ext4_resize_fs(), which builds its own group_data array.  The compat =
path
> already copies the six UAPI fields individually; the native path does =
not.
>=20
> Copy the UAPI struct, then set the internal fields from it.
>=20
> Reproducible on v6.12.9 and v7.2.4 by placing a 40-byte struct at the =
end
> of a mapped page whose successor is unmapped: the ioctl returns =
EFAULT.
>=20
> Signed-off-by: Kaixuan Li <kaixuanli0131@gmail.com>
> ---
> Built fs/ext4/ioctl.o warning-free (W=3D1, x86_64 defconfig) and =
checkpatch-clean.
> The bug (EFAULT on a conforming 40-byte object) was reproduced under =
QEMU on
> v6.12.9 and v7.2.4; the fix itself was not runtime-tested.
> fs/ext4/ioctl.c | 14 ++++++++++++--
> 1 file changed, 12 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index c8387e6a2c6e..ea3cd8cdae25 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -1674,12 +1674,22 @@ static long __ext4_ioctl(struct file *filp, =
unsigned int cmd,
>  	}
> =20
>  	case EXT4_IOC_GROUP_ADD: {
> +		struct ext4_new_group_input uinput;
>  		struct ext4_new_group_data input;
> =20
> -		if (copy_from_user(&input, (struct ext4_new_group_input =
__user *)arg,
> -				sizeof(input)))
> +		if (copy_from_user(&uinput,
> +				   (struct ext4_new_group_input __user =
*)arg,
> +				   sizeof(uinput)))
>  			return -EFAULT;
> =20
> +		memset(&input, 0, sizeof(input));
> +		input.group =3D uinput.group;
> +		input.block_bitmap =3D uinput.block_bitmap;
> +		input.inode_bitmap =3D uinput.inode_bitmap;
> +		input.inode_table =3D uinput.inode_table;
> +		input.blocks_count =3D uinput.blocks_count;
> +		input.reserved_blocks =3D uinput.reserved_blocks;
> +

This does more than necessary.  It doesn't need two copies of the struct =
on the stack,
and it doesn't need to copy the fields twice.  It could just copy the =
'input' part of
the struct into the 'data' struct and zero only the remaining fields, =
something like:

	case EXT4_IOC_GROUP_ADD: {
		struct ext4_new_group_input __user *uinput =3D (void =
__user *)arg;
		struct ext4_new_group_data data;
=20
		if (copy_from_user(&data, uinput, sizeof(*uinput))
			return -EFAULT;
=20
		memset(&data + sizeof(*uinput), 0, sizeof(data) - =
sizeof(*uinput));

		return ext4_ioctl_group_add(filp, &data);

Cheers, Andreas





