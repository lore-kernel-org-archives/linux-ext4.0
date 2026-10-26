Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793018838;
	b=BdLUMRzxsMcSwxB4L2tqJzTK4hzfFXerIeJZINIDsiAGwNFc0tqm8K42mMHhyy8+yZYr
	 G/WWI2W61yaPm5hb5fecvY/niu/YoEmu0xQLseaQgsi/nHIkDnWVCArdXIRgaHgF5d9DO
	 6Gdb7ETlaXRP5JfiVxVQ07wrp1yGb2NleYQTTIDHG/KSxfl5jE8XrYNzUBP1a0QYADzXv
	 4WOCj6hh/+D2DGQmRhQ6kI7OAldU//XWlVuMsxqe1z6V1cOSLkexfEEefVcrVt/XU6IGO
	 +xb6jmfPbX4KKTna7//CrNIhH7xXDrx9btrbU5Y1j4kohKrCUvX2zZWPedNXc3/uJvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793018838;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1+3TBNNPzAFSAJyzFaPgpA2xmsUFWJ9hGdYgURIaHgY=;
	b=e5D3JoDdzCY6PJ8kgK4rhBqnZ40kr3EI7F1Fk9vuMcuSKsKS5ydSr7nSP9CGFp1ydvhk
	 ePR5FjReEiVtNwffMMg6u9dfCAxLJwX2o8Y0MyNmxwa1/eDgysCIU8AfTD/HTYGuQIUCO
	 YV/g6PvG3CVxtL8+lljAEG9yKZdYVP88TUlrWv7Vs6qkwh52/u9eXu0IOMYGK2O9RLiOX
	 WWMqPRU+I58h0/ou1OIkb4VCYknPeSFGXYAI2eXadctu1x9e/Rq5ksd4JEhMQ+hCDe/b8
	 EgER5jdGq8JWNPCpvx/RwhkLRJYKGFOLF8eeNSQdyjWvteLK6aTrIRAJ3NIGr1KnJxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gQxTuR4+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA28606A31A
	for <linux-ext4@vger.kernel.org>; Mon, 26 Oct 2026 12:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gQxTuR4+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB011F01825;
	Mon, 26 Oct 2026 12:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793018838;
	bh=1+3TBNNPzAFSAJyzFaPgpA2xmsUFWJ9hGdYgURIaHgY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gQxTuR4+NwTdX+2BuM5z6WBGnXw8E8OK90sGNN33aanAwVRFYP0loOXbNJt+H4K13
	 PVHWliLJpWEOKVgLlqPXZvzkNVrdQNoFwKykDSKL/AAisP2LsIG0x8LXbwkv48vIlZ
	 nLrYo6KePdjOxvhWcoBoTAmrpPYyfZh4GC8Gqg1M2hK3JfnaCj6qMPhEN4l7du3wjP
	 QC3b9BwhiE/TAVwGznSQ6y/7JF2KGFtSqsnwnNMcOmYiN78p6zmNMLD/NW+AH9zN7J
	 ERqJD4XcmcBkOMhN7oUr1a9cQb4SvoTVrJ9hrFz/47IQE55qSdevFJ+T9o8sgk4xww
	 n5uGPORNMI7ng==
Message-ID: <sashiko-outbox-185244@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/4] ext4: fix extent status cache clearing when
 truncating inline data
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261026115131.1735014-3-yi.zhang@huaweicloud.com>
References: <20261026115131.1735014-1-yi.zhang@huaweicloud.com>
 <20261026115131.1735014-3-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 12:47:17 +0000
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
> ext4_inline_data_truncate() clears the whole extent status tree of the
> inode when it truncates the inline data, with
>=20
> 	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
>=20
> It does that when the inode still carries inline data while the
> EXT4_STATE_MAY_INLINE_DATA state bit is already cleared. This is the
> case once an inline-to-extent conversion has been initiated, which is
> triggered by a delalloc buffered write larger than the inline space in
> ext4_da_convert_inline_data_to_extent().
>=20
> The clear is meant to drop stale extent status entries of such an inode
> to prevent stale extents and stale reserved space after the conversion,
> [ ... ]
>=20
> Reported-by: syzbot ci <syzbot+ci46f64f7b6a2a188e@syzkaller.appspotmail.c=
om>
> Closes: https://lore.kernel.org/linux-ext4/6ac92a4c.70ed5d86.2ac85.0072.G=
AE@google.com/
> Fixes: 0add491df4e5 ("ext4: remove extent cache entries when truncating i=
nline data")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026115131.1735=
014-1-yi.zhang@huaweicloud.com?part=3D2

