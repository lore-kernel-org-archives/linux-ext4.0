Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793883318;
	b=tcGENZqnFYG50f/xe5fiOOMEhjEaPeivCQGNNICl2/srI4WjYUanymD/kY/fLRcqq1Ue
	 8j6JZhkVdmocILdiCXPDY6oX4EnDimiMlrk5+zh1v365yjkbemA6wPGm/zms+OAzRPQEL
	 Isl2oTohNRXjuxPPUSsuf2SgjmwIgjcT0HLfsToXJVZY4wxtyMjLfUHe6PPkrq5ZuLwA7
	 Zrf+Aj20P3b3jTddUg/79qWZRkUJEYiZnLK7lUEmsKwwtZTUpRRQJM1exPXFrBSGAdao7
	 5P9BJnjr21AHvXfEBIkyrTHx93CAwSyCkDNRoU2bU/QTHhL6X7fvkfO5QQ5qbpRNCiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793883318;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=D/49zGawTsf2wZb/TrhbZa6axM7RPGI4mfviBSLQb3o=;
	b=5AFsQOMstqDO/qtprxpLVyj1t81/P2IT/IHhxb5OUBJNuCCH2s/53s54+qDHRN910Tkm
	 YC8Rhf8eygZ6y4btz5uIMyqQDj74lC9BGYeUAiJIlgDutZGG5HElgRe1Y4wQ6Nq+5qHYJ
	 991kVx7hv29pU/Bjl1gOzfkmkLHSiCcwyhtSPh7e8n/SCW3ebFP7AKLTD4kjoP48rghmE
	 PFsunYWrgCs5HScfR058Ce8QaW3jXSZbEXEl5F17wKQUgP6SMcrbKPGJioQ38K8S+kbPk
	 +k0zqhv2ZNcDCCe8OR7nbAuXoY/JT4JxgWuUanVJb/q1kPJQYI2OEurBtXkU9MmSifg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KaSGwsiX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDC5606A31B
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2026 12:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KaSGwsiX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82051F00919;
	Thu,  5 Nov 2026 12:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793883318;
	bh=D/49zGawTsf2wZb/TrhbZa6axM7RPGI4mfviBSLQb3o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KaSGwsiXYDMJQNcXf6Op/jfwJ6/vrGvkmJBYmHhbTCX8+Mu7r2XAC0XT0wz1QK+mH
	 jqSDlWTh5jasaT1I4tQnhDIQC91mg20p7ho5xeyeBPculM4wJ1SgsZ3Y+XVJpvdfuI
	 uKpG6bro2/dRs+3XW5UQd9uUIy6dQnxv9DmT6r5SFz3KJqzskl9Z6OP2B2bhbDYcmJ
	 /8Nz2HXDI7Szha7M8ATaaTCWg96OWyMZDXyetpaar6U9z+a51H9d7S+dE2mq4hrkE/
	 2UJYMfhLFGLD/lWneHN4ZkQ/P8YYsAMKMEQ9zYXN023dIYSnH3qMosEJR0SsuCY4eS
	 WPHzfq0V3WF5A==
Message-ID: <sashiko-outbox-199080@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 13/13] fs: don't strand I_METADATA_WRITEBACK
 inodes outside the LRU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105-work-inode-metadata_writeback-v2-13-48628c60c336@kernel.org>
References: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
 <20261105-work-inode-metadata_writeback-v2-13-48628c60c336@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 12:55:17 +0000
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
> sync(2) leave it alone.
>=20
> inode_lru_isolate() treats every state bit other than I_REFERENCED as a
> reason not to reclaim the inode right now. It takes the inode off the
> LRU and relies on iput(), writeback completion or the removal of the
> last page from the page cache to put it back once the reason is gone.
>=20
> But I_METADATA_WRITEBACK doesn't go away on its own. iput() puts the
> inode back on the LRU with the bit still set and the next scan takes it
> off again. So neither memory pressure nor drop_caches can free these
> [ ... ]
>=20
> Fixes: c474bc56b6d1 ("fs: Provide way for filesystem to wait for metadata=
 writeback")
> Cc: stable@vger.kernel.org # v7.3; see patch description
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-work-inode=
-metadata_writeback-v2-0-48628c60c336@kernel.org?part=3D13

