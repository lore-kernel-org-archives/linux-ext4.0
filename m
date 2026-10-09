Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5194C150B
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 11:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791544019; cv=none; b=NowRWJHtNYtjhNpnaOCKn/dqUjdtKhTvkoePnaLhzaRV8vnt1wS7d5Hx0os7gD/fsS4imK5VYdBB/2NYqxwPDQFQsv/f2oFs3Efs/eK619s7S9r7I/9ULVe1+XiCvBCG9pxrZO5hXhDRo5xzm/0mFFWfrh0L85+EE6gx+F9wvKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791544019; c=relaxed/simple;
	bh=ZYTLPzIgVeQCgWGe4R75BgyAYBkhfn6Li00ZV+3BOe0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=IrWXY5bEqI1dWk/shANt8wXayveqZpcuQCqNEKxaGQaLTJ+JRlyEOKPbLRyl2zTDxD3jHM4zkdNuDDYHk9/VQQ+aobyEyFicvWDXIbylZ7SJ/aquVABvbpE0/dnGYvnA0Av/vXtsC2nknOBOnPQZA/oqqNo0yqdZLzeKKK97aqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QcX8H4rp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QcX8H4rp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D681F000FF;
	Fri,  9 Oct 2026 11:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791544012;
	bh=OjOPVyIctLdTsLrj7u54uAjf2PW2wnCfyUWvKnFJOP4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QcX8H4rprz4H1BpeRtp1yx9e7BlgHrwp9vnqI7mp//bEhSK9kJ84t8ngKdigjLhyQ
	 sFB3auGJ77/mGYoLii51GRpgDwtX8IFfkUAGmqxt0PTZ09C0J6b+/ciO/JFlAes6ps
	 9x55k9JJp0MORbTBt0ypWly77A5Fn0+ImL+HiFNI/4swhFFdIYBkSPErcnQHzRRnTV
	 9f7RmDfDlf0uvR1hCK46GEzK1917pQ4/K6bdY8MbVBmDkKeQT74Uj5cC2cIR3NbrjO
	 gEuNtJUjwG7BtPs/vcp5XBF5SbXm8mqJBzg1AK6UuOHwZqOFhjJMjfr9E5PX0/C718
	 hrvm/31i7tENg==
Message-ID: <sashiko-outbox-165316@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 18/31] ext4: drain writeback before removing extents
 on the iomap path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261009103033.2920530-19-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-19-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 11:06:50 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Because the iomap infrastructure does not always create an ifs to
> manage sub-folio state when folio size is larger than blocksize,
> invalidating a partial dirty folio during punch hole may fail to
> clear the dirty state of the affected range. As a result, writeback
> of that folio may observe a hole. At writeback submit time,
> ext4_map_blocks() already handles this case and will not allocate
> blocks. However, when punch hole races with writeback, the
> following scenario can cause I/O completion to encounter a hole.
>=20
>   punch hole                        writeback
>   ----------                        ---------
>   ext4_punch_hole()
>     ext4_truncate_page_cache_block_range()
> [ ... ]
> always maintain an ifs when folio size is larger than blocksize, so that
> partial invalidate reliably clears sub-block dirty bits and no draining
> is needed.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D18

