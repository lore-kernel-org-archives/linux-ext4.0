Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792682155;
	b=0cO7MQhQhtdnh/pTe1Wq9mmlKGRKtWmr7WYBgH0z/OgYyeo2aqk5M/KJDQHVFVGCPyOt
	 mXKIVLtmJQYH7LKfOqaB/t+f63eE46BHVkSooB8SbRoqpWGGywvMPJT+Nhtwz2zH3jcy/
	 c9swm6MBb8/rTbgBkisl0Z+pKn1SBLYlHMxtgl0JV9mY/Nchfbw0lc7r1JeYsXUfIfNoX
	 qS8xt/F7Typuv7+yc37HJ1iRBULl1ULOPZR1YEYRtOIeLgrOiuyJ6+p6fWhoesejSJ18C
	 oSM2C7l+jlkIaPURK+NJ72KIaKMIMQ57/6Hon00/VQbSJzpxLBIEJ+1bJqU1OFSvCcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792682155;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=r/1PVt1GJNTHRiZY511Nrkth962jP7aBqoSRKm6a4dU=;
	b=qPzCX50n9h4d1z4ZDuTE8cmmAo/nlGHq2oaOSur2wVqxLgaOmcoqIU39DV69OPS4PVJK
	 /k25v563S/gsuRTNoJDc1R47n7VXDZ+0z9u47HMfAlZFLiu1yki5NWYTA39eCl/mRzNgH
	 BM6QbGZwedm92U0Z8Nh8drKNgGgdbQkhO8ymtF7vEyQQtJfvja3jVXA2kk3iwsIe3/CcP
	 0v3xQ3fOobJopx7o89OaxQ0wmWGCi9odGACoPgqWRLcQfyE0e+VvIxgiTNCrHnytXDLv3
	 5go8ZD3p1+z6PvI9VQF9DPRv8TsuaCeKoZ1hQe8asm3MMtSmQykSR1T1j/zUfJG3f1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LaA4c125;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6ED606ACD9
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 15:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LaA4c125
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3671F01825;
	Thu, 22 Oct 2026 15:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792682154;
	bh=r/1PVt1GJNTHRiZY511Nrkth962jP7aBqoSRKm6a4dU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LaA4c125/ghIarI2lBqqOtqmU6RrUlRK+YeLtcKRMZGhCuLLhOc2QyM7+E7skOMpO
	 5Hoult5+VMTkIEDR4EKczX+mfHIkMGBv2qSn6uWUpLlAu7ESb+UoIsEixI6NvF7vxq
	 uwPowKzWDYuK7Wms9b15wRd5PvNG63wyD/OGVsW3BclbBtamcmaLO90dfmlOeh9S5p
	 Uk28KqzeHmUrfFK+ewy/WwWcC93O8qgfa+1OMVUSfofsNQVXwyx0Ug0Oypw9pR83Lk
	 5nQRIJ4sN7X5iPjYYtR/iYHjzjbF7Top22efLBV6YLwmiVjsHdUfKO/oq1dWgMLpOE
	 mnzEiIGere+Ig==
Message-ID: <sashiko-outbox-181679@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/6] ext4: put folio on partial writeback validation
 failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Julian Sun" <sunjunchao@bytedance.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261022150244.2969056-1-sunjunchao@bytedance.com>
References: <20261022145241.2950379-1-sunjunchao@bytedance.com>
 <20261022150244.2969056-1-sunjunchao@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 15:15:54 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> mpage_submit_partial_folio() takes a reference with filemap_get_folio(),
> but returns without dropping it if the mapping position fails the
> WARN_ON_ONCE() check. Release the lookup reference before returning
> -EINVAL. Leave the folio locked for the caller's cleanup.
>=20
> Fixes: ded2d726a304 ("ext4: fix stale data if it bail out of the extents =
mapping loop")
> Cc: stable@vger.kernel.org
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022145241.2950=
379-1-sunjunchao@bytedance.com?part=3D4

