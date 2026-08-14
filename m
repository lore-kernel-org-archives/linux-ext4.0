Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AACF442FAA
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786702510; cv=none; b=EHbb9+sbFKtZMdCULL9joGHgAExmReEsd9TMuk+UrXd/+fLlEjWKHXmju4XM/xM9TWx69zjKYT4rLKscknzdX85qo23bfMwneYIpUxBPxoG8dtxQg1ZbVpGh2xTdYxymNOBSo+m93LVS4Gfrcut6qjn0gdJ+QcK/6dF5RIJl15c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786702510; c=relaxed/simple;
	bh=9wsAngV0txUfPVNNEOoLPkxVhL1opEVncZ8SMwPmQhU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CIzbQOvEIR0/4Scbd5+AmxHxXsfC7uUUOrvgXW7Dpz4mUp5xL6RxuoG6ZpssMYrkZr/amtZWIaAoIRC/EXlHpKGgUQ4hRMC4R0/K+7KlhvZdFe5qNrBt5GHx4LS3vg5Deo2GJQTEDmxex7Kh1YWX8krP/8jsWBZuu1/LkS4WELM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XOZQIpP2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XOZQIpP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008C01F000E9;
	Fri, 14 Aug 2026 10:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786702497;
	bh=dqshb4B3/DDN07BDG5lSkXF+nA6HzWLGqBaw4aF0noI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XOZQIpP2Rt0irtCp1yTB9cTOFZMma/TBljW2WOHJgYQWyYhL77bVvf3vOi/tA7RZU
	 iT+n9QJLxzvh4sdFLbvJu8MKLXZyUnAUlEQx1WJlhyfiGVrhePhghpZ5Pm7K7C8EBV
	 rkC8kZnak559KbPVbchCFhp2i/vuRdwqJBh6g+fGiGFE1oC/gyxwY9qSiGPrHQGum8
	 iVN53IAy/F3biB11SLteQXuvwuxWgveDYNdxerF2PhKmGDfNKwq7oCE9pL+uDTlbVn
	 UCoEfQPJK/u6C3i+FhbeQOWu4y0iKHahCZ+50QN9ApHLvLZvkwv6am1RtJi/bVWaLs
	 L91Wk/Y10K/3w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 04/32] ext4: skip ordered I/O wait when zeroing
 beyond i_disksize block
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260814093331.1703882-5-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-5-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:14:56 +0000
Message-Id: <20260814101457.008C01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Torn read of the 64-bit `i_disksize` on 32-bit architectures can c=
ause the kernel to skip ordered I/O, leading to stale data exposure.
--

--- Patch [4]: [PATCH -next v5 04/32] ext4: skip ordered I/O wait when zero=
ing beyond i_disksize block ---
commit bb84de10d990ded9aab4107d18dd1616342efccd
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: skip ordered I/O wait when zeroing beyond i_disksize block

This commit optimizes ext4_block_zero_eof() by skipping the ordered I/O
wait when the zeroed range is entirely beyond the block containing
i_disksize. Since data beyond i_disksize hasn't been written to disk yet,
the ordered I/O wait is unnecessary and can be bypassed.

> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
[ ... ]
> @@ -4241,9 +4241,16 @@ int ext4_block_zero_eof(struct inode *inode, loff_=
t from, loff_t end)
>  	 * truncating up or performing an append write, because there might be
>  	 * exposing stale on-disk data which may caused by concurrent post-EOF
>  	 * mmap write during folio writeback.
> +	 *
> +	 * Ordered I/O is required only when zeroing the tail of a block that
> +	 * overlaps with i_disksize. If the zeroed range falls outside that
> +	 * block, the zeroed data lies beyond the existing on-disk data. It
> +	 * will be written out before i_disksize is later extended past
> +	 * i_size, so no stale data can be exposed.
>  	 */
>  	if (ext4_should_order_data(inode) &&
> -	    did_zero && zero_written && !IS_DAX(inode)) {
> +	    did_zero && zero_written && !IS_DAX(inode) &&
> +	    from < round_up(READ_ONCE(EXT4_I(inode)->i_disksize), blocksize)) {

[Severity: High]
Could this READ_ONCE() on the 64-bit i_disksize result in a torn read on
32-bit architectures?

If a background writeback thread concurrently updates i_disksize under
i_data_sem but without holding i_rwsem, and the file size is extending
across a 4GB boundary (for example, transitioning from 0x00000000FFFFFFFF
to 0x0000000100000000), a torn read might fetch 0 if the lower 32 bits are
zeroed first.

If 0 is returned here, round_up(0, blocksize) evaluates to 0, which makes
the condition 'from < 0' false. Would this incorrectly bypass the critical
ordered I/O guarantee and potentially expose stale data in the event of a
crash?

>  		handle_t *handle;
> =20
>  		handle =3D ext4_journal_start(inode, EXT4_HT_MISC, 1);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D4
