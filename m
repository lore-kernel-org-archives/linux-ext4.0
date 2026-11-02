Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793630452;
	b=jAdoiNMHmtthO4MWhOQl7D9/kzTRjaBTAXmLKOhqBRhhmrZ6IYsVDInDBFFsWEiaGg6z
	 7NeFU29p7CIxSZXDUWXIi/T35rmvvuFLQu1ZPJoFOT7astAXoFM8ugIizX/MMkuVkLHei
	 6tJaKU2Tfz/d3zPL0seHIgaflW5rHA8MpPx2y0kD+ibknQzKQmMJ0fY1EE8r9tHv0tzni
	 HmkevwrdrVTtQktageIx1k2l6J6+SuGm8LZyBwWTCRS5DWTzW3QmfqMZcwlFGRHfUUhMw
	 HiiXQ6eAZFfAxM6ADk9l2Bl1znY5mPBq3+2kzs1O8dolSKXH3xk3XDTU2zwmmXfOorA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793630452;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=tAzYqkfdltqBAQeOOPCm+dpBoVjuc+uueun9HuVZhoU=;
	b=fiSY/LqvV2nyUg7ve2htXjsi89UzhjvciKZT/mUKRSApeuRjeFw6XeU9ndP+6hKjuA4I
	 pWXF1bjATw1FE59YpxI3RtkkqzjU/9z1DDAsULw8M1kESKoKPJiqvcRFeUxpfAbHYJEPm
	 mpjZemLCfAqroY2sJIPkoPFYFclbAupAcSnmpA2sptQRIDlWaoh4c8E7XFu2Zd/uaZLB4
	 6f1P2me7V+0pKONOKPfZ8CtJCc5ObCN5O9VjvczGjoJOCZsEPJ3ia8OosbUxzPpUsTtLf
	 eOhX4VUXfVdxmiu2325rlWaNxSNuAh4ajhMuDCh882pPj9vYN5HRtKe1D0r3O5qam7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YrtrzbUb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05809606A59A
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 14:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YrtrzbUb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671801F00A16;
	Mon,  2 Nov 2026 14:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630451;
	bh=tAzYqkfdltqBAQeOOPCm+dpBoVjuc+uueun9HuVZhoU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YrtrzbUba0OB5APZqC9oKKeocoO1QJUltYkL25wKhCvbRi5nc/bZSWEOXOq1b16t3
	 K0NQTsfC+eG/XdgdlwfeRiKUVp+5GllTwEd0XOcvw9jXXzF1YV51uRIQ/GJAK7ddsr
	 gzVWZ0YPzOX+9vBs/Gm3AaLpLGsNjS15RBh72uvJMzSPRxVutFy8C4LICkVCs3gRRe
	 9khKmVb/zxiUgbS4i1QUBrtF0qEopP0BnLq2D3+pIxXBwwFzYMBVFvK/gmHYwVHPFV
	 K5dth0I9/SNrdMV4ntinJvE5kQHQTIT4UPvd0SZ27mfDcBM3c3HXzJgjZXCPddHTUn
	 TU/eT1yl98tDw==
Message-ID: <sashiko-outbox-193593@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.1.y 2/2] bs/ntfs3: fix NULL folio dereference in
 ntfs_lock_new_page()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Elliot Berman" <elliotjb@elliotjb.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261102-ext4-ntfs3-null-folio-v1-2-4fd91ee23a4a@elliotjb.com>
References: <20261102-ext4-ntfs3-null-folio-v1-0-4fd91ee23a4a@elliotjb.com>
 <20261102-ext4-ntfs3-null-folio-v1-2-4fd91ee23a4a@elliotjb.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 14:40:50 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> In 6.1, __filemap_get_folio() returns NULL on failure.  The backport of
> commit 95b917a14b15 ("ntfs: Do not overwrite uptodate pages") keeps the
> original IS_ERR() check, which is always false here, so a failed folio
> allocation while reading a compressed file dereferences NULL in
> folio_test_uptodate(). Check for NULL and return ERR_PTR(-ENOMEM).
>=20
> Fixes: 95b917a14b15 ("ntfs: Do not overwrite uptodate pages")
> Signed-off-by: Elliot Berman <elliotjb@elliotjb.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-ext4-ntfs3=
-null-folio-v1-0-4fd91ee23a4a@elliotjb.com?part=3D2

