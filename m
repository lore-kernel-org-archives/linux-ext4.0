Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794244605;
	b=ZtR1lwMvUtaDQagNnAZeCu54UV2bnpBmvAr/3kV7t9TO3RlFA82UaUNuYM1onr2Kxxx1
	 AHYJ6mGXuvfvDj+vq5lZW2ZqLcqFFaFSbNxTHwRDK5o2FwVitObO2kPHXBMc4/DCAMJQM
	 46zh0mZIKjusvf071DfxxyakyYeQK6EisnN6X/WmEJVNCrIOPe+AepYEdLb9JgmXlQyeH
	 Lr54kQqFvR8RZfx4pCSEjnKon9I5JBqnsAPnyCy8oiDoefFIqEoN1ljSTi8DLvtKo3Y62
	 3seuxVAlcJvQDKDEASRyB5UqOo/FEYj26/b3a0IE/l8Y2yl6Uu5mjXnSYOW7h/fe8Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794244605;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bWIXINFIpsyLdtx2qcJWa1n9eifVK96G+A9lQk+NNY8=;
	b=ajXL/F1muMXGkaVEOtUhdeq8BYqnITJ7LNcQPBvpPg1Wny/tepGsGSnJwuGDyz4QqEyp
	 cejg8DbgAvSjax0RR7vV9toZEbBBVHPoDepeZUhfyziUylHZLq2DJkRicv50dcDDfHiUW
	 DueE4+SBbh42fglEua+zSVU51CA+sKEyUvK/CGhIeFHtnz0ftVYDFteSNBBbVWd7TLkGS
	 V6VCfO8bn+GZkHpYUwpOQbiGvHYiIs0Lp2qlGEOWDcoHt+vqyfZC2b9wmUO8IMixhfuQG
	 irWQF0yvtR5e5RM0oUFbMF7a0RHfTnhpwJf+iCW+9MwqaSH4yART4qambJq1C4uJ8UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iZeFfu0g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976F7606A321
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2026 17:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iZeFfu0g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C15E1F0089F;
	Mon,  9 Nov 2026 17:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794244605;
	bh=bWIXINFIpsyLdtx2qcJWa1n9eifVK96G+A9lQk+NNY8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iZeFfu0gkoTIwcrShJ+haP7B372J8DOKuMVK/cbmixJ+gXDtWfWqqbLawHer+sRKb
	 be1n5LmT7kFyQeFT1KIrfF6SwMNvhjNm+tgxTgQr8FZveLyAQPJc1zb5OuV7Lc2gZS
	 JhwtuJ407xGqyqfhk1JULvsTdWSQJdxzcBVmTmEBWf+UH2VNIwn62Mq41rcOKXkTm5
	 xn3koW+1JamqtDZB/ZTORxgBeCI0dqLyqe/zC343D0aSmKiNl+t8Kw7it4kdk1tbqm
	 MXmKYIsUPmgJAx0oO6Xe/O3/a3/+wu0f4XA4G81XSpM9OGeWL1KoHXghjA2BDffvoB
	 Pzb4GjeKB3ldA==
Message-ID: <sashiko-outbox-205286@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 06/14] minix: don't read the inode block in
 minix_sync_inode_metadata()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261109-work-inode-metadata_writeback-v3-6-91ac6c024018@kernel.org>
References: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
 <20261109-work-inode-metadata_writeback-v3-6-91ac6c024018@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 17:16:44 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> minix_sync_inode_metadata() looks the inode block up with
> minix_V1_raw_inode() or minix_V2_raw_inode() which read it from disk if
> it isn't cached. But a block that isn't cached is neither dirty nor
> under writeback, so there's nothing to write or to wait for.
>=20
> That read is also something we can't afford once inode eviction calls
> ->sync_inode_metadata() from reclaim. So look the block up with
> sb_find_get_block_nonatomic() instead.
>=20
> Cc: stable@vger.kernel.org # v7.3
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-work-inode=
-metadata_writeback-v3-0-91ac6c024018@kernel.org?part=3D6

