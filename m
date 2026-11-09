Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794250504;
	b=a9absKE3m5hufL7EORc5yrrelahlntLVhhAAU+ccRgdjCQsNH/mzrS8AjbecTvb2G0ST
	 mkPCs3uUWfC/RJ1h2F/xNpzz9VNLZ10KUvRiCYbq7s78AoKKNOtFRpz2V44tKqKlJWwt0
	 oKSXvNwss7qx+wmR+nLtm7qRicm1srOxDz3F2EUNbaVrgbnQ3CL+y2dMU2+avOfzwxIU0
	 Q4Pm+j8aqFJ3Q7M1OiIJ8KTg0B6u/Z7n/0KrE/MhHaPMTlUqzNEXZTUdP/usvQJl5vqLR
	 sL+3/ABn7AeNDGQDdyggtuBxc4ooL+yK+iXjNuMJxJrhD5klo3AlYGy9aekYfdQI5+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794250504;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=NTi7CNw2jhqFD6FOpS26bolu1jkCyIR+ABgcOqTWJ98=;
	b=KxA9qc3RqVc6ebHEb8CXbnnm2ZRb9DGUD/Lz40pntDCe3oTYk+azN8yw+8RVn+uL7h7s
	 K+TbmGVVLph4e83/6QfvJ215dGDflNWpXMxi6jpCPHxzCsP8V5yaz/80Rt3DBD0JKB6E/
	 kDdCDbh4v9/noW1zzisotmAcD3JP7z/hszwDFhjQhf3OoabmUX6l3RSWpxP4pGCWtmHBt
	 61wg8dNJ+w9SlrBo7qM+uHDOZXxQcUyYI8kj6Pasy5Jvm3YGI+jNmxJ6Q+3ZOfgiZ9vpM
	 5dgpOpK+fCP0Eza6gEXJDwSn4r4QBSIu5mCzSPViZUVtjSJ1wZR+zVMLkFT1Cd3JTzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LbOKxkvD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9378A606A321
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2026 18:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LbOKxkvD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EB61F0089F;
	Mon,  9 Nov 2026 18:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794250504;
	bh=NTi7CNw2jhqFD6FOpS26bolu1jkCyIR+ABgcOqTWJ98=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LbOKxkvD8S1nnkxjXgtSq92lpDX6g28DyQBDGl1ndtlN2iLUZKN7tbqNLJRmFOwdn
	 SM5YlYrK0LXppydOc6jtzRTEWCZtW9oOky9hXH72c1UJhTBCZgFdGX8AwQpHHl/t8J
	 6TyNjwLTrzuqFES3IkTrBR3BimyDi87P1f0LYe8EKqA0BmxndPEe4q1r5xcsxHnn0J
	 5TpqzQkmy4W1mdr4l6NcQ4R1K9ipLjgUH34E2HWZmTdlxIdaz9GccMzZYnqZf+VFJM
	 5JAXfOCIzUIJniERz/YOso01a8+pHElPtwBv3DGTm7V+p6n0om03RG4FOwmiKmS618
	 nU0ttxEnowAiA==
Message-ID: <sashiko-outbox-205451@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 11/14] ext4: drop mmb_sync() from
 ext4_evict_inode()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261109-work-inode-metadata_writeback-v3-11-91ac6c024018@kernel.org>
References: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
 <20261109-work-inode-metadata_writeback-v3-11-91ac6c024018@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 18:55:03 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> evict() writes out what I_METADATA_WRITEBACK tracks before it calls
> ->evict_inode() and since mmb_mark_buffer_dirty() sets the bit that
> includes the tracked metadata buffers. So there's nothing left for
> ext4_evict_inode() to sync without a journal, and with a journal there
> are no tracked buffers.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-work-inode=
-metadata_writeback-v3-0-91ac6c024018@kernel.org?part=3D11

