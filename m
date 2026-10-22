Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792653379;
	b=x4FzWj57iEiC+EHyjCQunWcLwpUtoCMlekePj9BbL+5hZBWhgBLoviOkPD8wFPvUcKxB
	 Djf2HXxpoHslaK5LudvqOSrfsHVmrO4/JdGuCT8VuAkQ4Mg5oWtdPsKPXYIbxcCM+PWd+
	 8vSO/6xaqyvtvtSik7RTGt5XRJ2Rc2ng7HSwPyA8pXMS3d2P7wVn59VLOvRrcWtd8E2rP
	 hZkkuq7bLnlHZMkaxhkME1eKBLAoKXjjkrB3eKejIp1YEhxLjSgCFHJugyOOSMKVxSgLY
	 aqc+40YLD1BUlFqNDlf2BSqR42CzUkab7E1gZTsKYUKrq5tJJzaKmSNu5yNYh31nLSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792653379;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9Snp2NUFOR1qSdg4JOzh9LLywWwQ15FE2No4cpY/WoA=;
	b=FaCoaeSwyXH8bgrerl7H9ETCrYoE4f6qLL8EMhHpf6QJCLkHPKgDD3iWiO37/NXg00I2
	 xpoC51LlOI7mxOLFmTKfDt9qcoDd8R1Gjfc0C4wpa8irvtfMd5daY5D7Pez7ch6Pyhv5g
	 rRSMPPrF7OPSl6Otun6rvFcnAYvPW+CjTmBlk/lC6tldEVhgkmn022E+c8khCKUXkxLZg
	 R4E9NYN78LXw/AQ7qxh9dU89vdJOZ8CwXsO4L0S6lCM7/YRV0XNe/sFw8Vw7Xc1hDgQJN
	 yss9vVIGs6a4ch5ue0eQPJv6Pj8zqRfZLk8E5PBmUanBiiWZAWeqN1bLm2BAtMJVu1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KHj5HjkG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDFD606A319
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 07:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KHj5HjkG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901661F000C1;
	Thu, 22 Oct 2026 07:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792653378;
	bh=9Snp2NUFOR1qSdg4JOzh9LLywWwQ15FE2No4cpY/WoA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KHj5HjkGzv6VmdBmNyGNrvnKuktwAzftNyYNAByBNHHEYNsbwd+TTWZhSd+LGfz0z
	 WpZUy6GekD2wEbirBzwdAtp8wyJGaQeCJdA2XG3Z+zKv5EhfCRIEEh/RJc14O1gSjI
	 UIjBh7j3g2HYgfbOmuG0R+L796UIG1z7w8rAExNWQMOozzeQAWXIEIEDa1FrwqJWxp
	 QHzwND2Cz/ChojUyHbzGu/7VnErfFUN8dEjZPIo0sMt0yNUNTBobKlMAPHQlfUzuYT
	 wupHdzm87oE7n1i0ea44w/mA3Lv+GBywo04LTF6a34QknmCHeyKAM9rzseGcDIozk+
	 H0si4YJieS1BQ==
Message-ID: <sashiko-outbox-181121@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: skip eof zeroing when the zero range covers the
 eof block
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baokun Li" <libaokun@linux.alibaba.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261022065342.3569693-1-libaokun@linux.alibaba.com>
References: <20261022065342.3569693-1-libaokun@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 07:16:18 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] ext4: stale data in ext4_alloc_file_blocks() on FALLOC_FL_WRIT=
E_ZEROES
--

commit 5e26fed6c5f3f56bd5013064a243a3a558e3a73d
Author: Baokun Li <libaokun@linux.alibaba.com>

ext4: skip eof zeroing when the zero range covers the eof block

This commit skips calling ext4_block_zero_eof() in ext4_alloc_file_blocks()
when EXT4_GET_BLOCKS_CONVERT_UNWRITTEN is set and the allocation range cove=
rs
the EOF block, preventing the dropped EOF page from being read back into the
page cache with stale data during FALLOC_FL_ZERO_RANGE.

> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 7193429a05e1f..8f7ded6e08299 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4639,8 +4639,15 @@ static int ext4_alloc_file_blocks(struct file *fil=
e, loff_t offset, loff_t len,
>  	credits =3D ext4_chunk_trans_blocks(inode, len_lblk);
>  	depth =3D ext_depth(inode);
> =20
> -	/* Zero to the end of the block containing i_size */
> -	if (new_size > old_size) {
> +	/*
> +	 * Zero to the end of the block containing i_size.
> +	 * Loading the eof block back before it is converted to unwritten
> +	 * may leave the page cache inconsistent with the disk, and zeroing
> +	 * it is redundant, so skip it.
> +	 */
> +	if (new_size > old_size &&
> +	    (!(flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN) ||
> +	     !in_range(old_size >> blkbits, map.m_lblk, map.m_len))) {
>  		ret =3D ext4_block_zero_eof(inode, old_size, LLONG_MAX);
>  		if (ret)
>  			return ret;

[Severity: Critical]
Does this condition also need to check !alloc_zero to cover the
FALLOC_FL_WRITE_ZEROES path?

In ext4_zero_range(), after ext4_truncate_page_cache_block_range() drops the
page cache, FALLOC_FL_WRITE_ZEROES calls ext4_alloc_file_blocks() with
EXT4_GET_BLOCKS_CREATE_ZERO rather than EXT4_GET_BLOCKS_CONVERT_UNWRITTEN:

	if (align_end > align_start) {
		if (mode & FALLOC_FL_WRITE_ZEROES)
			flags =3D EXT4_GET_BLOCKS_CREATE_ZERO | EXT4_EX_NOCACHE;
		else
			flags |=3D (EXT4_GET_BLOCKS_CONVERT_UNWRITTEN |
				  EXT4_EX_NOCACHE);
		ret =3D ext4_alloc_file_blocks(file, align_start,
					     align_end - align_start, new_size,
					     flags);

Earlier in ext4_alloc_file_blocks(), EXT4_GET_BLOCKS_ZERO is cleared from
flags and converted into alloc_zero =3D true:

	if (flags & EXT4_GET_BLOCKS_ZERO) {
		flags &=3D ~EXT4_GET_BLOCKS_ZERO;
		flags |=3D EXT4_GET_BLOCKS_UNWRIT_EXT;
		alloc_zero =3D true;
	}

When FALLOC_FL_WRITE_ZEROES extends i_size across an unaligned written EOF
block covered by [align_start, align_end),
!(flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN) is true. As a result,
ext4_block_zero_eof() is still called and reads the dropped EOF block back
from disk into the page cache with stale data below old_size, marks the
buffer or folio dirty, and then the loop zeroes the block on disk via
ext4_issue_zeroout() and leaves the extent mapped as written.

Wouldn't this leave the dirty page cache folio with stale data that is
returned on buffered reads and written back over the zeroed disk block on
writeback or fsync?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022065342.3569=
693-1-libaokun@linux.alibaba.com?part=3D1
