Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794340157;
	b=iOkx2Eu7a8mSXuXmh9D1Dip7GTFQ4AbueBYCEkdb5LxPb+OK9QdGaPg3L4lAJC71t4aC
	 qldLto5LmpK5jgzZcjC7LZpxILur9yiHqtZY2X794RKbhXGDA7yuWcRfoBS3C6LxrEz/x
	 7a6DJpBBe/cm8X2AIVfW3xL/7dR97wQHoMus9OXC/a5TfJTa9m68yx/kbORjF2JnwUOf0
	 oh3zi9/9JeUK58MnzHaTiMF5uzNd6VoN8QwXSoGEXVeMtd52H03SVWjNf2ziDjC4iYUJn
	 5vstWtEPaa+TZDHduf+kp6y6NwJaBOY5IObb7KWE16Bfpeb8TEMqgDUDBOn2/a2eOqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794340157;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=TD/A35pPuB7b5uVB6QhIljxaLIvkBJ6Kef2eDXdfSYg=;
	b=Me3aD7uxqEBMjBUwMBFqcyiBFiRRs7o5rGVqywexio8n3podlljF7n7iUg8SxPclTe/F
	 oQMQQQzJwzeQ1LVkumaPMFgzSZTkxxXO8qpA6Ejk5zNuJW2XLvuitulWr6eLeM4npiwPo
	 03CdDS0PA8L5U+/qx46815gc3rlmIr8sYtbj6ymplTAmi0iIPZjittCGJ2DSBTpXb+tLG
	 jLQ/xihP5qPDEu26iJ/F2DYyX7ZSPz9sQO8VqnAuMJzoHR2voNC337xOaMR6VUUGj7rHI
	 cJeqc5I5D1G/VXw8MXouhtiUnmoz8MQd+5HXpjAPFD8zXHZL1ChCm17E+fh0echllYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fqJv+fbQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD70606A31C
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 19:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fqJv+fbQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1301F0089F;
	Tue, 10 Nov 2026 19:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794340156;
	bh=TD/A35pPuB7b5uVB6QhIljxaLIvkBJ6Kef2eDXdfSYg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fqJv+fbQtiR/sAhUI1yXxdXfylDNsxZrIEWBKB7jymZiagvp+AB9ayHUkP9YkzZN+
	 hqBEYrt/V3TSIO7KixkNrZobdJfz5QoFYTI95jmEs0pUcvjKSpdhRIrEr0aZgTCBzD
	 m4FAFrJssI0Ad0ivdBrpYgTbP9AYAx7s/qs+4aHJarII/deaUfS2GzFryk6BdRzTBO
	 sgA/UxK+HTWG6/dOfbEOWGLNHCUWIpVW7tkbaYz5yRnQVBarMholO8ZPKBJmU9IiFm
	 AYM6fk3wqUsox6x5PluZnP6MdRp+9M0ZaTrsMxm3moKvZjgLRzJ7xpLJk3ozqG+Ux8
	 DIz9v2iFHkjoA==
Message-ID: <sashiko-outbox-207684@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 06/11] xfs: recheck direct write alignment after
 write checks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Mason" <mason@kernel.org>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261110190417.32650-8-mason@kernel.org>
References: <20261110190417.32650-1-mason@kernel.org>
 <20261110190417.32650-8-mason@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 19:49:16 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] xfs: sector-unaligned O_DIRECT writes after write checks
  bounce to buffered I/O
--

commit 9318aacdeda831439c37400a39cd1973c5ae71aa
Author: Chris Mason <mason@kernel.org>

xfs: recheck direct write alignment after write checks

This commit rechecks block alignment in xfs_file_dio_write_aligned() after
xfs_file_write_checks() adjusts the write range for O_APPEND and file size
limits, falling back to the unaligned or buffered path when the final range
is no longer block aligned.

> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 153f53f964b99..8ee88910b487d 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -710,6 +710,17 @@ xfs_file_dio_write_aligned(
>  	if (ret)
>  		goto out_unlock;
> =20
> +	/*
> +	 * O_APPEND moves the position and the file size limits shorten the
> +	 * write, so only now is the range final.  If it is not block aligned,
> +	 * this is the wrong path for it.  Return -EAGAIN to
> +	 * xfs_file_dio_write(), which picks the path.
> +	 */
> +	if ((iocb->ki_pos | iov_iter_count(from)) & ip->i_mount->m_blockmask) {
> +		ret =3D -EAGAIN;
> +		goto out_unlock;
> +	}
> +
>  	/*
>  	 * We don't need to hold the IOLOCK exclusively across the IO, so demote
>  	 * the iolock back to shared if we had to take the exclusive lock in
> @@ -921,6 +932,7 @@ xfs_file_dio_write(
>  	struct xfs_inode	*ip =3D XFS_I(file_inode(iocb->ki_filp));
>  	struct xfs_buftarg      *target =3D xfs_inode_buftarg(ip);
>  	size_t			count =3D iov_iter_count(from);
> +	ssize_t			ret;
> =20
>  	/* direct I/O must be aligned to device logical sector size */
>  	if ((iocb->ki_pos | count) & target->bt_logical_sectormask)
> @@ -937,12 +949,32 @@ xfs_file_dio_write(
>  		return xfs_file_dio_write_atomic(ip, iocb, from);
>  	}
> =20
> -	if ((iocb->ki_pos | count) & ip->i_mount->m_blockmask)
> -		return xfs_file_dio_write_unaligned(ip, iocb, from);
> -	if (xfs_is_zoned_inode(ip))
> -		return xfs_file_dio_write_zoned(ip, iocb, from);
> -	return xfs_file_dio_write_aligned(ip, iocb, from,
> -			&xfs_direct_write_iomap_ops, &xfs_dio_write_ops, NULL);
> +	/*
> +	 * O_APPEND and the file size limits can still change the range, in
> +	 * xfs_file_write_checks().  So a range that is block aligned here may
> +	 * not stay so, and the write then comes back with -EAGAIN.  If we are
> +	 * doing nonblocking user I/O, propagate the error.
> +	 */
> +	if (!((iocb->ki_pos | count) & ip->i_mount->m_blockmask)) {
> +		if (xfs_is_zoned_inode(ip))
> +			ret =3D xfs_file_dio_write_zoned(ip, iocb, from);
> +		else
> +			ret =3D xfs_file_dio_write_aligned(ip, iocb, from,
> +					&xfs_direct_write_iomap_ops,
> +					&xfs_dio_write_ops, NULL);
> +		if (ret !=3D -EAGAIN || (iocb->ki_flags & IOCB_NOWAIT))
> +			return ret;
> +	}
> +
> +	/*
> +	 * Zoned inodes always write out of place, which does not work for a
> +	 * part of a block.  Fall back to buffered I/O.
> +	 */
> +	if (xfs_is_zoned_inode(ip)) {
> +		trace_xfs_reflink_bounce_dio_write(iocb, from);
> +		return -ENOTBLK;
> +	}
> +	return xfs_file_dio_write_unaligned(ip, iocb, from);
>  }

[Severity: Medium]
Can an O_DIRECT write whose updated range is no longer aligned to
target->bt_logical_sectormask silently fall back to buffered I/O instead of
returning -EINVAL?

When a block-aligned O_DIRECT write enters xfs_file_dio_write_aligned() and
xfs_file_write_checks() moves iocb->ki_pos to a non-sector-aligned EOF for
O_APPEND (or truncates from to a non-sector-aligned RLIMIT_FSIZE), the new
m_blockmask check returns -EAGAIN before iomap_dio_rw() can reject the
unaligned range with -EINVAL.  On the fallback path, neither
xfs_file_dio_write() nor xfs_file_dio_write_unaligned() rechecks
target->bt_logical_sectormask before returning -ENOTBLK for zoned or CoW
inodes, causing xfs_file_write_iter() to complete the sector-unaligned
O_DIRECT write through the page cache.  For non-CoW, non-zoned inodes,
xfs_file_dio_write_unaligned() also proceeds into iomap_dio_rw() and can
allocate unwritten blocks for extending writes before iomap_dio_bio_iter()
fails with -EINVAL.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110190417.3265=
0-1-mason@kernel.org?part=3D6
