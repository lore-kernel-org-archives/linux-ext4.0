Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792736830;
	b=RuqhCIiY0bpG/BkHHSoCToFYxAYt0tMbp8BDeYjAjCfl77iHp1E2yH+SOk6DuMVfVWYi
	 lR8LwItKCRjNsA+G289kkjKVWpnhmzu3nVpVa6sH89laUGhJfOXQWNjh/LgWL6ZS1xenO
	 9Rq21XqzRVNCjr13IbjxMo0ia6L7DzPC2iMxqGOs+u6Hm0XPZ/63HSxXVhKeRcxcIzNHj
	 R/ki0ZyB1L73FiYRJWvtDzy4IRvW9dzyEqOXnupmEHhYZj9Bug3i0ZddnxeqD6HCyu3xQ
	 8l7Bs0Eh0tO1MayC5uYHVr4KLIlKA2Ksd8weYnhc5d4JryVR6iH6KHSjPnCLOeW+jOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792736830;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=HmYEonVigYeJVBhx+uI0PFOXa+885fp54Gh7gqkWCoc=;
	b=Hgv4PlvvSWIHIUmAO0d1ljLjVKqTexn+cCbkEK1Yqk0qfjAeeHZLZ6JKNUez4NqIoQkX
	 1LrKGiT+tUdd9214fvZ2+ZaN5et2qJlUWteclvqFYYmipCSALTSgkBa4YDoNxF1QaN+uX
	 FlyqXagZA4HzRq8cDG4frcPv30hmYWi0FnhLXCnj+paz02+LOxNrOJZyaXZ+c8sDvpae1
	 FXITA5FaDBT4p8niKQVAYDdtMOgPvNPmJRqHwX1xeEVLNrbxLtIVeU50fCZTnx+9+IANn
	 QR6o3E8EpjrKYQwJyF0GVTK/YF39r4SRKbBmlFfgRXJWSe3shTgU7Zc2Cjc3jBb+6XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="UX/cYchL";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A45606A31A
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 06:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UX/cYchL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE171F01825;
	Fri, 23 Oct 2026 06:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792736830;
	bh=HmYEonVigYeJVBhx+uI0PFOXa+885fp54Gh7gqkWCoc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UX/cYchLpNaIWfA4eLTpuopRJSPmkCRw3eUrdkzkLf0hPF60knwNMV+lmyw94LP6V
	 uNUwh44uhUiAASw0Oitud/rHv/pmcp0HL+NRgoPPyZG71frcRODxcTCwRrE1LRJz4J
	 /r/Loo4JHZuv0vozuUL4Uq3L1AW9/dXENojB3gcCbDV5Tb9Xr+ssZr0mfrfU8JgOAF
	 cFkfh3JBXyCm6DoH6+Ou0ssJsorkLnnduZvx47Enxhf2z9ogKEkYyzG4Z/fvSC0Sug
	 xYP2j+tyBaCiA+jKGMh2euqojMLss69v+XZ0fTlHUx+ARez7B5bpnVb9Ek29D5OJ8m
	 B+9KZ/0r9OXgw==
Message-ID: <sashiko-outbox-182349@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/6] ext4: move extent mapping error handling out of
 the loop
Reply-To: sashiko-reviews@lists.linux.dev
To: "Julian Sun" <sunjunchao@bytedance.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261023061851.45579-2-sunjunchao@bytedance.com>
References: <20261023061851.45579-1-sunjunchao@bytedance.com>
 <20261023061851.45579-2-sunjunchao@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 06:27:09 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Move the error handling for mpage_map_one_extent() failures after the
> mapping loop in mpage_map_and_submit_extent(). Keep buffer-processing
> errors on the existing update_disksize path and preserve progress
> tracking and return values.
>=20
> This prepares for reusing partial-folio submission when buffer processing
> fails. No functional change.
>=20
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023061851.4557=
9-1-sunjunchao@bytedance.com?part=3D1

