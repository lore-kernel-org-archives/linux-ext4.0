Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E52B4FC34B
	for <linux-ext4@vger.kernel.org>; Mon, 19 Oct 2026 14:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792420358; cv=none; b=Ofw2xLM7S7557W3LJRTVk271mx+dBFov4Sp++8mZ2aZOyY+TK1KpZUtVaQD/FjVWro4x+WnvlWq0dPlxXJ5BHR7hA44OwOhzdoZSwJoZQDy2eX30HSMiJ3qwzKHJxfXKd+4RijZmJzL70cGDZtOFCMRZTCABP+eVtf4BhtGF5LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792420358; c=relaxed/simple;
	bh=/5AzuGD3VFRWLArQ+GCa62s9rIGJnEcGQxCKWilmHjU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=NoIQCzMplBqvjydYdhp/QUMFm5dOadJCFzDKDlCPybbCFLDwXJ1GSrZkR/Ll2vfH0hDavoxJcfKEUGgOHE5H/sV2mglEJnj0dU11JS59DeudSea5BNrYxB1s9v72JxWP0X16W6zZfA9d1672ZkMKm6jA/51WfuHXJbqqjYMifEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PAUcAMZD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PAUcAMZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8408F1F000C4;
	Mon, 19 Oct 2026 14:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792420356;
	bh=mynpnCr/PKlEaLq/YZCJmBcz5oruq+JiOMLcZ5xV5oA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PAUcAMZDe7+GWd+O/Ijmf9Qzj4Yjf7uODuh5lsyuP9yb0xQWQIERVCMjEfykZzZj8
	 AIIPfC1AxoNCmoXT/An/FvOt+9BrMEQxc0ZH4EONQQZVCUrVdtgMvn9o80V9bM9Ouw
	 lokTA7rIOSwAvpADHRod62676J24UIfQ9B+kXDGXr+E59pwITGmSZnux+b8TV1W93q
	 f7C9e0q8ZPS9+xS4cj4stBgfwTm9am5enJ7FtyHlAfxV6umVUUo1MAjwUtIWHzYdT+
	 Gee3mVtvNbpLejYWhhvse8/9Jd7xOBMtT9urb5WpFax77BBWyoVOcr5LZJdFpNjFbt
	 zixzfr1i1MLgA==
Message-ID: <sashiko-outbox-177421@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-5.10] ext4: check return value of
 ext4_get_block() in ext4_load_tail_bh()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sasha Levin" <sashal@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261019135441.1420968-141-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
 <20261019135441.1420968-141-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 14:32:36 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] ext4: unchecked ext4_block_truncate_page() return in truncate ca=
llers
--

commit 26fe59dd3c7737fcb95b3fe2c9732b862d57565e
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: check return value of ext4_get_block() in ext4_load_tail_bh()

This patch checks and propagates the return value of ext4_get_block() in
__ext4_block_zero_page_range() so that I/O or allocation failures are not
silently ignored as holes during zero-range, truncate, or punch-hole
operations.

Link: https://patch.msgid.link/20260714080044.4038124-4-yi.zhang@huaweiclou=
d.com

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index e99306a8f47ce..234dfe20ef4f3 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4092,7 +4092,9 @@ static int __ext4_block_zero_page_range(handle_t *h=
andle,
>  	}
>  	if (!buffer_mapped(bh)) {
>  		BUFFER_TRACE(bh, "unmapped");
> -		ext4_get_block(inode, iblock, bh, 0);
> +		err =3D ext4_get_block(inode, iblock, bh, 0);
> +		if (err < 0)
> +			goto unlock;
>  		/* unmapped? It's a hole - nothing to do */
>  		if (!buffer_mapped(bh)) {
>  			BUFFER_TRACE(bh, "still unmapped");

[Severity: Medium]
While this propagates the negative error from ext4_get_block() out of
__ext4_block_zero_page_range() via ext4_block_zero_page_range(),
ext4_block_truncate_page(), and ext4_zero_partial_blocks(), several
truncate and fallocate callers ignore the returned error.

In fs/ext4/inode.c, a shrinking truncate via
ext4_setattr()->ext4_truncate()->ext4_block_truncate_page() ignores the
return value and proceeds with block truncation:

	if (inode->i_size & (inode->i_sb->s_blocksize - 1))
		ext4_block_truncate_page(handle, mapping, inode->i_size);

Similarly, an extending truncate in ext4_setattr() ignores the error from
ext4_block_truncate_page() and proceeds to update i_disksize and i_size:

	if (!shrink) {
		inode_set_mtime_to_ts(inode,
				      inode_set_ctime_current(inode));
		if (oldsize & (inode->i_sb->s_blocksize - 1))
			ext4_block_truncate_page(handle,
					inode->i_mapping, oldsize);
	}

And in fs/ext4/extents.c, an extending fallocate or zero-range
preallocation in ext4_alloc_file_blocks() ignores the error returned by
ext4_zero_partial_blocks() when zeroing the old EOF tail block:

	if (epos > old_size) {
		pagecache_isize_extended(inode, old_size, epos);
		ext4_zero_partial_blocks(handle, inode,
				     old_size, epos - old_size);
	}

When the tail buffer_head is unmapped and ext4_get_block() fails, can
these paths still silently discard the error, update the inode size, and
return success with stale data left in the partial tail block?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019135441.1420=
968-141-sashal@kernel.org?part=3D1
