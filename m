Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C23D547063
	for <linux-ext4@vger.kernel.org>; Sat, 26 Sep 2026 07:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790408068; cv=none; b=rhAOK+YSdpsrr03CELOtaaZc+w3wLQ5r514aSsFWlB4e5keSj6K9LGf34Htyi0y5Fk+0mJlZ74DS70/BtDxVBKfSVLk/byhJiCRWbVyDLztiTimaxMXo8qlpICYoAFhL6PjHs+wLlpvklSjHhBDJqNrF58loTrHHKxsGqqzWPk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790408068; c=relaxed/simple;
	bh=LP2h58AAu5sgiLyz2hEDy6mfRy6bORwBMXRcs8d96Y0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mF5Zvhx8Sut3yssNQw/8N9JhH+kDf4ssqlvH8VBiMmwOzD/nYQajOqVnoLFLKkwXy8FAcTCcZ9XybxW7GYTiwAvURfV2Vr9R3bJpMDcQUR9YtoGgWZYZuygpdKZx+O60f68bUYUCyamnWl25j2mUNtupu5s3DPC68aBXBm+c6Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ldS7/0wN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ldS7/0wN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD191F000FF;
	Sat, 26 Sep 2026 07:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790408066;
	bh=eycqr9cQRpwuMAlA/xL1XYkFAtIiSxtKMamzUNU/neA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ldS7/0wNnvZK0WE+zsfHsAVM0J8tQCWbuEkJwN4XgerTmti3Axw2crBuhJOvquYq1
	 6x4Mgth1AHN8oC4mSrTFW3Ah/HTkDxzjXbn64XcP9t3l1sacg1l2ZQpAZZVtNv+NzD
	 DG8NSCuMZQq/5GalZ9IREIxYJm662YTO7Sp0h9Img/WPVjhWqpBZglXVcyzwyL9N9z
	 8LGCBP8MfK7ndix8PhEC1s4P632hEPDeso+5ZUmvXhKYGvB3rNv1i+dg5RrXuX/Yg+
	 ANTDwbBM4YWeyWcmvM0xt7oJl+G5E27Bft1kEWMmaJMs1wJU+BGV8+RDU9ufyffHjd
	 RCYfBuBm1eprw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/3] ext2: drain in-flight DIO before buffered write
 fallback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiale Yao" <yaojiale02@163.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260926072612.3022680-2-yaojiale02@163.com>
References: <20260926072612.3022680-1-yaojiale02@163.com>
 <20260926072612.3022680-2-yaojiale02@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 26 Sep 2026 07:34:25 +0000
Message-Id: <20260926073426.6CD191F000FF@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260926072612.3022=
680-1-yaojiale02@163.com?part=3D1

