Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF22469821
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 17:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791826139; cv=none; b=LnzscD1/z0yBTC3q+3TIcbjFHUUfT2KZaw0Lw+u1KMx4Arj/0TYM0D6yRnl0ZCsiC+zSWaqQFRqInpigF7wkwPwEmIkr4tGWDVf5Awi8zcpcJrQ8JMxAwbU6B5ZKAcOto5R6jChW0gviivxNCulNHyke/fScZx9F6tUU2Ig8EyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791826139; c=relaxed/simple;
	bh=FGKgjzzWRSamRJUEx2Fc5/t3CAJZb6SDAqZpP/XJoPY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=sj70C13/3oomIkjr4iveSZBYmCSygUM2HMssU0z9c9unXhYHaEmwiGzAzUvEgPdKDw8CEpUsNjpEVEzWPeyCJlVn4H2cogOqQ5jO2UAGWEi/H25q7g+BG6nOQrEb73pMPCIyZmsNCgKhU2xeirrbEQ9Whq9N9t6KUjbET4TMP1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n6cVcLZ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n6cVcLZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088BF1F0089B;
	Mon, 12 Oct 2026 17:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791826138;
	bh=FGKgjzzWRSamRJUEx2Fc5/t3CAJZb6SDAqZpP/XJoPY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n6cVcLZ5jNs+GBi1iFz1PxEmmItzkPA6UBgkMtJayquRz7jmO+FCtLKUtDa/VK4B7
	 a+x4YwdZ514Sym/+UmtIdOT5dhskbG/MEE2IdN9Lh7c2YUrryRL2sx31fXYxW7z0aj
	 vAQanZ/Yw0HOhqrN99jY+doBN+eGindgXjfbkUh7LET2tzdlYGCN2V1d/OvkhfEfbp
	 Q6xBa5gKMnfVf4Yxrbf76ipF5eKn1OjZvPYWcALvWbacBvQzU2z5wsRt2mOPYX5qDV
	 sRtV95eHafDJye9cJwzJ1H1ohKyDXJAqTVZ9gTcROoG/b47pwqUPEmBFYu6Zfe5FJa
	 RnZiM1SiwfVTg==
Message-ID: <sashiko-outbox-168457@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 2/3] ext4: never fall back to buffered I/O for
 atomic direct writes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tal Zussman" <tz2294@columbia.edu>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261012-ext4-atomic-no-fallback-v2-2-c4b30c60e500@columbia.edu>
References: <20261012-ext4-atomic-no-fallback-v2-0-c4b30c60e500@columbia.edu>
 <20261012-ext4-atomic-no-fallback-v2-2-c4b30c60e500@columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 17:28:57 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> ext4_dio_write_iter() finishes a short direct write through the page
> cache. ext4_buffered_write_iter() now rejects IOCB_ATOMIC, so a short
> atomic write would warn and then fail with -EOPNOTSUPP, as if atomic
> writes were unsupported on the inode.
>=20
> This came out of a block device fix [1], where an IOCB_ATOMIC direct
> write could complete short when only part of the buffer could be
> pinned, with the rest going through the buffered fallback. Christoph
> Hellwig noted that ext4 has the same fallback and only warns in it [2],
> and John Garry agreed it should reject the write instead [3].
>=20
> In contrast to the block device, nothing reaches the branch on ext4
> today: iomap requires the mapping to cover the whole atomic write, a
> buffer that can't be pinned in full fails in iomap before the bio is
> submitted, and a failed page cache invalidation returns -EAGAIN rather
> than reaching the buffered fallback. A short atomic write is therefore
> a bug, and neither a short count nor -EOPNOTSUPP is a valid result for
> one. Fail the write with -EIO before the fallback, keeping the WARN()
> so any future bug is visible.
>=20
> Link: https://lore.kernel.org/linux-block/20260828-blkdev-fixes-v2-0-32f3=
f40cebed@columbia.edu/ [1]
> Link: https://lore.kernel.org/linux-block/20260907071217.GD934@lst.de/ [2]
> Link: https://lore.kernel.org/linux-block/a7752d1e-8ec1-44d1-a266-c287c31=
5e8ab@oracle.com/ [3]
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-ext4-atomi=
c-no-fallback-v2-0-c4b30c60e500@columbia.edu?part=3D2

