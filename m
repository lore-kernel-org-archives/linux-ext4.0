Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93863191CA
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 11:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791544593; cv=none; b=YsC59RBhlV3iAqA1GQa8zIUfHzLh3zVnPT295aqKOa3pEvgFUmQVHawEIPT6Q4a+/Hin/y+imRQV9I2a0nnf2ibJpKy9CCePwAjeb7zZrWltri3PavlIp8QSEOtL0PpqpqoFkGU9soVaVvmk53kz9VNOpvBfwIN9/9LAV4SqHkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791544593; c=relaxed/simple;
	bh=jsiHcVijFWXoQGVvW+R2FoK/TG4Ie8RZR1NdAsy1iEY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=EDUCTvSoXzr3qzD5nB5brsnyA1B8gdqTpQexO73LxVZ76Dv0WPf1LSWMttwG2u4rcvM27GtvGG6C60wBhz0PMYrpmiiEON50RBzzzOIeIdxBEKFhEIvX+IvS0iX+Cie9huaZprcKXZ4OQ/C0xKlE1o0ZBDbRQorNQLNxyarPAFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WP+3JXsP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WP+3JXsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBF71F000FF;
	Fri,  9 Oct 2026 11:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791544582;
	bh=XVwLPGavJ3ULvn8UGxq8kVJYM0zXwDsmJR+RruU0c4c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WP+3JXsPYOpyLlavYRdN2DKL0eEjnRdyknxQnvFTeJ5N4CPIbLrvjt61tRreNY550
	 H65Pqc3wC/4XLaBad+jVfL4EY8sxKNhPTyTWSzwMTzh2RNAFLAJJXO7eTnJ8kZlh+H
	 48gSFNZtN4JIzw7Tw55hWaEVE0dD0ERQhjZTTyV6XoSfJC2lkUHMsoHuJWy8lohEbm
	 +UDfAxhL46EJdNFya1MdZfjoSMLowjBdj6cL2luTS/XVRqUIkd/uv9xuBYG5GztlQb
	 hfX7AolA/TWjFgSkm3KXkGv586ouOyyif2OuB9ykyTRHuCiH5c4lcScPFHiusXaL8R
	 L16avTtVwI+ng==
Message-ID: <sashiko-outbox-165341@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 26/31] ext4: clear DISKSIZE_GROW_PENDING on truncate
 or error
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261009103033.2920530-27-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-27-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 11:16:22 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] fs: missing DISKSIZE_GROW_PENDING clear during nlink > 0 eviction
--

commit b90813716147a7864ab2f3a3c46c2814d0084c2b
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: clear DISKSIZE_GROW_PENDING on truncate or error

This commit clears the disksize-grow-pending state on various paths where a
zeroed EOF block is discarded before writeback completes. It also adds a
warning in destroy_inode to catch any inodes that missed clearing the state.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
[ ... ]
> @@ -266,6 +266,8 @@ void ext4_evict_inode(struct inode *inode)
> =20
>  	if (ext4_should_order_data(inode))
>  		ext4_begin_ordered_truncate(inode, 0);
> +	if (ext4_inode_buffered_iomap(inode))
> +		ext4_iomap_clear_disksize_pending(inode);
>  	truncate_inode_pages_final(&inode->i_data);

[Severity: Medium]
When an inode with nlink > 0 is evicted and still has dirty pages (such as
during a forced unmount or after a failed sync_filesystem), ext4_evict_inod=
e()
logs a data loss warning and forcefully truncates the page cache using
truncate_inode_pages_final() before jumping to the no_delete label.

Because the pages are discarded immediately without initiating writeback, t=
he
writeback error path is never invoked, meaning the
EXT4_STATE_DISKSIZE_GROW_PENDING bit is never cleared.

Since the added state clearing logic is placed after the nlink > 0 block, d=
oes
this bypass clearing the bit for those inodes entirely?

[ ... ]
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1497,6 +1497,14 @@ static void ext4_destroy_inode(struct inode *inode)
>  			 "Inode %llu (%p): i_reserved_data_blocks (%u) not cleared!",
>  			 inode->i_ino, EXT4_I(inode),
>  			 EXT4_I(inode)->i_reserved_data_blocks);
> +
> +	if (!(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ERROR_FS) &&
> +	    !ext4_emergency_state(inode->i_sb) &&
> +	    WARN_ON_ONCE(ext4_test_inode_state(inode,
> +				EXT4_STATE_DISKSIZE_GROW_PENDING)))

[Severity: Medium]
Can this assertion be reliably triggered when unmounting a filesystem while
writeback is blocked or fails, since the pending bit is not cleared during
nlink > 0 eviction? This might potentially crash systems with panic_on_warn
enabled.

> +		ext4_msg(inode->i_sb, KERN_ERR,
> +			 "Inode %llu (%p): EXT4_STATE_DISKSIZE_GROW_PENDING not cleared!",
> +			 inode->i_ino, EXT4_I(inode));
>  }
> =20
>  static void ext4_shutdown(struct super_block *sb)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D26
