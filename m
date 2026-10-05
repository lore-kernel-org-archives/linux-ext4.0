Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00341FC0EA
	for <linux-ext4@vger.kernel.org>; Mon,  5 Oct 2026 00:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791161190; cv=none; b=YnIaMFYWmkybgfKWUGK1ILq+UnbhcNnXaB+PZy8W8c2xHvHnNI8kTlBeGuZdC3g0lPvsaQ/gDYsHppUGm9h0giClm1lMUZLXoSGyAUDfd+yMjvz1FhIbjHNamO+NM7ykoTNTlVI5Hq6bS3vwABeS0qvkLt9jv01GMl4UGBFqrC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791161190; c=relaxed/simple;
	bh=uUTPywUa7uO70mcktkOGQ8BIQsZ5RFGUFl3W5DvwArM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pHQr7/uZSZYxLgyquL83at9BzL7EGos+skWbAsLvnPfGOP7UIWcv3wT5MtxpbSyaZbzDMWIZDvJ/qa+cS6T7s2EPOASHaex4ztW4tARtNcJNrkMUgxnjod3JMLpH4NSCngF48NqyZtH77J4yA1TCcVNcSKBr0BWOreUqxQUlUUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MiHLBSkC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MiHLBSkC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277B51F000FF;
	Mon,  5 Oct 2026 00:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791161188;
	bh=DFKL2Xkx9GK0BOML6mC2k/EgxqUHAHdOcvJzAyMQrdo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MiHLBSkCfm/pK26dVZbvf71i/+JvQgtQKaudETD8QI8PDQgr/O23JUmB7MvM5s0Pa
	 hx3zIZ3ed5vu3Yq8VDKWkeV8cporn8z7XNT2WOLtynzZbalduYWm48UzdJtHLvOXgW
	 4jomPWQ3k3dGJH4rFu+/qs/8Res+Vv4JccR7Z7CHdfQS2t50rhqwrl5Xn79qd5dmg6
	 Bx+RA2ZzpUCL+ysLS/q6Pi0ezLTaLgRH1cn209IfZL3NarRfZZMZ+FV1yaxUO3OXhx
	 Z8AZ9swkCc+yGyos7w8C5STgyCZHFCm/DN191xG5oX6uPZS5t0tBpLLcSvo62szPJ3
	 H4y0oGeSBSjKQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: don't append a directory block already mapped
 in the inode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Adriano Cordova" <adrianox@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261005003528.92046-1-adrianox@gmail.com>
References: <20261005003528.92046-1-adrianox@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 05 Oct 2026 00:46:27 +0000
Message-Id: <20261005004628.277B51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] ext4: ext4_append() misses aliases in multi-block extents
- [High] ext4: ext4_append() forces O(N) iteration over holes leading to so=
ft lockup
- [High] ext4: ext4_append() escalates transient errors to filesystem corru=
ption
--

commit 4e22a7e845c3a3e2ac2696b510b59d9b11640408
Author: Adriano Cordova <adrianox@gmail.com>
ext4: don't append a directory block already mapped in the inode

This commit adds a check in ext4_append to ensure a newly allocated
directory block is not already mapped by the inode. It iterates through
the inode's logical blocks to verify the new physical block does not
alias an existing one.

Closes: https://syzkaller.appspot.com/bug?extid=3D09bec78ee77613a3efdd

> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
[ ... ]
> @@ -83,6 +83,25 @@ static struct buffer_head *ext4_append(handle_t *handl=
e,
>  	bh =3D ext4_bread(handle, inode, *block, EXT4_GET_BLOCKS_CREATE);
>  	if (IS_ERR(bh))
>  		return bh;
> +
> +	for (map.m_lblk =3D 0; map.m_lblk < *block; map.m_lblk +=3D map.m_len) {
> +		map.m_len =3D *block - map.m_lblk;
> +		err =3D ext4_map_blocks(NULL, inode, &map, 0);
> +		if (err < 0)
> +			goto out;

[Severity: High]
Could this cause a regression where transient errors are escalated to
filesystem corruption?

The goto out path calls ext4_std_error(inode->i_sb, err), which marks the
filesystem as corrupted.

If ext4_map_blocks() returns a transient error like -ENOMEM or -EIO, should
it instead propagate the error directly back to the caller, similar to how
the earlier ext4_map_blocks() call handles them before the loop?

> +		if (err =3D=3D 0) {
> +			map.m_len =3D 1;
> +			continue;
> +		}

[Severity: High]
Does this force an iteration over large holes, potentially causing a
performance regression?

When ext4_map_blocks() returns 0 for a hole, it populates map.m_len with
the full length of the hole.

Overriding map.m_len to 1 discards the hole size and forces the loop to
iterate block-by-block. For directories with large sparse holes, could this
lead to severe performance degradation and soft lockups?

> +		if (unlikely(map.m_pblk =3D=3D bh->b_blocknr)) {

[Severity: High]
Can this equality check miss aliases if the mapped extent spans multiple
blocks, allowing a memory corruption regression?

Because ext4_map_blocks() can return a multi-block extent with map.m_len > =
1,
the newly allocated block bh->b_blocknr might fall in the middle of a
previously allocated multi-block extent.

If bh->b_blocknr is within the range from map.m_pblk to
map.m_pblk + map.m_len - 1, this exact match check will evaluate to false,
failing to prevent the alias.

Should this check account for the extent length?

> +			EXT4_ERROR_INODE(inode,
> +					 "new block %llu already mapped",
> +					 (unsigned long long)bh->b_blocknr);
> +			err =3D -EFSCORRUPTED;
> +			goto out;
> +		}
> +	}
> +
>  	inode->i_size +=3D inode->i_sb->s_blocksize;
>  	EXT4_I(inode)->i_disksize =3D inode->i_size;
>  	err =3D ext4_mark_inode_dirty(handle, inode);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261005003528.9204=
6-1-adrianox@gmail.com?part=3D1
