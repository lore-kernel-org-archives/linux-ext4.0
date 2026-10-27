Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793137344;
	b=4b/3eOEya3n6sibhd2sHXBbDhPqtlsa1zi+Ao6lqyET79gLttheaH07GYRCZAmbg3Kmp
	 A4rJD705gShprbM3KsmM+wPgaNkRlrKEzE3AYV45hTnLlKdHsxUaSHS6wqIIy+C/reA1B
	 fHKu5ueAJN1LmySyYA4Ycy2AEihbv7IK7jYaStOp8Y/YXM2hACRK54ZEsQlf2JqTRRvjq
	 5sR2m3WSND01kl9lk3Au3JyX57nZs/1IzrRsYUwxkYPzV2+Y+LC2EcxJpS6v7YVHerHTf
	 7xHJ9oNz1s7SjZjcnyjvjSJfwhzouyym0yeIbhzSfeREwm6zBvu3EYwR8DtBUpDtjtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793137344;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+U/3AyE9h8VFoJfLGSAvZG/eHASWT4otmv7gFTiSty0=;
	b=IeqLVD+B4HeynOIzh1gU171BHrHBwcxo4Nsamw0xh/aR5GTL2DqVv6JFSEpKmbWaYEcx
	 8A9/XqP3+Pyq4IrOiYaQ04YiqqdDW/sMFMYo6Sbhjkc0Uq8PpNDspMWDJhsH2IwaGZqAp
	 j04gY6v345xQ+cQTLJg3nvzWCyM9JUvkRDvBYZ5if++8iMw2/F1nrcasq5o8bvyj7rm26
	 /jYGliPlXHd/rs2hf7ef73XU3yv8hea6to0EDLis+2ktdn6AoBMqfyI3D10LuQdMEyj34
	 ADOCs9nhc3aHYWG7W6iNf8dd1ESui9jfX3jSrZC4ivJhbgSzKbUs/I1Nn1vzsFQqsmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U7Jzrt9u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390E2606A31A
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 21:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U7Jzrt9u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89EBD1F01825;
	Tue, 27 Oct 2026 21:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793137343;
	bh=+U/3AyE9h8VFoJfLGSAvZG/eHASWT4otmv7gFTiSty0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U7Jzrt9u1oYfh06bKCddpUDOjJHfvBGYMiGb5JL6vK95NroclM9LzewJlI9Q0jYmo
	 gsa2CUQ5WC8dIlhl4+JLehYHIT4PRAdVfC5lrwPT1qeKA2JHzK5Wd7LiY+Ipk+K5Yj
	 Qoi0Sl1puMwEwkmFV2zqI50+1X3iGNJhKsieb1PY/gOT28u/Mn1ztkP9CnqMd7Z/wd
	 sgU0C6dgCMi0oCyHpP6q1iIS3/U85yieSCyGvgEzHiwHd6e4rYet96DcLiSPAZQFvZ
	 Ksh1+FepurNf1vcqhRfE8nE8idU80ubBZISPIaj9hIcSQbzR5dXQ8IJqtawW0aIvwB
	 nWX7VEU5e/dPg==
Message-ID: <sashiko-outbox-187137@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 09/10] ovl: handle lazytime on the upper filesystem
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: linux-ext4@vger.kernel.org, dsterba@suse.cz, tytso@mit.edu
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-9-802e512379a6@toxicpanda.com>
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
 <20261027-b4-ovl-containerized-sync-v1-9-802e512379a6@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 21:42:23 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] ovl: ovl_park_inode() leaves inode->dirtied_time_when at 0
- [Medium] ovl: unhashed root inode in ovl_get_root() is skipped by __mark_=
inode_dirty()
--

commit c6403b040bf7636a271f2175d48ac775e6f04154
Author: Josef Bacik <josef@toxicpanda.com>

ovl: handle lazytime on the upper filesystem

This commit handles lazytime on the upper filesystem by parking the overlay
inode with I_DIRTY_TIME when only lazytime timestamps remain on the upper
inode after writeback. It also implements ->sync_lazytime() on overlay inode
operations to propagate lazytime writeback requests to the upper inode.

> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 954648d417006..631f68a97980f 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -344,6 +344,28 @@ static bool ovl_upper_unfinished(struct inode *upper)
>  	       (inode_state_read_once(upper) & I_SYNC);
>  }
> =20
> +/*
> + * All that is left of @inode are timestamps which lazytime holds back o=
n the
> + * upper filesystem.  A pass which does not wait leaves them alone, for =
up to 12
> + * hours.  Do to the overlay inode what was done to the upper inode: with
> + * I_DIRTY_TIME it is off the list which the flusher walks, syncfs() sti=
ll gets
> + * to it, and ovl_sync_lazytime() is told when the time has come.
> + *
> + * One such time is when the last reference goes away, which it never do=
es for
> + * the upper inode as long as the overlay inode is there.  It may have g=
one away
> + * already.  iput() looks for I_DIRTY_TIME under i_lock before it drops =
the last
> + * reference, so either it sees the flag or the count is zero here.
> + */
> +static void ovl_park_inode(struct inode *inode)
> +{
> +	if (!ovl_tracks_dirty(OVL_FS(inode->i_sb)))
> +		return;
> +
> +	__mark_inode_dirty(inode, I_DIRTY_TIME);
> +	if (!icount_read_once(inode))
> +		mark_inode_dirty_sync(inode);
> +}

[Severity: Medium]
When ovl_park_inode() is called from ovl_write_inode() during background
flusher writeback, will inode->dirtied_time_when remain left at 0?

Unlike regular filesystems that set I_DIRTY_TIME via generic_update_time()
when the inode is not queued for writeback, an overlay inode only receives
I_DIRTY_TIME here in ovl_park_inode() during
writeback_sb_inodes()->__writeback_single_inode()->write_inode()->ovl_write=
_inode().

At that point, move_expired_inodes() has already set I_SYNC_QUEUED on the
overlay inode. When ovl_park_inode() calls
__mark_inode_dirty(inode, I_DIRTY_TIME), __mark_inode_dirty() in
fs/fs-writeback.c sets I_DIRTY_TIME in i_state and then takes the
I_SYNC_QUEUED early exit before setting inode->dirtied_time_when:

fs/fs-writeback.c:__mark_inode_dirty() {
    ...
		if (inode_state_read(inode) & I_SYNC_QUEUED)
			goto out_unlock;
    ...
		if (!was_dirty) {
			struct list_head *dirty_list;
			bool wakeup_bdi =3D false;

			inode->dirtied_when =3D jiffies;
			if (dirtytime)
				inode->dirtied_time_when =3D jiffies;
    ...
}

When __writeback_single_inode() returns, requeue_inode() in fs/fs-writeback=
.c
moves the inode to wb->b_dirty_time and updates inode->dirtied_when, but do=
es
not set inode->dirtied_time_when:

fs/fs-writeback.c:requeue_inode() {
    ...
	} else if (inode_state_read(inode) & I_DIRTY_TIME) {
		inode->dirtied_when =3D jiffies;
		inode_io_list_move_locked(inode, wb, &wb->b_dirty_time);
		inode_state_clear(inode, I_SYNC_QUEUED);
	}
    ...
}

When __writeback_single_inode() later checks whether lazytime has expired on
a WB_SYNC_NONE pass:

fs/fs-writeback.c:__writeback_single_inode() {
    ...
	if ((inode_state_read_once(inode) & I_DIRTY_TIME) &&
	    (wbc->sync_mode =3D=3D WB_SYNC_ALL ||
	     time_after(jiffies, inode->dirtied_time_when +
			dirtytime_expire_interval * HZ)))
		sync_lazytime(inode);
    ...
}

it compares jiffies against inode->dirtied_time_when =3D=3D 0 instead of th=
e time
when the inode was dirtied or parked. Depending on jiffies wraparound state
(or if the inode re-enters __writeback_single_inode() before 12 hours), cou=
ld
this either skip sync_lazytime() and requeue the inode on wb->b_dirty_time
for another 12 hours, or expire lazytime prematurely?

> +
>  static int ovl_write_inode(struct inode *inode, struct writeback_control=
 *wbc)
>  {
>  	struct inode *upper =3D ovl_inode_upper(inode);
> @@ -360,6 +382,8 @@ static int ovl_write_inode(struct inode *inode, struc=
t writeback_control *wbc)
> =20
>  	if (ovl_upper_unfinished(upper))
>  		ovl_mark_inode_dirty(inode);
> +	else if (inode_state_read_once(upper) & I_DIRTY_TIME)
> +		ovl_park_inode(inode);
> =20
>  	return ret;
>  }

[Severity: Medium]
What happens when timestamps are updated on the overlay root directory inode
with lazytime enabled on the upper filesystem?

In fs/overlayfs/super.c, ovl_get_root() allocates the root inode via
ovl_new_inode() and initializes OVL_I(d_inode(root))->__upperdentry via
ovl_inode_init() without hashing the inode:

fs/overlayfs/super.c:ovl_get_root() {
    ...
	root =3D d_make_root(ovl_new_inode(sb, S_IFDIR, 0));
	if (!root)
		return NULL;
    ...
	ovl_inode_init(d_inode(root), &oip, ino, fsid);
	ovl_dentry_update_reval(root, upperpath->dentry);
	return root;
}

Because __upperdentry is already populated at mount time, ovl_inode_update()
(which calls insert_inode_locked4()) is never called for the root inode, so
inode_unhashed(d_inode(sb->s_root)) remains true.

When timestamps on the overlay root directory are updated (for example via
touch_atime()->ovl_update_time()->ovl_mark_inode_dirty() or
ovl_dir_modified()->ovl_copyattr()->ovl_mark_inode_dirty()), or when
ovl_park_inode() calls __mark_inode_dirty(inode, I_DIRTY_TIME),
__mark_inode_dirty() in fs/fs-writeback.c bails out without queueing the
inode onto wb->b_dirty or wb->b_dirty_time:

fs/fs-writeback.c:__mark_inode_dirty() {
    ...
		if (!S_ISBLK(inode->i_mode)) {
			if (inode_unhashed(inode))
				goto out_unlock;
		}
    ...
}

As a result, wouldn't syncfs() and unmount miss flushing lazytime timestamps
for the upper root directory inode because the overlay root inode is never
queued on the writeback lists?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027-b4-ovl-con=
tainerized-sync-v1-0-802e512379a6@toxicpanda.com?part=3D9
