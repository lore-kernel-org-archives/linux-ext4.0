Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793281615;
	b=v6QmCPKo8T+Wu6nFoUV6ma/rk2aw4EzNFCgcZ3g1uxj5JlX84KdtzLwrSAE3qQLBcYEg
	 R4PTU+avrPHSjm0dow42fSwZia74MPUNSAnOjH8ho0S2Ts/P6lvP3nVE/eMsWQL3t+pCX
	 DQsOK55oonO/yWJ0tDqTZkMkDHOPy0oMKvNJD0DtqcBhCsr5KJ0DWE+Bp2L7n59GIRIXi
	 MwyikYZorgVN0AaF4pnJ2fIABL/i4dxi8ubRW5GsR0Bxd6KFL+5/qpp3BfcmnlnzGgEoq
	 fKopV0K581ZdhL56AJojkMSFWc4zHkpoOulfQgxa26x5pihbmoao6RbseQsY8dNL8QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793281615;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=yuaf8bzZ6xhx+aXFcUxFA+LQjt6tZ9BhDjMPMrTJ9NY=;
	b=C5tKKrkFMC2yvuyoC9Jhlja0WlawZkuYDzqxlQQirls0dzzIOC6aaQ8tr14GFQnxn3KT
	 XQ1W5NwE61J+YpsGrjtNwALkimAiisx7t+BX4cwpIYshf9+DQcN/C8rdrkuo/U4ZmyV2s
	 SRhxrMNmOHaEiAkTLGIhUeB54Pwk65QyeUvKEWM0GkaVMTYtsLSnwqigdAya2b//HxtpA
	 oPB05J68c+GV3xSkXjohO9vjaIFq2QI0WcMXPhZaMMTBEFCbg1ZVp9TvNshO1oTtlzjHC
	 mHzV4Tq0mU70TwrRStU0pkJFTD/+9FdRDuEsbI1WYC/d3Nqb2PbckEbZF3t7BHeTVyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NEEtepWX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2E260A3806
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 13:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NEEtepWX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C14D1F031E2;
	Thu, 29 Oct 2026 13:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793281615;
	bh=yuaf8bzZ6xhx+aXFcUxFA+LQjt6tZ9BhDjMPMrTJ9NY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NEEtepWX0ecQY7Hk7XmjxxCxWknaV5a/RwBiMmpNFfCmhkAFP4UxSARpmK+J8yX90
	 ODFVNmX3h3mVo3ffc23yvP5cOAMhFrgsSLFTAjYS32algF4+551+VQXenwQn7WaQRb
	 L6U1vhw9A4IzxNGotQMPRbVVSC7PgJQ4mPcYL6pEFNOvo7eAtNWinNyERs7dB0uIfC
	 UMdxLgPN47EQnFv17x3eQ0yqPFhQe8BoiGv/UAe88vT59q6E3XkVFEEAlXsXr9Guvx
	 lbS0//FYVkTwc/l6H3T6LYPW4U9HhBHViArBsQXdAIg7BlW+YT9n7jMaJEjh5ZMkig
	 dlBZT8wB8NOwA==
Message-ID: <sashiko-outbox-189418@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 9/9] fs: don't strand I_METADATA_WRITEBACK inodes
 outside the LRU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261029-work-inode-metadata_writeback-v1-9-7d6c678a585d@kernel.org>
References: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
 <20261029-work-inode-metadata_writeback-v1-9-7d6c678a585d@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 13:46:54 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Since commit c474bc56b6d1 ("fs: Provide way for filesystem to wait for
> metadata writeback") ext2, ext4 without a journal, fat, udf and minix
> set I_METADATA_WRITEBACK on an inode whose metadata was copied into a
> buffer that might not have reached the disk yet. Only data integrity
> writeback, i.e. fsync() and friends, clears it again. The flusher and
> sync(2) leave it alone. So a clean, unused inode keeps the bit around.
>=20
> inode_lru_isolate() treats every state bit other than I_REFERENCED as a
> reason not to reclaim the inode right now. It takes the inode off the
> LRU and relies on iput(), writeback completion or the removal of the
> last page from the page cache to put it back once the reason is gone.
>=20
> But I_METADATA_WRITEBACK doesn't go away on its own. Using the inode
> again puts it back on the LRU with the bit still set and the next scan
> takes it off again. So neither memory pressure nor drop_caches can free
> [ ... ]
>=20
> Fixes: c474bc56b6d1 ("fs: Provide way for filesystem to wait for metadata=
 writeback")
> Cc: stable@vger.kernel.org # v7.3; see patch description
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-inode=
-metadata_writeback-v1-0-7d6c678a585d@kernel.org?part=3D9

