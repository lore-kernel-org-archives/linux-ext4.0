Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657833;
	b=Jx+KkHKoE+5ZiKWmUv1uiBnNJDyASgMdF954ILF7H2Ape6dq7OomLX7izyLga6K4uofX
	 pD/JsJwdQuu2/qmLmPzK0PqDqp1gTesojYxRCGYqRmCuxCXBb+Zx+fzyolr8xfkRD+hHm
	 tgAhem3N4nbpzBpuosJWKHm4TtljrtOnCIswHCJL0/cWdmAZ+b55YSrd3v+W3Uy+dZ9bo
	 zOt+bup0nBni+29Bs3hiA6x/ZySzkRrRoqDnVQjDHlJc2q4EwSfzKFG6SXIVeGsmJotwO
	 SthJVM6iuMDJpYq5y2RnmktQqWqn4IknhFrzD1jV1GyCUbkznvxJLsUMQc+Skd70HSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657833;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=h9QvBLMsaftQkNF5XqflyzTjEcAymvR21sTq1hGFR9U=;
	b=xB5qSGxrMXgAXlE7nh8mENt4nv5VlI81GjWg/BB5k01J1mKLA+/OADIpyB3+yWe+Ufjv
	 4ikWSx6bhK1G0FAZyUBdChUknGWq6HVVjkC1QfbopQsPW6buQPotJKV8iZPEQnGVhfj/P
	 UPOXIM//R9X39fuq2ZRfUnQWUMDk+J1m7/08tgcZNApM+amhSRdV6k58erEYnm4R1DEKG
	 JylMXx73zSd8X/9fzw7qg6TteaKTeecxl1gWj4qFvhaPFUYWDJBhjyG5jfuV2wHsDyumL
	 gVyq9AOk1rjxvznp+lU4gkV9N689iMnWjFRJn8k/8OT9RvqQ3Ojya0QGp0mntfJ3gjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=acRLK16T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D23606A330;
	Sat, 14 Nov 2026 12:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=acRLK16T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7DA11F000C5;
	Sat, 14 Nov 2026 12:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657833;
	bh=h9QvBLMsaftQkNF5XqflyzTjEcAymvR21sTq1hGFR9U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=acRLK16Tv5rVfr5zfeXkCS81IwZynV0Iu0o5OGc2HpX3/05hrjbueaWKLxLlYqLmO
	 z3W+PPmaM3U0hqso0XI+Ooq0RQyvBrwDBT11n9g9KSgX8ZhGVcIxnOI9fIOtTrhxxK
	 HjE1FgbCj1dbiTCHVsQhDOFs56nIgMByBpuhawWcso3hlxTf//5jcUYgwAaZ04rwjz
	 BdkAHdeW3WWvKJw7xI6KV+jY+dZQrvNHw7VEagMRPiDHtBYiWi45s6JmOMZp7SE9XB
	 WqfiGf81GveG6tD+O2sIN9n3nXaeikmtUkJNFdgDSm4yOjub0sItWiIhIB1G/G4u+I
	 3yjoHedFGAoMA==
Message-ID: <sashiko-outbox-214481@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 30/33] ubifs: don't set SB_RDONLY after errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-30-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-30-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:52 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] ubifs: false space accounting error in ubifs_remount_ro()
  after error
- [Medium] ubifs: ubifs_fsync() trips !c->ro_mount assert after error
  remount
- [Medium] ubifs: race between in-flight writeback and
  ubifs_remount_ro() after error
--

commit fda6fbd307537dfd99ef75b3610022c5af4a9353
Author: Christian Brauner <brauner@kernel.org>

ubifs: don't set SB_RDONLY after errors

This commit switches ubifs_ro_mode() from setting SB_RDONLY directly on
s_flags to calling sb_set_emergency_ro(), allows remounting read-only after
an error, and drops dirty folios and inodes during writeback once
c->ro_error is set.

> diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
> index 38972786817e7..2d71274e89ad0 100644
> --- a/fs/ubifs/super.c
> +++ b/fs/ubifs/super.c
[ ... ]
> @@ -1839,19 +1846,26 @@ static void ubifs_remount_ro(struct ubifs_info *c)
> =20
>  	dbg_save_space_info(c);
> =20
> -	for (i =3D 0; i < c->jhead_cnt; i++) {
> -		err =3D ubifs_wbuf_sync(&c->jheads[i].wbuf);
> +	/* Like ubifs_put_super(), don't write anything after an error. */
> +	if (!c->ro_error) {
> +		for (i =3D 0; i < c->jhead_cnt; i++) {
> +			err =3D ubifs_wbuf_sync(&c->jheads[i].wbuf);
> +			if (err)
> +				ubifs_ro_mode(c, err);
> +		}
> +
> +		c->mst_node->flags &=3D ~cpu_to_le32(UBIFS_MST_DIRTY);
> +		c->mst_node->flags |=3D cpu_to_le32(UBIFS_MST_NO_ORPHS);
> +		c->mst_node->gc_lnum =3D cpu_to_le32(c->gc_lnum);
> +		err =3D ubifs_write_master(c);
>  		if (err)
>  			ubifs_ro_mode(c, err);
> +	} else {
> +		/* Syncing the write-buffers would have canceled them. */
> +		for (i =3D 0; i < c->jhead_cnt; i++)
> +			hrtimer_cancel(&c->jheads[i].wbuf.timer);
>  	}

[Severity: Medium]
Can an in-flight ubifs_fsync() trip the !c->ro_mount assertion in
ubifs_wbuf_sync_nolock() when racing with a read-only remount after an
error?

When c->ro_error is set, skipping ubifs_wbuf_sync() leaves wbuf->used and
wbuf->inodes[] populated while ubifs_remount_ro() sets c->ro_mount =3D 1.
Because vfs_fsync_range() does not hold s_umount or mnt_want_write(), an
fsync() on an inode whose node is already buffered in a wbuf (with no dirty
folios and ui->dirty =3D=3D 0) can interleave with ubifs_remount_ro():

CPU0                              CPU1
ubifs_fsync()
  if (c->ro_mount)
    return 0;
  file_write_and_wait_range()
  ubifs_write_inode() -> 0
                                  ubifs_remount_ro()
                                    hrtimer_cancel(&wbuf->timer)
                                    c->ro_mount =3D 1
  ubifs_sync_wbufs_by_inode()
    ubifs_wbuf_sync_nolock(wbuf)
      ubifs_assert(c, !c->ro_media && !c->ro_mount)
        <-- assertion failure

In ubifs_wbuf_sync_nolock(), the !c->ro_mount assertion runs before the
if (c->ro_error) return -EROFS check, causing a warning and stack dump (or
a panic when mounted with assert=3Dpanic).

> -
> -	c->mst_node->flags &=3D ~cpu_to_le32(UBIFS_MST_DIRTY);
> -	c->mst_node->flags |=3D cpu_to_le32(UBIFS_MST_NO_ORPHS);
> -	c->mst_node->gc_lnum =3D cpu_to_le32(c->gc_lnum);
> -	err =3D ubifs_write_master(c);
> -	if (err)
> -		ubifs_ro_mode(c, err);
> -
>  	vfree(c->orph_buf);
>  	c->orph_buf =3D NULL;
>  	kfree(c->write_reserve_buf);

[Severity: Medium]
Can ubifs_remount_ro() free c->write_reserve_buf and set c->ro_mount =3D 1
while an in-flight do_writepage() is still running?

Once ubifs_ro_mode() calls sb_set_emergency_ro(), sync_filesystem(sb) in
ubifs_reconfigure() returns immediately at sb_rdonly_any(sb) without
calling sync_inodes_sb() or waiting for in-flight writeback.  A writeback
caller that does not take mnt_want_write() or s_umount (such as
sync_file_range()) can pass the unlocked c->ro_error check in
do_writepage() just before an error occurs and then race with
ubifs_remount_ro():

CPU0                              CPU1
do_writepage()
  if (unlikely(c->ro_error))
  ubifs_jnl_write_data()
                                  ubifs_ro_mode()
                                    c->ro_error =3D 1
                                    sb_set_emergency_ro(sb)
                                  ubifs_reconfigure()
                                    sync_filesystem(sb) -> 0
                                    ubifs_remount_ro()
                                      kfree(c->write_reserve_buf)
                                      c->write_reserve_buf =3D NULL
                                      c->ro_mount =3D 1
    mutex_lock(&c->write_reserve_mutex)
    data =3D c->write_reserve_buf
    data->ch.node_type =3D ...
      <-- NULL dereference or use-after-free

Even when kmalloc() succeeds in ubifs_jnl_write_data(), make_reservation()
subsequently calls reserve_space(), tripping
ubifs_assert(c, !c->ro_media && !c->ro_mount).

> @@ -1977,10 +1991,7 @@ static int ubifs_reconfigure(struct fs_context *fc)
>  		if (err)
>  			return err;
>  	} else if (!c->ro_mount && (fc->sb_flags & SB_RDONLY)) {
> -		if (c->ro_error) {
> -			ubifs_msg(c, "cannot re-mount R/O due to prior errors");
> -			return -EROFS;
> -		}
> +		/* After an error ubifs_remount_ro() can't write but still works. */
>  		ubifs_remount_ro(c);
>  	}

[Severity: Medium]
Should ubifs_remount_ro() skip dbg_save_space_info() and
dbg_check_space_info() when c->ro_error is set, as ubifs_put_super() and
the taken_empty_lebs check in ubifs_reconfigure() do?

Because sync_filesystem() is a no-op once sb_set_emergency_ro() is set,
dirty folios and dirty inodes remain pending during ubifs_remount_ro().
dbg_save_space_info() snapshots ubifs_get_free_space_nolock(), which
includes c->bi.data_growth and c->bi.dd_growth.  If a concurrent writeback
or folio release drops a dirty folio via do_writepage() or a dirty inode
via ubifs_write_inode() before dbg_check_space_info() runs at the end of
ubifs_remount_ro(), releasing that page or inode budget changes the
reported free space and causes dbg_check_space_info() to log a false "free
space changed" error and call dump_stack().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D30
