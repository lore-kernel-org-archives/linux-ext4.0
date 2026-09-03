Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7434AFE05
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 13:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788442941; cv=none; b=cvH5MC04ds7eOEXeBKItmv4pb16vXk9JI6Pg+5JZTs0MQ0NaEYiE7+/6x/pP91UZu17eEEe/0CIriDWKGXZqibC5KVCwzf+ISxWE3Z/6QvbdgIFE50zOra4sEyMetEn8r+K6lPDJAzFZPb530MAPCfH+GxugMvwX/PnHEeoKcNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788442941; c=relaxed/simple;
	bh=97ndJ0w6gN5tIF0ztpicdiF3oZAiSyNRWeWhZt/JEmw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hJ2fEA0a2M1sUNdp6wDmK7UmdihaGXlZG4/Z4/8cDOStkFp0zq/4kbJ4oVDBiE1IxoPXbTxcqQcpprlHW5HfJUA3brMC5sCD/yXhJpYc4EOiS6yhIREQPbwmeqpK1qB5jjVmWfkskSoY0xqCMwXuyq+6iTMF72mvRfru6BRr16Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gda5d5vx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gda5d5vx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBEDA1F00A3E;
	Thu,  3 Sep 2026 13:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788442929;
	bh=97ndJ0w6gN5tIF0ztpicdiF3oZAiSyNRWeWhZt/JEmw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Gda5d5vxQavLgz4oFhTrLsBZX5EngaOXzgNI+kozUr+ynqP2ZX9UV8QGmG41FBlL4
	 DIhb8KQcNjF6LF1Lf/UHWNe3YRaOx/mlBQs2Vh249i2YiyhYDMIl5YmqDbD2NSEfYM
	 29EbY+xr0dCZL57fCWRoIgBT8HDX7Gt6keM8zmpugQfbNk+BpiAC1d/sAKSir51w2f
	 czXDon8qf8rtEnEGJQR1+U6QkAAH9MIa7a7OcDQvytRWVgMfrG/hAfcURfqwDzITv4
	 KqOouszC8cl40SWD8y8HTabamXSkckTYHB4N+reRNS/BleG0o22NV+HiVcq9c/W4D3
	 YQR5zE43SB8nA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 25/31] ext4: submit and wait for disksize-grow I/O in
 fallocate paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260903123543.2302999-26-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-26-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 13:42:08 +0000
Message-Id: <20260903134208.DBEDA1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Collapse range and insert range update i_disksize directly under
> i_data_sem. If the operation runs while the zeroed EOF block is still
> awaiting writeback, i_disksize could advance past the zeroed boundary
> before the zeroed data is persisted, exposing stale data on crash.
>=20
> Deferring i_disksize updates like fallocate and zero_range is not an
> option here because the shift would move written extents beyond the
> current i_disksize. So flush and wait for the pending zeroed EOF block
> before these operations advance i_disksize. Since these operations
> already perform writeback, the extra flush does not add significant
> overhead.
>=20
> In addition, for ext4_update_disksize_before_punch(), if the punch
> discards the pending block, the zeroed data will never be written back
> before advancing i_disksize, so it is also necessary to sync the
> pending EOF range there.
>=20
> Finally, for the SYNC variants of zero_range and fallocate, this also
> guarantees the i_disksize update is persisted on the synchronous
> return.
>=20
> Note that EXT4_STATE_DISKSIZE_GROW_PENDING is not set for now, and it
> will be set after everthing is done.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D25

