Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794774468;
	b=UctGLrqZE4lUGGs2sjNMCPmW6EhKfm9J10r9NrGoi7kL2zLK9zsQEcQX6wsNWS4KXRkR
	 6Toysmp87elf3fota98fJZoPLEyo7ok4Oc2c7N0UvLoZ5SimfrhyQuEcM+m2jk+kcna9Q
	 gy+VqBWRvGGSP9SZZxOcvAp8qjfE+Pqzg8WY0Ern2Tt+0XQOywur/O9WC2KiRv0B4NkWt
	 lvJW7lnEg+3rldhuTEbYGnN7jlX4y9JmMjCWt6wvp15K8Dpn9YMBFzHNvkkgAzEeNb5+O
	 BY93JJsXhYLg5jbfYjfVV3vf0AcV9hbxCJXCxGswRSqCEvTvq8af9+qgdBlAPlInaDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794774468;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ma1WHZIrAP3x/XdyE9Fe7QzGMm4l2pw1akoBMnem95w=;
	b=K/+jJAYK8nA5fUbO1u0eu2gs24Nmd103z0T+RBLO8ct7XRn0HxaOzsCnxVIoxQpZz3o3
	 B2N9TIZ9Qin+3Iluxc1U8uP4ot40gOeVBJ5mv0uc8VAQOKohFTNU70VoFz5I187yanKqp
	 YzTUuiLjmspUsrpkMVysGj0nk7gaFuqZETcid3aTaYY1eBKSY9QYw4tOLQJEbgegO/hJB
	 4h3ydHExEzuCG7wZJJZjnRvwg8ZWdIjXGvU3lb79LD89W2quESI61YzW87vFZKPx0lseP
	 0bnhNOm1MK04LIoDTGbwkxVWTvvIcBnGDg3JnI9/1sxF0ibk4YUpKU262+z31rIzT2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=asXjiVMz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5720F606A895;
	Sun, 15 Nov 2026 20:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=asXjiVMz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4CB1F000C6;
	Sun, 15 Nov 2026 20:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774468;
	bh=ma1WHZIrAP3x/XdyE9Fe7QzGMm4l2pw1akoBMnem95w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=asXjiVMz4H9i90bMdh/GI1U1+B6yMFVtYb1QgbTw3eyV9jSL34N8TN2v31r4hn0mL
	 8Fuj6MsrJH5XQMD03pNOyuX9xJT8c4wYdMnS3foLkQGu0ZBFIHYcocXNIJTaac2vII
	 H4Qi+4/BfonBzHgMYtyEdkVofKoQRD9+qRxLgWi/aOP39Ay4EOM0NdUdG3vk2ACl/7
	 dhTA4Sufk8OcY/DGV8GgL0jyHQitvuYAkqZOP3+nOHfBIxWdauazbffl2Wa3MXl+Qs
	 9+0GbYM1IU/+bpD+AgbsozGqtGKMmwoILcmJW1pl39fqEUHUedGhyKanhvcfTQLFrM
	 SRNGmY7qW7wMg==
Message-ID: <sashiko-outbox-215805@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 05/12] docs: ioctl-number: update video/fbdev entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Randy Dunlap" <rdunlap@infradead.org>
Cc: linux-usb@vger.kernel.org, virtualization@lists.linux.dev, linux-ext4@vger.kernel.org, tytso@mit.edu, "Michael
 S. Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261114202653.3113381-6-rdunlap@infradead.org>
References: <20261114202653.3113381-1-rdunlap@infradead.org>
 <20261114202653.3113381-6-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 20:27:47 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Update the list of files where video or fbdev ioctls are defined and
> update the ranges of function numbers that are used.
>=20
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114202653.3113=
381-1-rdunlap@infradead.org?part=3D5

