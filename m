Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882778;
	b=HHnD01YW0Aq6bbDRE/FF9BsH1wlfEQPJnjNrGptth/hiIs3TlMnwJoSARmCPRtU1Qcl4
	 PfpTWhTxhmgmlubP41h7hU5x6ANYKy/daQjOu77B4bEukhvJmOgXJbFDYMRk8U4JnE/E3
	 HqksSJchV398itKDwcTlR+KB3OmxzqhC3MvsoBBa8bReKaxWKPbGnl4BIUPuMEfUC1iZa
	 OyKAtq4VMfs0i8JPHiIzSker6wysIBu7SeZMTuE0eiYtnlGXYc/BlU5ix62yehDohy82Z
	 uFaT18axMrgPRypM/iI4cN4jODzmlM/Qab6W9qQESfNTiKBpjIAbieuxxAQcqg2bzQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882778;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=vb+FgRUE7e3QR7ZEoIbEiNPEOImemefYpR7RNjZhpJw=;
	b=l5Q4PEuicoOfaHbeUVoZCe7gNBKy5vkk9Mv/n9Pyy3u1EyO4k/YRJpLWrpRf5BYaEwhD
	 8TIeeLtl+IYxx2Fq8d+556+zc1PHB2fTk0sDB+22KoccaNLmFUJE2bzQTIpTI/2qQH4Z/
	 UA2ZKuuZIqww/h7lgX98fDOLWr1t+wKpLnD/J/zbC0A8lR0x1rtKvPFuyQAR+Ub4URSac
	 2G6lthCoOwCE1DeupSsU1X6YkwnJ3E81tn23d31J3I43aYrwgyvOMrjo8M8jgUOES80Fb
	 TMPX2pwGWQpEyUN0MWt8OYkiI9Eojc9I8nSr8N+REonpdmA4Y2wutFngDY8dncY4CaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BUyRL1VX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39170606D833
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2026 12:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BUyRL1VX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0B01F0093A;
	Thu,  5 Nov 2026 12:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793882777;
	bh=vb+FgRUE7e3QR7ZEoIbEiNPEOImemefYpR7RNjZhpJw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BUyRL1VXhyv+wKxjMGUGAahMlDhqPMa1iCMX6Lb4zDK/DUYxYBSuFDzy5nny91SdM
	 VBB20EsLELGtxoqKA8d7K9alLxEG9efHl8h8vAd2A/PB5WcEaAMo2QWU9mteLGVAvW
	 ZD29wrVd5+gozw6HuepC8D10Fy9yzi+WFzVktdvcoKH08TL4cr1CBAUVqWwDTDQBeO
	 65xoscy6i5hHdulu0h85VEjdKpbBUB7c3jzg42pkpyTv8rYYI41c6qjp9AuetPZ6i2
	 eo3rarHqg8TXJDv7o4vTaYrByvHvGVxQ/nF+YdxietpQ2dshk/bM6RhkQS98lyZ1YK
	 aZLOIl54TZhoQ==
Message-ID: <sashiko-outbox-199056@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 08/13] minix: don't read the inode block in
 minix_sync_inode_metadata()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105-work-inode-metadata_writeback-v2-8-48628c60c336@kernel.org>
References: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
 <20261105-work-inode-metadata_writeback-v2-8-48628c60c336@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 12:46:17 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-work-inode=
-metadata_writeback-v2-0-48628c60c336@kernel.org?part=3D8

