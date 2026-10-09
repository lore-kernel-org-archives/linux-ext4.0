Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142373D9545
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 04:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791521966; cv=none; b=joWcsYoroAoXLoa5bt6wTV1VJObgrqYzhIYXg7j5x3oByt5IQ05XPjbumNFU8qsbPFJ+3ALgo1A2pAttPjCJefhyCxVl7CcG/V6HB3Nnh98pUluqPLC5QzXR53K9k4MCDoIbqyM1i1vstHpmEsvQRWb3uWb8QxKQOZWSX7sEzmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791521966; c=relaxed/simple;
	bh=DT6CA3vy+L18/G/9KKuq6yIp6dLTYmg7SormMr1XlpY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=howL6eADLFp9AtZ3pRli7Q76gEDVLE8upVVR8Ck8iJ/MGqIVOUN0Y+kTdDCmoMtmb+N+wg6xFRVd9NjG4k3vV9h4w+HOXzOUbxFIS+aPQS7WtEbYYYoal8jMC4QEUvlBdzKGkP6S6XbkP+bn9N0vPwdGa5hXEWQbv56nIXgrGQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B8eFAt6Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B8eFAt6Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC5E1F000FF;
	Fri,  9 Oct 2026 04:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791521964;
	bh=P5gg1VYgBDqYE+g2eAGLd0A8iRLoQ6puxBSTUgWKipM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B8eFAt6Y5Y/LCknhXNRvIP3RhEM/A6YTxhIf97PKdBKxuIJCt2t8STcb9ig9owCRU
	 XQ8yPJ4zOZ7M3hyn0zio8oG505ddcTDzaKRqle3DmiGBHZuO+Rm6pYxCYXFnOveC/a
	 sZSIewcYGhuqh42aGfqea21H6UkTBCY3mp2Q5D1UaU1S3ZXwsmJwrfl/feAdI+xiYB
	 Tj0CWQ6x+oAxlHzYKwqd/7TBIsYYid6pn6u50v+hHdL6IHJQ630qSTcRPYIFr+R3rN
	 ahnitfOux1qsFHuiGSMp04BS8Tg30klbwilSlXles0bIbV4hOJqoeJtkwiFe7vbXZN
	 lSQ+Q4yyPntFw==
Message-ID: <sashiko-outbox-164860@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: do not advance i_size on a buffered write that
 copied nothing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hengyu Liang" <hengyul@cs.unc.edu>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261009044656.1993196-1-hengyul@cs.unc.edu>
References: <20261009044656.1993196-1-hengyul@cs.unc.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 04:59:24 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ext4: delayed block and quota leak on failed writes in delalloc pa=
th
--

commit acb80c0263f3e15c2b0d945f36271eb41aefe50e
Author: Hengyu Liang <hengyul@cs.unc.edu>

ext4: do not advance i_size on a buffered write that copied nothing

This commit changes the ext4 buffered write path to avoid updating i_size
when a write past EOF copies zero bytes. It also attempts to clean up the
page cache and delayed extents beyond i_size in the delalloc path.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9a9ec02dce9fd..339b20a238053 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c

[ ... ]

> @@ -3210,6 +3213,24 @@ static int ext4_da_should_update_i_disksize(struct=
 folio *folio,
>  	return 1;
>  }
> =20
> +/*
> + * Delalloc counterpart of ext4_truncate_failed_write(): ->write_begin()=
 only
> + * reserved delayed blocks, so drop the page cache and the delayed exten=
ts
> + * beyond i_size and leave the blocks that are allocated there alone.
> + */
> +static void ext4_da_truncate_failed_write(struct inode *inode)
> +{
> +	struct address_space *mapping =3D inode->i_mapping;
> +	ext4_lblk_t lblk =3D EXT4_B_TO_LBLK(inode, inode->i_size);

[Severity: High]
Does this EXT4_B_TO_LBLK() conversion round up the block number?

If i_size is not block-aligned, won't this skip the delayed extent reserved
for the block overlapping EOF, leaking its reservation since the folio is
never dirtied?

> +
> +	filemap_invalidate_lock(mapping);
> +	truncate_inode_pages(mapping, inode->i_size);
> +	down_write(&EXT4_I(inode)->i_data_sem);
> +	ext4_es_remove_extent(inode, lblk, EXT_MAX_BLOCKS - lblk);
> +	up_write(&EXT4_I(inode)->i_data_sem);
> +	filemap_invalidate_unlock(mapping);
> +}

[ ... ]

> @@ -3261,9 +3282,16 @@ static int ext4_da_do_write_end(struct address_spa=
ce *mapping,
>  	folio_unlock(folio);
>  	folio_put(folio);
> =20
> -	if (pos > old_size)
> +	if (copied && pos > old_size)
>  		pagecache_isize_extended(inode, old_size, pos);
> =20
> +	/*
> +	 * A write past i_size that copied nothing leaves i_size alone, so
> +	 * trim what ->write_begin() set up beyond it.
> +	 */
> +	if (!copied && pos > old_size)
> +		ext4_da_truncate_failed_write(inode);

[Severity: High]
Does this condition miss cases where the write starts before or exactly at =
EOF
but extends past it?

If a failed write (copied =3D=3D 0) starts exactly at EOF (pos =3D=3D old_s=
ize) or
overlaps EOF (pos < old_size and pos + len > old_size), pos > old_size is
false.=20

Since the write_begin path already reserved delayed blocks past i_size,
will skipping this cleanup permanently leak those reserved blocks and quota?

> +
>  	if (!disksize_changed)
>  		return copied;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009044656.1993=
196-1-hengyul@cs.unc.edu?part=3D1
