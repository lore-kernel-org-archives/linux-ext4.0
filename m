Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639087;
	b=L9atY/zWYlEffItfrCOwVqmW6nRYPaVp9Sz5dBY9/n2xLQgTNj4gdhw0Tve5ncirCN2g
	 FpP26kbVPmhpm+jnsSZ0Zn3A11h0mA21Dm5NC2VTRUrZjczaNnUC1wfYz9xCwAo5xCp5m
	 +z6/EE7RJYwwR28zCOD3+1l4NNHnMru/haWn4H2FJn83SPu8BffGZpWptPUT/6avIbRBd
	 LbnlPGYqI1nR/S475x0Sl+CQfDJGHyqD+kPQ5ceo6GJZWmpoT3MNU0JKGZEFv5mDslDGZ
	 SQ36wJzb2aifoBHGr3cp6g0Uc3eO568peKFK1U3Uv2U3krHK6JEetchU+pGVoWvYvYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639087;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xIeRjuP8Hd8dZEnz8sWjOjn62YDNrzush+aKKm0+k0w=;
	b=uizs1MjMvIziDvtvPNskq3PpCrZzr/XqvJDO0Je30nXBfDM69XZ2xs9cAp5Ufe6PuHTa
	 inkrAl0Uhqgm3zU4g6F86gteCJ3XaZleUSlUnWpXLITaHhRsv7AnfbrZ1LI8vmSz9pWwE
	 ZmfuchWbEhfVCAm1XhUJ2LGmb8yFV13usTnQIVmqdAmekJ/IVjE0zUn7vgLSUkEHGIGF7
	 RbiTv36/aeSOJFZdQWiO3Cu0AyK1mrqx0RCT2f6GuvRsqYPG6f6BV68z1eOkcp6dbfUie
	 WbCzuZX9Gf3zEDU4Q3A6PLN+4Cp609TcszWpNCIGMBzzB+QyqavvUKxyBSktldgxy8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SvZBKTde;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F8E60A4AE9;
	Thu, 22 Oct 2026 03:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SvZBKTde
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3131F000C1;
	Thu, 22 Oct 2026 03:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639086;
	bh=xIeRjuP8Hd8dZEnz8sWjOjn62YDNrzush+aKKm0+k0w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SvZBKTde4CVAMrgFcMmAxNgMyALQdBnJjZqZjN/e4UrP+nCsLxrVgfEw8SpZlzPjQ
	 4p2+yg5n0WtVrChiXBqo3ulsJujYh/u54HEMRxOCuALgCQjCDyGOabJVIqN4CxG7wq
	 WKvdjxioaUR0KOqRlqhvpcmio/EUJ8uJA2mLf3r1XmjhV5Vx0XVdXM81DTACW7BRhv
	 ImgSwGvo6flnfPiddj0z/GpFRcfkhPFjFFPQg4vgz7uroWLhImlOxwh66OAwNZnb+1
	 KExJd7YnHbakF1ZumbiGAKC2XXCDyiZenxHYTfj7WjVByo7F+Jvm/G76IlD7BP/kkb
	 63UtAsLJxYZ+Q==
Message-ID: <sashiko-outbox-180938@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 37/41] ovl: allow UUID and GUID owners when the
 upper layer does
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>
Cc: linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, tytso@mit.edu
In-Reply-To: <8bb654a6a07fa2c000a965f72629138eec3f87b1.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <8bb654a6a07fa2c000a965f72629138eec3f87b1.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:18:06 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Changes to an overlay land in its upper layer, so whether the overlay
> can store UUID and GUID owners is the upper layer's business: take
> SB_I_UID_R over from it. Copy-up of such an owner from a lower layer
> into an upper layer without the flag keeps failing with -EOVERFLOW.
>=20
> This is what a live system with a tmpfs over a read-only image needs
> to give files to UUID and GUID users.
>=20
> Assisted-by: Claude:claude-opus-5-5
>=20
> Signed-off-by: Jan Koester <jan.koester@tuxist.de>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D37

