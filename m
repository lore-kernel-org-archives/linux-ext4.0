Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376613;
	b=jJghoOtY4zgoEyX2FuyGSlptkrmyXgQW3dKfskAegvRt01MASZePgk+DUv3m60TkSClb
	 4Yj7voYNaqjtJ8vISHtCc2uwcu3ztrl1CtD8ilmUPtoBz6kEF98AwNz9KXnQm3I9uUjU/
	 ncdHlEB2GaWoZ82W+K6zJnVNh6UzCvYWhSSubAtUAHijJ35tWPAzsOEVnOyQlJgwACUSd
	 WzdMbb+hFBwamBcxq9tOm/hi1dfaQtSavcah62025rkT3D8IaQELa5PGC3ga40/7cYBWN
	 +JCJ/uYsg6eL37Sbsxe7SqOusnJ4cDcbn2FRlIjxQ7y230dRnICUboqQnPNk0P+VRhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376613;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=kAiqGPacwqkp7RD0t/j3EiiQ5JgxsosdAwoGl+0dweM=;
	b=BZRbni3JFxqwvD3a7qzvkyd6CBfk3ARKLaugSvckHKAufOzsAuJElPm5n8A/UsK49egm
	 KXJJM3m7ii9gudDUUVGhAfXI8P/U/2lgUyIB3ttk8jgJ/d7vhuNdPfzsQMTXx2FiBjhW3
	 WCPPvscW37zFCcm2LPJx026TkVsqQE514ltpWR8uc4Zt2T6btiRuGIrM0n57t3y4uPbTp
	 hTzcyU2U9hp8X2B/LvC2lB1UWZ8M3Qg4jEUhK/OFjsuGFCj8WmzBj4OOzplowj+870xSj
	 dxKfrq6jB3zq27A8/pKpFyduzVMdVBCXwX+eHCStf8yNvOrTljLMAA/cjIzradVTebw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="RcjTV/4o";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C25606A332;
	Fri, 30 Oct 2026 16:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RcjTV/4o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C8E1F000C1;
	Fri, 30 Oct 2026 16:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376612;
	bh=kAiqGPacwqkp7RD0t/j3EiiQ5JgxsosdAwoGl+0dweM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RcjTV/4oMe4pBc6xB0mYkpnOSBS30rDBSF7w9Pt40fq6gIHr4zglrd4OTeyNkgH8G
	 QPa37rUgDBshDdKLBItzg3vkQkeMSDQ598L3D743yUtza3ZeEsxxmbAb8sSKLP/nlC
	 oH/R9VXhkzyMLGHF+FDoLWvlhQp7rFg5At1cjmD2ZIpEHG2OviCuR/hEt8KYXM2cyI
	 6tWddnFVBOY1pBp7p/V/htIwFZuDMps9Tb/1XKESVb0LSfNFiF1uBhIlRro6iLAOS6
	 extA0sPCMF5/DmOQT4y1aM0nN71pXea8jo8jFn0y3ra/S1xiTgdzjoqURXlnBG/AcZ
	 0j/afep/4oekg==
Message-ID: <sashiko-outbox-191247@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 28/34] ubifs: don't set SB_RDONLY after errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-28-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-28-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:10:12 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] ubifs: writeback and ubifs_remount_ro() run inconsistently after r=
o_error
- [Medium] ubifs: unguarded assert in ubifs_reconfigure() when remounting a=
fter ro_error
- [Medium] ubifs: setting SB_RDONLY before SB_BORN in ubifs_ro_mode() desyn=
cs ro state
--

commit 3140481bddfcfa10cd4b3bde25d5a8913266c1e3
Author: Christian Brauner <brauner@kernel.org>

ubifs: don't set SB_RDONLY after errors

This commit stops setting SB_RDONLY in ubifs_ro_mode() once SB_BORN is set =
on
the superblock, calling sb_set_emergency_ro() instead. It also allows
read-only remounts to proceed through ubifs_remount_ro() after an error and
checks c->ro_error in the xattr setters.

> diff --git a/fs/ubifs/io.c b/fs/ubifs/io.c
> index 6c6d682427793..7a59aa1ea5ce9 100644
> --- a/fs/ubifs/io.c
> +++ b/fs/ubifs/io.c
> @@ -72,7 +72,14 @@ void ubifs_ro_mode(struct ubifs_info *c, int err)
>  	if (!c->ro_error) {
>  		c->ro_error =3D 1;
>  		c->no_chk_data_crc =3D 0;
> -		c->vfs_sb->s_flags |=3D SB_RDONLY;
> +		/*
> +		 * Before SB_BORN the mounter holds s_umount, later see
> +		 * sb_set_emergency_ro().
> +		 */
> +		if (!(c->vfs_sb->s_flags & SB_BORN))
> +			c->vfs_sb->s_flags |=3D SB_RDONLY;
> +		else
> +			sb_set_emergency_ro(c->vfs_sb);

[Severity: Medium]
Can setting SB_RDONLY instead of calling sb_set_emergency_ro() before SB_BO=
RN
is set race on sb->s_flags and leave c->ro_mount and SB_STATE_EMERGENCY_RO =
out
of sync with sb->s_flags?

In mount_ubifs(), c->ro_mount is latched once at entry and the background
thread c->bgt is started before vfs_get_tree() sets SB_BORN:

fs/ubifs/super.c:mount_ubifs() {
	c->ro_mount =3D !!sb_rdonly(c->vfs_sb);
	...
	if (!c->ro_mount) {
		/* Create background thread */
		c->bgt =3D kthread_run(ubifs_bg_thread, c, "%s", c->bgt_name);
}

Before vfs_get_tree() sets SB_BORN, ubifs_ro_mode() can be called without
failing the mount if an assertion fails under the default ASSACT_RO action =
in
ubifs_assert_failed() during mount_ubifs() or ubifs_iget(sb, UBIFS_ROOT_INO=
),
or if ubifs_bg_thread() wakes up after ubifs_fill_super() unlocks
c->umount_mutex and hits an error in ubifs_bg_wbufs_sync() or run_bg_commit=
().

If c->bgt calls ubifs_ro_mode() before SB_BORN is set, modifying
c->vfs_sb->s_flags |=3D SB_RDONLY happens without holding s_umount while the
mounter thread is modifying sb->s_flags in vfs_get_tree().

In addition, the mount finishes with SB_RDONLY set on sb->s_flags,
c->ro_error =3D=3D 1, c->ro_mount =3D=3D 0, and SB_STATE_EMERGENCY_RO clear:

fs/ubifs/super.c:ubifs_reconfigure() {
	if (c->ro_mount && !(fc->sb_flags & SB_RDONLY)) {
		if (c->ro_error) {
			ubifs_msg(c, "cannot re-mount R/W due to prior errors");
			return -EROFS;
		}
		...
	} else if (!c->ro_mount && (fc->sb_flags & SB_RDONLY)) {
		/* After an error ubifs_remount_ro() can't write but still works. */
		ubifs_remount_ro(c);
	}
}

Because sb_emergency_ro(sb) is false and c->ro_mount is 0, a subsequent
remount to read-write passes both reconfigure_super() and ubifs_reconfigure=
()
and clears SB_RDONLY, while a remount to read-only sees sb_rdonly(sb) as tr=
ue
in reconfigure_super() and skips sb_prepare_remount_readonly() and
sb_start_ro_state_change() before calling ubifs_remount_ro().

Should ubifs_ro_mode() call sb_set_emergency_ro(c->vfs_sb) unconditionally?

[ ... ]

> diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
> index 38972786817e7..ef39da4e780b7 100644
> --- a/fs/ubifs/super.c
> +++ b/fs/ubifs/super.c
> @@ -1977,10 +1977,7 @@ static int ubifs_reconfigure(struct fs_context *fc)
>  		if (err)
>  			return err;
>  	} else if (!c->ro_mount && (fc->sb_flags & SB_RDONLY)) {
> -		if (c->ro_error) {
> -			ubifs_msg(c, "cannot re-mount R/O due to prior errors");
> -			return -EROFS;
> -		}
> +		/* After an error ubifs_remount_ro() can't write but still works. */

[Severity: High]
Does allowing ubifs_remount_ro() to run after c->ro_error is set cause a NU=
LL
pointer dereference on c->write_reserve_buf or trigger assertions in
reserve_space() and ubifs_wbuf_sync_nolock()?

Previously, ubifs_ro_mode() set SB_RDONLY on sb->s_flags (causing
sync_filesystem() to return early via sb_rdonly(sb)), and ubifs_reconfigure=
()
refused to call ubifs_remount_ro(c) when c->ro_error was set.

With SB_RDONLY no longer set on error, writeback still runs
ubifs_writepages() -> ubifs_writepage(). When a dirty folio extends past
ui->synced_i_size, ubifs_writepage() calls ubifs_write_inode():

fs/ubifs/file.c:ubifs_writepage() {
		if (folio_pos(folio) + len > synced_i_size) {
			err =3D inode->i_sb->s_op->write_inode(inode, NULL);
			if (err)
				goto out_redirty;
		}
		return do_writepage(folio, len);
}

In ubifs_write_inode(), ubifs_jnl_write_inode() fails with -EROFS when
c->ro_error is set without updating ui->synced_i_size, but ubifs_write_inod=
e()
still clears ui->dirty =3D 0:

fs/ubifs/super.c:ubifs_write_inode() {
	if (inode->i_nlink) {
		err =3D ubifs_jnl_write_inode(c, inode);
		if (err)
			ubifs_err(c, "can't write inode %llu, error %d",
				  inode->i_ino, err);
		else
			err =3D dbg_check_inode_size(c, inode, ui->ui_size);
	}

	ui->dirty =3D 0;
	mutex_unlock(&ui->ui_mutex);
	ubifs_release_dirty_inode_budget(c, ui);
	return err;
}

ubifs_writepage() then jumps to out_redirty and calls
folio_redirty_for_writepage(), which re-marks the folio PAGECACHE_TAG_DIRTY
and marks the inode I_DIRTY_PAGES without calling ubifs_dirty_inode(), leav=
ing
ui->dirty =3D=3D 0 while requeue_inode() puts the inode back onto wb->b_dir=
ty.

If sync_inodes_sb() during ubifs_reconfigure() is the first writeback pass =
to
hit c->ro_error on that inode (for example, if writeback_inodes_sb() stopped
earlier after exhausting work->nr_pages or its time slice in
writeback_sb_inodes(), or skipped the inode while I_SYNC was set),
sync_filesystem() finishes with the redirtied folio still on wb->b_dirty and
ui->dirty =3D=3D 0.

ubifs_reconfigure() ignores the return value of sync_filesystem() and calls
ubifs_remount_ro(), which frees c->write_reserve_buf and sets c->ro_mount =
=3D 1:

fs/ubifs/super.c:ubifs_remount_ro() {
	kfree(c->write_reserve_buf);
	c->write_reserve_buf =3D NULL;
	vfree(c->ileb_buf);
	c->ileb_buf =3D NULL;
	ubifs_lpt_free(c, 1);
	c->ro_mount =3D 1;
}

When background writeback (wb_workfn) subsequently flushes wb->b_dirty,
ubifs_writepage() calls ubifs_write_inode() again. Because ui->dirty is 0,
ubifs_write_inode() returns 0 immediately, and ubifs_writepage() proceeds i=
nto
do_writepage() -> ubifs_jnl_write_data():

fs/ubifs/journal.c:ubifs_jnl_write_data() {
	data =3D kmalloc(dlen + auth_len, GFP_NOFS | __GFP_NOWARN);
	if (!data) {
		allocated =3D 0;
		mutex_lock(&c->write_reserve_mutex);
		data =3D c->write_reserve_buf;
	}

	data->ch.node_type =3D UBIFS_DATA_NODE;
}

If kmalloc() fails under memory pressure, data =3D c->write_reserve_buf is =
NULL
and data->ch.node_type dereferences NULL. Even if kmalloc() succeeds,
make_reservation() -> reserve_space() hits
ubifs_assert(c, !c->ro_media && !c->ro_mount) before checking c->ro_error:

fs/ubifs/journal.c:reserve_space() {
	ubifs_assert(c, !c->ro_media && !c->ro_mount);
	squeeze =3D (jhead =3D=3D BASEHD);
again:
	mutex_lock_nested(&wbuf->io_mutex, wbuf->jhead);

	if (c->ro_error) {
		err =3D -EROFS;
		goto out_unlock;
	}
}

Furthermore, unlike ubifs_put_super() (which guards ubifs_wbuf_sync() with
if (!c->ro_error)), ubifs_remount_ro() and ubifs_sync_fs() call
ubifs_wbuf_sync() -> ubifs_wbuf_sync_nolock(), which evaluates wbuf geometry
assertions before checking c->ro_error:

fs/ubifs/io.c:ubifs_wbuf_sync_nolock() {
	ubifs_assert(c, !(wbuf->avail & 7));
	ubifs_assert(c, wbuf->offs + wbuf->size <=3D c->leb_size);
	ubifs_assert(c, wbuf->size >=3D c->min_io_size);
	ubifs_assert(c, wbuf->size <=3D c->max_write_size);
	ubifs_assert(c, wbuf->size % c->min_io_size =3D=3D 0);
	ubifs_assert(c, !c->ro_media && !c->ro_mount);
	if (c->leb_size - wbuf->offs >=3D c->max_write_size)
		ubifs_assert(c, !((wbuf->offs + wbuf->size) % c->max_write_size));

	if (c->ro_error)
		return -EROFS;
}

If c->ro_error was triggered by a mid-write failure in
ubifs_wbuf_write_nolock() after advancing wbuf->offs while wbuf->used > 0 a=
nd
before updating wbuf->size, those assertions can fire during
ubifs_remount_ro() or ubifs_sync_fs().

>  		ubifs_remount_ro(c);

[Severity: Medium]
Can remounting read-only after a garbage collection error trigger the
c->lst.taken_empty_lebs > 0 assertion at the end of ubifs_reconfigure()?

At the end of ubifs_reconfigure(), the code checks:

fs/ubifs/super.c:ubifs_reconfigure() {
	if (!c->need_recovery)
		ubifs_assert(c, c->lst.taken_empty_lebs > 0);
}

When c->lst.taken_empty_lebs is 1 (holding only the reserved GC LEB
c->gc_lnum), ubifs_garbage_collect() -> ubifs_garbage_collect_leb() ->
move_nodes() -> switch_gc_head() consumes c->gc_lnum and sets c->gc_lnum =
=3D -1.
Once the first node is written to the GC write-buffer, bud_wbuf_callback() =
->
ubifs_update_one_lp() -> ubifs_change_lp() decrements c->lst.taken_empty_le=
bs
to 0.

If an error then occurs in move_nodes() or gc_sync_wbufs() before a new
c->gc_lnum is retained, ubifs_garbage_collect() switches to read-only error
mode with c->ro_error =3D=3D 1, c->gc_lnum =3D=3D -1, and
c->lst.taken_empty_lebs =3D=3D 0:

fs/ubifs/gc.c:ubifs_garbage_collect() {
out:
	ubifs_assert(c, ret < 0);
	ubifs_assert(c, ret !=3D -ENOSPC && ret !=3D -EAGAIN);
	ubifs_wbuf_sync_nolock(wbuf);
	ubifs_ro_mode(c, ret);
	mutex_unlock(&wbuf->io_mutex);
	if (lp.lnum !=3D -1)
		ubifs_return_leb(c, lp.lnum);
	return ret;
}

Now that ubifs_reconfigure() no longer returns -EROFS on a read-only remount
when c->ro_error is set, should the assertion at the end of
ubifs_reconfigure() also be guarded by !c->ro_error, similar to
ubifs_put_super()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D28
