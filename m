Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792737195;
	b=0l2b6jll8lnzpJABx7u9yevallcnwvroD1xAEeTCeI59QvPWXBt84+/TmZEM6bBvHjie
	 Sw1pUFhcWs4FpgKwJ/fXTkzOebvuCvUPMkzcPRIKh44t2YMo+MY+q6+wNCtCAxfYTad+z
	 MZBKNbFfeC25ISXAgLSbkm+rAjQh0qJ0/SLfQfYUJf8c/tbcSXLp2gyz9uzCfslD5Quj6
	 8+iL7XpohG74lbtTDVJDq3boHe1f8PQ9zvAx54No119oREoelblgr5fTl5+T5C0eN52Fi
	 tYhx3UiAMTF8UXSLD/XCapw/eIZ8P61z69URcp02Zubc7axg4BjBxROgzWKPF/x9JEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792737195;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=doX/xwb+RsqO9fIPmMrMHDx+s5DwRChBVG4ishGA7GQ=;
	b=S2OOJC56sXO2l/uhaJtOrwrCZKSK/0XmVDtZJx5wMik9nWI9cApQQzp0YprCfJwroC4z
	 r/bEHpvKvrI9AoWdd4+Fxlh+ZR1RmVZiyTB1cOZTeX5Ng1w865i7r/agTzFUN0N338ysM
	 uICzA2sm9UOyZGFwzHJrFXqmxyQOzs7TTg3IGJySAEd3fdrcuD1oo5F9v47kYvM1ziBQ9
	 j78HVhwxNWLCA7M7r0+nWH8Z+4PczXOkhFRmF9AtUWbz1qT2C/SUqlJ6Crimw9N9pLKmE
	 GF7svpQyQB7KQdtHpr4dYK2mEH2R3Ua4cHqWkpkYdsoQs/nLZIPpf+fFeXEQP/b/JuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aYKdU4xe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1D9606A31A
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 06:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aYKdU4xe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F321F01825;
	Fri, 23 Oct 2026 06:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792737194;
	bh=doX/xwb+RsqO9fIPmMrMHDx+s5DwRChBVG4ishGA7GQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aYKdU4xe5rs0AO0AS2n0frFrabg5dDR8RRdKp+NOs9jmJ8jBposbfT/37PifY9ZUJ
	 WfvMADYb5Yzjy/hDQK0O08bW884lTHmDVwsQ4CWQJL57T8Ucn4s64bFuxcTyIqssU/
	 yWC9PAo8ch8jI03WEtoenxdwfon0q9ZgiPIM8A7fmzK4nkSVww3SoHrKw0XeOzYl08
	 Vgpokq0pOjtmTjVls0B5pcXf7ncwDXdwk6+TbuF903T66fVXqCma5SfTAa+aOqosOz
	 wlnFv5zExuyh34ktipTQtanKi2Zq9jdTYWSGRK4CRxgo9NrGAfsDGefLpo4xS5bJsn
	 7jdzPSbUBHCsA==
Message-ID: <sashiko-outbox-182353@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/6] ext4: submit mapped buffers when io_end_vec
 allocation fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Julian Sun" <sunjunchao@bytedance.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261023061851.45579-3-sunjunchao@bytedance.com>
References: <20261023061851.45579-1-sunjunchao@bytedance.com>
 <20261023061851.45579-3-sunjunchao@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 06:33:14 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> When the filesystem block size is smaller than the folio size, a folio
> can contain discontiguous unwritten ranges. mpage_process_folio() records
> a mapped range for conversion before allocating an io_end_vec for the
> next range.
>=20
> If that allocation fails, mpage_map_and_submit_buffers() returns before
> submitting the folio. Its caller skips partial-folio submission, leaving
> the recorded range in io_end. Completion can then convert the range to
> written without writing its data, allowing reads to return stale disk
> contents.
>=20
> Pass progress into buffer processing and set it as buffer mappings are
> updated. Route errors after such progress through the existing
> partial-folio submission path, so the mapped buffers are submitted before
> io_end completion. Buffers still requiring mapping remain dirty for retry.
>=20
> Fixes: 4d06bfb97ecb ("ext4: Add error handling for io_end_vec struct allo=
cation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023061851.4557=
9-1-sunjunchao@bytedance.com?part=3D2

