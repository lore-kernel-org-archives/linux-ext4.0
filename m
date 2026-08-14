Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EFA43B6CE
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786702184; cv=none; b=taCQ2Prs4MAAlaZ3Ojr/etavcq6+mypmvAEcHmeeu1X+nRkxm1S5AseVqzUQDSBzxp2Q1SrI/m5/LLlaxKTPIEDO7hkrpJNgEtXoneZ8vLttGjJT7QkIJ/0BpQamq5G/mTNMJbcPhLbx/vNsxjpJJQtkmmLZ8C3Bw2+2MAaen3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786702184; c=relaxed/simple;
	bh=athEHOpnAc+yrTq/B/KhOEghkx8jGZMVoBvENNBxCKQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=luARRJQS+Pjcou6zfKkruXjgiioPsKGnGd8sNEd8ou9L30KG7TJhzPX1Dbda4BvXKX8Kun8PzTtdsDpfaspZSqroGB0hbK8mFt13UEsXkiu2PocvZXfHQVAi+HiEE+EEaEL0Y/nOLwe+T+12qZ3WZN0E5y+DwH6JdIXPFqhTwKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yl5AdiBa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yl5AdiBa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9951F000E9;
	Fri, 14 Aug 2026 10:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786702173;
	bh=athEHOpnAc+yrTq/B/KhOEghkx8jGZMVoBvENNBxCKQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Yl5AdiBad5oRFiAyPELRuLO9OnRE+qDRHDTqp7GfEbqBju3zaA/6URI5iEmc8iG46
	 WwmKOceI2Lm5FWwHx87NmX59Gyb6cD7EtKZvCvOchmjNNW/tiQ7DlGSMZ/6SaEHEBD
	 tHWrpT7VL+GoDovkmq1ovMCnZ5/30GPTjqPeZekKikBAIYaAbtDWnXk9kF801noDHa
	 EyRlyzh22u8WU/9FHA0xDg5NS2CmAHtJBuekFak5DL6jgu1Z7FhOcxfPH+UOgr18a9
	 CT7xV+LEodIZ9r4Ggi11XI6zyUWF37MnY44UisysLqvjG85L5pyV3mQeW57CDNQ2ja
	 L78gFz1O2ZLrA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 22/32] ext4: add
 EXT4_STATE_DISKSIZE_GROW_PENDING state bit and helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260814093331.1703882-23-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-23-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:09:33 +0000
Message-Id: <20260814100933.9D9951F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D22

