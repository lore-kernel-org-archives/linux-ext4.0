Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794774473;
	b=BciJELx9ZfAwHXOqqxBapJbzqgsloMzGYfdPxFZZdWgGVIBF7/JX0pJ5mOfExFAf5jU/
	 gYlVv6A6oWARXBQrr8i+AzKwlknAU8I+o3GFAlyEBasOANdcbCemhgRewkzZlZ4KP6a2I
	 cbRLL0s96uEa/EM506D595rT8z12T5eRJy7o2EWk1xWckXI0W0JNljXcaOp6JoeXGcU4U
	 Bgx94kCeV4N6eW+DmtKTkkhEkYQpMvcKwYbcgtzN+WgIDfHt4aBGJZc9z0JtN1Po7w8XW
	 oEGOoIbh+wc6faus+7OLNm6qC6ycMMo7q4Lozn7yqdIgCLaG08pc/qUh2+kDmVDkrFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794774473;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=njL8//ozwB9ckvTpo0EBZJRah/W/mOz/aTNxkAI1Esc=;
	b=z3TvumSWiI9OXDibl7DKHfB/2JfKLLzTOSScd/SelhhKMQPBIgvD3A36duQXU5qW8poi
	 Sj+e395mPfJGQCmUXvwgecBkM3XFP4ty7ej8LniqUlAYdt3xkU8eT3xbtojTqi5SjYmHm
	 EWj3sBOu1xkziLdYV05ugXTxcqfH96O7cG7ShCCj51zpyBxbUj20jE0kYUg6pySndiySU
	 BSvpACwM1AYLE0Rh/ZEwr8CPsu4p4QWnDB0BT8poT5mJZ5p4Dni+itxBzPMU7v3J4Ruaz
	 kNQuN7nqALGBk3rz8kZcbvtBgJQ/iHz5A3Ufo8vsr0FJDEWbeb9Ml/QRRfaS3fqb4dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OlhSBQoc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A224606A33B;
	Sun, 15 Nov 2026 20:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OlhSBQoc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179131F000C5;
	Sun, 15 Nov 2026 20:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774473;
	bh=njL8//ozwB9ckvTpo0EBZJRah/W/mOz/aTNxkAI1Esc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OlhSBQocVMtTqLHR93BMw6xYlfrBMWRevZbmbkcvpmd8y+jwC/JHxLhUNVF7LIss+
	 kvVWe2blGoVA7DoTD0Fx6hoECJ1diQlBVUXdcoRmNPlmvlQXdxkywpoE8TjPioe5js
	 HRuXZwr5at6KNfB1vA8kGvqMlPvbJryfQY896MwxwaQGiqF7VMuv/8LVJxFuUScaVM
	 mbg0ZT03YVPwQEdWw70cHTO041BqmDIcwp2qFZ/EZ8F8Abv6it0/NnMgQgyuHbaK8c
	 4f9GYsRzMmR3FJnsl9sgzek5Zj8Ltp+0bFsGBFqeOZebwmXy1SubBnQJG0CbsJpVQs
	 kyKldJyA9LVJg==
Message-ID: <sashiko-outbox-215808@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 08/12] docs: ioctl-number: update USB entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Randy Dunlap" <rdunlap@infradead.org>
Cc: linux-usb@vger.kernel.org, virtualization@lists.linux.dev, linux-ext4@vger.kernel.org, tytso@mit.edu, "Michael
 S. Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261114202653.3113381-9-rdunlap@infradead.org>
References: <20261114202653.3113381-1-rdunlap@infradead.org>
 <20261114202653.3113381-9-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 20:27:52 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Update the list of files where USB ioctls are defined.
>=20
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114202653.3113=
381-1-rdunlap@infradead.org?part=3D8

