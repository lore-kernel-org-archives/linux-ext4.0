Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135598;
	b=MphMFeE/UIgcsaqGg1ErpSCgd8+/eZ5mbEansmXpgVAGi7w3wdg7ZKFm34UA0Dpu3MSS
	 RcSjUEPmns3mUv5vYYhnYvPe6/SJ9n5eDDjy4kkCwErtUDOMLh9WEjl+edkqAGjm7K9k2
	 mwh8BRyYUJ245qDl/ok5msgwmBcJ5MF8jEUTh4nvT2HbXDiHCOvyiTg13kUppIL8J+R3u
	 pDJAuzgt2oAEmZUu77n00Fw0IYF51iWe+cHqe27eviKc9G5ODBTrgkt0grSG25hl1Dits
	 RDqlbY5yECVXAl/ZXW+E5SeQVClBaMewUawHfJqO09/jZtqQ0IRCHlD1xt9I5GLcm2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135598;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=478wUwvYEn0nOPnlKuOeKIl9bjmxPEPnO7yqdHWwIPY=;
	b=3254q2WQPxdmKBEfwp4Vq5jULnYLf1L8K+wN3YA4UdLYuN2q+///zGXlwCajTNGXePj0
	 siEq9mgf8XABt9a0ARAumhzCXxERr266aGDjMNCqoVNXtqWmRQ58QcnH21vS7Kadz+sCU
	 f3WLIDOw8h+ElG3PKuV4FaMlWTH9FETc+CAj+3VMcQMmRj4pJKVhqgwqvvOO04tUkq+c0
	 m3kdX7QFrAZKLHgEka3DnN/JUwSfiHGtPkU/PPU18oS6j8yQS/9dU6dyCi5gz2YOog9mQ
	 4NWfKvax9dAQJzoFKdbACfkiZ31oxm4O9S6eZZcsVKloiFjWtotklNWnzG1EQJOgnLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VT3LsNtS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F22E606A31A
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 21:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VT3LsNtS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8087D1F01825;
	Tue, 27 Oct 2026 21:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793135597;
	bh=478wUwvYEn0nOPnlKuOeKIl9bjmxPEPnO7yqdHWwIPY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VT3LsNtS8WarVQF0YbT0sZjAA6oVzXAAxC/wmF+1QpL0sz9zUY7cQz84jnF4bcdrI
	 g/swODr9JkEWo9ofoDeGrCEhwe1jAldo7uqjZpdweD3D94s+FTrSQq/QQLQTYM5uNL
	 crwWdgoRPPdQ5HAH5BlUX+pTTDmfTAD3ls19oXKGsDpYvfG3km+Eml1giuva+oOL7S
	 8yu1I3u0AQnD4iHQiLM7e9okJssrJKq/bem1w7BM0ZScf3meeQcCAmxpDoeLzzcfvj
	 Or/BFTZZY680YCzdqUa+R50Z9bjLnoVSKm6cpKXCfGNblm/hxvfSnqi4JKOSHU6NWQ
	 BieRflgB4pRdA==
Message-ID: <sashiko-outbox-187114@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 03/10] xfs: set SB_I_OVL_USE_SYNC_FS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-3-802e512379a6@toxicpanda.com>
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
 <20261027-b4-ovl-containerized-sync-v1-3-802e512379a6@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 21:13:17 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> All metadata is logged, xfs_fs_sync_fs() forces the log, and there is no
> ->write_inode().
>=20
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027-b4-ovl-con=
tainerized-sync-v1-0-802e512379a6@toxicpanda.com?part=3D3

