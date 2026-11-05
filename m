Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793880239;
	b=gwwIIeb+EpJvCxFFRoEKb5VVdlGLYjRFmZBuoUO8gHVtiEv4l5gFDgVMwJS6aFb04szc
	 IzIaDVbL+mcZs6sZ964h0kMpwRmfYbgvH6ixdz+dZO5VUEIHB6RzWSPAxMm4IMLL8F0rq
	 ub7Msy1QWAADaNSDDnpFzYbdf4ecDraj5D2nXFhOXu0ibwU4UgyZ6Ktq1/vdhXycXAQlU
	 yC88XSYSLyUiL5BR3oQmYSHX1rCKuI2yjOEFe4XFHw+JlAD0Qi/mX4zsbCW3haA7xJo2i
	 3DEzgXsJ79B0g8WT9H/HjkPe6PKo0ZO+gIG+dR/ruMj5y8mRf3GYg35YOh7WYZBtwcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793880239;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=BD7l9yO/ye2/Qj7a8/wZw8zRvBFJtyyeadiv5aaacGM=;
	b=BD50ln1L35kt7CixNqDifovs6hOmTp/ogi27SpYWjR+CV19Eo29AyAnZfzFgMWb2zQVF
	 6tJQ0BgC6rwShl8JCfzEQ9aqUwAhqKGQ7rO6fsANqdqSorWESGkC3JTZ1M1wKUv3s1oQo
	 kAyaJgVUbcyjhkp4EF7R4BoO4BAJDo+knL3p97QRjjqXSgKst2GuiQZBh1F/exa+9Ca5C
	 AacwFPskF86SkUtgovsAPNnACYSCWwBf8Khvxlww5EIWlzs2eT75sU5gZokJAlB+jC+gB
	 +TVGq/NGbJ0GgIdpj1kTBzgkUoVvPuHzcNSq7naFLFGFqoPVSV/sPx0XYGk+5/Dn9yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AmEA6gJ6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DE6606A334
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2026 12:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AmEA6gJ6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3FE1F000C1;
	Thu,  5 Nov 2026 12:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793880238;
	bh=BD7l9yO/ye2/Qj7a8/wZw8zRvBFJtyyeadiv5aaacGM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AmEA6gJ6kfLXJvWBDkwHxr+05lYdcOabYVdHH4F8yahX1Hsap97fiRVJX/r0GTIx8
	 pJKqIJhYOkYnJh1UUdg5bGvrifrOnowPDyRbRWN+ZkhFChXXx6XuaQTzj0VTGArD/v
	 6Lf/FWZofG13EuyZhJ4DM5R2EffoNe6Gp5veV8a5C3t663Y4h2+S3KM8WH7NdLpxU0
	 sQNyO0yNjv9OLqNWq+FC3Q5XY1UcqqyGsYvU2mZquT57btxFVc64sFJYraSJVEvvSt
	 bvjtl3p2inqWl8tswbvxNknbDRiSmiCNLIk6Gkvcrt5t39tbHDMvHv0XdHfBPP1iiF
	 vRiKOVZlwwTWQ==
Message-ID: <sashiko-outbox-198988@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [f2fs-dev] [PATCH v2 2/5] fsverity: add I_VERITY_BUILDING inode
 state flag
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn via Linux-f2fs-devel" <linux-f2fs-devel@lists.sourceforge.net>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105115532.613467-3-aalbersh@kernel.org>
References: <20261105115532.613467-1-aalbersh@kernel.org>
 <20261105115532.613467-3-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 12:03:58 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Every filesystem that supports fs-verity keeps a private runtime inode
> flag meaning Merkle tree is currently being built *_VERITY_IN_PROGRESS.
> They all serve the same two purposes: reject a concurrent enable with
> -EBUSY and let the write paths recognize the special writes done while
> the tree is under construction.
>=20
> Hoist this flag into the VFS as a new inode state flag,
> I_VERITY_BUILDING, and manage its lifetime in the generic fs-verity
> enable path. The flag is set after ->begin_enable_verity() succeeds and
> cleared after ->end_enable_verity() returns (both on the success and the
> rollback paths). Add the concurrent-enable guard.
>=20
> A new helper, fsverity_is_building(), is provided for filesystems to
> query the flag. No filesystem uses it yet; the per-fs flags are
> converted in following patches.
>=20
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105115532.6134=
67-1-aalbersh@kernel.org?part=3D2

