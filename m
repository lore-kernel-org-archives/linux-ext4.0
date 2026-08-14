Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEA8426ED3
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786702704; cv=none; b=oBp5s3wwIMd4Ed0gRIOG6S6hywCQRFBgpvwJ6edwRNAJeH6IqBVMhfJUgZgra5uFB98D9qCEmFSDI4ndHxeFXBaLgcxRYMMzxUz7MUMWVJiUj2xxzfeOKKXBKBa/AwNDW0JgBrQIU9KYmSv+WuZnMahwr21VFB5DxcQtsaj9xts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786702704; c=relaxed/simple;
	bh=u0qpLAbB9ASpLBNQAbQsTCDOFBfKs9Iw+rtqOlJfP9w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AEF3rzix+IKp/Tv37b+1IhdS+p49wUCEJHm5rWDssErVxCIMZAFovhAIsrRyjOv78RMZcIDXKA+aL9b1nsP2HBE2ac+TW/P3YZNnG8mxcCtw3eejDf2vpjFIxmveipyvxt2hJdJaylBRrxz1IIWxGRTTvWOAWY0HcBPjBwHprM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CIxyx4e8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CIxyx4e8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC741F000E9;
	Fri, 14 Aug 2026 10:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786702696;
	bh=u0qpLAbB9ASpLBNQAbQsTCDOFBfKs9Iw+rtqOlJfP9w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CIxyx4e8N6gULfvpfaT+x0O6RYJ99e1yah9V06Fe9YnTgx4C4x9nLNaw8lcJtTksP
	 6rox3uBTn+71Q7ho4z1SSt13A1ffd7EMsCVA95876Iq3wAmJIwSYF5psjciPAQS0q2
	 84HBQgqOq/v5iCvwz2OQ846RZORXUq6jxZJoOOjP04n+CuxCnFxzJSnQJ6Htz/ZSC3
	 dTJs1HPxxwfMaPz3dMoK3ElUqLXVb1ATmHT7Rs/bFpoRe8UqILuZySDtni8YqQLUHX
	 goeYw3qrnckjM6EWKzU2m3FZhYXO/Br8FWSxNA7LKJDjro8jy2QY9hpGcKmqBKQrJY
	 lqr3i77nlRIMg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 28/32] ext4: set DISKSIZE_GROW_PENDING after
 zeroing unaligned EOF block
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260814093331.1703882-29-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-29-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:18:15 +0000
Message-Id: <20260814101815.CFC741F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> In the iomap buffered I/O path, data=3Dordered mode is not used, so the
> zeroed EOF block has no implicit ordering with later i_disksize updates.
> Without the pending state being set, i_disksize can be advanced past the
> zeroed block before writeback completes, exposing stale data after a
> crash.
>=20
> Previous patches added the consumer side of the
> disksize-grow-pending mechanism: the state bit, clear and wait helpers,
> and ioend tagging. Now add ext4_iomap_mark_disksize_pending() and call
> it from ext4_block_zero_eof() after zeroing the tail of the block that
> straddles i_disksize.
>=20
> The helper locks the folio, waits for any in-flight writeback on it to
> complete, then sets EXT4_STATE_DISKSIZE_GROW_PENDING only if the folio
> is still dirty. Waiting for writeback prevents folio_test_dirty() from
> returning false mid-writeback, which would cause us to skip the pending
> state while zeroed data is still in flight. The dirty check then avoids
> setting the bit when the data has already been written back.
>=20
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D28

