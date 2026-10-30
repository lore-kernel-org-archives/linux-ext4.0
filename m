Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376611;
	b=tkZAtJkzRLYWajfBwqEGLbuozlUIiMjoAFf5Fow9jLTq+IpVe5WQ2UuYgEf6hdhmUT/y
	 7s9Zk13l395/yQQNbd5iM4aIgwdMZa8Q/8Ml0xHdjl7yDTpeEZAJ/E7Y+EGIScPLUrIFb
	 g2fxVNCr3lPTRdc+I/TLvvJx0hpB+oWtvWidsZLuttCBcNqrR4TeOENaoJwRAd/PCLdb1
	 chXVhvc97Mbhmk973HkC4AYYuBikUEn//d2yr5nnlo/fN7Yfz928x71JKxxtT+e/iOEuJ
	 5f2aArFnINTqJmxuTrk3ChXjBDgEpibjwcHsSzQDFzPz1f0mQUlctp7CbULNKT8FtNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376611;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ZcJMAN1WEDLBmcVjJji36pJ2+2BOXRKD4UYVao+MNcs=;
	b=UF3PPYTrFrjpBncOZZam8HTc8WG7osVNftIgoftU0BcFYHZu1CtEloc6fKUxn7yK01D2
	 2csT0fuKc/XB09ewpgrQ80sXo3PIYhZstJwVdh5nsJffKMIJcTyHqIUv2DnY8aSAj0Sya
	 3fOUdBHqxKTakwCm89WGUfwz+HsQ7JUKLGyC88z3Ikj3gOJ9PIR7BfLTd0EjzCJx42AJr
	 eaIjQTIDd4fncO65qLaF+ZMAe3AfvHnized7gK8oyFp+OczuSe6eU6W5c72R8OMJhSq4J
	 XK21PNQCCp9b58o9VfaLJEAdZbLX1xQf01shR/Dx2vvMSYtVa7GR+IpLUnfL4zRdz1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=inNheHXO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FAD606A33F;
	Fri, 30 Oct 2026 16:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=inNheHXO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A886B1F000C1;
	Fri, 30 Oct 2026 16:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376611;
	bh=ZcJMAN1WEDLBmcVjJji36pJ2+2BOXRKD4UYVao+MNcs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=inNheHXOvVuPpHySy1lgcss7FWDCqOqwgssaDeZy9QPl79AuL9KANuK9zqFV1kA8l
	 lb255VmAdzCOcsye6+bh+3F9QS9Uo7C5fgIvWX+bsZqIZY/HG604zNHiXseXSd5w4R
	 OF1cCcUS5kuB++LDmGFqHz9AcEbvGAtJUn9bQwnJJuXhAG5vfSPWPAOs4a/koPZajE
	 W/B/1AB/GRiz1Rpu4/t8LOYAWZTQVnu2TK3ow7Hws4sPjw/X7PL5E4cacLLptD51TQ
	 ht4YStHkctUhWLuZsMU7+20PtS4GJ3NZIYmwcqCHsvsblL2TQgAFiY+qpb4kWXnhLe
	 UiYsV25nzIsJQ==
Message-ID: <sashiko-outbox-191245@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 26/34] gfs2: don't set SB_RDONLY on withdraw
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-26-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-26-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:10:10 +0000
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
- [Critical] gfs2: missing withdraw check in gfs2_aspace_writepages() after=
 SB_RDONLY drop
- [High] gfs2: double freeze glock acquisition in gfs2_freeze_super() error=
 path
- [High] gfs2: gfs2_freeze_fs() allows freezing withdrawn fs after journal =
clear
--

commit 492245d825d0faf64cbdfa5077542cb35552bb3d
Author: Christian Brauner <brauner@kernel.org>

gfs2: don't set SB_RDONLY on withdraw

This commit stops setting SB_RDONLY in do_withdraw() so that thawing and
unmounting a withdrawn filesystem do not leave s_writers rwsems locked due
to a read-only superblock. It updates inode eviction, quota sync, inode
writeback, and freeze/thaw handling to check gfs2_withdrawn() directly.

> diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
> index f61c309368ef1..82f9d90f35788 100644
> --- a/fs/gfs2/super.c
> +++ b/fs/gfs2/super.c
> @@ -455,6 +455,9 @@ static int gfs2_write_inode(struct inode *inode, stru=
ct writeback_control *wbc)
>  	int ret =3D 0;
>  	bool flush_all =3D (wbc->sync_mode =3D=3D WB_SYNC_ALL || gfs2_is_jdata(=
ip));
> =20
> +	if (gfs2_withdrawn(sdp))
> +		return -EIO;

[Severity: Critical]
Does checking gfs2_withdrawn(sdp) only in gfs2_write_inode() allow dirty
resource group metadata buffers in sdp->sd_inode->i_mapping to be written to
disk after a withdraw now that do_withdraw() no longer sets SB_RDONLY?

Resource group metadata buffers are allocated in gfs2_aspace(sdp)
(sdp->sd_inode->i_mapping), which uses gfs2_rgrp_aops with
gfs2_aspace_writepages() in fs/gfs2/meta_io.c as its .writepages callback:

fs/gfs2/meta_io.c:gfs2_aspace_writepages() {
	while ((folio =3D writeback_iter(mapping, wbc, folio, &error)))
		gfs2_aspace_write_folio(folio, wbc);
}

When a transaction modifying resource group blocks commits in gfs2_unpin(),
mark_buffer_dirty(bh) marks the folio dirty in sdp->sd_inode->i_mapping and
sets I_DIRTY_PAGES on sdp->sd_inode. If the filesystem then withdraws,
do_withdraw() drains the AIL via gfs2_ail_drain() without clearing BH_Dirty
or the folio dirty state, and gfs2_withdraw_glocks() -> withdraw_glock() in
fs/gfs2/glock.c calls request_demote() without queueing gl->gl_work, leaving
cached resource group glocks with no active holders undemoted and their
dirty buffers in sdp->sd_inode->i_mapping uninvalidated until
gfs2_put_super().

Previously, setting SB_RDONLY in do_withdraw() caused sync_filesystem() and
sync_inodes_one_sb() to return early. Without SB_RDONLY, sync_filesystem()
during sync, remount-ro in gfs2_reconfigure(), or umount in
generic_shutdown_super() runs:

  __writeback_single_inode(sdp->sd_inode, &wbc)
    -> do_writepages(sdp->sd_inode->i_mapping, wbc)
      -> gfs2_aspace_writepages()
        -> gfs2_aspace_write_folio()

which submits writes for those dirty resource group buffers to the block
device without reaching gfs2_write_inode(). Should gfs2_aspace_writepages()
also check gfs2_withdrawn(sdp)?

> @@ -686,7 +689,8 @@ static int gfs2_do_thaw(struct gfs2_sbd *sdp, enum fr=
eeze_holder who, const void
>  	int error;
> =20
>  	error =3D gfs2_freeze_lock_shared(sdp);
> -	if (error)
> +	/* A withdrawn filesystem can't get the freeze glock back, thaw anyway.=
 */
> +	if (error && !gfs2_withdrawn(sdp))
>  		goto fail;
>  	error =3D thaw_super(sb, who, freeze_owner);
>  	if (!error)
> @@ -751,6 +755,11 @@ static int gfs2_freeze_super(struct super_block *sb,=
 enum freeze_holder who,
>  		mutex_unlock(&sdp->sd_freeze_mutex);
>  		return -EBUSY;
>  	}
> +	/* A withdrawn filesystem can't take the freeze glock anymore. */
> +	if (gfs2_withdrawn(sdp)) {
> +		mutex_unlock(&sdp->sd_freeze_mutex);
> +		return -EIO;
> +	}
> =20
>  	for (;;) {

[Severity: High]
Can a withdrawn filesystem still be frozen once do_withdraw() clears
SDF_JOURNAL_LIVE?

Without SB_RDONLY set by do_withdraw(), VFS freeze_super() on a withdrawn
filesystem no longer takes the sb_rdonly(sb) shortcut and instead locks the
s_writers rwsems, calls sync_filesystem(sb), and invokes
sb->s_op->freeze_fs(sb), which is gfs2_freeze_fs() in fs/gfs2/super.c:

fs/gfs2/super.c:gfs2_freeze_fs() {
	if (test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags)) {
		gfs2_log_flush(sdp, NULL, GFS2_LOG_HEAD_FLUSH_FREEZE |
			       GFS2_LFC_FREEZE_GO_SYNC);
		if (gfs2_withdrawn(sdp))
			return -EIO;
	}
	return 0;
}

Because do_withdraw() in fs/gfs2/util.c clears SDF_JOURNAL_LIVE,
gfs2_freeze_fs() skips the if-block and returns 0 instead of -EIO.

If a freeze is triggered via freeze_store() in fs/gfs2/sys.c or
gfs2_freeze_func() in fs/gfs2/super.c (which call VFS freeze_super()
directly rather than gfs2_freeze_super()), or if a withdraw completes during
the msleep(1000) retry loop in gfs2_freeze_super() after the initial
gfs2_withdrawn(sdp) check above, won't freeze_super() succeed on the
withdrawn filesystem and leave s_writers locked? Should gfs2_freeze_fs()
check gfs2_withdrawn(sdp) outside the SDF_JOURNAL_LIVE check?

> @@ -767,6 +776,13 @@ static int gfs2_freeze_super(struct super_block *sb,=
 enum freeze_holder who,
>  			break;
>  		}
> =20
> +		/* Withdrawn meanwhile, don't take the freeze glock again. */
> +		if (gfs2_withdrawn(sdp)) {
> +			(void)thaw_super(sb, who, freeze_owner);
> +			error =3D -EIO;
> +			goto out;
> +		}
> +
>  		(void)gfs2_do_thaw(sdp, who, freeze_owner);

[Severity: High]
When gfs2_lock_fs_check_clean(sdp) fails in gfs2_freeze_super(), doesn't
calling gfs2_do_thaw() below re-initialize sdp->sd_freeze_gh while it is
already queued and holding sdp->sd_freeze_gl in LM_ST_SHARED mode?

Looking at gfs2_lock_fs_check_clean() in fs/gfs2/super.c, if it fails before
gfs2_freeze_unlock(sdp) it never drops the shared freeze glock, and if it
fails after gfs2_freeze_unlock(sdp) (for example, returning -EBUSY when a
journal is dirty or failing during a concurrent withdraw) it jumps to
relock_shared:

fs/gfs2/super.c:gfs2_lock_fs_check_clean() {
	...
	gfs2_freeze_unlock(sdp);

relock_shared:
	error2 =3D gfs2_freeze_lock_shared(sdp);
	gfs2_assert_withdraw(sdp, !error2);

out:
	while (!list_empty(&list)) {
	...
	return error;
}

When gfs2_lock_fs_check_clean() returns a non-zero error to
gfs2_freeze_super() without the filesystem having withdrawn,
sdp->sd_freeze_gh is already holding sdp->sd_freeze_gl in LM_ST_SHARED mode.
Calling gfs2_do_thaw(sdp, who, freeze_owner) then calls
gfs2_freeze_lock_shared(sdp) -> gfs2_glock_nq_init() a second time on
sdp->sd_freeze_gh:

  gfs2_do_thaw()
    -> gfs2_freeze_lock_shared()
      -> gfs2_glock_nq_init(sdp->sd_freeze_gl, ..., &sdp->sd_freeze_gh)
        -> __gfs2_holder_init()

In __gfs2_holder_init() in fs/gfs2/glock.c, INIT_LIST_HEAD(&gh->gh_list)
overwrites sdp->sd_freeze_gh.gh_list while it is still linked on
sdp->sd_freeze_gl->gl_holders, corrupting gl_holders, leaking the glock and
pid references, and triggering the recursive holder check in add_to_queue()
(or if a withdraw races between the gfs2_withdrawn(sdp) check in
gfs2_freeze_super() and gfs2_freeze_lock_shared() in gfs2_do_thaw(),
gfs2_holder_uninit() clears gh_gl =3D NULL while leaving the corrupted list
entry on gl_holders, and gfs2_do_thaw() now ignores the error).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D26
