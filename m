Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A25149E5C9
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2026 10:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792061088; cv=none; b=lT/YfoE41iotDgGFSkHyAwCzqCFXQchleFvpzpa/T6n2vczmfqEH3TOxyDQEo7J/+sV9aDBHDWbAnFUZA/c2B30sKNQLNyRjsYV0l4iv6dMRiiKMJOkXQERslEXHbPGR/QDH/2P1AcVL+9rX7TDVLsTS4wiZ0Rn/0NryKv9wFmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792061088; c=relaxed/simple;
	bh=1aHTJTl2ZV5H+Boce+LB+gPerf3x5tBlg1dlElqvuXo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=EkSW2rM0viZw5eIkBIBZ2wlfRKrj+3DGt8ZWjcr5DwMj2bw0MeyiGHjjwlFMqrHKPdMn/VOoqXLe4OpvvYERAXlzRYjaNGqfuNtky6xARYoq8tNjv/N7eaf1AOOMnyhbcDxshT66NAYkepdMHlidvZoKrpfp8204TSqwZoD1FBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RAACt9CL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RAACt9CL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1C61F000C4;
	Thu, 15 Oct 2026 10:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792061084;
	bh=1aHTJTl2ZV5H+Boce+LB+gPerf3x5tBlg1dlElqvuXo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RAACt9CLeeDS4/pZABGOUQwQhnGbjp4cBjN3zh5sHxFCXZnhz/AXTjS7nmD+65iwD
	 tPk4cA2fiHyTRASF5qhZ9yQLvcGXyjk6FO4i8eboILa0J6n+VC5AktQ9sMCQxAOa0K
	 nnxIFuztuN4nvAe2ltdlTPqfsD4aG3hfiiqANbQET6Mj/qeZEwprzCk3JCzVC05/Yh
	 uv5uHt6o7PCD7Vby8+9KEpmCmqIbNiQwPzqi8Xdhhxrqaznue/N8SXOphBQYcS1nym
	 OOvD2zkX87QiLeJKyuQFTYgRIHm9Mi+tGBeaKIadzg5XZlBAEOl3D8qE1TPeXOtPvB
	 z1UO89+p9Ochw==
Message-ID: <sashiko-outbox-172667@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: report unwritten extent conversion failures as
 writeback errors
Reply-To: sashiko-reviews@lists.linux.dev
To: guolingxing <guolingxing@tju.edu.cn>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261015102943.74632-1-guolingxing@tju.edu.cn>
References: <20261015102943.74632-1-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 10:44:43 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> When a data writeback bio completes successfully but the subsequent
> unwritten extent conversion fails, ext4_end_io_end() does not record
> the error in the inode's mapping writeback error state.
>=20
> Bio failures are already recorded by ext4_end_bio(), but conversion
> failures are not. When the conversion is processed asynchronously,
> its return value is not propagated to userspace, so fsync() may
> return success despite the failed conversion.
>=20
> Record conversion errors with mapping_set_error() before
> ext4_release_io_end() ends folio writeback and wakes waiters. This
> allows fsync() to observe the failure.
>=20
> Fixes: b82e384c7bb9 ("ext4: optimize locking for end_io extent conversion=
")
> Cc: stable@vger.kernel.org
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015102943.7463=
2-1-guolingxing@tju.edu.cn?part=3D1

