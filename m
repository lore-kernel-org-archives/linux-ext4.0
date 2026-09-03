Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043384B1277
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 13:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788443235; cv=none; b=K89icJ0ATMKrOwpDwdF+lrsHsTWrsNqpy1gGJWROSgRzcMnWh+SruNKUWzOpJO136PyogcPWHs+1QvRsTPs32RS51m8Ii3jWqNqeL1XJdCaMoPDWuXHvmO8BkKtXpn5miArV0vt2lAx9P0pwOurGai6qmXzm4uwjyz/JfbrWRNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788443235; c=relaxed/simple;
	bh=askqbBmuMDrMS1gAbJOnQYAwFFt0bMvLeESdNXXZ2cU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=A4OaJQcqrIc4SgqjXo0do8HKCMFVXtvnDNgQZkCW6jjQiDllZyPfkVzDCZg69cRu+3vI0kwN5KhglhyL1WQMhm6cGQFZJTpjwe2jEZISwracW8VcV9+ka1ut4fOOd96RTDsLIWYTy2LszIZ7DjvhtGyzZALqkVDK+dAyXd9UwmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QkaAjiGv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QkaAjiGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FDE1F00ACA;
	Thu,  3 Sep 2026 13:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788443217;
	bh=YmUniuH+1lGYDnXZ25P4lMeVxZnl8xNmZC1dpZGIuqA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QkaAjiGvqlgbZCbxEM+glljM0gpaiKZ3b2s2oa3F5jJWWy8iHex6koEeQKAApvmBa
	 1aN7/BAucLZs281y0FoacwNSX/qiWT73RPcxfqWNBk9/VO5hut1CArHI/NRcGMByLD
	 PjfdhpTRcYgSSPBC4e+eU9zGLxu1WiZMS6rkF1Q7FtRocCvkP53OwSF5OY4fcxwB9j
	 s2L+DTIrEc3GrwIH2DbUujjOFKNpKRC3MCte4qlzR+hj9jfzScFgpPWZZatuMvOLLd
	 CiJhn/fkN1HE3+tmiY3zsd4hkp/DEEU6PPwijCYU0hrYTJ8QcilxWtAl8lIYsu1e7g
	 Kv1gKS9RdYE/g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 26/31] ext4: clear DISKSIZE_GROW_PENDING on truncate
 or error
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260903123543.2302999-27-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-27-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 13:46:56 +0000
Message-Id: <20260903134656.C9FDE1F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Unconditional advancement of i_disksize in ext4_truncate_down expo=
ses unwritten data and corrupts the disksize pending state.
- [Medium] EXT4_STATE_DISKSIZE_GROW_PENDING is not cleared when evicting an=
 inode with i_nlink > 0 or a bad inode, leading to a spurious WARN_ON_ONCE =
in ext4_destroy_inode().
--

commit ce48fe2572983c4095fed45d85327a228bcb48f0
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: clear DISKSIZE_GROW_PENDING on truncate or error

This commit clears the DISKSIZE_GROW_PENDING state on error paths, such
as folio discard and unlinked inode eviction, as well as during truncation.
It aims to prevent writeback from blocking indefinitely when a zeroed EOF
block is discarded, and adds a warning if an inode is destroyed with the
bit still set.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 173ac69e9b953..f38437fa91064 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c

[ ... ]

> @@ -273,6 +273,8 @@ void ext4_evict_inode(struct inode *inode)
> =20
>  	if (ext4_should_order_data(inode))
>  		ext4_begin_ordered_truncate(inode, 0);
> +	if (ext4_inode_buffered_iomap(inode))
> +		ext4_iomap_clear_disksize_pending(inode);
>  	truncate_inode_pages_final(&inode->i_data);
> =20

[Severity: Medium]
Does this miss clearing the pending bit for linked inodes (i_nlink > 0)
or bad inodes?

If writeback fails for an inode with a pending zeroed EOF block, and the
filesystem is unmounted, evict_inodes() unconditionally evicts all inodes.
Earlier in ext4_evict_inode(), the code truncates pages for linked inodes
and then jumps to the no_delete label:

	if (inode->i_nlink) {
		...
		truncate_inode_pages_final(&inode->i_data);
		...
		goto no_delete;
	}

This jump bypasses the new ext4_iomap_clear_disksize_pending() cleanup here.

Could this result in the pending bit remaining set and triggering the new
WARN_ON_ONCE in ext4_destroy_inode() when the inode is finally destroyed?

[ ... ]

> @@ -6765,7 +6776,18 @@ static int ext4_truncate_down(struct inode *inode,=
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
> +
> +	i_size_write(inode, newsize);
> +	__ext4_set_i_disksize(inode, newsize);
> +	up_write(&EXT4_I(inode)->i_data_sem);
> =20
>  	ret =3D ext4_mark_inode_dirty(handle, inode);
>  	ext4_journal_stop(handle);

[Severity: High]
Could unconditionally advancing i_disksize here expose unwritten data or le=
ak
the pending bit?

If ftruncate() is called with a newsize that is smaller than i_size but
strictly greater than i_disksize, the condition
(newsize <=3D EXT4_I(inode)->i_disksize) evaluates to false. The pending bi=
t is
not cleared.

However, __ext4_set_i_disksize(inode, newsize) then unconditionally advances
i_disksize past the safely written data.

If a crash occurs before the dirty pages up to newsize are written back, wi=
ll
this expose stale or uninitialized data on disk since data ordering is not
guaranteed for the iomap path?

Additionally, if newsize is block-aligned, would the writeback thread later
hitting ext4_iomap_get_disksize_pending_range() encounter a WARN_ON_ONCE
because i_disksize was updated to a block-aligned value, preventing the ioe=
nd
from ever clearing the pending bit?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D26
