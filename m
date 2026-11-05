Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882886;
	b=G8qCy7VerGnFDSklK0Px0wcRLsDwb4KRgWEvODRcNW1rIuT9vsDwyzARLDiKWRc3eFsq
	 zso4iGm1btBFjIwJWdy1aool+vPe6dgBAWtJe9g6gCr7csi/L/PdMjAJ/KKFhU/Pc3+1e
	 jMbJ7Kk4lMF8GSuAVBWuG/9cMvM9UmuWojNyKKuC2goRb5I3fUnCd52hYithyKcFtKI74
	 yTG8HFlr5KLf82OikcXXft9wzm3b2OZpWZXi0z1p+alW9vPWxEaE87t9wM8E1UmfehhJ6
	 5VSRtl0x+tktH3idg3t7xM5aaL+5cvYp2qImX/jLDxhyrimoox/IxopiwB0uitqsxtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882886;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xZOScuj+ulOi83enruT+hiPQZecLRKU1WZV10fEK20I=;
	b=cyAoRI+UwTxMu8STTetrxYURGfOXGPVDFbTqoTxaZcBeeMom0EJcBmrdH6ni6qu+OdX6
	 szBe+rqs1+Poqv3ro4iZGY9YASsx5K5UHhILPAs9af9GS6L1xsEfUmAK4tSZSDUFTJM0L
	 IQTKq4OqBN6N+9u5Nz5ZPlPkU5kgMa/87YQYLYgyxMly4Rm/8/YwOvJKKqGjEJrSuL6Hu
	 KrrYbTEL4SdoobYZf4R4Kn+QA65a/foBolvoYKm582QuNo43T8ZM95GBX+3G+/mUH9eS2
	 mKKPUNQnjmtznkSoJ/WWzaVI2nCbFV7o3FMGIEz5b9nvdOkjS4euPGGK1wb+0iRimhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z3Lw4Hy0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD65606A31B
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2026 12:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z3Lw4Hy0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD081F000C1;
	Thu,  5 Nov 2026 12:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793882886;
	bh=xZOScuj+ulOi83enruT+hiPQZecLRKU1WZV10fEK20I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z3Lw4Hy0uQCiDkXcH6nklgQKa72mKPbrO7uLzTyj+hZfdXf48v8/j7gMWHnBbphgz
	 qSLwIqkVeXlbUjkK9IEMxkA4anLiD3g10uDtWeZlHonrqlAWu41uaTAbjEUlvMiZPI
	 Cc7KX02fNj4qbFbYxebNsZRTHJgbcfBse/W9Wp45IRnE1l5WPrqwSJF4dq5+ox5oEj
	 np0aW4caHLtwu2D7HsnIPlXV1JCrhe3SilLT0/NTx/i4OgN4caAotklgdAfdYBzPT/
	 HANExZ43VzEl66qSlVN2OepXpKkbocO1lSGv8vb2pv4H0AlNhSLR5ki0VTuVI3nC+n
	 dQN0s+Eq1561Q==
Message-ID: <sashiko-outbox-199061@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 05/13] ext4: don't read the inode block in
 ext4_sync_inode_metadata()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105-work-inode-metadata_writeback-v2-5-48628c60c336@kernel.org>
References: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
 <20261105-work-inode-metadata_writeback-v2-5-48628c60c336@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 12:48:05 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Without a journal ext4_sync_inode_metadata() looks the inode table
> block up with __ext4_get_inode_loc_noinmem() which reads it from disk,
> with readahead of the inode table on top, if it isn't cached. But a
> block that isn't cached is neither dirty nor under writeback, so there's
> nothing to write or to wait for.
>=20
> That read is also something we can't afford once inode eviction calls
> ->sync_inode_metadata() from reclaim. So look the block up with
> ext4_get_inode_loc_noio() instead and treat -EAGAIN as nothing to do.
>=20
> Note that ext4_get_inode_loc_noio() also returns -EAGAIN for a block
> that isn't uptodate. Such a block is being read or failed to be read
> and can't be dirty either. A block whose write failed still counts as
> uptodate for ext4_buffer_uptodate() so the write error still gets
> reported.
>=20
> Suggested-by: Jan Kara <jack@suse.cz>
> Cc: stable@vger.kernel.org # v7.3
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-work-inode=
-metadata_writeback-v2-0-48628c60c336@kernel.org?part=3D5

