Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792682711;
	b=RWQgASf+VZ4EKh1/B3zHHj67TldnbiXAWfQbKOVOGxyTfX9Pjz4DIOiKdUvS9+t79ktm
	 ftfSZHhX5pf9uHOB6oTdQLiRvsm1RLyXXnVtbh2W3mFvAWvsGjn9zT5NNN7qfzx8jpuBu
	 +uspa9/IGBp7vQHGZRbx3KYUyAzJ2pOXwfiptBlv7VgLFLB6/8401xJyATJW6y6uAqB51
	 svbIPDLv0DTjZoLaxryDOII9xmuvkjuwztdsBZFp8uSEELy4lDG6afvQCC3RZ/Pgz/Y2N
	 hzGa4mK5IGIsTgNgrXje34kSWVO+k8gkT7PtCjtv4Ns0ghOpBl+LD/AauGUoXI3EElg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792682711;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Z/BlZvy4u6u1NoCEGzqE9r4OhP1HfWOMxFY0aIWcei4=;
	b=EZPbQ9pnL55Mr01sQVsHdXBaX9lm+FxJmE/DD3k5tHfAOia9MPDMFLauSIwftNuxr37o
	 IawmWnvjav+1hotQhaXnjV/53k7zidjdmiUk/yh04XsqeguenaXF23t5vK4ge4g6fB2pg
	 xAkhh0LvdlWnZLikX0saS/nYm4sRAMMnSl7nyXvsJsZlPuu0h886gM0LJY6072aqNiAlE
	 8rA/mUl4fIFYOa65iuHZYyEtl/vqOgRJYhnu1o6CdBEkCqSKP8BfYPx7chmntDwEgiVjz
	 C7KvoktfNgloIa+SmSor6LFpS47VCoKf4gzjhpVQWdY4ZMi/hentD7GAQgWTt93Zehw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oHWilCtW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF402606A31B
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 15:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oHWilCtW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E93C1F01828;
	Thu, 22 Oct 2026 15:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792682710;
	bh=Z/BlZvy4u6u1NoCEGzqE9r4OhP1HfWOMxFY0aIWcei4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oHWilCtWkGJRHpci5pfnPQtlxjHgdRRq+jCFD4mMlvIs1Qco+JCkYAsQABcgVTol8
	 KfwvzIM2bXRtCS41IdG7SosmeZ3SLS0Cl6xrDfuZONLKSUWnO6s1u/o7wra1F68LwO
	 HH9rrUIc44olhlCpT1+kvEjiJcnCYmQTbMwUxidzUHpLocNhMG0ke6PZTjUbV4NvIe
	 bMCF5lF8cMcKqk9E880FMJSNINK5VHagn3QIVMSB4mrbIVhbKucVhjTi8oGUbW4zfe
	 Xx5xc0BiCA41wmLlRsS5BP4kkj+DGeFeAJRWanYSP9vfEko+gTY69NcIDjX47JKlLu
	 iEl0CZr0heyTA==
Message-ID: <sashiko-outbox-181694@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/6] ext4: submit mapped buffers when io_end_vec
 allocation fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Julian Sun" <sunjunchao@bytedance.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261022145241.2950379-3-sunjunchao@bytedance.com>
References: <20261022145241.2950379-1-sunjunchao@bytedance.com>
 <20261022145241.2950379-3-sunjunchao@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 15:25:10 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022145241.2950=
379-1-sunjunchao@bytedance.com?part=3D2

