Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D2D4CE688
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 11:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791544601; cv=none; b=DOKuAopLdSNUPlL2AUivA1A7XYur1f9lGNS5Y9DROS01ISxYoyjGQeQZvE2bqR9uA3CFhU8Xk321A+wLlDKAI9YA9vfcMJiz+L662MMkBnLraSOduKKMq9w5tsx55D1eRPdvArYS5VmtJFBH70NUrahRL3A/e4jzxf8kqaGV47U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791544601; c=relaxed/simple;
	bh=UvYSawgV2CDRL3S8ZbDXBZVNhZVYblmnkqRECXvxViw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Add6w5/5K1L6OtYOCIcj3MQE1xn1JI8wi8uIOjccw+hwlIhfCctQtoZXigMr2onhYeElSpX5vBV6z/LayEoIRKEqp330IUcut9QgrvHEu1bhYzjXRzJCYZRXk6LhDDLB+p3mRrEUkjPISjgjg8KtHNTQOuk2QY4aXtuls8C0tXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZESq4tak; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZESq4tak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E96C1F00893;
	Fri,  9 Oct 2026 11:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791544592;
	bh=KnVzmz2zQOIjchBti9yZOpjuHdbubPn9jkAbU8e/4Mk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZESq4takYk04s1tXsYkJ1wwcn9Ay43Y00g77NvQDNlTwJOZv2UyugpVwqhalhOvUF
	 9R02m8lnpW+UwWmBatg6mGoscn0G2WGVx+HiCBfLh9L073OfwIql7AVYHen+q+CkOm
	 7E+ecW6uZT4jM9jKqNdxoLaY+pUVdn+KDxDv7qirFBccgnXxcJGdaABLGqoZzRsz7o
	 GkYpzM4rTgDCy00qz9LisibrBrW52xH/BNZdEXNJ29cmVv21fttjEF8NnUIorq1oxV
	 6UMMxgk3f9s0oS/BbOrJbmRO64Kv9dGyrPtaLNGEr6DkPeDe+zpCVaT8b6riZz++k5
	 1ylzeKxKGb3sA==
Message-ID: <sashiko-outbox-165343@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 29/31] ext4: add tracepoints for EOF block zeroing
 and disksize-grow I/O
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261009103831.2978767-1-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103831.2978767-1-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 11:16:29 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Add tracepoints to track the disksize-grow-pending lifecycle in the
> writeback path and the block-zero-EOF entry point:
>=20
> - ext4_iomap_wb_disksize_pending_submit: ioend is marked as
>   DISKSIZE_GROW_IO in ext4_iomap_writeback_submit().
> - ext4_iomap_wb_disksize_pending_complete: ioend of type
>   DISKSIZE_GROW_IO completes in ext4_iomap_finish_ioend().
> - ext4_iomap_wb_disksize_pending_wait: ioend worker waits for the
>   pending zeroed EOF block to complete.
> - ext4_iomap_wb_update_disksize: i_disksize is advanced in
>   ext4_iomap_wb_update_disksize, including the new value and
>   whether the update is a disksize-grow completion.
> - ext4_block_zero_eof: ext4_block_zero_eof is called with the range
>   and zeroing outcome, capturing the producer-side entry point.
>=20
> Together with the previous mark/clear/wait tracepoints, these cover the
> full lifetime of the disksize-grow-pending state.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D29

