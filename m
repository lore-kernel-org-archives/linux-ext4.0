Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793327118;
	b=Is1sLGT2wSUrC8GmuhXY5rXUCPgLXcAv0O60gCyZpLY9Nk8zj/Iba8gTdGHb5ZYi12ZJ
	 bXWD+eESVMZRCT+qy/5jgwB0PcrnXJ1QxXaoKyS4IJ9ZgjxLTS4seqZ8or6q0pEjMKCoc
	 N/28UdFgKS6atbiq0lVn6l1zRkYler9IOstaFKhIcSDADBWXjYKOa4Z7JlvNF27y/AEr4
	 Rzgb7ig7w+em4f3/MSW31X1i4CKnbEBhT18+O3TB0UJLLMzmGfU0YX6kmJXTKWOsDqqDL
	 W66BCY/7LZ7Z+Dweteaji+8piNaQtcnbTop+AH7V/nT+8PPrnTxMoGSDpoqDK9Tb8WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793327118;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=s8gm+w3Tx49jznC3IEANc2D+u538cFFWF6SBqTzJJLk=;
	b=bwMoYOx32BsLGGlL64GnmusajYguTOav7mdxz5Mhm+J+ivIsvo/yH+Ze4YOWQo8zJ00B
	 Csl7giT36CTqVoLdJjkQVSSY6Gy4Id0J1xRvELv9+/HvkAiNJVzatnmns7HEneU/MeQej
	 AgogvlAEWT/t/bFIPv5xywGCeWcKQB/w7fJv79jMCXVMwYbzUJ0kKtSBx0pHwwikZ3wig
	 /qQq7iKILlP7PonU6MYbesFoRSTzSLBozTjgxrRtXa6b6dSqm1Vx+GNdr0MB1mLDZ+P6o
	 luox2G/7p5cUce/uEfK7BQJeehk/7o6haPOv6i2mHjGHJGJ222f5Qhv8CFj3B0lBkwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QRuAW1mq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01B9606A31A
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 02:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QRuAW1mq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D7A1F00919;
	Fri, 30 Oct 2026 02:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793327117;
	bh=s8gm+w3Tx49jznC3IEANc2D+u538cFFWF6SBqTzJJLk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QRuAW1mqL68vzcF+VyVD2g7TVnlrK51PpLln0EInju/Py/XjVJ4bIvia88nudM6/h
	 4AhoA74T5gnPLYBG17mRX70g0lrEhSDr0e/QqiTgAM3O107T+U/zHqAmzKcvM4LDGs
	 vDtY9BW4Wvwi2Qk9rLKEAOa4h4G/7gnN2QRm8MbQ4HSBZyXeRHQ3Lx875qS10jojrm
	 OZA7KwTubYZqxIcFrK+8LdoufyeeKt6A5HZUojzmUxZH0k4PmRKGn4FZXodiCDrh3K
	 0kYtvc7TBXoHsMrngEHsmEXuzrVT4hXs2KmaJbyjH+Uja4CW5fTY19o2i7+LYKiew9
	 q7A0xDrG/lHCg==
Message-ID: <sashiko-outbox-190173@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/4] ext4: return 0 instead of stale ret in
 ext4_iomap_writepages()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261030021338.1768292-2-yi.zhang@huaweicloud.com>
References: <20261030021338.1768292-1-yi.zhang@huaweicloud.com>
 <20261030021338.1768292-2-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 02:25:16 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> smatch reports a "missing error code" warning:
>=20
>   fs/ext4/inode.c:4518 ext4_iomap_writepages() warn: missing error code? =
'ret'
>=20
> The 'ret' variable has already been consumed by the
> ext4_emergency_state() check at the beginning of the function, so its
> value is always zero at this point. Returning it is equivalent to
> returning 0, but it is misleading because it looks like an error code is
> being propagated.
>=20
> This branch handles the race with ext4_change_inode_journal_flag(),
> which flushes the dirty data and drops the page cache before switching
> the inode to the buffer_head path, so there is genuinely nothing to
> write back here. Return 0 explicitly to make the intent clear.
>=20
> Fixes: bdcbb0f19e92 ("ext4: partially enable iomap for the buffered I/O p=
ath of regular files")
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Closes: https://lore.kernel.org/r/202610160314.PLMEXaOJ-lkp@intel.com/
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030021338.1768=
292-1-yi.zhang@huaweicloud.com?part=3D1

