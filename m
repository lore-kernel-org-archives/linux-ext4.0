Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A6336B934
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 10:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801580; cv=none; b=sEo6dy+1AUwXkOcAQXtJV6cTO6D7Z1W34BS9/99Zk0OXByHKRY+JdR7XNYPyw2L3zrkhNNISHdrx7d8BNtc6ej6WfVtz/TZdvSQw/THTHlDavQ3UB8SqRchavCdwZBKegsE2yX/LGwWtUOgUkFOnBjV4vrEQ2RqNO41Y/NE5350=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801580; c=relaxed/simple;
	bh=e39JtHgcqt1f7xkCAnQbx2eCH2T3xa6dmCBEmsPan1A=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=mf0SnFp/lvXvpnI/hj4p013ANBFY5HQWJyTH9Ej1neC+PTgNQmynz4kPnE9gjc1jq3X47GAM7jTwd0LysZEmF4I6jla46wQt6hJBuGc9ADTNrT98EkX0uFMBjPaULLDDZ3DLFkFOqZiYRxQA5ASPiJrncqnkieeD/fw8dEaKBXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=blgTV+vl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="blgTV+vl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0A61F0089B;
	Mon, 12 Oct 2026 10:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801578;
	bh=kWuMwvNbb9ZSMwFkf5ubyXRHUOVWbhm4REIDPFcZkm0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=blgTV+vlnfJQrlLbYMx/Fh4xQZXy9Z7S0st9UQ6xztFzKNzn8nL27fvgbkprG/TuR
	 LKG8LfKUem72xfWUMG1mGYfIqud8NzH68zoypxnUvhVTY6zYcDfirnzIIdHA1VpAd6
	 0hfFUV2+lV4wfnKzKRYfwtR85WHkdsmfSwNljY8wyhMbZlSqIV2eF1yvWGbf0Uh0PO
	 YCe2rSL5KBUKVkNmRnAWHLhVrhkEJj5f4phT5eSTrT2mLxelV0LRzJnJkInxxXqYb0
	 Q6/Q5BEbn6SzX/awtKhm9QEZtEYbf/Dk4xCBKdKyjVwK4RvvBlno9Vkw8Mw8+pTP35
	 e4qMf0rpM3k/Q==
Message-ID: <sashiko-outbox-167972@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 12/28] ufs: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>, dsterba@suse.cz, tytso@mit.edu
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-12-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-12-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:39:37 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ufs: writeback, mmap, and eviction bypass emergency read-only state
--

commit 6478a7f3e3ddcde9a7105fb1b9035fa4059fa6a4
Author: Christian Brauner <brauner@kernel.org>

ufs: don't set SB_RDONLY after filesystem errors

This commit replaces the setting of the VFS SB_RDONLY flag on filesystem
errors with a custom UFS_STATE_EMERGENCY_RO state flag. This prevents
thaw_super() from hanging, while preventing new modifications by returning
-EROFS in VFS-level UFS functions.

> diff --git a/fs/ufs/super.c b/fs/ufs/super.c
> index 3569ac92b065b..ba2dd4502869c 100644
> --- a/fs/ufs/super.c
> +++ b/fs/ufs/super.c
> @@ -280,11 +280,17 @@ void ufs_error (struct super_block * sb, const char=
 * function,
>  	uspi =3D UFS_SB(sb)->s_uspi;
>  	usb1 =3D ubh_get_usb_first(uspi);
>  =09
> -	if (!sb_rdonly(sb)) {
> +	/*
> +	 * Don't set SB_RDONLY: that requires sb->s_umount and a proper
> +	 * remount. Set while the superblock is frozen it makes thaw_super()
> +	 * skip releasing s_writers and every later writer hangs. Refuse
> +	 * modifications until umount instead.
> +	 * The superblock buffer marked bad goes out with the block device.
> +	 */
> +	if (!sb_rdonly(sb) &&
> +	    !test_and_set_bit(UFS_STATE_EMERGENCY_RO, &UFS_SB(sb)->s_state)) {
>  		usb1->fs_clean =3D UFS_FSBAD;
>  		ubh_mark_buffer_dirty(USPI_UBH(uspi));
> -		ufs_mark_sb_dirty(sb);
> -		sb->s_flags |=3D SB_RDONLY;

[Severity: High]
With the removal of the VFS SB_RDONLY flag here, are background VFS operati=
ons
now able to bypass the emergency read-only state?

Since the VFS is no longer aware of the read-only state, it appears that
background writeback and eviction operations will continue to run.

For example, ufs_writepages() in fs/ufs/inode.c lacks a check for
ufs_emergency_ro(). Dirty pages dirtied before the error occurred could sti=
ll
be flushed to disk, and mpage_writepages() could allocate new blocks by
calling ufs_getfrag_block() with create=3D1.

Memory-mapped writes use filemap_page_mkwrite(), which invokes
ufs_write_begin(). Without an emergency RO check in ufs_write_begin(),
userspace could continue to dirty mapped pages and allocate new blocks.

Additionally, ufs_evict_inode() processes unlinked files when they are clos=
ed.
It unconditionally calls ufs_truncate_blocks(), ufs_update_inode(), and
ufs_free_inode(). These functions modify block/inode bitmaps and call
ubh_mark_buffer_dirty().

Because the block layer's flusher will sync these dirty buffer heads to the
underlying block device, could this silently write data and metadata
modifications to a corrupted disk while the filesystem is in the emergency
read-only state?

>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D12
