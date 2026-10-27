Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135517;
	b=KKL0Gss3rB5sEGZl1arpl/A5EYk4N1b190QfObpJ3PJK91pNCMs+BHU2WDEn4oqPbPHr
	 6t2dAATnGWLNulhdrirNfYjnXOr1tPzqB3L6DTakNR6/18QhyuNGpp+EZ6rhc9j6jqpjT
	 60KH8zdRIo5fFb/xBvys0gFsP3zAwBcQGtx9UVcyVk7y0CtnCDsOqXgIQxF+/qjm6z/m2
	 XRsbZxNncCkMPMhl1PL+PqsZkz2hF6kcIIzTvS4OLfr0b1sdkHiyrCoNIBJPkiiqwFAri
	 o9FDgJXAwzdC+nnQzyZMYlqaGaBCubxAFJkQKeuKNl0V3cqu10j+EY0IMCaDSLyrdpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135517;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3fXmMsSTyiBxvhVxOgibbEDEv/JyRijfBzVDlh1FY5A=;
	b=u9H4tJ6gB9V9/Mk6y2Wb15yz8wxr7zYuXNoI2FczajhFbrqOh1HXLHA+S90umeewfNfi
	 rtRf2pv1w1ddp7eOx+lWx0QPLMeF6J+NB9MqDqWQ2dK4bZ9nwEcHI5uGh0VMl8qzPV8cN
	 pPvJfFd6y2nMpRySdM/Uzjx9C9D+owkenbsYfoYpOQCJCS3NRH5iQGvGVCJOs01CbA3yI
	 FYlTMp3xFUo5ZyBea0r1RjWgKkNkrIJxloXo+N4ZIcKs2TxJ6+4w3IQOQQSMwg4jmUZpo
	 L0oWklLoLI2XfFrAkd6X79QjrLEFV8UUVtLZqz3JOU8Szxl3454m32w8VvUlqE/Ftcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gx5MZ42M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1EB606A31D
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 21:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gx5MZ42M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5661F01828;
	Tue, 27 Oct 2026 21:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793135516;
	bh=3fXmMsSTyiBxvhVxOgibbEDEv/JyRijfBzVDlh1FY5A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gx5MZ42MAEu9EPY7/A0yjNliOq2fITUCTEejiotIsetQuytOjBpQepzz1Ws4YpKQz
	 xBQyr0M/cunEV0T4aAWDYIA13T2qStr450f4m6NPIGnbgWg2JjT7vg9yew3GNX67Mq
	 rrb6ti8ymPR0xzY3zglihDPYCZB6FojuL1JTkYj4TOyKnyGaLx7ji/HjvLSXDIxjB/
	 AHzBOW72FIqEoWb86VSYP+lVS8pwGZmLkDSwcbHNuP1jKbLMWmlXxKi5JPSRXbvflc
	 A5253nAcITQLjCHmG1LxpvmEsrjENp43SBVz+ffaVs8m/Wpv7OWr47RuZmoplm7qB8
	 ldE1i1GOYF5Cg==
Message-ID: <sashiko-outbox-187113@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 01/10] fs: add SB_I_OVL_USE_SYNC_FS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-1-802e512379a6@toxicpanda.com>
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
 <20261027-b4-ovl-containerized-sync-v1-1-802e512379a6@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 21:11:56 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> sync_filesystem() writes every dirty inode of a filesystem and then calls
> ->sync_fs().  The data needs that.  Whether the metadata does depends on
> the filesystem.  ext2 copies an inode to its buffer in ->write_inode() and
> nowhere else.  A filesystem which logs its metadata has recorded the
> change when it was made, and ->sync_fs() commits the log.
>=20
> overlayfs wants to sync what was changed through one overlay instead of
> the whole upper filesystem.  It knows which inodes it wrote data to.  It
> has a much harder time with all the inodes which the upper filesystem
> dirtied on its behalf, many of which it has no inode of its own for:
> whiteouts, index entries, work directories, the parents of all of them.
> With a filesystem which logs its metadata it doesn't have to know.
>=20
> Add SB_I_OVL_USE_SYNC_FS, by which a filesystem says that ->sync_fs() with
> wait set makes every change of metadata durable which was made before the
> call, whether ->write_inode() was called for the inode or not.  Timestamps
> which lazytime holds back are not covered by that.  As an upper filesystem
> of overlayfs it then gets ->sync_fs() instead of sync_filesystem().
>=20
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027-b4-ovl-con=
tainerized-sync-v1-0-802e512379a6@toxicpanda.com?part=3D1

