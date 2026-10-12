Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812BD3ABDA5
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 10:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801702; cv=none; b=F7OgVesxbKsHo/LucWWJX/3ZxPUVpGno8CRaPbKpEsCeFXttDbHqJa3c16D8YkzR1d441pSU9v7qYFuzDFlFWcbN0spZAeCmgTzsBBhyQshaowVIN2hc2O8tN9BX9y5e0iJbJkNtrCZbMBENba6YgPf1Ncjx+0dotiYyfC1nZQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801702; c=relaxed/simple;
	bh=YCiVTxJLRxbV4rFlCw0Iw4rDY6gyykKQ5gFoptuEBbY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=jdqck53OC5cP9LLcYuJ8HgkzGU9fwrwun8X1MmsP+0t3CX/QVVP9BkSqYQT87RrXNTN6ps/EoIK5mtpkowEA1k1FHdilxd6/wapacLbK2+5dPlvFjyhkRt+eJ01mLcLV0PnHOykG9Wa184E2JK03GKfOGWxl5HPbuVt3UiRckjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lXy3tHZD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lXy3tHZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C681F0089B;
	Mon, 12 Oct 2026 10:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801701;
	bh=c6+dfR/B4t8VPrURhz4+xnj9vI1YDgNiB8cok0Ss8jY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lXy3tHZD8PyblK2m8qTkoidi2J0F8WZhGyOVNYpVU+0ov+evyknnaugntTIITiPST
	 JmhWrZT59gBpfn/mne4BOtPSLRzQVmW7+JIOhdmSBGip+TO/DH4RqCyxCNcQhTn9b1
	 nhyq/4XfccQZaL34ka/ko5Zv21ik3NADrKHl/G0qCUvPCy+Xg4rUn7sD03tMWq7/W0
	 YMapTKDEEeje/89D/ix60InhLX8EZtq7jLly2Vgwt+qLLu3bQVsOq0Nw1u3kqb4Fcn
	 JsbDnvTJzGHp2lvHjr8gNqjne1ibPOeD3wHaa8EBk7QG0F+tMriGDBzpUHqAH0PVAt
	 sx9mW5oJO8JJQ==
Message-ID: <sashiko-outbox-167975@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 04/28] jfs: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Mark Fasheh" <mark@fasheh.com>, "Joseph Qi" <joseph.qi@linux.alibaba.com>, "Joel
 Becker" <jlbec@evilplan.org>, tytso@mit.edu, dsterba@suse.cz, linux-ext4@vger.kernel.org
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-4-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-4-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:41:40 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] jfs: mmap writes bypass emergency read-only state
- [High] jfs: remounting with nointegrity bypasses emergency RO protections
- [High] jfs: double log shutdown oops on jfs_unfreeze error path
- [High] jfs: extRecord() omits synchronous commit of synclist anonymous tl=
ocks
--

commit c9dce4eb0ee2105ccd8325a0b887750dd35ed8fb
Author: Christian Brauner <brauner@kernel.org>

jfs: don't set SB_RDONLY after filesystem errors

The commit avoids setting SB_RDONLY on errors to prevent freeze deadlocks,
introducing a private JFS_FLAGS_EMERGENCY_RO flag instead. It updates vario=
us
entry points to check this flag before modifying the filesystem.

Link: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.com

> diff --git a/fs/jfs/file.c b/fs/jfs/file.c
> --- a/fs/jfs/file.c
> +++ b/fs/jfs/file.c

[ ... ]

> @@ -146,7 +160,7 @@ const struct file_operations jfs_file_operations =3D {
>  	.open		=3D jfs_open,
>  	.llseek		=3D generic_file_llseek,
>  	.read_iter	=3D generic_file_read_iter,
> -	.write_iter	=3D generic_file_write_iter,
> +	.write_iter	=3D jfs_file_write_iter,
>  	.mmap_prepare	=3D generic_file_mmap_prepare,

[Severity: High]
Does using the generic VFS VM operations here allow memory-mapped writes to
bypass the new emergency read-only state?

Since SB_RDONLY is no longer set on errors, the generic fault handler
filemap_page_mkwrite will succeed because it only checks sb_rdonly(sb).
This allows dirtying the page. When the VFS writeback daemon processes the
dirty inode, it calls jfs_writepages.

Because jfs_writepages maps already-allocated blocks via jfs_get_block
without calling extAlloc or extRecord, it completely bypasses the new
emergency read-only checks, allowing modifications to be written to disk.

> diff --git a/fs/jfs/jfs_extent.c b/fs/jfs/jfs_extent.c
> --- a/fs/jfs/jfs_extent.c
> +++ b/fs/jfs/jfs_extent.c

[ ... ]

> @@ -270,6 +276,10 @@ int extRecord(struct inode *ip, xad_t * xp)
>  	/* update the extent */
>  	rc =3D xtUpdate(0, ip, xp);
> =20
> +	/* get the anonymous tlocks committed, like extAlloc() does */
> +	if (!rc)
> +		mark_inode_dirty(ip);
> +

[Severity: High]
Does this omit the synchronous commit of synclist anonymous tlocks that
extAlloc() performs?

When xtUpdate() initiates an anonymous transaction, it can flag the inode
with COMMIT_Synclist and set nohomeok > 0 if the metapage is already on
the journal's synclist.

While extAlloc() explicitly tests for COMMIT_Synclist and calls
jfs_commit_inode() synchronously to clear this state, extRecord() does
not. This leaves the metapages pinned in memory. If a concurrent operation
calls jfs_flush_journal(), it can stall indefinitely waiting for the
synclist to empty, leading to a hang or bug in the journal thread.

> diff --git a/fs/jfs/super.c b/fs/jfs/super.c
> --- a/fs/jfs/super.c
> +++ b/fs/jfs/super.c

[ ... ]

> @@ -367,6 +388,11 @@ static int jfs_reconfigure(struct fs_context *fc)
>  	int flag =3D ctx->flag;
>  	int ret;
> =20
> +	/* An error made the filesystem read-only until it is unmounted. */
> +	if (jfs_emergency_ro(sb) && (ctx->resize || (sb_rdonly(sb) && !readonly=
)))
> +		return -EROFS;
> +

[Severity: High]
Can a remount command that toggles nointegrity bypass this read-only guard?

If the filesystem was originally mounted read-write, sb_rdonly(sb) is
false. A remount command that only toggles nointegrity evaluates to false
in this guard and proceeds down the function.

Further down in jfs_reconfigure:

	if ((JFS_SBI(sb)->flag & JFS_NOINTEGRITY) !=3D (flag & JFS_NOINTEGRITY)) {
		if (!sb_rdonly(sb)) {
			rc =3D jfs_umount_rw(sb);

This block would be erroneously executed, calling jfs_umount_rw(). That
function flushes block and inode maps to disk and closes the log, which
violates the guarantee that nothing may be written after an error, and
risks severe metadata corruption.

[ ... ]

> @@ -616,15 +657,19 @@ static int jfs_unfreeze(struct super_block *sb)
>  	struct jfs_log *log =3D sbi->log;
>  	int rc =3D 0;
> =20
> -	if (!sb_rdonly(sb)) {
> +	/* Undo what jfs_freeze() did, also if an error happened meanwhile. */
> +	if (test_bit(JFS_FLAGS_LOG_SHUTDOWN, &sbi->jfs_flags)) {
>  		rc =3D updateSuper(sb, FM_MOUNT);
>  		if (rc) {
>  			jfs_error(sb, "updateSuper failed\n");
>  			goto out;
>  		}
>  		rc =3D lmLogInit(log);
> -		if (rc)
> +		if (rc) {
>  			jfs_error(sb, "lmLogInit failed\n");
> +			goto out;
> +		}
> +		clear_bit(JFS_FLAGS_LOG_SHUTDOWN, &sbi->jfs_flags);
>  out:
>  		txResume(sb);
>  	}

[Severity: High]
If lmLogInit() or updateSuper() fails, does this leave the log state
desynchronized?

By jumping to out without clearing JFS_FLAGS_LOG_SHUTDOWN, the flag
remains set while the log is still shut down (log->bp is NULL).

Later, when the filesystem is unmounted, jfs_umount calls lmLogClose(),
which unconditionally calls lmLogShutdown() if the log is inactive.
lmLogShutdown() will then dereference the NULL pointer, triggering
the exact null pointer dereference this patch originally intended
to fix.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D4
