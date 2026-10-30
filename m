Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376592;
	b=1m4gp55y4GjG0BHkP1lkf2o1YJ8SYhyWlLOq5wX2qzjY8H0eYTwpzf+LdFuDXJSuDO+H
	 ogg6eDhAtrKPCfNGA0KpHJxCeeh1i3J/+7VaJNuBdCpuTWp5ryGJ22tdHoczI1CEOejKr
	 6QIoVc2B9A2LnQa0+4ag5RSe8J5CoHww6ew0W+S5KchafpPKysfPQf6DomfQcZdiyRZnS
	 OHnlCxfnQhYuXlIK+6fiFd9LS1MQAtjVgWFV6kC11vjiqtfL8UdZ/Q0F1P2Xgd4Qng6Fp
	 wrINsrsSKjH+6Sfl7kmppR+qzRkDb0ywDSgn3gwhlulyC/RMa49gpDB+/Xrry3R1pmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376592;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bXdDkLDRoQfo0RDcxKVzZBJ1sPUWnSU51HFGyOfej4k=;
	b=O/8+uwYlQvtMFV6GzzQjkECvHaVq5TX03XuWtLGal+je4qUN6KWTW0QkzEVHLtgwgNUp
	 XYMrShVcqAN0gqUUdNl9BZWXVS2aRPShwwC3tJ59mRz9+wjML3+pkEI25yaKhZ5PunedH
	 kpoqKu9rTrvmccLePdz0hpxwARSKXMSs+PNOY40HeAx1tTbSYaiO0eyPzrX7gmmUAgf2j
	 VGEwQ/nrfVOY41sSdwhOJp2Sh7w1TDUddNr6lYy1hoxeuqh6rUGAoLE3d04AwESt2i3mj
	 P9YOWttJ3ILG+Nd7e9cm9MOJKl3jjfLz11CVekyssoiIbaxO96k/lXZT/UO4HYwkjyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PfRb7zlK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C26606A330;
	Fri, 30 Oct 2026 16:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PfRb7zlK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CC61F00A17;
	Fri, 30 Oct 2026 16:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376591;
	bh=bXdDkLDRoQfo0RDcxKVzZBJ1sPUWnSU51HFGyOfej4k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PfRb7zlK3p1uNnvx3Ov4FLVxblzsklQrJh/YO3Z8iV6j3TtkBBmecG96JvE2fAKfF
	 aHF+WdNcgwv90aphI7rsDhbSi/3uRGFpZVhrii67yHqKCzmiznqsEVOOreNgteURKT
	 bqVNkaIW8I97eyHWNS7sFZS5NyCQ2vVyp6NIzc0cpEfayy5QedTUhh2tyK0vxTw1c3
	 gNJiWlfeaGm/+A5ZJezGe3j6Ehy7VJ+JzYU2S7ACEB/B4YoVyqmJzYoP1p2jrxnaTh
	 FuoZCaHWS+XJpdlLrEbv9AX/LK8HQaoOIK1TgrtZpBH7FACtFac79/2/2Lr/wQo7sD
	 UloeYHujID5NA==
Message-ID: <sashiko-outbox-191224@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 05/34] jfs: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, "Karl
 Mehltretter" <kmehltretter@gmail.com>, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-5-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-5-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:09:51 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] jfs: jfs_reconfigure() allows rw remount and mutates sbi->flag in =
emergency_ro
- [High] jfs: uncommitted anon tlocks on error in extRecord() and extAlloc()
- [High] jfs: updateSuper() clobbers FM_DIRTY in jfs_unfreeze() under JFS_N=
OINTEGRITY
- [High] jfs: race between jfs_reconfigure() and in-flight allocations trig=
gers BUG_ON
- [Medium] jfs: jfs_reconfigure() does not recheck sb_emergency_ro() after =
sync
--

commit 2a162200f78051c6110938dcdd3b265d4583997b
Author: Christian Brauner <brauner@kernel.org>

jfs: don't set SB_RDONLY after filesystem errors

This commit replaces direct setting of SB_RDONLY in jfs_handle_error() with
sb_set_emergency_ro() so that errors occurring while frozen do not cause
thaw_super() to skip jfs_unfreeze(). It also tracks log shutdown state in
JFS_FLAGS_LOG_SHUTDOWN and adds sb_emergency_ro() checks across JFS
allocation, metadata modification, freeze, sync, and remount paths.

Link: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.com

> diff --git a/fs/jfs/jfs_extent.c b/fs/jfs/jfs_extent.c
> index 46529bcc8297e..ba55e0bbecd24 100644
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
>  	mutex_unlock(&JFS_IP(ip)->commit_mutex);
>  	return rc;
>  }

[Severity: High]
What happens in extRecord() and extAlloc() if xtUpdate(), xtExtend(), or
xtInsert() fails after acquiring an anonymous tlock?

In xtUpdate() and xtExtend(), BT_MARK_DIRTY(mp, ip) runs before txLock(0, i=
p,
mp, ...):

fs/jfs/jfs_xtree.c:xtUpdate() {
	...
	BT_MARK_DIRTY(mp, ip);
	/*
	 * acquire tlock of the leaf page containing original entry
	 */
	if (!test_cflag(COMMIT_Nolink, ip)) {
		tlck =3D txLock(tid, ip, mp, tlckXTREE | tlckGROW);
		xtlck =3D (struct xtlock *) & tlck->lock;
	}
	...
	if ((xoff > nxoff) ||
	    (nxoff + nxlen > xoff + xlen)) {
		XT_PUTPAGE(mp);
		jfs_error(ip->i_sb,
			  "nXAD in not completely contained within XAD\n");
		return -EIO;
	}
	...
}

If mp is not the root xtree page, BT_MARK_DIRTY() does not call
mark_inode_dirty(ip). If mp is the root xtree page and sb_emergency_ro() was
already set concurrently, BT_MARK_DIRTY() calls jfs_dirty_inode() while
JFS_IP(ip)->atlhead is still 0, so jfs_dirty_inode() returns early without
setting COMMIT_Dirty.

Immediately afterward, txLock(0, ip, ...) attaches an anonymous tlock to
JFS_IP(ip)->atlhead and queues JFS_IP(ip)->anon_inode_list onto
TxAnchor.anon_list. Similarly, in extAlloc(), xtExtend() and xtInsert() (via
xtSplitUp() -> xtSplitPage() or xtSplitRoot()) call txLock(0, ip, ...) befo=
re
subsequent metapage reads or extent checks can fail and call jfs_error() ->
sb_set_emergency_ro().

When xtUpdate(), xtExtend(), or xtInsert() returns a non-zero rc, extRecord=
()
skips mark_inode_dirty(ip) because of the !rc check, and extAlloc() returns
early before mark_inode_dirty(ip):

fs/jfs/jfs_extent.c:extAlloc() {
	...
	if (xaddr && xaddr =3D=3D nxaddr)
		rc =3D xtExtend(0, ip, xoff, (int) nxlen, 0);
	else
		rc =3D xtInsert(0, ip, xflag, xoff, (int) nxlen, &nxaddr, 0);

	if (rc) {
		dbFree(ip, nxaddr, nxlen);
		dquot_free_block(ip, nxlen);
		mutex_unlock(&JFS_IP(ip)->commit_mutex);
		return (rc);
	}
	...
	mark_inode_dirty(ip);
}

With COMMIT_Dirty never set on ip (and jfs_freeze() skipping txQuiesce() on=
ce
sb_emergency_ro() is set), could evicting the inode trigger
BUG_ON(!list_empty(&ji->anon_inode_list)) in jfs_evict_inode()?

> diff --git a/fs/jfs/super.c b/fs/jfs/super.c
> index 8180d83d33fed..bbaba14821e64 100644
> --- a/fs/jfs/super.c
> +++ b/fs/jfs/super.c
[ ... ]
> @@ -367,6 +368,11 @@ static int jfs_reconfigure(struct fs_context *fc)
>  	int flag =3D ctx->flag;
>  	int ret;
> =20
> +	/* Don't resize based on a block map we don't trust after an error. */
> +	if (ctx->resize && sb_emergency_ro(sb))
> +		return -EROFS;
> +
> +	/* After an error this only commits what was queued before it. */
>  	sync_filesystem(sb);
> =20
>  	/* Transfer results of parsing to the sbi */

[Severity: Medium]
If a filesystem error occurs while sync_filesystem(sb) is flushing dirty pa=
ges
or inodes during a resize remount (or concurrently while sync_filesystem(sb)
is running), jfs_handle_error() now sets sb_set_emergency_ro(sb) instead of
SB_RDONLY.

When execution reaches the ctx->resize block in jfs_reconfigure():

fs/jfs/super.c:jfs_reconfigure() {
	...
	if (ctx->resize) {
		if (sb_rdonly(sb)) {
			pr_err("JFS: resize requires volume to be mounted read-write\n");
			return -EROFS;
		}
		...
		rc =3D jfs_extendfs(sb, ctx->newLVSize, 0);
}

sb_rdonly(sb) is still false, so won't jfs_extendfs() proceed on a filesyst=
em
that just entered emergency read-only mode during sync_filesystem(sb)?

> @@ -415,6 +421,9 @@ static int jfs_reconfigure(struct fs_context *fc)
>  		return ret;
>  	}
>  	if (!sb_rdonly(sb) && readonly) {
> +		/* After an error nothing may be written, umount closes the log. */
> +		if (sb_emergency_ro(sb))
> +			return 0;
>  		rc =3D dquot_suspend(sb, -1);
>  		if (rc < 0)
>  			return rc;

[Severity: High]
What happens if userspace requests a read-write remount (for example, mount=
 -o
remount,rw) after a runtime filesystem error without having remounted
read-only first?

Because jfs_handle_error() calls sb_set_emergency_ro(sb) without setting
SB_RDONLY, sb_rdonly(sb) remains false. In reconfigure_super():

fs/super.c:reconfigure_super() {
	...
		remount_rw =3D !(fc->sb_flags & SB_RDONLY) && sb_rdonly(sb);
		remount_ro =3D (fc->sb_flags & SB_RDONLY) && !sb_rdonly(sb);
	}

	/* An error made the filesystem read-only until it is unmounted. */
	if (remount_rw && sb_emergency_ro(sb))
		return -EROFS;
}

remount_rw is false, so reconfigure_super() calls into jfs_reconfigure() wi=
th
!sb_rdonly(sb) && !readonly.

In jfs_reconfigure(), JFS_SBI(sb)->flag =3D ctx->flag is executed unconditi=
onally
right after sync_filesystem(sb) (which also makes the later
(JFS_SBI(sb)->flag & JFS_NOINTEGRITY) !=3D (flag & JFS_NOINTEGRITY) check c=
ompare
flag against itself), and then jfs_reconfigure() falls through and returns 0
instead of -EROFS.

Furthermore, if a remount (either ro or rw) includes the nointegrity option
after an error, JFS_SBI(sb)->flag gains JFS_NOINTEGRITY while sbi->p_state =
is
still 0 (FM_CLEAN). When jfs_umount() later calls updateSuper(sb, FM_CLEAN):

fs/jfs/jfs_mount.c:updateSuper() {
	...
	if (sbi->flag & JFS_NOINTEGRITY) {
		if (state =3D=3D FM_DIRTY) {
			sbi->p_state =3D state;
			return 0;
		} else if (state =3D=3D FM_MOUNT) {
			sbi->p_state =3D sbi->state;
			state =3D FM_DIRTY;
		} else if (state =3D=3D FM_CLEAN) {
			state =3D sbi->p_state;
		} else
			jfs_err("updateSuper: bad state");
	} else if (sbi->state =3D=3D FM_DIRTY)
		return 0;
}

won't updateSuper() take the JFS_NOINTEGRITY branch instead of returning ea=
rly
at sbi->state =3D=3D FM_DIRTY, and overwrite the on-disk FM_DIRTY error sta=
te with
FM_CLEAN?

[Severity: High]
Can a read-only remount in jfs_reconfigure() also race with an in-flight
extAlloc() or extRecord() that passed the sb_emergency_ro(ip->i_sb) check j=
ust
before an error occurred?

Consider an in-flight allocation running concurrently with reconfigure_supe=
r()
-> jfs_reconfigure() (either during a forced remount such as
emergency_remount() where sb_prepare_remount_readonly() is skipped, or via
background writeback in do_writepages() -> jfs_writepages() ->
mpage_write_folio() -> jfs_get_block() after writeback_iter() clears
PAGECACHE_TAG_DIRTY and before folio_start_writeback() sets
PAGECACHE_TAG_WRITEBACK):

1. extAlloc() or extRecord() passes sb_emergency_ro(ip->i_sb) before
   sb_set_emergency_ro(sb) is set.
2. jfs_reconfigure() runs sync_filesystem(sb) and returns 0 at the
   sb_emergency_ro(sb) check, and reconfigure_super() sets SB_RDONLY on
   sb->s_flags.
3. extAlloc() or extRecord() finishes acquiring its anonymous tlock (setting
   ji->atlhead and adding ji->anon_inode_list to TxAnchor.anon_list) and ca=
lls
   mark_inode_dirty(ip) -> jfs_dirty_inode(ip), which sees ji->atlhead !=3D=
 0 and
   sets COMMIT_Dirty.
4. During unmount, generic_shutdown_super() calls sync_filesystem(sb), which
   immediately returns 0 because sb_rdonly(sb) is now true.
   generic_shutdown_super() then calls evict_inodes(sb) before
   jfs_put_super().

Wouldn't jfs_evict_inode() hit BUG_ON(!list_empty(&ji->anon_inode_list))
because nothing commits the inode after jfs_reconfigure() sets SB_RDONLY?

[ ... ]
> @@ -616,15 +635,19 @@ static int jfs_unfreeze(struct super_block *sb)
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

[Severity: High]
If the filesystem was mounted with JFS_NOINTEGRITY and an error occurs whil=
e it
is frozen, does calling updateSuper(sb, FM_MOUNT) in jfs_unfreeze() clobber=
 the
FM_DIRTY state?

When jfs_freeze() runs on a JFS_NOINTEGRITY mount, updateSuper(sb, FM_CLEAN)
writes FM_CLEAN and sets sbi->state =3D FM_CLEAN. If a filesystem error hap=
pens
while frozen, jfs_handle_error() calls updateSuper(sb, FM_DIRTY):

fs/jfs/jfs_mount.c:updateSuper() {
	...
	if (sbi->flag & JFS_NOINTEGRITY) {
		if (state =3D=3D FM_DIRTY) {
			sbi->p_state =3D state;
			return 0;
		} else if (state =3D=3D FM_MOUNT) {
			sbi->p_state =3D sbi->state;
			state =3D FM_DIRTY;
		} else if (state =3D=3D FM_CLEAN) {
			state =3D sbi->p_state;
		}
		...
	}
	...
	sbi->state =3D state;
}

Under JFS_NOINTEGRITY, updateSuper(sb, FM_DIRTY) records FM_DIRTY in
sbi->p_state and returns 0, leaving sbi->state as FM_CLEAN.

When jfs_unfreeze() then calls updateSuper(sb, FM_MOUNT), the state =3D=3D =
FM_MOUNT
branch sets sbi->p_state =3D sbi->state (FM_CLEAN), overwriting the FM_DIRT=
Y in
sbi->p_state. When jfs_umount() later calls updateSuper(sb, FM_CLEAN), won'=
t it
write sbi->p_state (FM_CLEAN) to disk, leaving the corrupted filesystem mar=
ked
clean?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D5
