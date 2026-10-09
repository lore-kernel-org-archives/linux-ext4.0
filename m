Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4BF4C2277
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 11:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791543809; cv=none; b=BFMMpQn5Ej8hMFYhpGOtot7X+IXO2rdvUOxOcY5hL6HYFuX5LVL0NqvP3NI7RVJthVMynVs6BsXFSdjA2TQWiHzegUbY5OLd/oBnUrVK62QV+0fnPyuGuQ9wd4UonCcFJu3CyaU12Xx4BDT9pfXkHv9g2JpMjsnSY2x2f3ClWrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791543809; c=relaxed/simple;
	bh=xMbyVchL/OZp+nqtGKC0/sRt+EpJqpzJbQiR8YzOhKs=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=cZ40Tb9GAH1vzGZrjwwO+yGQh6AdPQEUrgU2FU0Mf+4D7l8gXtWu4pmFb/geK38r4n3IW3roW0+qSjE5SpJSe/4aXzZ10pH7oX+j3pyV48hgprVIrigrIRBKLSpYlTiJw/2Z7/ryqEXIcSC3o0CnJY+D2SvqtqqMLSDmoi5Nuwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XOdeP9fJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XOdeP9fJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4921F000FF;
	Fri,  9 Oct 2026 11:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791543801;
	bh=/eKY6B/BPVbNkj8vTKX/Djqb5BFHcvJTcBYyvrNiJt4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XOdeP9fJNL82/iNTU0wpPB8kf77TGjOZuPz1HZ7mXcyUWPw1fqkSztqlVKh7KSMp5
	 d326LKFw4SDksQ31DmuM0XMoh1ryaqtTcXu3r4O0GkHAEeU/y6fbasE6CpQ9vTqqSN
	 3cHffOayzfZKaTzGrt0bMsXsavMKNUSp0lZzZfGhnhz97tUigSu/4jyYEnss9v41EO
	 5HCKugNg1EDq10SRUGNbUiuJJ9YDzC+6JIK4b/1qkpeCeZgUGIn8oNdBUGxJUr+C3E
	 W4TGZ9fRaOUHYMVqFt/SlOFlRYzTVUOqShH+WycXFmzzKbks8LdaMeJe+lTnNV3/J/
	 gam8+ghO62WiQ==
Message-ID: <sashiko-outbox-165302@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 13/31] ext4: implement buffered write path using
 iomap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261009103033.2920530-14-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-14-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 11:03:20 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Introduce two new iomap_ops instances for ext4 buffered writes:
>=20
>  - ext4_iomap_buffered_da_write_ops: for delayed allocation mode, using
>    ext4_da_map_blocks() to map delalloc extents.
>  - ext4_iomap_buffered_write_ops: for non-delayed allocation mode, using
>    ext4_map_blocks() to directly allocate blocks.
>=20
> Also add ext4_iomap_valid() for the iomap infrastructure to check extent
> validity. This is useful for the iomap buffered write path because it
> does not hold the folio lock between mapping the inode extent and
> copying data. So it can race with writeback, which may modify or stale
> the extent type.
>=20
> [ ... ]
>    the buffer_head buffered write path. To handle this, the journal
>    handle must be stopped in iomap_begin() callbacks. The lock ordering
>    documentation in super.c has been updated accordingly.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D13

