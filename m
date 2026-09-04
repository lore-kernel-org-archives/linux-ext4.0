Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DA5126BE1
	for <linux-ext4@vger.kernel.org>; Fri,  4 Sep 2026 07:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788508081; cv=none; b=llBZdqhjiGC8Lp4rsw9vPoickDA1ZnxUDfSdbqk8hJslg/jkl5vJuwEcjVJA2HehvH6yulOmNs0d3HCtZtzkIEcVZ/+Yf9+pkZvan/+Y5TDBzSMTVLr5VMnW5Of6Fgl4V94asW8CHtnN3RPabUH/YpGkFYNUkUab/xKYszl0EAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788508081; c=relaxed/simple;
	bh=WtNj381OF4mi4uHMdSm1F3yWvTiMDaBw/0Ty5J5aS1c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kppESx+8HvClkS9hZrZfa/kWLinmmmJ2+7OAGFwKU4X5GCK0bFIATOSVv6aX3AB3U3K79GylwDop6+67mh01E6W6J/5cyrWEh1wC8F6bCnwUuYar3G1xzeYBub1d9EqZ8XbOd2fA6JUQHL74ox/KG3uXuSymGQfHgClm7SULrcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a+4owlvB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+4owlvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36081F00A3E;
	Fri,  4 Sep 2026 07:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788508080;
	bh=vhG90Hcq6hf16ob+uJLjKoIUSg3TBayQ3kEhfIfSlA8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a+4owlvB6buZkgADA2F+cb6hT4Byi4qAKdPw7eVxdFxMmneFz/EUbGZGjjQWmu9w0
	 2x4ZvQrEN3g7q6vugYRxCRIQwBfejXWEDDvFt6Bh0eG9QW1c1xZs+EkxcPQSZuNswm
	 hTrmv45l6jYKvDBEo6RFnrmCmSN2QrQWEeiFRW/vAW8jqBltR6w2bNnpUQA+RfONJs
	 WLeBXXP/dWV1k/imfZYrA0c0W/bzMnnF5klYd9keLBlhN71bZIQl3U1ytY8CY9AlFR
	 ANgY07Suto8YqxURYotwGSeWmZ1a4o/3FthN0gwgI7LqaDRsO+UqqiGwTH07t2+Vrz
	 aaeBynODjSw+Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/2] ext4: Fix out-of-bounds read in
 ext4_get_group_info()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260904073253.663243-2-ruanjinjie@huawei.com>
References: <20260904073253.663243-1-ruanjinjie@huawei.com>
 <20260904073253.663243-2-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 07:47:59 +0000
Message-Id: <20260904074759.D36081F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> A plain read of s_groups_count in ext4_get_group_info() allows CPU
> load-load reordering. On weak memory models, speculative prefetch of
> s_group_info prior to the boundary check could lead to an out-of-bounds
> read if a concurrent online resize expands the array and increments
> s_groups_count.
>=20
> The data race occurs between the ioctl configuration path (holding the
> resize lock via ext4_resize_begin) and the lockless metadata lookup path:
>=20
>    CPU 0 (Writer, Resize Lock)                CPU 1 (Reader, Lockless)
>    ---------------------------                ------------------------
>    ext4_ioctl()
>      [EXT4_IOC_GROUP_ADD]
>      ext4_ioctl_group_add()
>        ext4_resize_begin() // Takes lock
> [ ... ]
> Fixes: 5354b2af3406 ("ext4: allow ext4_get_group_info() to fail")
> Link: https://sashiko.dev/#/patchset/20260825095422.3166067-1-ruanjinjie%=
40huawei.com
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904073253.6632=
43-1-ruanjinjie@huawei.com?part=3D1

