Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3749A3BB9ED
	for <linux-ext4@vger.kernel.org>; Wed,  9 Sep 2026 21:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788988179; cv=none; b=caXXU8ZlJnu+3JkGYBAbqOSdhLl2HgKEReGH4rOaUgXvbR95Pc0qYOh7CAB0u2JWgnn6pMgclIs5aUaeTgRYr0bdRXdRd7aJOwx/9Xz2YE5rNJDXtjwafGJflicG8p3B3zEGFt+ks9lk47a/LCf+7IPz7+CLFmOiqCrjwOzQt54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788988179; c=relaxed/simple;
	bh=eh4rXyy10O0081J3ePa39SrPjpLL0bz5k/h76lEgFfQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZMXrCQp1SQgjFFm/kNhWg4bPXuwHvdxNgObWQxa0rMHxbqO8MuR3/g5w7ORpVh9L2QKgZOvEaPnKyHLJK/Pyu1CAps2PBYzQ1Wg9meCPQ8cXQg8j1UMbwyuLgBSelviQGOYlIjOjTc7FGYlQI8yCdNPJxrGqEkfNKEBtu9iRllE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RGYgbkl+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RGYgbkl+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A031A1F000FF;
	Wed,  9 Sep 2026 21:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788988177;
	bh=jPxSfhNwwpXpRGpHkXqLhGxHVhmQ2C89sfq+usrZ9Js=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RGYgbkl+BQGLozfp0e9KXnWhMKQ87j42s4OyftNoQGV09EcwWMAfCD9zOixieQfdk
	 1lm/UtC2x06k9KjzswppFqBmsGbDhgMRyS2J9nJJ2R8W6mOXG7ewfLHtkzRkrm8Anu
	 9jdIk1dx1KgLFYJGIVLDn2pudfAJqvrK7yA5CDpuWQJr7PsGQMX5dDO6V3QgW/aCgV
	 RvTP0Y1RrzaSm1gCl42W9hSr40Icbv1PqGKzjcAawd1lE3mtJudZkBaxwyeH5v+kD2
	 lSKJdT7tUcdOSH/zxggeuUoEJosAkkHjjYUsLg4wc4xTiRDVlq0Dk4AdyM479PWpCI
	 /ddGyKP9aKtZg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC] ext4: never fall back to buffered I/O for atomic
 direct writes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tal Zussman" <tz2294@columbia.edu>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260909-ext4-atomic-no-fallback-v1-1-5a6b9539c002@columbia.edu>
References: <20260909-ext4-atomic-no-fallback-v1-1-5a6b9539c002@columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 21:09:37 +0000
Message-Id: <20260909210937.A031A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] The patch fails to return an error for short atomic writes, silent=
ly returning a torn write instead.

Pre-existing issues:
- [High] Silent fallback to non-atomic buffered I/O early in the function w=
hen `ext4_should_use_dio()` returns false.
--

commit 4f1077482a95547df7986c873d9a1c2cff493fea
Author: Tal Zussman <tz2294@columbia.edu>
ext4: never fall back to buffered I/O for atomic direct writes

This commit modifies the direct I/O path in ext4 to explicitly prevent fall=
ing
back to buffered I/O for atomic writes. It intends to return an error for s=
hort
atomic writes instead of completing them through the page cache and issuing
a warning.

Link: https://lore.kernel.org/linux-block/20260828-blkdev-fixes-v2-0-32f3f4=
0cebed@columbia.edu/ [1]
Link: https://lore.kernel.org/linux-block/20260907071217.GD934@lst.de/ [2]
Link: https://lore.kernel.org/linux-block/a7752d1e-8ec1-44d1-a266-c287c315e=
8ab@oracle.com/ [3]

> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 374b4bc25bd5d..fb561c701d291 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -666,17 +666,16 @@ static ssize_t ext4_dio_write_iter(struct kiocb *io=
cb, struct iov_iter *from)
>  	else
>  		inode_unlock(inode);
> =20
> -	if (ret >=3D 0 && iov_iter_count(from)) {
> +	/*
> +	 * Buffered I/O provides no torn-write protection, so never finish an
> +	 * atomic write through the page cache. iomap should not return a short
> +	 * atomic write anyway.
> +	 */
> +	if (ret >=3D 0 && iov_iter_count(from) &&
> +	    !(iocb->ki_flags & IOCB_ATOMIC)) {

[Severity: High]
Does this unintentionally return a short torn write instead of an error?

The commit message states the patch "yields an error rather than a torn
write with a WARN()". However, if iomap_dio_rw() completes a short atomic
write, where ret is greater than 0 but less than the requested count, we
skip this fallback block entirely because !(iocb->ki_flags & IOCB_ATOMIC)
evaluates to false.

Since we skip the block, the function proceeds to the end and returns the
positive short byte count in ret to the VFS. This exposes a torn write to
userspace without returning an error. Should we explicitly return an error
like -EIO or -EFAULT when a short atomic write occurs?

>  		ssize_t err;
>  		loff_t endbyte;
> =20
> -		/*
> -		 * There is no support for atomic writes on buffered-io yet,
> -		 * we should never fallback to buffered-io for DIO atomic
> -		 * writes.
> -		 */
> -		WARN_ON_ONCE(iocb->ki_flags & IOCB_ATOMIC);
> -
>  		offset =3D iocb->ki_pos;
>  		err =3D ext4_buffered_write_iter(iocb, from);
>  		if (err < 0)

[Severity: High]
This is a pre-existing issue, but it looks like we might silently downgrade
atomic writes to non-atomic buffered writes if the file doesn't support DIO.

Earlier in ext4_dio_write_iter(), there is an initial fallback:

    /* Fallback to buffered I/O if the inode does not support direct I/O. */
    if (!ext4_should_use_dio(iocb, from)) {
        if (ilock_shared)
            inode_unlock_shared(inode);
        else
            inode_unlock(inode);
        return ext4_buffered_write_iter(iocb, from);
    }

If a user requests an atomic write on an ext4 file that does not support
DIO (such as a file with data journaling enabled), ext4_should_use_dio()
will return false. This causes an early fallback to
ext4_buffered_write_iter().

Because ext4_buffered_write_iter() does not check for IOCB_ATOMIC, it
proceeds with a standard buffered write via generic_perform_write().
Does this silently break the atomicity guarantees expected by userspace
for such files?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909-ext4-atomi=
c-no-fallback-v1-1-5a6b9539c002@columbia.edu?part=3D1
