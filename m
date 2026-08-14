Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A118E3F9F25
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786704061; cv=none; b=utbRnekZB18R6PjlIHpTBOjcjfB3GFhAMyUYl9IrQXx5DusOLHToy6Q+QcCziNJekDbTvbVSrcPyUh+kYRNSy/6m/CaWoKbYSJbJ978n3Jq+ctteC7/vS/JjGNwNkUNOuXvYONyv3fHwfEIrQ4z81g5H9gRvlqCpIwUU9mNjHK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786704061; c=relaxed/simple;
	bh=qOG6zlh7du/HTKNnvtZAAXjfJV+58Ztpay97y4OvluA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oeaNvlZtYlUc8pRCK3p87XjbR7kG0GZrAnII65IzAvE9D5SB4im6SWemtMxWI03lpgT0YQtApEhvuk4GUCpllLOUciphE3Ot7L644IKnQ92wlgKrsUYJzjLKJCvnm2unjUB+iK/8aMFNXQeNCiIM1IEe67dM/mCMOj7Oyc6iTO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mJteKj4n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mJteKj4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2C21F000E9;
	Fri, 14 Aug 2026 10:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786704055;
	bh=FrCvv8NzFHoAw8rirAz8xr8rhGmcZFFCAD8C/B8N9po=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mJteKj4npWHgWC442przRupcGReYQh+swEiRh9vRzxcXECiypGC7qWROzVR3b8Mu2
	 ZKTaD1eLr1iWo3NbWavGC790wDLdruKjTnVUHSJYCgLG9M70Qx3fmaq5yNiyi/xnVJ
	 ao+y3AT+B5bUV0QSJQwQ+WBvzqRomzfxawvUwdKe/g/7Z3g8HQ1NmAcWQrI3gDZ2tG
	 qOtE3Iqrq0oeM8E8DoOLbNhzlfup3bydduei2/PZ0746mSa4rnKRYFp/gY/XLk1x8P
	 5xmF+JICYYGQAUhGfR4geKoOd3qu+qSrnXuADu68p9LkTK3pufB+UdtiWT9ok4+2Ru
	 xM0WQE6EJG98A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 15/32] ext4: implement buffered write path
 using iomap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260814093331.1703882-16-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-16-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:40:55 +0000
Message-Id: <20260814104055.7F2C21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] Extending a file within an already-allocated block does not up=
date the on-disk `i_disksize` or mark the inode dirty, causing appended dat=
a to be lost on a crash or unmount.
- [High] The iomap non-delalloc buffered write path permanently leaks unwri=
tten extents past `i_size` when a short write or failure occurs.
--

--- Patch [15]: [PATCH -next v5 15/32] ext4: implement buffered write path =
using iomap ---
commit 7a553e37ec457f0a485aa7c6fc378e68d6d66bfb
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: implement buffered write path using iomap

This commit introduces two new iomap_ops instances for ext4 buffered writes:
one for delayed allocation mode and another for non-delayed allocation mode.
It also updates the folio lock and transaction start ordering for the new
iomap buffered write path.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9098d9a5fc05b..d831d1911a6ff 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c

[ ... ]

> @@ -3994,6 +4009,113 @@ static int ext4_iomap_buffered_read_begin(struct =
inode *inode, loff_t offset,
>  	return 0;
>  }
> =20
> +static int ext4_iomap_buffered_do_write_begin(struct inode *inode,
> +		loff_t offset, loff_t length, unsigned int flags,
> +		struct iomap *iomap, struct iomap *srcmap, bool delalloc)
> +{
> +	int ret, retries =3D 0;
> +	struct ext4_map_blocks map;
> +	int map_flags;
> +
> +	ret =3D ext4_emergency_state(inode->i_sb);
> +	if (unlikely(ret))
> +		return ret;
> +
> +	/* Inline data and non-extent are not supported. */
> +	if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
> +		return -ERANGE;
> +	if (WARN_ON_ONCE(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
> +		return -EINVAL;
> +	if (WARN_ON_ONCE(!(flags & IOMAP_WRITE)))
> +		return -EINVAL;
> +
> +	map_flags =3D delalloc ? EXT4_GET_BLOCKS_DELALLOC_RESERVE :
> +			       EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT;
> +retry:
> +	ret =3D ext4_iomap_map_blocks(inode, offset, length, &map, map_flags);

[Severity: High]
Does this code permanently leak unwritten extents past i_size if a short
write or write failure occurs?

If the user memory copy subsequently fails (e.g. fault_in_iov_iter_readable=
()
returns -EFAULT), it results in a short write.

In the non-delalloc path, ext4_iomap_buffered_write_ops lacks an iomap_end
callback to clean up the allocated on-disk blocks, which could exhaust
disk space or quota.

> +	if (ret =3D=3D -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries=
))
> +		goto retry;
> +	if (ret < 0)
> +		return ret;
> +
> +	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
> +	return 0;
> +}

[ ... ]

> +static int ext4_iomap_buffered_da_write_end(struct inode *inode, loff_t =
offset,
> +					    loff_t length, ssize_t written,
> +					    unsigned int flags,
> +					    struct iomap *iomap)
> +{
> +	loff_t start_byte, end_byte;
> +
> +	/* If we didn't reserve the blocks, we're not allowed to punch them. */
> +	if (iomap->type !=3D IOMAP_DELALLOC || !(iomap->flags & IOMAP_F_NEW))
> +		return 0;

[Severity: Critical]
Will this silently lose data for extending writes within already-allocated
blocks?

If a buffered write appends data to a file within an extent that was already
allocated, iomap_write_iter() will update the in-memory i_size and set
IOMAP_F_SIZE_CHANGED.

However, this early return skips checking IOMAP_F_SIZE_CHANGED.

Without updating EXT4_I(inode)->i_disksize and calling ext4_mark_inode_dirt=
y()
to persist the size change, appended data can be lost on a crash.

> +
> +	/* Nothing to do if we've written the entire delalloc extent */
> +	start_byte =3D iomap_last_written_block(inode, offset, written);
> +	end_byte =3D round_up(offset + length, i_blocksize(inode));
> +	if (start_byte >=3D end_byte)
> +		return 0;
> +
> +	filemap_invalidate_lock(inode->i_mapping);
> +	iomap_write_delalloc_release(inode, start_byte, end_byte, flags,
> +				     iomap, ext4_iomap_punch_delalloc);
> +	filemap_invalidate_unlock(inode->i_mapping);
> +	return 0;
> +}
> +
> +/*
> + * Since we always allocate unwritten extents, there is no need for
> + * iomap_end to clean up allocated blocks on a short write.
> + */
> +static DEFINE_IOMAP_ITER_NEXT(ext4_iomap_buffered_write_next,
> +			      ext4_iomap_buffered_write_begin);
> +
> +const struct iomap_ops ext4_iomap_buffered_write_ops =3D {
> +	.iomap_next =3D ext4_iomap_buffered_write_next,
> +};

[Severity: High]
Is it safe to omit an iomap_end callback here?

Without an iomap_end callback for the non-delalloc path, two issues appear
to occur:

1) Allocated unwritten extents past i_size are leaked if a write fails,
exhausting disk space or quota.

2) Extending writes into an already-allocated extent set IOMAP_F_SIZE_CHANG=
ED
in the core iomap code, but without an iomap_end callback to update i_disks=
ize
and mark the inode dirty, this size update is never persisted to disk.

> +
> +static DEFINE_IOMAP_ITER_NEXT_END(ext4_iomap_buffered_da_write_next,
> +				  ext4_iomap_buffered_da_write_begin,
> +				  ext4_iomap_buffered_da_write_end);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D15
