Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FF9532F12
	for <linux-ext4@vger.kernel.org>; Mon, 19 Oct 2026 14:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418652; cv=none; b=bIpLsmB6ROy5zOuxTy6ALixt3ptT/I7AM7dVFTfq+7LCvAhFD35cklg3t4UxTFNaoCYP8yLUn+qm5lc0AerZEbAsWuKnl0wPVa49PTvQucD2k1GDW7VBO26uhsfF+jBmNzFfswuqeW8axPWnrhGEWwx/J0ObMvrdq0KR2EQLO8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418652; c=relaxed/simple;
	bh=wF9ipKacsqMUdGYp+xmCYuPIgWB+apobtWx8pwTf/SE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=udQ2F8i6ZUU4C+SMbKjdmdSSLumF85d5lz0PTxt+QafdKKM0lbM7Io2wp+m+tySY8fXgY08ReajDprY0YYl7fanS7igq8AJdWCNh4ZE8W7bRVYxzyvERyWeTU8ZpHsnjG9/GDEwMGWnYVIlnsHFted/WxXP+P0efiF30T33eYp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D+Y7YEMZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D+Y7YEMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714AA1F000C7;
	Mon, 19 Oct 2026 14:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418649;
	bh=lP4xf0Y1m/2RQSyppn8hVTV6RpUTQWmKtuW0VjH8344=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D+Y7YEMZAqmd1uPTw1nYTumhW04+ADuUblE4kXQmgiIAS/T9wvAaMfWyB+KcsNm61
	 3r76pEK+uEuaFX4y+KenoOpTj0Atv2LcnlF2d6DzsaNhR44DTuz4wFNkct8+8bSdzD
	 1uVtxnbORfe/v15HUXKzK5b+Rdcwn7o5fPXC6bmq3LVWC055U9VPgySoQIsWkypHkv
	 pHNdJb1cWKnN29vK99BbUQXHLiKRKMYe36knaLrVm9eL8c09vF4Blxkx89bJ+UYT5U
	 mBbwKUkyKW30fu4u+UbaztwuVyvu0HtCvu5+9npq+Gxz9sZc/UQKnYYiWLiYDt4tek
	 unPTcTNH8qMNw==
Message-ID: <sashiko-outbox-177273@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-6.6] ext4: use FGP_WRITEBEGIN for tail
 block zeroing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sasha Levin" <sashal@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261019135441.1420968-5-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
 <20261019135441.1420968-5-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 14:04:09 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> [ Upstream commit e1cf7b5f5c8ad1e00d00c50c61c3e8fdc79cd422 ]
>=20
> ext4_load_tail_bh() returns a locked folio that callers immediately
> mutate through folio_zero_range() and mark_buffer_dirty().  Use
> FGP_WRITEBEGIN so that, on backing devices that require stable writes,
> __filemap_get_folio() waits for writeback to finish before returning
> the folio; on regular devices the wait is a no-op.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Link: https://patch.msgid.link/20260714080044.4038124-2-yi.zhang@huaweicl=
oud.com
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019135441.1420=
968-5-sashal@kernel.org?part=3D1

