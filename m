Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071CD4AFE31
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 13:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788442614; cv=none; b=ONgkWja7CfCWW0qfNGKkn5rG5WXdOinkkasEgrhLvzEz1UfT3eIjVxy2HzCILIm/LlT4yV2OsVnGmt8GtjpexNocDnTe6HXkmSWEu0ZPpdc6a0qWG5MdB5wgMc13gGc6DAN9/sO30xrFVCu8yP7mzDtYZys7f8wu9kPg5A6eKDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788442614; c=relaxed/simple;
	bh=KK/VUCD3+dBqL43/bMy16Ke8jTrjXhaFCFdjJ+6O0+8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ORO8kNTojypFlNOAWnt3wHa4g2w4HbhchPWpt5L7lFUzmZvBxCwLF/K91KJQnSwngI63bu/TVf4pBUZdN94W7VFNwQqBlxnSOnA+15yxNuoL72IajOVqOdBMbpVatz1vJFrh3st0brGY+chVRJ0wggm1oafJ/qa5cxNzQ/vF/ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N0B/XUoc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N0B/XUoc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A551F000E9;
	Thu,  3 Sep 2026 13:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788442600;
	bh=KK/VUCD3+dBqL43/bMy16Ke8jTrjXhaFCFdjJ+6O0+8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N0B/XUocnFO4jdsGAtRL1WN+9j8EzjwI0zLnV3Kk3KEqehiKS4H4r0HH5ekRRA90R
	 tmtyxLxxMMwWJQMWj7YUR6ceMHpQofJz26Ewv3GL1mK4TsJIETFWlk5XlCYI4UDg3B
	 Ql7+177S4PmiW4wj6mYTSMUSp6Wqi2BkK88um1h2kwxB+etQ5MXFtu9iBfjmpsQf9P
	 8jRsCD78t26vMzul9hJUqVSmJN459ePqWPr5s6uobw3sIKT3ZYgjCBsVmXhOQute4V
	 19IafwCbcGK/X49kiBzMkfdc3YPagyTpHKknJRJgYj39C/Qh1VJnxglXZ/mlPnzcPH
	 si2v9kiYYM8Fg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 27/31] ext4: set DISKSIZE_GROW_PENDING after zeroing
 unaligned EOF block
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260903123543.2302999-28-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-28-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 13:36:39 +0000
Message-Id: <20260903133640.52A551F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D27

