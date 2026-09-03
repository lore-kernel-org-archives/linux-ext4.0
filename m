Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4944AF68B
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 13:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788441795; cv=none; b=FgKJfpzG4DHuSluRHHPRtjit+KbP7o1T2hCxCQHhhkVkNFWnzgIEFYgTnRBRVm0wKjPh1dQSsbiT3Q7QNYlmikLh3MFSh5MQaIm3xgLb2Za+BmnxzjD9+AdAYmynpVLyLSBcRyd1X93ALbhdQT7ik/p763rOoKkdVFp0HEAohQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788441795; c=relaxed/simple;
	bh=YDjEgtOjDbjvObY2XE2AyEAAMJeezzHSIdbnCSYoH4M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TTnbmV9Nr/7YJlhzF6XL84cv9rBC/vgYBJBm45FHgIUtEALhS4HSzJpH+s1LPmGcBwNbbLZaQr+ad7jtyJjQ9GHl3r6JYGSFiAssCZJ2w/UIA7MSFQLa5N9aKMULJz6y2F251xEg5NAfCg/yo1CkZZeVnPhnBKfUUknzF5XwCOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SRrpbH25; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SRrpbH25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1EF1F00A3A;
	Thu,  3 Sep 2026 13:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788441785;
	bh=ziWrDZASsWyEcVO16iCzHkTIxmt+VMzAMSBuF8uhCYI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SRrpbH25MxGhQOL3FZelPdiHRjjLRggUx+hbMIK7jFo16EFC8JcE5mXykvSSVx+Yj
	 wAWE2CwqZw4K/dhs/Tm8dmqOY+X/1qCOQqrKTvSInAW/2bRy9wESlpMhbY/cOIDpOY
	 iUJc4h0FkEHWsrUcPLyG3oYhB3MZFeqhmsjuAAvtkK71QqqOeSHyTCvnGHzSDZImIH
	 JIgtRpjF8LWOxVcHnk3W+2Y5CC+3SP5ROZetocd0qKiamo8aFRKKD5G7z4AXb0fELr
	 i+hkKEgBGBpPBug+uQFOyVZbjVU89x3OF92W2dSlTVoY0qU+XBCbgddvo0xEo8oCCo
	 NtGnz2k8B9C1w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 14/31] ext4: implement buffered write path using
 iomap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260903123543.2302999-15-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-15-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 13:23:04 +0000
Message-Id: <20260903132304.CE1EF1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Spurious ENOSPC failures occur on large writes because space exhau=
stion protection is evaluated only once per write syscall.
--

commit 0e8cfe3183ec36e2c7cb68a2f835e58a2e54d43e
Author: Zhang Yi <yi.zhang@huawei.com>
ext4: implement buffered write path using iomap

This commit introduces new iomap_ops instances for ext4 buffered writes to=
=20
transition to the iomap infrastructure. It also adds ext4_iomap_valid to=20
verify extent validity and handles cleanup of stale delayed allocation=20
ranges on short writes.

> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 374b4bc25bd5d..50d3c92709c8b 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
[ ... ]
> @@ -330,6 +330,21 @@ static ssize_t ext4_write_checks(struct kiocb *iocb,=
 struct iov_iter *from)
>  	return count;
>  }
> =20
> +static ssize_t ext4_iomap_buffered_write(struct kiocb *iocb,
> +					 struct iov_iter *from)
> +{
> +	struct inode *inode =3D file_inode(iocb->ki_filp);
> +	const struct iomap_ops *iomap_ops;
> +
> +	if (test_opt(inode->i_sb, DELALLOC) && !ext4_nonda_switch(inode->i_sb))
> +		iomap_ops =3D &ext4_iomap_buffered_da_write_ops;
> +	else
> +		iomap_ops =3D &ext4_iomap_buffered_write_ops;
> +

[Severity: High]
Will this cause spurious -ENOSPC failures on multi-gigabyte writes?

In ext4_iomap_buffered_write(), the ext4_nonda_switch() check is evaluated
only once before passing iomap_ops into the iomap_file_buffered_write() loo=
p.

If space runs low during a large write, the operation stays locked in delay=
ed
allocation mode instead of dynamically switching to non-delayed allocation.

This bypasses the continuous per-page free space threshold checks that were
previously done on-the-fly, which could lead to over-reserving space and
silent data loss during background writeback.

> +	return iomap_file_buffered_write(iocb, from, iomap_ops,
> +					 &ext4_iomap_write_ops, NULL);
> +}
> +
>  static ssize_t ext4_buffered_write_iter(struct kiocb *iocb,
>  					struct iov_iter *from)
>  {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D14
