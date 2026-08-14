Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079D0427FA2
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786702561; cv=none; b=NxU0mjyKbT6l3yvd7xaabw+IDO/R6Z1eWLpcuaff/xcl48sUbgTkf4IJhYJSJp1jvXmivHVoZxvsaFVoVf2Y3r2kzVG75t5v9mtypt+GyZypADO3KS6QwP1QMi3d1b1cHJ/DnAPJ9ZJAQ3S72YoE5O7YgrUD8uPtKMzSsS/WDf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786702561; c=relaxed/simple;
	bh=do4abbVEH38k9UTk+u5krP7OafxWQo1CdGk+dBJ14Uw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Os5xs9M4iHl99MbuUZ7CfBzcXnkIz/vcY/RNPK2R3lSAAMBNV6BTSzWrdFUmVxk+GBFxpqIUT/BWoOaVCqzTz+gxicWZhaTgVtdRfEDwu2mK4sSSfGU+xjc53H9OddFYk0hvIF+ydZ/qk1uYuEutm2NQPq0Pqfr059FOayCYQxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iwmKONTZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iwmKONTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E86E1F00A3D;
	Fri, 14 Aug 2026 10:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786702548;
	bh=u0R1nMtHm0/vFxQ0Ao9/9Oq+NdTtiPVfdYvkPltt2JI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iwmKONTZef48lzLm4OghRYcEuh1OsSZMEQEahVkZ8Opix0TU/B9KYefgEDQrHOd/8
	 +KRg7R9lhzGqZ+w4wNCTtR6nABqqtlun1m2UbMac1Dy678PKwnkA6EUCJSSPhYZzsV
	 IAmCI0ibo9LA1URLPZNz/MPgUZ0iDNO8IMCX6opYzeLaw6otwPqDqLujY9zEQMnnM2
	 l37BZ1oSo3UKiYtzvYRZFdRjfPyhEZFsTvCizH4kWvaCjy1K+KxtxfxnUiafxQxwjI
	 /rFgeh1qejYJEiEK6YnOT+8otGY4x43tzlkLIohRAeulv/UqChGSGKLI62LBvHWmAe
	 Pml+8WcnByFDg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 06/32] ext4: recheck extent status tree before
 block allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260814093331.1703882-7-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-7-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:15:48 +0000
Message-Id: <20260814101548.7E86E1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Reading uninitialized `map->m_seq` on error paths leads to an infi=
nite retry loop in `ext4_map_blocks()`, causing a kernel hard lockup.
--

--- Patch [6]: [PATCH -next v5 06/32] ext4: recheck extent status tree befo=
re block allocation ---
commit 6ae9b515f2027351280fce82734e7e8361a281e7
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: recheck extent status tree before block allocation

After acquiring i_data_sem in write mode, recheck that the mapping
found via the extent status tree or disk query has not changed. If
we find a valid extent and the sequence number has changed, retry
the entire lookup to obtain the correct trimmed mapping.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9dbece14ae569..548a3968c5a7d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c

[ ... ]

> @@ -820,6 +821,19 @@ int ext4_map_blocks(handle_t *handle, struct inode *=
inode,
>  	 * with create =3D=3D 1 flag.
>  	 */
>  	down_write(&EXT4_I(inode)->i_data_sem);
> +
> +	/*
> +	 * Check the validity of the mapping found via the extent status
> +	 * tree or the disk query. A racing truncate may have changed the
> +	 * extent, since writeback does not hold i_rwsem or the folio locks
> +	 * covering the full extent.
> +	 */
> +	if (map->m_seq !=3D READ_ONCE(EXT4_I(inode)->i_es_seq)) {
> +		up_write(&EXT4_I(inode)->i_data_sem);
> +		map->m_flags =3D 0;
> +		map->m_len =3D orig_mlen;
> +		goto create_retry;
> +	}

[Severity: High]
Could this cause an infinite loop and hard lockup on disk error?

If ext4_map_query_blocks() encounters an error like -EIO or -EFSCORRUPTED,
it returns < 0 without setting map->m_seq.

However, if EXT4_GET_BLOCKS_CREATE is set, the function does not return
early on error and falls through to this TOCTOU check.

Since callers like _ext4_get_block() allocate struct ext4_map_blocks
on the stack:

fs/ext4/inode.c:_ext4_get_block() {
        struct ext4_map_blocks map;
        ...
        map.m_lblk =3D iblock;
        map.m_len =3D bh->b_size >> inode->i_blkbits;

        ret =3D ext4_map_blocks(..., &map, flags);
}

Will map->m_seq contain uninitialized stack garbage, causing the sequence
check to mismatch and jump to create_retry, which then encounters the exact
same disk error indefinitely?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D6
