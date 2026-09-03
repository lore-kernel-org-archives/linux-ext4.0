Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0386B49DB97
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 13:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788441318; cv=none; b=afsA7mf4sL5Rf7OpCXPIB68BPfe9GjjoFYoIJ3YSPO5DHf89D/TA+SelzyiAQ0P+LMbz8E0OlH2ZVF+SBtqEVumNZHfQtmAwEzbuoH1/ZaQclYH0piH1rcQLPO97yWz2PFpLEkrmJSTCksOjGKyxXj9z56urXP6S6mbEM040Kuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788441318; c=relaxed/simple;
	bh=jXiNcOWgt9jFJpBdbrwSlCpUeNa3GO9AwHStO9N/SEY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KDt6wzuVqewMOy53DagxhCDAx4nz3y4D3XPGiUDbZijvKdmEz+Lik3s4laxmiaTcgDWhUF3C6I3XKj8LsDIJMDzjX71e88c1fMzMugDXsljgOxSHqYdO1r6oL0QKFlD5t3yVd+UUOXIRu+tYK+y+u0bFgy7m3iNGDR5d+ATebh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a4s/VSnP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a4s/VSnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8131F00ACA;
	Thu,  3 Sep 2026 13:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788441292;
	bh=D6unQv/H87ePI4DAybSheQ6Njhp4qf/xcTIUEpbac/U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a4s/VSnP08ihdbmNtUXBHNqlXkThgrqZZQSJTbI09m1+5C0N3ICdX7k7Ob1TflAU2
	 FHpWWMv+pMAch/YPj0cinH78QEvGtx2QArIX1ANbwRbRmSlT1W/DcXgEYEt/rbD8K5
	 LAWU+Nq98srmSVnkSnkIw8I512HCpI+PtsP19P2eBEcXEGEEFFeJMyQsnbrvdVdrV+
	 el7CaYqQQSHx0hUtEHh1iiZgyeF7uq5rSfqH1yemR3H/l3yYU6KMDIEDVSz7Olk4NE
	 yNCp8gUoJAhj2GaWtYNMzkjMvHrA3NBgttlzrcWUjfcpJWJM2QAuFkc8+wAiqY54i1
	 QR60BQKYxSi9w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 03/31] ext4: skip ordered I/O wait when zeroing
 beyond i_disksize block
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260903123543.2302999-4-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-4-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 13:14:51 +0000
Message-Id: <20260903131452.4F8131F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Skipping ordered I/O wait based on an unstabilized `i_disksize` al=
lows stale data exposure due to a race with concurrent writeback and mmap.
--

commit 9f1f97ff9aa74fccfe7305cebcde6a641f847ab5
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: skip ordered I/O wait when zeroing beyond i_disksize block

ext4_block_zero_eof() zeros the tail of a partial block beyond EOF.
After zeroing, it waits for ordered I/O completion to prevent stale
data exposure from concurrent post-EOF mmap writes during folio
writeback.

However, if the zeroed range lies entirely beyond the block containing
i_disksize, no stale data can be exposed because the zeroed region is
beyond existing on-disk data. The zeroed pages will be written out
before i_disksize is later extended past i_size, so the ordered I/O
wait is unnecessary. Add a condition to skip it.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index d0ccafa554f8d..339ebd553959b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4241,9 +4241,22 @@ int ext4_block_zero_eof(struct inode *inode, loff_=
t from, loff_t end)

[ ... ]

> +	 * Note that it's safe to read i_disksize without holding i_data_sem
> +	 * here. Since we already hold i_rwsem, the only possible race is with
> +	 * concurrent writeback that updates i_disksize. And if such a race
> +	 * occurs, it means the previous unaligned EOF block has already been
> +	 * zeroed (if needed) and persisted to disk.
>  	 */
>  	if (ext4_should_order_data(inode) &&
> -	    did_zero && zero_written && !IS_DAX(inode)) {
> +	    did_zero && zero_written && !IS_DAX(inode) &&
> +	    from < round_up(READ_ONCE(EXT4_I(inode)->i_disksize), blocksize)) {

[Severity: High]
Does this condition rely on an unstabilized i_disksize to skip the ordered
I/O wait, creating a window where in-flight writeback IO can leak stale data
upon a crash?

If a file has a delayed allocated block at the end, its on-disk size
(i_disksize) could be lagging (e.g., 0). If the user mmaps the file and
writes data past EOF into the page cache, delayed allocation writeback can
begin, allocating the block and formatting a BIO with the user's stale
post-EOF data.

Concurrently, if a truncate operation extends the file (truncate up), it
calls ext4_block_zero_eof(), which zeroes the page cache tail and marks it
dirty. However, because READ_ONCE(EXT4_I(inode)->i_disksize) is 0, the
check evaluates to false.

This incorrectly skips ext4_jbd2_inode_add_write(), failing to add the
newly zeroed data to the ordered data list. The truncate operation then
sets i_disksize to the new size and commits the transaction, waiting only
for the first BIO (containing the stale data), not the zeroes.

If a crash occurs, upon recovery, the on-disk block would contain the stale
data because the transaction committed the new i_disksize without waiting
for the zeroed page cache to be written.

Note that this issue does not appear to be resolved by follow-up patches in
the series. While commit "ext4: set DISKSIZE_GROW_PENDING after zeroing
unaligned EOF block" introduces ext4_iomap_mark_disksize_pending() which
safely waits for writeback, it is placed inside the exact same flawed
condition branch, meaning the wait is still bypassed.

>  		handle_t *handle;
> =20
>  		handle =3D ext4_journal_start(inode, EXT4_HT_MISC, 1);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D3
