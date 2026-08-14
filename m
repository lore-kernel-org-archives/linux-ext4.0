Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FA442C4E4
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786703500; cv=none; b=q0KqXYtmaplPhu2Ov3GrDIFo6nhei59zqpIIni0PIRXNhtI0/E0T2MrLq8DZeyhG0XBrkiKaxawbcMO4w0Im1DdDLszvCK7PG8X8sBdIG/sdeWZbxU8CMyZ+W+KxvSGR5kYHZ3YNS2Z1jRVFlS5ryXSg6nvrkviIDopVi9J7I8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786703500; c=relaxed/simple;
	bh=nuX19a79muKSzVdhukpLNxRB5kswXFiWvIztG2jFce0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=E1sJKV/w4rqAwUyvroyMAfM4VxUctgyQBOMcV1ZUr5pl+9PTs4CflXGNUFfPJaWu15MxBrysQHfUvYdP8BwzNagwcjwl7PLwElAA8FkkE678W6DG9k3jGQ1V5cr8oRBIw5GMgRXuMldWXIcoyF2d4Sb1UM90XzryOVeRTQGnlIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JchWBBNF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JchWBBNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BD71F00A3A;
	Fri, 14 Aug 2026 10:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786703489;
	bh=mxGTKMQeUyzlhC3GEPhMbchHTnIhNZNoxXp18ot1Nrw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JchWBBNFaQl3jK2eU8xcJ6DEluEPrAg7u/4ssyCD5FJxzlv4O72OZoV5XYLfE29rM
	 1VxsofuwbsQYaAwGxQXeuT9ZszuyIXOPdsSfPp3so8oTfIt+fQ4d15MDzJ4LVq+E8J
	 S8YEvH4VYH746DJTYBj8UvVYVEpHnEhCdoh8zyKaDYsYdygkFP7ch8lVe4hv5SagsD
	 AYXGcN8ggg0EUnG/9FnuVV/5TTFyobLBmxWr/tQ8bkwy8Iin/J9CYbU/JMBzTRPStw
	 Ew6NmLZvzcKb4dYoaRKNWbcm6q7CKF5gK+LQucwcZj2Pgi5xO6xqyYJgQVI9lS3l9I
	 CrrjUVWV4NyKA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 27/32] ext4: clear DISKSIZE_GROW_PENDING on
 truncate or error
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260814093331.1703882-28-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-28-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:31:29 +0000
Message-Id: <20260814103129.98BD71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The EXT4_STATE_DISKSIZE_GROW_PENDING inode state bit is never set =
anywhere in the codebase. As a result, the entire deferred disksize update =
mechanism introduced in this patch series is non-functional.
- [Medium] The DISKSIZE_GROW_PENDING state is not cleared for linked inodes=
 (i_nlink > 0) during eviction, leading to a WARN_ON_ONCE in ext4_destroy_i=
node() on forced shutdown.
--

--- Patch [27]: [PATCH -next v5 27/32] ext4: clear DISKSIZE_GROW_PENDING on=
 truncate or error ---
commit a9d36fc1a5b406105120b9e8fd8d91b4a9fe12f0
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: clear DISKSIZE_GROW_PENDING on truncate or error

The disksize-grow-pending state is set when a zeroed EOF block is queued
for writeback and cleared by the ioend completion path once writeback
finishes. This patch clears the disksize-grow-pending state on discard,
inode eviction, filesystem emergency state, or truncate to avoid blocking
writebacks and preventing warnings in ext4_destroy_inode().

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 056937e278594..a1dfb70127ca8 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -273,6 +273,8 @@ void ext4_evict_inode(struct inode *inode)
> =20
>  	if (ext4_should_order_data(inode))
>  		ext4_begin_ordered_truncate(inode, 0);
> +	if (ext4_inode_buffered_iomap(inode))
> +		ext4_iomap_clear_disksize_pending(inode);

[Severity: Medium]
If a filesystem is forcibly shut down (e.g., via EXT4_IOC_SHUTDOWN without
logging an error that sets EXT4_ERROR_FS) and then unmounted, dirty linked
inodes will be evicted.

Looking earlier in ext4_evict_inode(), if inode->i_nlink is > 0, the code=20
jumps to the no_delete label, completely bypassing this cleanup:

	if (inode->i_nlink) {
		...
		goto no_delete;
	}

Will this cause the newly added WARN_ON_ONCE in ext4_destroy_inode() to
trigger for linked inodes since they bypass this state clearing?

>  	truncate_inode_pages_final(&inode->i_data);
> =20
>  	/*

[ ... ]

> @@ -6741,7 +6759,18 @@ static int ext4_truncate_down(struct inode *inode,=
 loff_t oldsize,
>  	start_lblk =3D newsize > 0 ? (newsize - 1) >> inode->i_blkbits : 0;
>  	ext4_fc_track_range(handle, inode, start_lblk, EXT_MAX_BLOCKS - 1);
> =20
> -	ext4_set_inode_size(inode, newsize);
> +	down_write(&EXT4_I(inode)->i_data_sem);
> +	/*
> +	 * Truncate the zeroed EOF block invalidates the pending disksize
> +	 * update, so clear the disksize-grow-pending state.
> +	 */
> +	if (ext4_test_inode_state(inode, EXT4_STATE_DISKSIZE_GROW_PENDING) &&
> +	    (newsize <=3D EXT4_I(inode)->i_disksize))
> +		ext4_iomap_clear_disksize_pending(inode);

[Severity: High]
Is the EXT4_STATE_DISKSIZE_GROW_PENDING bit ever set anywhere in the
codebase?=20

A search of the tree indicates the literal EXT4_STATE_DISKSIZE_GROW_PENDING
is only ever read or cleared, never set via ext4_set_inode_state() or=20
similar.=20

There is a TODO comment in ext4_block_zero_eof() indicating that this state
should be set:

	/*
	 * TODO: In the iomap path, handle this by tracking the ordered
	 * range and updating i_disksize to i_size after the zeroed data
	 * has been written back.
	 */

If the bit is never actually set, won't this entire deferred disksize update
mechanism be non-functional, leaving the filesystem vulnerable to the stale
data exposure this patchset was intended to fix?

> +
> +	i_size_write(inode, newsize);
> +	__ext4_set_i_disksize(inode, newsize);
> +	up_write(&EXT4_I(inode)->i_data_sem);
> =20
>  	ret =3D ext4_mark_inode_dirty(handle, inode);
>  	ext4_journal_stop(handle);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D27
