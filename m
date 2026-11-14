Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657802;
	b=midBVZVnhm1hNbTejFuqrgMmeoYeCKnry2vfGTWK3V0cDsuEo1vfcWZIwAcaHSGqDNp+
	 plUuSSZVH/IRWU49HatunUuyLJ7hNM8wEhAqeE1uQ3/4jXDCLiZhG3m6Q3AL0YPtnJ66w
	 6/NHmEVnSrGDZTKMaflMuEnuptgJ/UpxUHvkcyHKVZLh9Doe8reX9P13IcAsNHtpWYhGn
	 HXGCtBHNu1WXRpl7BS/adnqV3HFPMDZuzYPXW5aRGYV2hf1PYdEpdzqS9dBAIfeCtWWzG
	 rdNDXvfupaltlY/3Pho29rxGS/IrQM3U5fFmZRjlcZs37Xb4yOfh1mHG4M1VTR1hr7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657802;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ZtvIFXoOKLAsH+V2h5HHt5wrTO8bTwuJgaiMNtvW4Sw=;
	b=YcOLFYDsnO6Lk+11mbk9SDaqAXOvdLw4mbKnOuRWNyRlxmx8zs4R4H+8DapsYZJbrefv
	 /9sMe6CNaPWsFqVAmoND7P4jdCai6MXXIi0xziu279AXmJ6J4NGNpyEdpLRk/IerkXnSl
	 AJynfom1CMtvrJ4VgBWPacmiQXR8JUc6K19g6HTAzdSqr8GVqtfI7YjcP11dpbw2FxqNz
	 PgnRzp2wyQgDG315zxNqUhvr+ZegpyhfhU7ZQTJWNYxNkp5PnUB8DcvBn1ngijsNVlDaT
	 M7zbS++c4bAZokoegY+K9IDVxOHM326R5KA1u7S5ZPn9ru5FpbN7xlK1t5rHQVUjdug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZBqU4DgI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531A6606A327;
	Sat, 14 Nov 2026 12:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZBqU4DgI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBAB1F000C4;
	Sat, 14 Nov 2026 12:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657801;
	bh=ZtvIFXoOKLAsH+V2h5HHt5wrTO8bTwuJgaiMNtvW4Sw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZBqU4DgIsVF4fBQNr4bYIKhPWkjeKQvvtPUUd9Cz31YPzLVJOtMSWjDuH7EGA/h7n
	 P2EPM9PNC3jDOgl7kqQR3OcR5SuiZnwdbTz/URj/thGHq6pavdyM9GR1V7q5+9Nr9L
	 ogQpeDGM/vpkwHN2a+d6KH5p1Dq1y5+epVPBRSkaCZhhXeQqYtWZ7nOpi4phoiJOFa
	 QW2WytooNIT+NaZ1bOtDLE6flFWVJJCUO+3bxaKOxlU9uNVzGHsSLlk/mD2Ae18ZH1
	 y1aN0XFGCVxI9RZanX5gvGBBfw/tKxhyoRW6iX00wFbvNon9+aBAYwguwpQmTyJmz/
	 sjdBN32e0lXhA==
Message-ID: <sashiko-outbox-214452@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 01/33] jfs: free uncommitted anonymous tlocks when
 evicting an inode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-1-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-1-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:20 +0000
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
- [Medium] jfs: false WARN_ON_ONCE() in jfs_evict_inode() on read-write
  mounts
- [Medium] jfs: txAbortAnon() after jfs_free_zero_link() leaks metapages
  and tlocks
- [Medium] jfs: race between jfs_evict_inode(), txAbortAnon(), and
  txQuiesce()
--

commit a15655dff32c48b09c331d3e03e198e2173008c1
Author: Christian Brauner <brauner@kernel.org>

jfs: free uncommitted anonymous tlocks when evicting an inode

This commit adds txAbortAnon() and calls it from jfs_evict_inode() to
release uncommitted anonymous transaction locks and metapage pins when an
inode is evicted before writeback commits them.

> diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
> index c7914dbc91ed9..6390d915c7f11 100644
> --- a/fs/jfs/inode.c
> +++ b/fs/jfs/inode.c
> @@ -172,6 +172,15 @@ void jfs_evict_inode(struct inode *inode)
>  	clear_inode(inode);
>  	dquot_drop(inode);
> =20
> +	/*
> +	 * Writeback commits the anonymous transactions of allocations. If the
> +	 * filesystem went read-only without a sync, e.g. after an error,
> +	 * nothing did.
> +	 */
> +	if (ji->atlhead) {
> +		WARN_ON_ONCE(!sb_rdonly(inode->i_sb));

[Severity: Medium]
Can WARN_ON_ONCE(!sb_rdonly(inode->i_sb)) fire on a read-write mount when
ji->atlhead is left populated without setting COMMIT_Dirty?

In extAlloc(), xtExtend() and xtInsert() acquire anonymous tlocks on
non-root xtree metapages via txLock() before splitting pages in
xtSplitUp().  When xtSplitUp() fails with -ENOSPC or -EDQUOT, extAlloc()
frees the data blocks and returns before calling mark_inode_dirty(ip):

fs/jfs/jfs_extent.c:extAlloc() {
	...
	if (xaddr && xaddr =3D=3D nxaddr)
		rc =3D xtExtend(0, ip, xoff, (int) nxlen, 0);
	else
		rc =3D xtInsert(0, ip, xflag, xoff, (int) nxlen, &nxaddr, 0);

	/* if the extend or insert failed,
	 * free the newly allocated blocks and return the error.
	 */
	if (rc) {
		dbFree(ip, nxaddr, nxlen);
		dquot_free_block(ip, nxlen);
		mutex_unlock(&JFS_IP(ip)->commit_mutex);
		return (rc);
	}
	...
	mark_inode_dirty(ip);
}

Because COMMIT_Dirty is never set on the inode, jfs_write_inode() does not
commit the anonymous tlocks, and evicting the inode triggers the warning on
a read-write filesystem.  The warning also triggers after a filesystem
error when mounted with errors=3Dcontinue, where jfs_handle_error() marks t=
he
superblock dirty without setting SB_RDONLY, or via extRecord() ->
xtUpdate(), which is fixed in a later patch in this series (commit "jfs:
don't set SB_RDONLY after filesystem errors").

> +		txAbortAnon(inode);
> +	}

[Severity: Medium]
Does calling txAbortAnon() after jfs_free_zero_link() leak metapages and
linelocks when an unlinked inode with COMMIT_Freewmap is evicted after an
error?

Earlier in jfs_evict_inode(), an unlinked inode with COMMIT_Freewmap calls
jfs_free_zero_link() -> xtTruncate(..., COMMIT_WMAP).  For each non-root
xtree metapage, xtTruncate() marks mp->lid with tlckFREELOCK, calls
discard_metapage(mp), and finishes with txFreelock(ip):

fs/jfs/jfs_txnmgr.c:txFreelock() {
	...
	while ((lid =3D xtlck->next) !=3D 0) {
		tlck =3D lid_to_tlock(lid);
		if (tlck->flag & tlckFREELOCK) {
			xtlck->next =3D tlck->next;
			txLockFree(lid);
		} else {
	...
}

If the transaction in jfs_unlink() or jfs_rename() aborted after
commitZeroLink() set COMMIT_Freewmap, ji->atlhead still holds anonymous
tlckPAGELOCK tlocks when jfs_evict_inode() runs.  txFreelock() unlinks
those tlocks from ji->atlhead and frees lid before txAbortAnon() runs,
without dropping mp->nohomeok, clearing mp->lid, or freeing chained
linelocks.  Calling txAbortAnon() before jfs_free_zero_link() would release
the metapage pins and linelocks before xtTruncate() discards the pages.

> diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
> index 083dbbb0c3268..85192dd4461a4 100644
> --- a/fs/jfs/jfs_txnmgr.c
> +++ b/fs/jfs/jfs_txnmgr.c
> @@ -2581,6 +2581,74 @@ void txFreelock(struct inode *ip)
>  	TXN_UNLOCK();
>  }
> =20
> +/*
> + *	txAbortAnon()
> + *
> + * function:	free the anonymous tlocks of an inode that is evicted
> + *		before writeback committed them, e.g. because an error made
> + *		the filesystem read-only.
> + *
> + * A page that carries nothing but uncommitted changes isn't written hom=
e.
> + * A page that is also waiting to go home with committed changes (mp->ls=
n)
> + * goes home with both, after an error the superblock is marked dirty.
> + */
> +void txAbortAnon(struct inode *ip)
> +{
> +	struct jfs_inode_info *jfs_ip =3D JFS_IP(ip);
> +	struct linelock *linelock;
> +	struct metapage *mp;
> +	struct tlock *tlck;
> +	lid_t lid, next, llid, k;
> +
> +	/* txQuiesce() and jfs_sync() commit under the commit_mutex */
> +	mutex_lock(&jfs_ip->commit_mutex);
> +
> +	TXN_LOCK();
> +	lid =3D jfs_ip->atlhead;
> +	jfs_ip->atlhead =3D jfs_ip->atltail =3D 0;
> +	list_del_init(&jfs_ip->anon_inode_list);
> +	TXN_UNLOCK();

[Severity: Medium]
Can jfs_evict_inode() and txAbortAnon() race with txQuiesce() walking the
global TxAnchor.anon_list?

txQuiesce() walks TxAnchor.anon_list (shared across all JFS mounts) under
TXN_LOCK() and drops TXN_LOCK() without pinning the inode before taking
commit_mutex:

CPU0                              CPU1
txQuiesce()                       jfs_evict_inode()
  TXN_LOCK()                        txAbortAnon()
  jfs_ip =3D list_entry(...)            mutex_lock(&jfs_ip->commit_mutex)
  TXN_UNLOCK()                        TXN_LOCK()
                                      list_del_init(&jfs_ip->anon_inode_lis=
t)
                                      TXN_UNLOCK()
                                      ...
                                      mutex_unlock(&jfs_ip->commit_mutex)
                                    ...
                                  destroy_inode(ip)
  txBegin(ip->i_sb, ...)
  mutex_lock(&jfs_ip->commit_mutex)  <-- use-after-free

In the opposite interleaving, txCommit() called from txQuiesce() clears
jfs_ip->atlhead =3D 0 before taking TXN_LOCK() to remove
jfs_ip->anon_inode_list.  Because jfs_evict_inode() checks if (ji->atlhead)
without commit_mutex or TXN_LOCK(), it can see ji->atlhead =3D=3D 0, skip
txAbortAnon(), and hit BUG_ON(!list_empty(&ji->anon_inode_list)) or free
the inode while txCommit() is still running.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D1
