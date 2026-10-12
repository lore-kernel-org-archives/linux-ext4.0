Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEBE33A70A
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 17:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791825910; cv=none; b=pTyh5evGp7es/owZCtAQnbMETVAyuoIhuhvzMVSKRxB1qCefWw6ZeGEL0VaOYwXBI90TrWdyUIJavwuGF67bD2wbgpyg9FL1ZRi9u1ATLncEL+gI8ClTvE5jj73xZz49BlIdvFyr/fFwZtug3WIsEHmhg39AtKLI/hbXNkiJ2Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791825910; c=relaxed/simple;
	bh=jXQOHSFJ9xIbKYTZTdgEX9gI5qfg0uGEQz2ZXDgZq8w=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=R19jvKzxFYVpQyoGMMrngsi3s5Lc97XBto3tv/SEqhEZFcEax28u5W0bCkyCLclGGlwc/NDnrAe1YDyFwPSgdHwpYcTJedaVudNCCpgN7t61JTzytOmCiSNS+eW7H0frg8OtX8IM9U1vGO9lSH7Y0pifQxGA3EQkEDb+nEEbL2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hbeT+JC6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hbeT+JC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263C11F0089B;
	Mon, 12 Oct 2026 17:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791825909;
	bh=jXQOHSFJ9xIbKYTZTdgEX9gI5qfg0uGEQz2ZXDgZq8w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hbeT+JC6yBd1VgWu2e/kLKCgHucCKJQCxEtoXcOJjZdpBhnZAJfkIeCMYJoR8eD5E
	 lnN6aaGCgMaNqUVnONyXDcRbB5ZRmYhZjghkjyE7VevK0EMszga9NOjbmyAIyvdsQl
	 LyyEGB83F8Ssy36TkdjX2bh3olHrkYn+gN7ZLrH+tuuYQkh8z+yYab/E8x59W3X/GQ
	 4gYOH1VLtP8+Bp6Kf7XkNGvQD1itIhcHydZkETG4ewolJrmjIKGCF4M4S7IMYgkIR9
	 TLSeb9oXqEfZKfr30u6O+CrJV4RE8IGXmxbAe1R3XjHWWFxbM6sn9wHbhvREMKIFMu
	 eopWUBVzB2S1Q==
Message-ID: <sashiko-outbox-168452@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 3/3] ext4: don't advertise atomic writes for DAX
 inodes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tal Zussman" <tz2294@columbia.edu>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261012-ext4-atomic-no-fallback-v2-3-c4b30c60e500@columbia.edu>
References: <20261012-ext4-atomic-no-fallback-v2-0-c4b30c60e500@columbia.edu>
 <20261012-ext4-atomic-no-fallback-v2-3-c4b30c60e500@columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 17:25:08 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> ext4_file_write_iter() hands DAX inodes to ext4_dax_write_iter() before
> any of the atomic write handling, and the DAX path neither checks
> IOCB_ATOMIC nor provides torn-write protection.
> ext4_inode_can_atomic_write() doesn't exclude DAX inodes, so on a device
> that supported both DAX and atomic writes, statx() would advertise
> atomic writes for such an inode and the VFS would let an RWF_ATOMIC
> write through to a plain DAX write.
>=20
> No DAX-capable block device advertises atomic write limits today, so
> this isn't reachable. When XFS gained its corresponding check, Ritesh
> Harjani suggested excluding DAX inodes in ext4 anyway [1], so that what
> is advertised matches what the write path can do. XFS does the same in
> xfs_inode_can_hw_atomic_write() and xfs_inode_can_sw_atomic_write().
>=20
> Link: https://lore.kernel.org/linux-ext4/87a54e4cdn.fsf@gmail.com/ [1]
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-ext4-atomi=
c-no-fallback-v2-0-c4b30c60e500@columbia.edu?part=3D3

