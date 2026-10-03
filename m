Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB243AD528
	for <linux-ext4@vger.kernel.org>; Sat,  3 Oct 2026 09:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791020449; cv=none; b=l2qiYRZEdhjCJUmNnGB1R/FQPzsTrk2yzltEHNs5Pp5/q0nxvvdDlyPiCczYsWyQwUJrut+ZayeyAiaQ+Wj5LGFNzs38//RWlVIQ3nYiXhDXsZ8TpKyMQrmL1zsvFE9HNMZDUf7cncy2gXvGIRdzM3xK8ddo/e5fwgwR/63uxqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791020449; c=relaxed/simple;
	bh=x6tz+Q32LkhTNMVhH8y/usCey/6hFVvvMCj5E/lneH0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Li5M/WdMZUPKv5Xt3RuwkUc+nzEo5jzbn7NddvLxKunuK8hb8YQI6C2pBmujp9mvkptrGqJYsB3FVhSbSTHL1bHmks1aCv2THCFw0tfNydorTuknIqvxKoWyA63Zozwfe7+l4OOgX1bXUAg3IkwZMBAvkiLj0Nhap/W6VzefYIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WbEEWuW9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WbEEWuW9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610731F0089B;
	Sat,  3 Oct 2026 09:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791020447;
	bh=ENh04CcltXjbgCVyITFDO8evvN/kQ/b6YtDOfgf+gc8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WbEEWuW9b9LzBeq7RMPUuGnnYxacQitF1Z1bvsFTzgD4qO5VRfeASpWqMD0HBH6iX
	 htZ5dbEMXSuPXvIIkdVo9LBEBiqlT8x/vguzg9shE1wyOrVbKbCiwlbG+qktcQVB1/
	 PF/c0u5Ryd0IeXofgttOUsJHTKUBuUIIeaZgZY6Dpnd/qSfTk5HF1c3dY5bqIE007/
	 E6GP3ZhFuqs7eUoTZTq8YevGx7XM+ZioLHauNxI2OABdZFbFJeNXeBQ6L0HoESaGko
	 63vbRN8tV4oGmlZiPpVehzfKFIfgc7Q/xv7EuziezaSzTpnwz36+EYmH80fRAt1LVK
	 Vq3/rq1TXX64g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/3] ext2: drain in-flight DIO before buffered write
 fallback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiale Yao" <yaojiale02@163.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261003093035.532916-2-yaojiale02@163.com>
References: <20261003093035.532916-1-yaojiale02@163.com>
 <20261003093035.532916-2-yaojiale02@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 09:40:46 +0000
Message-Id: <20261003094047.610731F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> An asynchronous direct write can remain in flight after the inode lock is
> released.  If another direct write falls back to buffered I/O while the
> first write is still pending, generic_perform_write() can dirty pages
> before the first write completes its post-I/O page cache invalidation.
> The invalidation then finds dirty pages, reports a page cache invalidation
> failure, and records -EIO in the mapping error sequence.  A later fsync()
> therefore returns -EIO.
>=20
> Commit 15cdefd0c0522f9d5e12d947fa04f4c11649b699 ("ext4: drain
> in-flight DIO before buffered write fallback") fixed the same race in
> ext4.  Ext2 has an equivalent fallback after iomap_dio_rw() returns
> -ENOTBLK or a short write, but does not drain other in-flight DIO before
> dirtying the page cache.
>=20
> Wait for in-flight DIO before calling generic_perform_write() in the
> fallback path.
>=20
> A reproducer using concurrent AIO direct writes and buffered fallback
> triggered the following warning and made a subsequent fsync() return
> -EIO:
>=20
>   Page cache invalidation failure on direct I/O.  Possible data corruption
>   due to collision with buffered I/O!
>=20
> Fixes: fb5de4358e1a ("ext2: Move direct-io to use iomap")
> Link: https://lore.kernel.org/r/20260629113827.4074335-3-libaokun@linux.a=
libaba.com
> Signed-off-by: Jiale Yao <yaojiale02@163.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003093035.5329=
16-1-yaojiale02@163.com?part=3D1

