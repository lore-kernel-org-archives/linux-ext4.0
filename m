Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376595;
	b=ue1MjW4PuxVjvi4ADfY+65FCv9Sw0ZAsQOjHvcsZij/QTCaTPod03E5eBEw9TYuQKlsv
	 s2aMhAsSmivKxWigcyG1lsrGdImq0mo0zBfnkCriR2NbPIyKC3vqiy1gIlGptuDUDi7xJ
	 kSQps7hgJ30rn+8cKANrrFu2evunrmKNs5QKXZqk+i8MkrhFPrz8ZhAhiVyKc9cU5ljhL
	 KEx9neHcZFTHcw2i6FFtpQkW34vh/2k6Y+DhwGcdzW7Qh6a7l7WcMjf1nGeIgec3eNUp5
	 wHXi2pgRYFOF+rEtOryie5/4gsglgEsu+7CvAfMXlP9L3lDtT7jRlQdlaOT2DHVn2eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376595;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=G/NlFSnNcldx9naDXGStLPpiwmKvzlTeOOk/gge3EPI=;
	b=0bWZbya626hh/WWnwthgGGFQU8WeQevnSbuArYhhYjwiTBUscirHlFtli35iiOEdcbAM
	 sPXIRPCrhb6lbCtihuvmUpEvER77CfFuUkd1c481Z3Z8Ow7oNcgZDukkBidTFhf8QdbhH
	 fAJq4ovdKnUV55pPq0JHf1r9rOcm4WL/jEtUAizduv73CAQiRDaV/3gPgXs5gsPwMP4Jq
	 z2PPvpPZYegrqV1WeVu557HaO6Nldk9TkTlC1KQ3QVpU/FJxikVJefAGKhjMuLEp3Sr22
	 L/BYYvkrXeltCS5NYRB+Ku5GEpbDN4/H6V89E6llHWYGGyhtLxVAYzBSWbt/wGr78Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X0vb+QKs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F92606A32A;
	Fri, 30 Oct 2026 16:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X0vb+QKs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFD41F00A17;
	Fri, 30 Oct 2026 16:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376594;
	bh=G/NlFSnNcldx9naDXGStLPpiwmKvzlTeOOk/gge3EPI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X0vb+QKsc0IfCurUZLqL1bXCL4/R5byO7UPcHRV5QGGJsKwXncsM9RFyYBy3fzkXd
	 FdIt7I8/c4kyHBMyx+WzDD4cFvakaVRlfmo+h/MfUVXnPumegsa4GttpC83jrDvxx6
	 ZoxohkjJWLK01b6m8c43ZltgssPNu3ZQu8ZOVj7UOiWfUFzg58iw4UIruyslgfhirt
	 YbOnPd6ULjJJiF0dUJLE9TxPkv1KDrpr52th/qSGVq3gfYBkVJjLF0dt/mV0KhRjsk
	 zSHCKLTNZ6vYq1vhtPLSrNcc6x6TN3ldQwLcgkR8qx/xN0+ZAGwc6MYM+mWhG4c8r8
	 6E/+TaSxXOhVw==
Message-ID: <sashiko-outbox-191226@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 07/34] fat: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-7-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-7-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:09:53 +0000
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
- [High] fat: fat_write_inode() refusal on emergency ro corrupts pending di=
r entries
--

commit 57e06a99b59c945df35624d543f51f3cdc78897d
Author: Christian Brauner <brauner@kernel.org>

fat: don't set SB_RDONLY after filesystem errors

This commit replaces setting SB_RDONLY in __fat_fs_error() after SB_BORN wi=
th
sb_set_emergency_ro() so that thaw_super() does not leave s_writers locked =
if
an error occurs while the filesystem is frozen. It also adds
sb_emergency_ro() checks across FAT operations to reject further
modifications.

> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index d85c8fbdcca46..afd73dc4ba9a8 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c

[ ... ]

> @@ -954,6 +963,9 @@ static int fat_write_inode(struct inode *inode, struc=
t writeback_control *wbc)
>  {
>  	int err;
> =20
> +	if (unlikely(sb_emergency_ro(inode->i_sb)))
> +		return -EROFS;
> +
>  	if (inode->i_ino =3D=3D MSDOS_FSINFO_INO) {
>  		struct super_block *sb =3D inode->i_sb;
> =20
> @@ -1949,6 +1961,9 @@ int fat_flush_inodes(struct super_block *sb, struct=
 inode *i1, struct inode *i2)
>  		ret =3D writeback_inode(i2);
>  	if (!ret)
>  		ret =3D sync_blockdev_nowait(sb->s_bdev);
> +	/* The change is done, an error made us read-only in the meantime. */
> +	if (ret =3D=3D -EROFS && sb_emergency_ro(sb))
> +		ret =3D 0;
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(fat_flush_inodes);

[Severity: High]
Can rejecting fat_write_inode() when sb_emergency_ro() is set corrupt
on-disk directory entries when dirty block device buffer_heads are still
flushed to disk?

In FAT, an inode's starting cluster (i_logstart) and size (i_size) are stor=
ed
inside its msdos_dir_entry in sb->s_bdev buffer_heads and are only written =
to
that buffer_head by fat_write_inode() -> __fat_write_inode():

    raw_entry =3D &((struct msdos_dir_entry *) (bh->b_data))[offset];
    if (S_ISDIR(inode->i_mode))
        raw_entry->size =3D 0;
    else
        raw_entry->size =3D cpu_to_le32(inode->i_size);
    raw_entry->attr =3D fat_make_attrs(inode);
    fat_set_start(raw_entry, MSDOS_I(inode)->i_logstart);

During vfat_rename() and do_msdos_rename(), vfat_add_entry() or
msdos_add_entry() creates the target directory entry in new_dir's buffer_he=
ad
with cluster =3D 0 and size =3D 0 and marks that buffer_head dirty:

    err =3D msdos_add_entry(new_dir, new_name, is_dir, is_hid, 0,
                  &ts, &sinfo);
    if (err)
        goto out;
    new_i_pos =3D sinfo.i_pos;
    ...
    fat_detach(old_inode);
    fat_attach(old_inode, new_i_pos);
    ...
    mark_inode_dirty(old_inode);
    ...
    err =3D fat_remove_entries(old_dir, &old_sinfo);

Similarly, when a newly created file allocates its first cluster in
fat_chain_add() and updates i_size in fat_write_end(), the FAT and directory
buffer_heads are dirtied in sb->s_bdev while the directory entry still has
start =3D 0 and size =3D 0 until __fat_write_inode() updates it.

If fat_fs_error() sets sb_emergency_ro(sb) either during the operation (for
example, fat_add_entries() hitting "Odd directory size" or fat_chain_add()
hitting "clusters badly computed", both of which call fat_fs_error() and
still return 0) or before background inode writeback runs, fat_write_inode()
will now return -EROFS without updating the directory entry's start cluster
and size.

However, the dirty directory and FAT buffer_heads in sb->s_bdev are still
written out by bdev writeback, mmb_sync() in fat_evict_inode(), and
sync_blockdev() on unmount. Wouldn't that flush the deleted old directory
entry along with a new directory entry containing start =3D 0 and size =3D =
0,
losing the file or directory contents and orphaning its cluster chain?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D7
