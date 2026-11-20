Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795152981;
	b=iO9wEcuzyAgs9CfPGorD3MI5/GD4HdOyPlB4hK5MX/AWY7ZlqfytcRZs9eyTHILoa9p2
	 cj6AIZhdxVlz3um5+hUf+bL28T9JeJ9y05qRI3jOJw2nh0duFQP5ErltyDMvC00jie4Gi
	 HC5+l68lcRbpNFl1IhjoFVPDixPcOlNSoznOFn3S1YnErZ5btnvAfDOj3leBeS5QOMtI8
	 P9mDMnmI+JNtmwywWH7ERsGuI0bxZFuu5ROGS9pOuE1+9bJCK7ZODZtvnv3itypZ9KUu/
	 W5I+8o/e/9VfKL/v2c/Hp4aKvbu/SQC9AXQl6ULE/q88K97C+m6M2FNz+Cc+30OzMeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795152981;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=iba3EthPEXUJc+e+oMrAeOn69+dQ2+xmQdiXHoFQTdA=;
	b=d1oRvcZAtsuEIE2J7ZEx29Eja85BlFPrmawKAtSHa49koqoQgTTmB1+AEabuGO5z88Zb
	 fsWql4vsQa6URD5HWm/P2h8pHCbs2tnezq83190nIkaYrEkDX+ahE1uezMLyDXTGWBXsj
	 HMucgN3Qy+ML7gH4z5U1XbfHiuIzEC1Ykls3NSqa8AtopXYhHav4zmkdnTl3V3R0CSaQR
	 OvwRXpochq0qp4vLpCOMYVz4umcLnRoKRdoeO6Sw/KCxHzaPVdQ2vyaKJkGuur0E+zeUb
	 W2S5W7NP4cpW3CQ53HGCEjz8ICF4uyiuWRAltcpa2Jr43wl0Wy1t0ULiDlxfz17gLvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d0MW1CPi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279F860A2600;
	Fri, 20 Nov 2026 05:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d0MW1CPi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0EB1F000CA;
	Fri, 20 Nov 2026 05:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795152980;
	bh=iba3EthPEXUJc+e+oMrAeOn69+dQ2+xmQdiXHoFQTdA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d0MW1CPiQdSlHC6K89qQ2PMBQKyZv0oURYTiZSzURX5i+9areuo+8nG8Z7HFD9oo6
	 L1jaPxJS8upmn+EKvH3VQh025QNNUsgrHEnLEyRKi5O88C7g7JvDwpK8a6cI7tfCTs
	 ypv7FZ8PA3ee9xyoJEcACK3sjNaQmBlVeI1ub20LmpredrQsTsJo5PVbH8aMHXse2Z
	 +AbCYo/gqCKBGBEnTxWpP9HbVWLRtAqhgskIEm4+j5LtWkE4lHdwmQBrfvfHrDc6gB
	 ycGaSOoCKe7KJZCbwzHnnpBwVHcN8G7V/6RvUd3LsUoPbkmWoCkEj/heI1930WKhNj
	 /6JT1TEtPIRzA==
Message-ID: <sashiko-outbox-224504@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 12/12] docs: ioctl-number: update DRM entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Randy Dunlap" <rdunlap@infradead.org>
Cc: linux-usb@vger.kernel.org, virtualization@lists.linux.dev, linux-ext4@vger.kernel.org, tytso@mit.edu, "Michael
 S. Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261119053514.255348-13-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
 <20261119053514.255348-13-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 05:36:20 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Update the list of files where DRM ioctls are defined.
>=20
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119053514.2553=
48-1-rdunlap@infradead.org?part=3D12

