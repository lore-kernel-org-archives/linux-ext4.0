Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B7949DBAB
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 13:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788440742; cv=none; b=mOHTKb0rUykqcJdHfd11ivumqKgdNJjZBpGw9A2/XDRlbOSbFF9vm7aJ7g2/pNNTDrRTSqeeAEnD8C8szBf7nWuzHCQNyI8gUrj2j+3mZKO5OYmaM7jGRfyFhyKPqv8M701QdleRdVbcpX8F30cic1Sk34GjaXiizNfNof77SmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788440742; c=relaxed/simple;
	bh=apcK9kNwBCDXO3uzEANw5Gm8tjz2lTMuSHfEdzubcWI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bkeJIHZsW0JWfDfvAM6lU9NEWLK4rmnS9MigF/z4J3cHZoJuOQ3Oz2E4SjVKwi0ZETytZv6UuuBGVk/C5bQOu9L/gR24lgUt4oqlQyc7l1EDg//aJF+E/5MkUvutpPGSlaej/KAETaQp0bI2EhzD7PBYb+8AF9CkfZpsy5TA2JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OTiO9GiO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OTiO9GiO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE471F00A3F;
	Thu,  3 Sep 2026 13:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788440726;
	bh=apcK9kNwBCDXO3uzEANw5Gm8tjz2lTMuSHfEdzubcWI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OTiO9GiOmAMuLkez3IY5aCqRZJ0HNXTAZnB2h+nujsK8Jts2Nn8oXXTzwC+7iYX4f
	 gW0+/jOcpU3E0ztQQkbaVbvi5ACVR/vPNt4dVhB2NiByYt+o4x5KKm7BrzVFvSC3cl
	 2kgrP8y/fkMeDrN5JCNthdOlC3EbGQyRiAqTsnSyg7ykkBzVA15HdfdAiSZyCPKZZY
	 2nQ6Brlw+wQRN/ALPRDJKr0+1nfRBXZb6PcP3mrbQjBE2HJF+BT5sVlliMK+QbRiWo
	 rHv+MDZ6z1hJWtO2mOluWuTlexDMRiamSmFvGBVVNeEKsfqxVukB47MOA/pFJ/1/oe
	 H9wE7NIdaB7Mg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 12/31] ext4: pass out extent seq counter when mapping
 da blocks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260903123543.2302999-13-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-13-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 13:05:25 +0000
Message-Id: <20260903130525.EEE471F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> The iomap buffered write path does not hold the folio lock between
> mapping the inode extent and copying data. Therefore, it can race
> with writeback that modifies the extent type (e.g., from unwritten to
> written). This can lead to data corruption on partial writes, as
> iomap_block_needs_zeroing() may return a false positive based on a
> stale extent. The iomap infrastructure uses the sequence counter
> stored in the inode to detect such stale mappings.
>=20
> Commit 07c440e8da8f ("ext4: pass out extent seq counter when mapping
> blocks") added the m_seq field to ext4_map_blocks to pass out extent
> sequence numbers, but it missed two callsites within
> ext4_da_map_blocks(). These callsites are on the delayed allocation
> path, which is needed in the iomap buffered write path. Pass out the
> sequence counter to ensure stale mappings can be detected.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D12

