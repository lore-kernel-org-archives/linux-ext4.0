Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8351A4C150B
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 10:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791543490; cv=none; b=rZdtkW4CGIsN6scLXzJ1qGJoAtICs5OdDEL31y0Fbl5yWskiJFGAOVJU6CrATpOVClmCcBfmUor/JQmTr4ipYItcVPBm+3pJsU8q00MdzPlzFrdiUSuAaVI86vKNf1bst/yhPbbJIT9qD4A/XNHc4VrOqEi4qVT7RY/SVgPPQr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791543490; c=relaxed/simple;
	bh=+zqDg27zuKjpaCq+SvWPM78SPaVoWwEwwPfmDATRXHM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=WIQsqPQ9BKV3j8IItKYwB1xt9C9evoAp1xsaLjs7VswMW7fcF4tYlJap+IFOCSuontrBSitSP5IeLzJQyLb4sVuS0+vRi3/VuTcZKdRIPVe4WDESFCmPTpraVbvtE+Rvq7ZxaaWZ4VGC/8x9Cerukk6/MvUnTY5i2qMclmf7ZRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dTzfraH/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dTzfraH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CAA1F000FF;
	Fri,  9 Oct 2026 10:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791543481;
	bh=D/1Ze0QrGCPh6vCtL/+JrWSMzzhmCMjXmdSdaNS2EYQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dTzfraH/vVDRoC0Wvp/LoQM5/ENg9OFCS73PjrLOi7LTZVNquB7RlOQzI4JrwhB+7
	 XEJNiWahPvqRf43/f56S7z6VEbXQZoV1bGZ3g2pcwrcuuLBYURVNUxs4WRshZgp93R
	 3INePq+SugmuCf1vyLb9KFd7RP+MYZJ51p0iiN+7K7UqRN53/16ULBxhpV7Sr41FJF
	 t7lw+HqA/kHmL5Mwq+qgwFBQl4PUJ2NSOTlQs+wDXg/A3JkBxLUCu8RQFGIfjj3cij
	 hTc0ONRymEczGwTE/VPPxGf2YtSTRILfayi1+caOg6zvGfk2qrVqVcQmDYJMFvRoxt
	 AqeYALotF2njw==
Message-ID: <sashiko-outbox-165289@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 08/31] ext4: skip block allocation for holes in the
 data submission path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261009103033.2920530-9-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-9-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 10:58:00 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ext4: silent data loss in atomic extent conversion due to unhandle=
d 0 return
--

commit d986a085e4ae32e7076239e912abb3b6e2e97038
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: skip block allocation for holes in the data submission path

When ext4_map_blocks() is called from the data submission path and I/O
end extent conversion path, it should not allocate blocks if the lookup
returns a hole. This patch prepares for the buffered iomap writeback
conversion by filtering out holes and bailing out with an error.

>     In the ioend extent conversion path, holes are also not expected beca=
use
>     we should wait for folio writeback before punching hole. If one is
>     encountered, it likely indicates a failure in the concurrency
>     protection, so ext4_map_blocks() returns zero, and we keep warning and
>     bail out with -EINVAL to surface the failure rather than continuing
>     conversion on torn data. Atomic writes in
>     ext4_convert_unwritten_extents_atomic() already bail out similarly.

[Severity: High]
The commit message states that ext4_convert_unwritten_extents_atomic()
"already bails out similarly" (presumably with an error code like -EINVAL)
when ext4_map_blocks() returns 0 for a hole.

However, looking at ext4_convert_unwritten_extents_atomic() in
fs/ext4/extents.c, it breaks the loop when ret is 0, and returns 0 (success=
):

fs/ext4/extents.c:ext4_convert_unwritten_extents_atomic() {
    ...
	while (ret >=3D 0 && ret < max_blocks) {
		map.m_lblk +=3D ret;
		map.m_len =3D (max_blocks -=3D ret);
		ret =3D ext4_map_blocks(handle, inode, &map, flags);
		...
		if (ret <=3D 0)
			break;
	}
    ...
	if (ret <=3D 0 || ret2)
		ext4_warning(inode->i_sb, ...);

	return ret > 0 ? ret2 : ret;
}

If ret is 0, the expression ret > 0 ? ret2 : ret evaluates to 0.

Could this cause a regression where the unwritten extent conversion fails
due to encountering a hole, but the direct I/O layer is told it succeeded,
leaving unwritten extents on disk that will return zeroes on subsequent
reads?

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 6b0489cbb1319..778cf539f6df2 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c

[ ... ]

> @@ -830,6 +830,13 @@ int ext4_map_blocks(handle_t *handle, struct inode *=
inode,
>  				map->m_flags |=3D EXT4_MAP_MAPPED;
>  			goto out;
>  		}
> +	} else if (retval =3D=3D 0) {
> +		/*
> +		 * Do not allocate blocks for holes in the context of
> +		 * data submission path.
> +		 */
> +		if (!map->m_flags && (flags & EXT4_GET_BLOCKS_IO_SUBMIT))
> +			goto out;
>  	}
> =20
>  	if (!handle) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D8
