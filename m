Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793328491;
	b=PcqR74uq/vZkzGv2OXQ5pVBkRYiDN16JYNT11gjsZn6Mz1hk1v572qgtNMIC8gQyWOrc
	 AUmS5xjXCicQbKNdI5fAxYcVSL1wknqD5R18cdwCbkgplEyayd4mEt695doYHqFr8GlPJ
	 LjV5qZ+mieJ4dAKTsNiQgwmeDGuBjKpVy9zT2OhrPUKcW1qD6IP2AHQmWWgOxCYZwkCHk
	 W9HKyypy39BGrEOxzCuUJhdo6GGImOrD7vGUdYwGPZo2IGg/wu01LKkiXhYxdjfi3j183
	 kzkzEYS+r9Mh520VKVrZh+uhlxQe19uFIbShRWsoO3eYuT+KnzC5w4y+6tKQt8D4p6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793328491;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=2CuTclFA7z+YnLFA+vqQxXjw226jz3MlVm0SmblXjEQ=;
	b=5YJrW5PgybuiXCBsNBYBXXP/TtKWJtQDPcrnxErNdNzRYNpASVyl7q9xDyXBF0/YNLDV
	 3Xaz2lWljI265U16c6N3hi9d6BBE8d3yCHoD7LDg3q2H05Q94LWlNIUYJPHDiVRiSruX7
	 vE5nMl1DukMBG916w9RUORDpaGcdkDNGsKpwrzFyB6uN1tcXU3uyKNYqReSy09Jq3cY50
	 0GRC0HhgJ00hy3Qhdk385s9dq2RC9XIyDS0LI69rQTMuYuQ3xFMubS1KIelpXyT0CCqqZ
	 kC246I73dI84uHTCTLdKwWJfp083hf4ptXL2oUE1vV4HPrHw1HcqhpB+f76ck3aqbsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HxmLMTdA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992BB606A31C
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 02:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HxmLMTdA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DB61F000C1;
	Fri, 30 Oct 2026 02:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793328491;
	bh=2CuTclFA7z+YnLFA+vqQxXjw226jz3MlVm0SmblXjEQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HxmLMTdA7oLrdIGR//fgEGC9XZ3bhu4p6kj29Vq72or6AhYPx/NG9McHVa0rt87Sf
	 W8Og9S4/cM0B39rpnbcVmUvewzvrSYb7Q8di6KUX4advLf6DiHZ0pyD9YN+E9III2Z
	 ZxDRs3gj8pohJtfYGELbu3M5swUJlMp9uaB26YRXo0ZlPeZjbGOxO6mLkKX4shE631
	 GHAAswDTIVnUHlyiXLQOEdLN52kL1ZoihdkpfLDSteJgwiItV8n3Ph0xtLKpspgPbr
	 +YMLXUxAMnkzizXgzM8WGO8XLQJ79sU3tc3uJPHcdyivV+OGgTgUf4VAQeuc87hkpI
	 xoFR2XxI0E4bQ==
Message-ID: <sashiko-outbox-190182@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/4] ext4: fix extent status cache clearing when
 truncating inline data
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261030021338.1768292-3-yi.zhang@huaweicloud.com>
References: <20261030021338.1768292-1-yi.zhang@huaweicloud.com>
 <20261030021338.1768292-3-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 02:48:10 +0000
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
> EXT4_STATE_MAY_INLINE_DATA state bit is already cleared.  This is the
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030021338.1768=
292-1-yi.zhang@huaweicloud.com?part=3D2

