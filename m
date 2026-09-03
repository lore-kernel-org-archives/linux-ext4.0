Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DC64AF9DB
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 13:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788442286; cv=none; b=bnw7KaNPoUHwbJ6qHeS2JH/7ZtAApt316pHW73FW24l/qkmCtlaD8seo1k+YC5bGdxfHh9QrHPMQFSIPV/FMwlIcIofVSgScIQAJL5hwiwFtT2cYhCoJ7cLzsgr93khtk1dpCMfkFa4SbkZvkyjhKctxUF2jT9W31iyXfqpi6jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788442286; c=relaxed/simple;
	bh=OiWzTsmwfmiMR3jpTltjTW/WahU7cZT7n3z+CVT8aQ0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ou5g66Jm3wnnc/la/G2zu5glGx3ENOcBhQke0FNHUHgyTCLHgAMqcBUnAxzTeOtfYFaVzjdQ0mNTOjJ6R/1tRdyXq41d+amTfOxgjhfBLfK5g1xq+MOcFcrizfUTPNpbTS5qRLfKXfDG5YsFSEbmmkRaUKlQTRkQyYDn/nZ6tH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WTZI1U3Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WTZI1U3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906521F000E9;
	Thu,  3 Sep 2026 13:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788442275;
	bh=OiWzTsmwfmiMR3jpTltjTW/WahU7cZT7n3z+CVT8aQ0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WTZI1U3QFl3RhgooaIyuVVy6lX9booCkUAbuVIVhU2BeGd9sIGfWudeiZwN2Df/Yp
	 mdEAYk15YLw3PiesOKd0RoLX4PFqc1sUD4dm9puwVFe+BYL3dr8e5JWKCXT9jmL8fu
	 v5oJVmgDMc6bNGjsBxj4ot66rgd6khmV/pZPFO2IQbXY49JnXeKCc3vagXzU9i+xEb
	 UCNs/IW/UFDZrTGJtaQ3JqCFxBSd3T4UU9YhDTQJBc9BVCRwgk2txv/4ZUbRvoRp9K
	 ZfcJT2/22e7ueS3xI7NbjM9YPqCt93fxaPIdiipHj/KB/hI4o3gXkLmlB/gvmBxsYP
	 VLycXHtLPiV/A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 23/31] ext4: advance i_disksize to i_size upon
 disksize-grow I/O completion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260903123543.2302999-24-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-24-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 13:31:15 +0000
Message-Id: <20260903133115.906521F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> When the disksize-grow-pending zeroed EOF I/O completes, i_disksize has
> to be advanced. Advancing it only to the end of that specific I/O would
> discard any later i_disksize updates from concurrent fallocate or
> similar operations, causing filesystem inconsistency.
>=20
> Scanning dirty or writeback folios beyond the current position to
> compute a safe advance target is expensive and racy with concurrent
> fallocate, so instead advance i_disksize directly to i_size. This may
> expose zeroed data (not stale data) after crash recovery when dirty data
> in the range is not yet on disk, but only for unaligned append writes,
> which is deemed acceptable.
>=20
> To support this, teach ext4_iomap_wb_update_disksize() to take an
> is_disksize_grow flag and advance i_disksize to i_size when set, and
> have ext4_iomap_finish_ioend() pass the flag based on the
> EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO tag of the completing ioend.
>=20
> Note that EXT4_STATE_DISKSIZE_GROW_PENDING is not set for now, and it
> will be set after everthing is done.
>=20
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D23

