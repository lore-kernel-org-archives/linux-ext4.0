Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793137048;
	b=eOnPyarcFfCC4gAHiyfFnbDqH046H/Lhr7kXMQ6T+Ggd6q+WuWRdPviiNf1YJeFV9L0O
	 MjvTNVV825HvlofTBC8FrxaG/+W4In3QAANSqdsXisD+ydw6Q9/3D8MyemaDt08g2DSGS
	 t7hUqS2Ig224y5Kn/7xjiyzP3ROhW6ZpTA7n99hvfRXkt++2G4BlSoaNSwqlWg8x4YHWy
	 07em+UzyPzOFmVo2wPE+F2G4O7XJMqgaqHxU0UOkKJbx2boXX7iKLrGQ9f+JxtifX4qlr
	 GDp13bwP2wkRdi+kowJCgMY2UrgzfQt3UTyLoj/YTuRd4Tk0ZWPPT8QE5nXIZaX3EGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793137048;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cTT21q74pTrpVUoiXwcZuOMb4QKhELjvIBkdrSjXuZs=;
	b=p4bMMXNenNJPqGx3S0Pol6Z20FHaSqhaTZLe2x1lVqdGsVqncC8Z3g9ytRGkkRKTepg0
	 4NmAZ5jqCmYntUH1eCSo9odJmKPN69xOhpOM+kfEdzmLamhzKxgTuE56s0yBRfLvF5r5d
	 H8IA9O6/1rBE6Ts6tkuoNol/eVvHcBgZWuVPWZKvVqNACGk9QT0bIk0IRMk20/03Do6mj
	 5AmK5qrmCWhsFGPs6i2zUSWRS+ZANB66Hyn4WflPblI5RZWhqAnyH85cz20ZlpQsUIO84
	 xmeoGnjRZhH27cLm/A8wIKwy4fF22IaMKW58k8H1wbusFCU5ilGIemdedJcwGmgG5Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lHu9JRkZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866A3606A31A
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 21:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lHu9JRkZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD231F01825;
	Tue, 27 Oct 2026 21:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793137048;
	bh=cTT21q74pTrpVUoiXwcZuOMb4QKhELjvIBkdrSjXuZs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lHu9JRkZHk55g+uSkd8aI87iw+/a7VXob8taAD98JTxKx/KnC1Cr+PwQ2zN2fYdit
	 0giEnlJolN3grEhUls13Dm8hs6Dq2/FUvars01NcN6dgAsCR5zNOIfdJv+lJI8UrtT
	 yuNHx0iACJLjmvTG7487TEUWozuNYbSRziwWk+OU4kLpqwdrblfm6X6cV3H0/yCpBb
	 u5wLJihlaIJNooRFo7OLqHh3Vek2f6ASpj1Ec/dUpZGV97XywYWQPU7YxmBs6duJWj
	 7K5B9KNbWf5a5zPzIAZ6WwBNTt2Ou0KjSTNimezlpe/UmRWKVQcEf2v65FleEnjnZ+
	 cm/27KD/DoL4g==
Message-ID: <sashiko-outbox-187130@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 10/10] ovl: implement containerized syncfs for overlayfs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: linux-ext4@vger.kernel.org, dsterba@suse.cz, tytso@mit.edu
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-10-802e512379a6@toxicpanda.com>
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
 <20261027-b4-ovl-containerized-sync-v1-10-802e512379a6@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 21:37:27 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] ovl: unhashed root inode skipped by dirty tracking in ovl_sync_f=
s()
--

commit 741172152da9dc7e9c48781b1b044c29b845fc05
Author: Chengguang Xu <charliecgxu@tencent.com>

ovl: implement containerized syncfs for overlayfs

This commit changes ovl_sync_fs() so that when dirty inode tracking is
enabled on an overlayfs mount (SB_I_OVL_USE_SYNC_FS), it skips calling
sync_filesystem() on the upper superblock and instead invokes ->sync_fs()
and syncs the upper block device directly.

> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 631f68a97980f..c570bf7103f84 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
[ ... ]
> @@ -269,18 +270,45 @@ static int ovl_sync_fs(struct super_block *sb, int =
wait)
>  	/*
>  	 * Not called for sync(2) call or an emergency sync (SB_I_SKIP_SYNC).
>  	 * All the super blocks will be iterated, including upper_sb.
> -	 *
> -	 * If this is a syncfs(2) call, then we do need to call
> -	 * sync_filesystem() on upper_sb, but enough if we do it when being
> -	 * called with wait =3D=3D 1.
>  	 */
> -	if (!wait)
> -		return 0;
> -
>  	upper_sb =3D ovl_upper_mnt(ofs)->mnt_sb;
> =20
> +	if (!ovl_tracks_dirty(ofs)) {
> +		/*
> +		 * If this is a syncfs(2) call, then we do need to call
> +		 * sync_filesystem() on upper_sb, but enough if we do it when
> +		 * being called with wait =3D=3D 1.
> +		 */
> +		if (!wait)
> +			return 0;
> +
> +		down_read(&upper_sb->s_umount);
> +		ret =3D sync_filesystem(upper_sb);
> +		up_read(&upper_sb->s_umount);
> +
> +		return ret;
> +	}
> +
> +	/*
> +	 * For syncfs(2) and for unmount, sync_filesystem() has written the
> +	 * dirty inodes of this overlay by now, see ovl_write_inode().  What is
> +	 * left is for the upper filesystem to commit its metadata.  The dirty
> +	 * inodes of everybody else on the upper filesystem are none of our
> +	 * business.
> +	 */
>  	down_read(&upper_sb->s_umount);
> -	ret =3D sync_filesystem(upper_sb);
> +	/* As in sync_filesystem(): ->sync_fs() doesn't expect to be called the=
n */
> +	ret =3D 0;
> +	if (sb_rdonly(upper_sb))
> +		goto out;
> +
> +	if (upper_sb->s_op->sync_fs)
> +		ret =3D upper_sb->s_op->sync_fs(upper_sb, wait);
> +	if (!ret && wait)
> +		ret =3D sync_blockdev(upper_sb->s_bdev);
> +	else if (!ret)
> +		ret =3D sync_blockdev_nowait(upper_sb->s_bdev);

[Severity: Medium]
Can lazytime timestamp updates on the overlay root directory be lost across
syncfs(2) and umount(2) when ovl_tracks_dirty(ofs) is true and the upper
filesystem uses SB_LAZYTIME?

In fs/overlayfs/super.c:ovl_get_root(), the overlay root inode is allocated
via ovl_new_inode() -> new_inode() and never inserted into the inode hash
table:

	root =3D d_make_root(ovl_new_inode(sb, S_IFDIR, 0));
	if (!root)
		return NULL;

When timestamps on the overlay root directory are updated (for example via
ovl_update_time(), ovl_setattr(), or ovl_dir_modified() -> ovl_copyattr()),
the upper root inode is marked I_DIRTY_TIME and ovl_mark_inode_dirty() calls
mark_inode_dirty() on the overlay root inode:

	touch_atime(&upperpath);
	inode_set_atime_to_ts(inode,
			      inode_get_atime(d_inode(upperpath.dentry)));
	ovl_mark_inode_dirty(inode);

However, fs/fs-writeback.c:__mark_inode_dirty() skips queueing unhashed
inodes onto wb->b_dirty:

	if (!S_ISBLK(inode->i_mode)) {
		if (inode_unhashed(inode))
			goto out_unlock;
	}

As a result, writeback_inodes_sb(sb) and sync_inodes_sb(sb) never visit
d_inode(sb->s_root) to call ovl_write_inode() -> ovl_sync_lazytime(). During
umount(2), fs/overlayfs/super.c:ovl_drop_inode() also calls
inode_generic_drop(), which returns 1 for an unhashed inode so iput_final()
evicts the root inode without calling write_inode_now():

static int ovl_drop_inode(struct inode *inode)
{
	if (!(inode_state_read(inode) & (I_DIRTY_ALL | I_SYNC)))
		return 1;
	return inode_generic_drop(inode);
}

Previously, ovl_sync_fs() called sync_filesystem(upper_sb), which flushed t=
he
upper root inode via sync_inodes_sb(upper_sb). With this change, when
ovl_tracks_dirty(ofs) is true, ovl_sync_fs() only calls
upper_sb->s_op->sync_fs() and sync_blockdev(), leaving I_DIRTY_TIME on the
upper root inode unwritten. Should the overlay root inode be hashed (or
otherwise flushed during sync and eviction) so its dirty state is tracked l=
ike
other overlay inodes?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027-b4-ovl-con=
tainerized-sync-v1-0-802e512379a6@toxicpanda.com?part=3D10
