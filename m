Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794522124;
	b=B58HRKfBuSs2J/7S6dddb8ht+k2X8F7QbJpWCiwF5dv1xVqvfPqJ8iCrsSgi7D6FP32S
	 JYsPhsab2ZYr/WA7lg/D1xwH54v44xyCpX9S/nK9BCjJAC6bu0UTF2yJc1xbtJoKGsqjs
	 EcSqemmMAGZvc66w3tVmvLsbiEATC0OQHvNh2HuUvGS/468JztkgB0NUDWnHXgpmhP7Vl
	 R8HtSaN4sQPkQtypPLDGP2N4+wgUSyYYhTX9U7dalqyMXXDCMbX+6iqw8seqzTnNpT86u
	 OqG1nzu9bs3cgFvqJRCgMA/J4YivgA/haMjXc9tWxEz3XeoHjZ3MR4KCiysMFL7hTfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794522124;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=g3UAA9rz3RK0FsGYIjJdiqcERayIpShxQ7/zyMZacwo=;
	b=H+4bFB6DEytBFPzG8FcNsWgRf/qZLfyzuxYiWe3IAZ3GgZ0E0vgK/hT07p4B6lGWSeUA
	 koqrGA9389F2OeUB0sxXJLHdNSDiy4mZkCcSODJGLy1JztmwYxRCQvTN4w+4ECkvTigvF
	 KbszXxirpw+SSN2oReH4MOT/ezeXC2fQfluNlklSdPDnq8CPLWRD5k20NeNfIaLK3mWjC
	 u4CH6+gRZkUhJDDgZQpIpXpUN+71Ydj907h60vptWBF9lGxd883Ri4wjjkFW1oL+78XiD
	 x0QRj7sTKI5ybZV7Ys2pQfh3hjrE3lqPFdZLGGWlOUqjTq8K7/UiZzB3SZWWWA4L8tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HR5TMOzG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5B1606A321
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 22:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HR5TMOzG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C0A1F000C4;
	Thu, 12 Nov 2026 22:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794522124;
	bh=g3UAA9rz3RK0FsGYIjJdiqcERayIpShxQ7/zyMZacwo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HR5TMOzGV+eiDNpWG/PK+wWK/yGRmw2ux8r2VjKkcggfVlA28oy4JnRV99mkO6Nip
	 EdCUm/BJqUjAMNV+/J9J9PE/zf7hU/+p9rLF8egiPP9aj0raZhlSsvRCOm64NGq6A/
	 xDwnEtfZ0ydphA3aqRzJglZTtn2RgCEMphVGue85xBQKvFEIKVz4kPxB/yHg9eNGRL
	 WW7adM9pfgJMqj602EqHtc/lHx7tP6fT9CekH8ZM2Iaeo7FKC/Sd9OP5SRIIzTUq1M
	 jTiPdY1fyawTSDNi8Sbw60aApeSbeL6TTDdVbF8bslzsga5lK2xqrvWvg4WtOlb2pR
	 fMsXZPIHMZYAg==
Message-ID: <sashiko-outbox-211908@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 06/14] xfs: recheck direct write alignment after
 write checks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Mason" <mason@kernel.org>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261112214604.67875-7-mason@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
 <20261112214604.67875-7-mason@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 22:22:03 +0000
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

commit abd43cb75b989255524945b08ecf0cb03d4da551
Author: Chris Mason <mason@kernel.org>

xfs: recheck direct write alignment after write checks

This commit rechecks block alignment in xfs_file_dio_write_aligned() after
xfs_file_write_checks() adjusts the write range for O_APPEND and
RLIMIT_FSIZE, falling back to the unaligned direct write path or buffered
I/O if the updated range is no longer block aligned.

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
Does returning -EAGAIN from xfs_file_dio_write_aligned() without checking
target->bt_logical_sectormask cause sector-unaligned O_DIRECT writes to
bounce to buffered I/O instead of failing with -EINVAL?

When a block-aligned O_DIRECT write passes the initial sector check in
xfs_file_dio_write() and xfs_file_write_checks() then moves iocb->ki_pos to
a non-sector-aligned EOF for O_APPEND (or shortens the write via
RLIMIT_FSIZE to a non-sector-aligned length), xfs_file_dio_write_aligned()
now returns -EAGAIN before iomap_dio_rw() can reject the write with
-EINVAL.  On the fallback path, neither xfs_file_dio_write() nor
xfs_file_dio_write_unaligned() rechecks target->bt_logical_sectormask
before returning -ENOTBLK for zoned or CoW inodes, causing
xfs_file_write_iter() to complete the sector-unaligned O_DIRECT write
through the page cache.  For non-CoW inodes, xfs_file_dio_write_unaligned()
proceeds into iomap_dio_rw() where extending writes allocate unwritten
blocks in xfs_direct_write_iomap_begin() before iomap_dio_bio_iter()
rejects the bio alignment.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112214604.6787=
5-1-mason@kernel.org?part=3D6
