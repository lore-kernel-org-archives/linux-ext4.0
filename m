Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59CB3A9636
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 10:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801696; cv=none; b=q+jw9Rvg/CuZXJU/iJPMcy5W8UrwCmUpZ4e7GGEqyyS8epTAsf1nUj06sN9yu6vYgQpx5FzcDN0DfKZFWYFMOI72HaWXpWArM2DlFB823WbjAGChSNp1fHOBDE2+tesRTGp2iE47H5orkcJSSVV3lyr5wOU/CqwTa/0MPG/xY6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801696; c=relaxed/simple;
	bh=TZ/Nyfdb9tvCJalnAdbKw/vlBHCbnRnFWNqA/U02aYI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=cQKAU+ibRKZ2+1d7fX9qXa562aJ/5dHlmBxEEHBJKwu/PXu0qZULF8oTKon14sZ2q6qdb9PYIwyvVj4sspgj3kftfDH83DFoWVWLK+88AlBkIGUxPtTtcRuy8SvrEOrjihdiN22wyM6DUqE91AAxbQGOBZ4kiVX3nvZBRncahMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uy39LkPg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uy39LkPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365921F0089B;
	Mon, 12 Oct 2026 10:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801695;
	bh=JbqtMOE5hqSIK1iR17dtktNWdsjAaebZ17VzRfgStVk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Uy39LkPgIFQmG74WoBGPYn9WSekwS0C/fkGu4Lt9J4tbWqRnILHSR5N78z/n560//
	 iMgutP6IDekOX5S+L2GyDUYxHIuw/doBWfjWi8zvEzmyjCjf+b9quAKQENCNyqfxm9
	 MmkbaO+/bLVE1uBJ0jZZlzAXvysDjOG40kyiHcCcgf7cD+YcIIqPS9CyouF+M+LVVo
	 ktlRGZItmDVNOCmxq05Z+peHS2b0IuVWGnacuPNgXruHoRtOWFCDDWlTWPp/7W5HZN
	 x9PrwpNQc6O6/vhEz7pnc9D/seL19TMAXAypSQIHbTzZj6bPNNFr5lBDa1V2TpUl3+
	 rJsprDQwL6/Dg==
Message-ID: <sashiko-outbox-167974@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 09/28] hfs: don't set SB_RDONLY after MDB write
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>, "Mark
 Fasheh" <mark@fasheh.com>, linux-ext4@vger.kernel.org, dsterba@suse.cz, tytso@mit.edu
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-9-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-9-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:41:34 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] hfs: mmap writes bypass emergency read-only enforcement
- [High] hfs: b-tree corruption on mount due to mismatched MDB and b-tree h=
eader
--

commit 438a15bb409c797940d5b4b61b0567260f26030a
Author: Christian Brauner <brauner@kernel.org>

    hfs: don't set SB_RDONLY after MDB write errors
   =20
    Since commit fdbb95ff89b2 ("hfs: don't re-dirty MDB buffers after a
    write failure") hfs_mdb_commit() sets SB_RDONLY when the MDB or the
    alternate MDB buffer lost BH_Uptodate after a failed write.

[ ... ]

> diff --git a/fs/hfs/extent.c b/fs/hfs/extent.c
> index f066a99a863bc..dab31f159b1aa 100644
> --- a/fs/hfs/extent.c
> +++ b/fs/hfs/extent.c
> @@ -350,6 +350,9 @@ int hfs_get_block(struct inode *inode, sector_t block,
>  		if (block > HFS_I(inode)->fs_blocks)
>  			return -EIO;
>  		if (ablock >=3D HFS_I(inode)->alloc_blocks) {
> +			/* No new allocations after an error. */
> +			if (unlikely(hfs_emergency_ro(sb)))
> +				return -EROFS;
>  			res =3D hfs_extend_file(inode);
>  			if (res)
>  				return res;

[Severity: High]
Does this code allow data modification on a filesystem in an emergency
read-only state?

If a user memory-maps a file with PROT_WRITE and modifies the pages after t=
he
filesystem enters the emergency read-only state, the page fault succeeds
because hfs does not override page_mkwrite to check hfs_emergency_ro().

When the VM triggers writeback, hfs_writepages() calls mpage_writepages(),
which calls hfs_get_block(). For existing file blocks where
ablock < HFS_I(inode)->alloc_blocks, hfs_get_block() bypasses this new chec=
k,
maps the block, and successfully writes dirty pages to disk, violating the
read-only guarantee.

[ ... ]

> diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
> index 2aef3c36a150a..42a2c2e390b23 100644
> --- a/fs/hfs/inode.c
> +++ b/fs/hfs/inode.c
> @@ -472,6 +479,20 @@ int hfs_write_inode(struct inode *inode, struct writ=
eback_control *wbc)
>  	int res;
> =20
>  	hfs_dbg("ino %llu\n", inode->i_ino);
> +	if (unlikely(hfs_emergency_ro(inode->i_sb))) {
> +		/*
> +		 * Writeback still writes the b-tree nodes. Keep the headers in
> +		 * sync with them so the trees on disk stay intact.
> +		 */
> +		if (inode->i_ino =3D=3D HFS_EXT_CNID)
> +			hfs_btree_write(HFS_SB(inode->i_sb)->ext_tree);
> +		else if (inode->i_ino =3D=3D HFS_CAT_CNID)
> +			hfs_btree_write(HFS_SB(inode->i_sb)->cat_tree);
> +		else
> +			return -EROFS;
> +		return 0;
> +	}
> +

[ ... ]

> diff --git a/fs/hfs/mdb.c b/fs/hfs/mdb.c
> index 277de712f9d47..ce20824bbdc84 100644
> --- a/fs/hfs/mdb.c
> +++ b/fs/hfs/mdb.c
> @@ -338,12 +338,18 @@ int hfs_mdb_commit(struct super_block *sb)
>  	struct hfs_mdb *mdb =3D HFS_SB(sb)->mdb;
>  	int ret =3D 0;
> =20
> -	if (sb_rdonly(sb))
> +	if (sb_rdonly(sb) || hfs_emergency_ro(sb))
>  		return 0;

[Severity: High]
Can writing the updated b-tree header in hfs_write_inode() but dropping
the MDB update here cause b-tree corruption on the next mount?

The commit message notes that b-tree growth through hfs_bmap_reserve() isn't
refused. If a read operation triggers a cache flush of an extent record,
allocating new physical blocks, the b-tree header is updated and written to
disk with an increased node_count.

However, since hfs_mdb_commit() now returns early when hfs_emergency_ro() is
true, the MDB is not updated on disk. This causes the on-disk MDB size fiel=
ds
(such as drXTFlSize and drXTExtRec) to desync from the b-tree header.

On the next mount, the b-tree file size is initialized from the stale MDB a=
nd
is smaller than node_count * node_size. Accessing the newly allocated nodes
reads past EOF, which the VFS zero-fills, resulting in -EIO during tree
traversal. Furthermore, the newly allocated blocks are not marked as used in
the MDB bitmap, leading to potential data overwrites.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D9
