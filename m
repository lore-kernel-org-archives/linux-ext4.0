Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02A233F5A8
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 07:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788335888; cv=none; b=ffM64bcagAnylheIg2h+kngzABGNt/rn4zI+Z4+jCCczXTEWc4yMp5KwIa0m/ot+tX1j1duKpzOl383A6DrrB052xUiQgSA0ZQb6w5x5XnaomGcAbLEnGkbdRSP8cxyITGNNW7mBLRpQ+G/WPFgGu9IWInJMRy6cy1/BCWyRNYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788335888; c=relaxed/simple;
	bh=IpXV19ZGgXhZKLfXlKNI1tRU9TYbXbH1Q/IVU9ktSn0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RyHnhxBs0RlkcEN3CPue+ltGqnS8sXHWjvXqqtXZVvmbJ/zBATWKhxYSPXQI0wecsoqEpZK+pwA1jTk1VrB2GXHWfLudkuGoArCHaa0b5CKIMFab+AtSe3xyfmnygXKPNK/ClsnGIRbnr0QAJgJL6ah5VERllBj9kH6pNeisXMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gqmgqzDl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gqmgqzDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9FC1F000E9;
	Wed,  2 Sep 2026 07:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788335886;
	bh=IpXV19ZGgXhZKLfXlKNI1tRU9TYbXbH1Q/IVU9ktSn0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gqmgqzDlQjkyb6DkApANQ1aWPSZNHwqvX3r1fL+pxnDEPWVURvcxkvN7qlsoAtWcP
	 hmfvBqATffDAOQ5yWKRcFPaIymt7+ul6hjCRsvltYK4pLwnrEvmT2J/Byv037iSmKA
	 5srInjy8r9g7GB68esuTCpLviLdDwVljqyO5edXMpNK2JOXYHC0avdMumZ1m99Nyfu
	 2xEB90T30nNdlfNKdKWDshUvAq2npoQZbWjsiw5kBG2v31et7vue/ZICI7Yimeb/rH
	 6Rf53S1xztzkSfKu6812pkmPp1oZYBH8c0yifWQu1DnHnirIBzLJu50V89JLSb5lFL
	 R4+0Os9Hy44kg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 6/8] super: Use acquire for SB_BORN check in
 super_cache_count()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260902074805.398540-7-ruanjinjie@huawei.com>
References: <20260902074805.398540-1-ruanjinjie@huawei.com>
 <20260902074805.398540-7-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 07:58:06 +0000
Message-Id: <20260902075806.9B9FC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> The active SB_BORN check in super_cache_count() pairs with the
> smp_store_release() in super_wake() when publishing a newly initialized
> superblock.
>=20
> Replace the historical independent smp_rmb() barrier with an acquire load
> on sb->s_flags via super_flags(). This expresses the publish-subscribe
> pattern more clearly and allows weakly-ordered architectures like arm64
> to utilize efficient native instructions (e.g., LDAR) instead of a full
> one-way barrier.
>=20
> Also remove the outdated memory barrier comment in super_cache_count(),
> as the underlying super_flags() implementation already self-documents
> the matched smp_store_release() in super_wake().
>=20
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Assisted-by: Gemini:Gemini-3.1
> Assisted-by: DeepSeek:DeepSeek-V3
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902074805.3985=
40-1-ruanjinjie@huawei.com?part=3D6

