Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793585336;
	b=MazZnvypoX8rJRvIHYedkoMdr3OW2vxOkslWohOkCnI/mOH5Rv33CFKugmzKGUswcs0F
	 G+jqXxwatfsspRG1jK+lTIeM9ddwnebteM1LWgropCwfmqPRQTTqo879OfpJkvyoHbzRO
	 YFCc0q1vHXs5MZE9e081j6AHPsylpWtTPhYdDFg/JQiRQupKRFshCibnorzcz53yBApvT
	 wicZjOAbCM/Nq6gTwwpZigkq360oh7b+n8DG+ZgFw01dbwIWW76FFzFXMbw1FX9a/wxHb
	 ss+232kR+infvKXxxFuTE7zgF4Gk6RhXrdhh42RUmxFN1uwhU2c/pyAzuNpX43ztoVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793585336;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=yjpg+YwIGqycCLsLbv48k+GU9B8nbb2iU7CNcn6wBaY=;
	b=fg3OirviC/54gbttR0nJf29YLtsL2HIpLYLFnF2tjmE5AS/QmV4upeOqbr4p+4n2ACMw
	 Eaz0FTr+rVp9VOqG08w15qvYr8VmvYeZdrlPDYKloN+OQNa5Ssu7/PQ/hBhCvofdZ8Qv/
	 xZYb1LHKHM2Bt0QVTi3sZ+sDRWh+enoqT53NPd7e7yv/Ep7s01ECX/qc76j4jpCAOG4oo
	 erft0ZioASmT+yYJBagzuGejM8ugv9W+zBzEQDu4AM6ZWM9kGr9Jb/u1eTkDWCYu5QFwi
	 tqQKAVHp28Wtu+xUdE04zC5g1M6O8aeO434Mo3gpT/SpPzIGiAN45JNz4oH7hw/efsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mGTCW6Ie;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A185606A324
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 02:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mGTCW6Ie
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8181F000C1;
	Mon,  2 Nov 2026 02:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793585335;
	bh=yjpg+YwIGqycCLsLbv48k+GU9B8nbb2iU7CNcn6wBaY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mGTCW6IeOetLSuBCM0rujylx/dHfLonH84iAiimY2uTxWtviULm1RoK0zfeLbIO+R
	 Vj3tg7HHFBp/EDdj7zS4GI4Af6ryzPUY2Ao/c0CgpfSq3FqAx5yH/wlxcnFXh/EQLE
	 pwU6gz8zNHlSHYCDUEFLyLynY33r1hP9AGPU8/TIr/lBz2mITHKjUixDAH4SuNdF6Z
	 tJPmGpv7u+ZBcg8ELgQgsE8wZEE+cBmaKhkbGiJa2tqXaSyVlTarFWkihF/1iH8Mh4
	 eIDxF2y/taq5G17/0CotCMfPMDWdCf+/8KVLHTtKpIEpB0VWDO4+do22hqJp0N99PA
	 sTtjQhUfX6WOg==
Message-ID: <sashiko-outbox-192822@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v4 1/2] ext4: fix shrinker scan budget accounting
 in ext4_es_scan()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <odys.yuan@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261101-fix-ext4-es-scan-nr-scanned-v4-1-1290a288f5ea@gmail.com>
References: <20261101-fix-ext4-es-scan-nr-scanned-v4-0-1290a288f5ea@gmail.com>
 <20261101-fix-ext4-es-scan-nr-scanned-v4-1-1290a288f5ea@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 02:08:55 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> do_shrink_slab() reads count_objects() once per invocation to derive
> a one-shot scan budget, then calls scan_objects() repeatedly until
> that budget is exhausted or scan_objects() returns SHRINK_STOP.
> include/linux/shrinker.h documents that scan_objects() "should track
> its actual progress" in sc->nr_scanned, so do_shrink_slab() can tell
> when there is nothing left to examine and stop early.
>=20
> ext4_es_scan() never updates sc->nr_scanned, so it defaults to the
> full sc->nr_to_scan on every call. do_shrink_slab() therefore always
> believes a full batch was examined, regardless of what __es_shrink()
> actually did, and keeps calling scan_objects() until the budget
> derived from the (possibly stale) percpu extent_status count is
> drained, even after sbi->s_es_list has nothing left to examine.
>=20
> Make __es_shrink() report the number of extent_status objects it
> [ ... ]
>   after this patch    239                      1 (0.4%)
>=20
> Fixes: 1ab6c4997e04 ("fs: convert fs shrinkers to new scan/count API")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261101-fix-ext4-e=
s-scan-nr-scanned-v4-0-1290a288f5ea@gmail.com?part=3D1

