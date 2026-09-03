Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3D6466B4C
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 13:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788441600; cv=none; b=K8MQXs5hct44QcLS8wbxuOYfvVjx8pLJSCNMvvZWPKaVoUG2qn4e9AWIrIhNAbtosqlB2TDcG7bNRlQrwlADBatF2D2Cy6Jd75R+lkY51YYdka6CYQVfVLxPHtu4ZKvrFC5YSNnz6JUutvdn7/cpj/qXBWlzPCWnVqq+bG1mPzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788441600; c=relaxed/simple;
	bh=J7Gm5GTwR2kKVqWxtEFUH2TPKhvMH0u2aTwTz1TKIuI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nbprVHwyyobGBscu2ItKSEMgn63UhC4smKo7iJ1VgSdQeyGs60vmQIvBVUBrYkvHIZRO2LowQ/T3VusbcjHY3Q0ZSxeauJoaiGPKfTMA0h9GSIhKQWOn/5LhTP+YeYqQpFrbEkOlzqvvU8SHdfDfxwike2h7PHXz2iZfAkYCcXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hf8CKg53; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hf8CKg53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413301F000E9;
	Thu,  3 Sep 2026 13:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788441587;
	bh=J7Gm5GTwR2kKVqWxtEFUH2TPKhvMH0u2aTwTz1TKIuI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hf8CKg53ze8Qnp2inqanQktoqRY8S1UrNya/HxvlXfkDqZ+YCjQtq/Sl3oVbzbBMo
	 I5CHdLO3QzAsiK419k4dc6oTpMqsqXvQOPpP21GJXXFTUj8gX89NDy0IRhlVQ5v96A
	 S3PfDBNO/Sr8CCVvin4/+9mLUsOSLRDXOyPKxaBTnWF225uPcADpCv2TjEP909LeIY
	 hd8HSTvmoG8XS96wU55WNC5cV9JPjpg4TJ2LG3+uG5fM3n3VGhxE6zu9cg9DK4WwlR
	 ZMu7hlZxAKDNPtGLEDi9rEihkzsy7GLQD4/2jvr8GdEo0w62BawRYYb1K/V8/VLOlO
	 Lm0JOwFCSSFLA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 21/31] ext4: add EXT4_STATE_DISKSIZE_GROW_PENDING
 state bit and helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260903123543.2302999-22-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-22-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 13:19:46 +0000
Message-Id: <20260903131947.413301F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Inodes using the iomap buffered I/O path do not use data=3Dordered
> mode, so the zeroed EOF block that straddles i_disksize needs explicit
> tracking to ensure it is written back before i_disksize is advanced.
>=20
> Add the EXT4_STATE_DISKSIZE_GROW_PENDING inode state bit and three
> helpers: ext4_iomap_clear_disksize_pending() to atomically clear the
> bit and wake waiters, ext4_iomap_wait_disksize_pending() to block until
> the bit is cleared, and ext4_iomap_get_disksize_pending_range() to
> compute the pending range from i_disksize.
>=20
> These will be used by subsequent patches to serialize i_disksize
> updates with the writeback of the zeroed EOF block.
>=20
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D21

