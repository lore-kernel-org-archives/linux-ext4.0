Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA3B2D7DF1
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 11:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790248537; cv=none; b=iy+tpwwhVs+PE9JVcuyH7EILjaPduiCvytTisDz483WgymwHWHJ1A0o8ZdZYAHhk2j9sAh3yO9IsTQikSYCgYuPgpVwDDzEsTMphIQFQVc6tD4kHdspSjsP/q34Av8Y74IkLxz4f68mpDZIzSLsFUjeHZm8gVH95tDyKgefJpus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790248537; c=relaxed/simple;
	bh=qq+fy2ENSShLJcTJVS/0JAcSJFJjslMk8tFk0LfDsYk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SJ3IEJBN5u1z3+6MqCO6HdBQmAKuVo94xNvG8DZx/k+vNDvb1pGkgmA0XEjgQJ0OvfIDXKUc5sGxDv9IqaQxpEAWNqWYRzpUlS+SW11dc6zQ+tZ6+rcUbxVULKuB14iS6il6eSu64viDyd3xEYNMU2k7LP0jtSV5o3ZPDfrOfyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ML0CW8um; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ML0CW8um"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242461F00898;
	Thu, 24 Sep 2026 11:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790248531;
	bh=0KmwMtQDVsjXmtyLuMt6+ClAne9FhQGC9EWeFpQz/nM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ML0CW8umJ+Gh73749pVQhKdi4yUG35XeHBlF0gUQFMXlpNO/b6GdSuBRXoacXJYwO
	 cyIUK3X0cHusT+yOnMxaa3ye3bBy1zXfybmG8WKTTWi5NNeN5vV8KEQTyvDR4tv961
	 n5Y45Jd1JnIbcb+rbF1WNjnA6xaibw2Zpq1zssv80mwsj6k97sCwP5/oQ9OcDhpq0R
	 mTeMDMfYsoJW2GtQ4a1yQSoOmagWa9J2RrF6Ek17OobERlvEhMt0An/dd8jhklh0g0
	 pbkVTHeJsQJ6LMU+PnyAfl5TjkKx9VWvFhwERkzHc+D3ATDIQDVcOavmf4d5T/sPDW
	 hxH2cXmROEWpg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] exfat: drain in-flight DIO before buffered write
 fallback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiale Yao" <yaojiale02@163.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260924110544.601390-4-yaojiale02@163.com>
References: <20260924110544.601390-1-yaojiale02@163.com>
 <20260924110544.601390-4-yaojiale02@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 11:15:30 +0000
Message-Id: <20260924111531.242461F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> An asynchronous direct write can remain in flight after the inode lock is
> released.  If another direct write falls back to buffered I/O while the
> first write is still pending, iomap_file_buffered_write() can dirty pages
> before the first write completes its post-I/O page cache invalidation.
> The invalidation then finds dirty pages, reports a page cache invalidation
> failure, and records -EIO in the mapping error sequence.  A later fsync()
> therefore returns -EIO.
>=20
> Commit 15cdefd0c0522f9d5e12d947fa04f4c11649b699 ("ext4: drain
> in-flight DIO before buffered write fallback") fixed the same race in
> ext4.  ExFAT has an equivalent fallback after iomap_dio_rw() returns
> -ENOTBLK or a short write, but does not drain other in-flight DIO before
> dirtying the page cache.
>=20
> Wait for in-flight DIO before calling iomap_file_buffered_write() in the
> fallback path.
>=20
> A reproducer using concurrent AIO direct writes and buffered fallback
> triggered the following warning and made a subsequent fsync() return
> -EIO:
>=20
>   Page cache invalidation failure on direct I/O.  Possible data corruption
>   due to collision with buffered I/O!
>=20
> Fixes: 867b9c96dc83 ("exfat: add iomap direct I/O support")
> Link: https://lore.kernel.org/r/20260629113827.4074335-3-libaokun@linux.a=
libaba.com
> Signed-off-by: Jiale Yao <yaojiale02@163.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924110544.6013=
90-1-yaojiale02@163.com?part=3D3

