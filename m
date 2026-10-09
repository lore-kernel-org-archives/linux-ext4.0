Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3003AF677
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 11:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791543855; cv=none; b=X03Au7cpDzzID9najt6MZw9UNv7+0WDQ+KBmJUzCj2ocZW31ohGg3KecOfZKocexuAQm6W55ZjEO8RGEmt9UPKg6ZLHJsd6Yc5u4aYdqNvubWMp6OysXun09zyf4JdxL7sPuArvBo8y+kUjEvnHcBd57NVh35Dc5qsrys59YQG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791543855; c=relaxed/simple;
	bh=Qp2uGmi+OcHS4cEOGT9gcSiDjr2LZVHkQqn2CjGWcSk=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ULuWnmgak9xJYBz7P87RKt9tIdrzg0aAaDeuKIwWoqyUtCF78UPdG1NFPMCSmZOHEEFEuM46I8HkzJIfa0/A34wPnXxhZh46Hnmw0K+KWo92eeXxi1qRYwE+dZxX3x/6RSsJmv3lqGRIZuL3QhPbSRVnAvFgKnpFhgP0Xx6JbkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yg2pyXFW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yg2pyXFW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0E81F000FF;
	Fri,  9 Oct 2026 11:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791543848;
	bh=Qp2uGmi+OcHS4cEOGT9gcSiDjr2LZVHkQqn2CjGWcSk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Yg2pyXFWO0p7dVK47YjgPtDKsgQlE7gMDCGH6E+iuRdukLRYrrRguYrOpW8UjYu0V
	 VWlD967EFFxu+imJk3hVwrx+SBHPxBps12cb6yq7iGpS1NSWGdUqWVoPSr65bZNzcb
	 Th+mEcxFXjoTXtwKteNuhho/kVCRL+G++ITHRSw0aVdwZF3gtF09jOutmXCc71m8NT
	 TowZYkh8bJ42DupxETtqF4CqiN18A7hf0l3kJGix56+8SH9Le8ueVuM6r4+vrw4Fml
	 VMoWwx0LC9ye6qVX2kTfuEgbldehXcNnFlkMW1f3jQqMfDl86+qYxTypSGQMeBYFTx
	 CHfi4OtRbDLTQ==
Message-ID: <sashiko-outbox-165307@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 21/31] ext4: add EXT4_STATE_DISKSIZE_GROW_PENDING
 state bit and helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261009103033.2920530-22-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-22-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 11:04:07 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D21

