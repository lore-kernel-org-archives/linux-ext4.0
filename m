Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794521016;
	b=gEUyNkeGDK+6ICNMSUci8obYJgVu2LwYeb0qVeFyZqHd3AKhqyliP7jLDL2a9vdSEMdt
	 wjak/VShuer7H501v9mH8D1lycAozeEjlt0+iYg4tNp1l99gM38mh7Ppp3h28v6SPapDX
	 vr+XGs3i/9KYueX73gbcvo6DvBZ7S2izVxOSKrW4gJuCP5PGK5EjOOQwQbDMC7mKsYkAW
	 U1/ra47hefrIDt6Qi9iXURqwZAan+60IHzvwWy1n+kCJeGN1nApHMi1YLZCEb3+QySjOB
	 wFM5acB8PL8QHIQnpfFwAvu1i9IaUrwu6ANY5x618RRPAWFbMInxF/D5mbKP+8c+GKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794521016;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xbNouj6qz977jmBqwfF9jms3C/KdwW+itLrEfwWEGmM=;
	b=GIrrNnSn5KPuciu1TmMBd4R4hq4aiSfpQVXjRUY5wZvk+1zJtrehQLXLLZVE/r81lRi1
	 eOqt5Mapg3OXpcBbfgvEb5TBOjDCnThslHFdrMhFz1xFeA0I4yyC8XMGS5O17O88sMWcz
	 FoqgqUS7dPB360jTAPyuz5vLd9CcWODOk/IFj3akWphTGX+K9bYJUOVbVDe+xAJ4qvdY+
	 04e18f8E9dC0FA1FOq5LvHRKpnBh83AN8B11APJpy+jTkxOAm+VkQAGLYOone1mHY3OmX
	 3Mw0l5FdXycHgnA7h+a+lB7+XUSm65DmmLrJdAziyBRoR9GwSeuo2k0Qg6UAOOfVxog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HXwFKoxK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D522606A323
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 22:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HXwFKoxK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7321F000C4;
	Thu, 12 Nov 2026 22:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794521016;
	bh=xbNouj6qz977jmBqwfF9jms3C/KdwW+itLrEfwWEGmM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HXwFKoxKZWooABoVzcT8m+IiWrZHoeJVv4GIWQ6fCLwdwE8fMYCTg+qNKLJRx7I5m
	 0O0hTU59VrrvafhWKkTsGLHciXkBAvB5cIC/c1DSvEljon5k5KpKB91/wZyfaenpDI
	 sGST6dD70+hsOE4ORZcatzJG9FHNQeQp0P6mmr4DFRCj4DrZh4W7ToSiiuNa7nOQeJ
	 9okePVQwP5PcguxnCWPlDzy+1UwTZXoYnJ8KIBBgdRs5Sk3SlCD76p2Wjej4KBPhHh
	 xjzaxVjJOhZmIqrMOLVeb+Sxlwxcv/PNs5DhdbauT08hSBFnRWdpDSzeUjD9SwHlWC
	 r5PnXll7ToQsg==
Message-ID: <sashiko-outbox-211886@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 03/14] xfs: don't change the block map under a dirty
 folio
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Mason" <mason@kernel.org>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261112214604.67875-4-mason@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
 <20261112214604.67875-4-mason@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 22:03:36 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> With CONFIG_TRANSPARENT_HUGEPAGE=3Dy, writeback on XFS can write in place
> to a shared block and corrupt the other file that shares it.
>=20
> xfs_map_blocks() writes in place unless the COW fork has an extent for
> the block. write() and write faults reserve one before they dirty a
> folio over a shared block, so xfs_flush_unmap_range() writes back and
> truncates the range before a clone changes the block map. But the holder
> of a GUP write pin takes no filesystem lock, and the truncate keeps a
> large dirty folio that straddles the range:
>=20
>     clone                         pin holder         writeback
>     =3D=3D=3D=3D=3D                         =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D         =3D=3D=3D=3D=3D=3D=3D=3D=3D
>     writes the range back
>                                   dirties the folio
>     truncate keeps the folio
>     maps a shared block under it
>                                   dirties it again
>                                                      finds no COW extent
>                                                      writes in place
>                                                      /* shared block */
>=20
> The fix used here is to invalidate the range instead of truncating it,
> and to fail the call with -EINVAL if a dirty folio is left, before the
> block map changes.
>=20
> Fixes: 6795801366da ("xfs: Support large folios")
> Signed-off-by: Chris Mason <mason@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112214604.6787=
5-1-mason@kernel.org?part=3D3

