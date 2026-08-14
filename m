Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2016743F8CF
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786702561; cv=none; b=SLMqaCirxrWdIcc0HeIj2OEilm/kSVGPS8sSEfeTGoczE8xkFWnK0bFw9BB9PfwsOHk+BHWNPHvUA0mbPPttNc/haM67eyF0vcSCwlqbB3MfEj6q7urH2X1jW7FFhE6y4G0GH5SaD15hX2+Jp+ak/uEXV4VjdNvHxMZeE+5E6Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786702561; c=relaxed/simple;
	bh=UCNLHajMA/vzLb2Nw2FNUmwXxNaJiVjk3Ppj9yJ93rA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oqTASdsLrOabDp5qwB/rOVC0mF4UPPZZ1IUVcJhC2EIv65qZOHOnWI3UTBK6az3o3FNDbVIDmS+kax1OfUOuYyGK2QZogqT+EBqSVtQPpnX4nxPx9jCqK9z9woWm8BVtPoZTVUYC2q1C+rn0EM58/0gVA6ltt1Cg/2nwZWzKYKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WSikkW4Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WSikkW4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428AA1F000E9;
	Fri, 14 Aug 2026 10:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786702554;
	bh=zmidhZb14XfYV6BQA4QsdpCcjVcjFmGr72gid3kfr6k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WSikkW4ZM8iJ4bjwRejkkM3x8porjQEOHTimHvrVJqdpEKaUEE+V0ATMOtOVVGFAX
	 Uy9lUGK4bLzNbSsGVkpFWoWxUPfzAsPB/tyTvixIhM+Jfins1H4qWB7F4vEJLgTDsE
	 vA0iOgeMZNjuw/IqlFyFL9XyfyhtEO+rQN64iV3T7RnTi3Q95YVEbpHNRbcu3Cgk6V
	 dID8kOUVfW27Hgpty/zaF7Y4xnLB/9zNi3QG8itpv/7doeNjlftZa278bNKUXksFKg
	 +0cJhU8droy6mkODYf6Z67bfJVHKCCd7WjUYcZ3CkQ+MVjGfS5a4URlL25xzmWhwO6
	 7IidGfGwDTf2Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 10/32] ext4: skip block allocation for holes in
 the data submission path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260814093331.1703882-11-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-11-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:15:53 +0000
Message-Id: <20260814101554.428AA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ext4_convert_unwritten_extents_atomic() silently aborts conversion=
 if it encounters a hole, leading to data loss for the rest of the atomic w=
rite range.
--

--- Patch [10]: [PATCH -next v5 10/32] ext4: skip block allocation for hole=
s in the data submission path ---
commit 741674f6128ebda7382e0529fd0b709e4ae876be
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: skip block allocation for holes in the data submission path

This commit updates ext4_map_blocks() to avoid allocating blocks for holes
in the data submission path, returning 0 instead. To prevent data loss
during extent conversion, ext4_convert_unwritten_extents() is modified
to skip over unexpected holes and continue converting subsequent blocks.

> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 76038b6c36552..0d62d9312284e 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -5167,11 +5167,15 @@ int ext4_convert_unwritten_extents(handle_t *hand=
le, struct inode *inode,
>  				      EXT4_GET_BLOCKS_IO_CONVERT_EXT |
>  				      EXT4_EX_NOCACHE);
>  		if (ret <=3D 0) {
> +			/*
> +			 * If the ret is zero, an unexpected hole may cause
> +			 * conversion to fail.  To avoid data loss during I/O
> +			 * end conversion, skip the hole and continue
> +			 * converting subsequent blocks.
> +			 */
>  			ext4_warning(inode->i_sb,
>  				     "inode #%llu: block %u: len %u: ext4_map_blocks returned %d",
>  				     inode->i_ino, map.m_lblk, map.m_len, ret);
> -			if (unlikely(ret =3D=3D 0))
> -				ret =3D -EINVAL;
>  		} else {
>  			conv_blocks +=3D map.m_len;
>  		}

[Severity: High]
Since ext4_map_blocks() will now return 0 for holes when
EXT4_GET_BLOCKS_IO_SUBMIT is set, should
ext4_convert_unwritten_extents_atomic() also be updated to handle holes?

In ext4_convert_unwritten_extents_atomic():

	int flags =3D EXT4_GET_BLOCKS_IO_CONVERT_EXT | EXT4_EX_NOCACHE;
...
	while (ret >=3D 0 && ret < max_blocks) {
		map.m_lblk +=3D ret;
		map.m_len =3D (max_blocks -=3D ret);
		ret =3D ext4_map_blocks(handle, inode, &map, flags);
...
		if (ret <=3D 0)
			break;
	}

It looks like if ext4_map_blocks() returns 0 for a hole, the loop will
break early and the function will return 0. Will this leave the remaining
blocks in the atomic write range unconverted and cause data loss?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D10
