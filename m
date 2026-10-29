Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793278055;
	b=v7cQkjXn9FIxqjRaJdqtcas42RZY92aqut0ZlNrWsmF52hOCHP4XW1IrhNPSuoba6p6r
	 w5P2XHZ4ze8Q7vZkEBAP3L5/RV4GWnvbjxfvlYxW+s1vQmvf9m5neAmAgC3npzifoVFsH
	 /2Mj+JwZjaocRIdtzbwe57lqAhes+rvi2+liVwRnn+hyHDV7p8BQmFbi3eWp45SeN0R78
	 glLURtg4fKeDRPjKQWdgzSzVD0TmttepZ8GL2iczFa+aqPfye5JSVbXEfUXynzkSOovCz
	 p2LQq/rua9CJa+pv1fpeloVwHje99x09DudoscWswPEKUa8qeS6fiX33S7RMrEutcKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793278055;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=nK7l3Sbrvt021L4154iD6CpCSFgpiym3zEaRsy7S8Cs=;
	b=dtiUuyEQBmqVt94WIifZqXeJaLYWWjWuh6/SshjPUNO9OPtlSxyKP/+K0wnpQjIj+3QO
	 0dFjboSDqd8abMACxWC6kDFduFDt4+r3DJgmqo3gGks1LgliWqz90/gf+ja/XCQnOJV60
	 wbJs5KjV2u0qVKVzqW1aaeVc37ZovhhDaaFQZB4et69reoH5Ea6GRvHh/O/5a3UYOgzq0
	 d6eMzF1ngoywUywRpqxo21vWgy+iZY+OPo+WIhphP46wlW2Dg4tT8xoE1N46DrCa6xBPm
	 +GEj1gYtEPTOg21joHNVOWklNPFVvR1m8E7BmaEe9pV5Af6nEEqZE9xPNyp1mTWgnpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xu2ZkXIn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388D6606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xu2ZkXIn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23831F01825;
	Thu, 29 Oct 2026 12:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793278055;
	bh=nK7l3Sbrvt021L4154iD6CpCSFgpiym3zEaRsy7S8Cs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Xu2ZkXIn5MAcGE3BSW0+T+WtIjKapYqAMejjcy9SPogopwfpv6tFdm76ikMG7PzFD
	 OYaadkS2D77l4cDMIx1zPjC7CJYZiaxr5nI/7007E6dkud+nq82gPW8I4XV6mDVDaQ
	 Z5GdMbgYQSngTFPmX3BHdoBwHOpSyRsjRCMIeVtfuVu36S2yBeI/8nwclZebQUw3C3
	 q1PCSzAh1Osfmps/zcRJE5LwAizdzSIw+Z8dghIj2qgt4IWjgpcHx3lIS84Q9/mgMk
	 jf1BPsX+19Au4JIZy4DbPGov+eICQKqGqHamusIaFe0XNmWblfyjOey2GRsmBqGv3B
	 z5mvE2R76ObDw==
Message-ID: <sashiko-outbox-189309@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 09/11] ext4: add dirdata LUFID support for directory
 entry rename
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Blagodarenko" <artem.blagodarenko@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261029122413.230409-10-ablagodarenko@thelustrecollective.com>
References: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com>
 <20261029122413.230409-10-ablagodarenko@thelustrecollective.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 12:47:34 +0000
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
- [High] ext4: directory corruption in ext4_resetent() after RENAME_WHITEOU=
T failure
- [Medium] ext4: double-fetch of ddh_length in ext4_lufid_snapshot()
--

commit 05f91dc592ccfff134532dbb86b63e7c812e5a35
Author: Artem Blagodarenko <artem.blagodarenko@gmail.com>

ext4: add dirdata LUFID support for directory entry rename

This commit extends ext4_setent(), ext4_rename(), and ext4_cross_rename() to
snapshot and preserve dirdata LUFID payloads across directory entry renames.

> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 30bbf6a56bf64..433bee757ea4c 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c

[ ... ]

> @@ -3762,8 +3758,57 @@ static int ext4_setent(handle_t *handle, struct ex=
t4_renament *ent,
>  	if (retval)
>  		return retval;
>  	ent->de->inode =3D cpu_to_le32(ino);
> -	if (ext4_has_feature_filetype(ent->dir->i_sb))
> -		ent->de->file_type =3D file_type;
> +	if (ext4_has_feature_filetype(ent->dir->i_sb)) {
> +		/* Copy the source LUFID payload into the destination slot when
> +		 * both carry a LUFID of the same on-disk size.  LUFID is
> +		 * inode-specific and must travel with the inode through rename.
> +		 * CFHASH bytes are left in-place: CFHASH is a function of the
> +		 * destination filename, and its bytes sit at the correct offset
> +		 * because LUFID always precedes CFHASH in the extension layout.
> +		 * When src_fid is NULL, the LUFID flag is synced to the LUFID
> +		 * bit already present in file_type: callers that clear LUFID
> +		 * (rename of a non-LUFID inode, whiteout) pass file_type with
> +		 * LUFID=3D0; ext4_resetent passes the original file_type so the
> +		 * flag is restored for error recovery without overwriting the
> +		 * LUFID bytes that are still intact on disk. */
> +		if (ext4_has_feature_dirdata(ent->dir->i_sb)) {
> +			if (src_fid && (ent->de->file_type & EXT4_DIRENT_LUFID)) {
> +				unsigned int rec_len =3D
> +					ext4_rec_len_from_disk(ent->de->rec_len,
> +						ent->dir->i_sb->s_blocksize);
> +				unsigned int ddh_off =3D
> +					EXT4_BASE_DIR_LEN + ent->de->name_len + 1;
> +				struct ext4_dirent_data_header *ddh =3D
> +					(struct ext4_dirent_data_header *)
> +					((char *)ent->de + ddh_off);
> +				unsigned int copy_len =3D src_fid->df_header.ddh_length;
> +
> +				if (ddh_off + sizeof(*ddh) > rec_len ||
> +				    ddh->ddh_length !=3D copy_len ||
> +				    ddh_off + copy_len > rec_len) {
> +					/* Cannot copy: clear the flag so the
> +					 * slot does not advertise a stale LUFID
> +					 * from the old inode. */
> +					ent->de->file_type &=3D ~EXT4_DIRENT_LUFID;
> +				} else {
> +					memcpy(ddh, src_fid, copy_len);
> +				}
> +			} else if (!src_fid) {
> +				/* Sync the LUFID flag with what file_type requests.
> +				 * For normal rename (source has no LUFID) and for
> +				 * the whiteout setent, file_type carries LUFID=3D0,
> +				 * so we clear the stale flag.  For ext4_resetent
> +				 * (error recovery), file_type is the original
> +				 * file_type with LUFID=3D1, so we restore the flag =E2=80=94
> +				 * the LUFID bytes are still on disk untouched. */
> +				ent->de->file_type =3D
> +					(ent->de->file_type & ~EXT4_DIRENT_LUFID) |
> +					(file_type & EXT4_DIRENT_LUFID);
> +			}
> +		}
> +		ent->de->file_type =3D (file_type & EXT4_FT_MASK) |
> +				     (ent->de->file_type & ~EXT4_FT_MASK);
> +	}

[Severity: High]
Are the LUFID bytes in old.de guaranteed to remain untouched on disk if a
RENAME_WHITEOUT operation fails and rolls back via ext4_resetent()?

In ext4_rename(), when whiteout is non-NULL, ext4_setent() is called on old
with EXT4_FT_CHRDEV and src_fid =3D NULL before ext4_add_entry() runs:

	if (whiteout) {
		retval =3D ext4_setent(handle, &old, whiteout->i_ino,
				     EXT4_FT_CHRDEV, NULL);
		if (retval)
			goto end_rename;
		retval =3D ext4_mark_inode_dirty(handle, whiteout);
		if (unlikely(retval))
			goto end_rename;
	}
	if (!new.bh) {
		new.dentry->d_fsdata =3D edp;
		retval =3D ext4_add_entry(handle, new.dentry, old.inode);

Because that first ext4_setent() call clears EXT4_DIRENT_LUFID in
old.de->file_type, ext4_dir_entry_len() computes the active length of old.de
without its LUFID payload.

When !new.bh and old.dir =3D=3D new.dir (same-directory rename with
RENAME_WHITEOUT), ext4_add_entry() can reuse or discard those LUFID bytes:

- ext4_find_dest_de() and ext4_insert_dentry_data() treat old.de's LUFID
  bytes as unused slack space, shrink old.de->rec_len to the smaller active
  length (smaller than ddh_off + ddh_length), and overwrite old.de's LUFID
  bytes with the new directory entry.

- During an htree block split in make_indexed_dir() or do_split(),
  dx_move_dirents() and dx_pack_dirents() copy only the active length for
  old.de, discarding its LUFID payload and shrinking old.de->rec_len.

- Additionally, after a later patch in this series adds
  ext4_setent_compact_exts(), if old.de carried both EXT4_DIRENT_LUFID and
  EXT4_DIRENT_CFHASH, the whiteout ext4_setent() call slides the CFHASH
  record over the LUFID slot at ddh_off.

If ext4_add_entry() (for example, returning -ENOSPC when the directory or
filesystem is full) or a later step in ext4_rename() fails and jumps to
end_rename, ext4_lufid_snap_release(&old_snap) frees old_snap and
ext4_resetent() calls ext4_setent(handle, &old, ino, file_type, NULL) with
old_file_type:

end_rename:
	kfree(edp);
	ext4_lufid_snap_release(&old_snap);
	if (whiteout) {
		if (retval) {
			ext4_resetent(handle, &old,
				      old.inode->i_ino, old_file_type);

Wouldn't the !src_fid branch in ext4_setent() then unconditionally set
EXT4_DIRENT_LUFID back on old.de->file_type without checking whether
old.de->rec_len still encompasses the LUFID or restoring old_snap.fid,
leaving a corrupted directory entry on disk?

[ ... ]

> @@ -3899,6 +3944,67 @@ static struct inode *ext4_whiteout_for_rename(stru=
ct mnt_idmap *idmap,
>  	return wh;
>  }
> =20
> +/*
> + * Stack buffer sized for 1-byte header + 4 =C3=97 16-byte FIDs, coverin=
g virtually
> + * all real-world LUFID payloads without a heap allocation.  ddh_length =
is u8
> + * so the absolute maximum is 255 bytes; larger payloads fall back to km=
alloc.
> + */
> +#define EXT4_LUFID_INLINE_SIZE  65
> +
> +struct ext4_lufid_snap {
> +	struct ext4_dirent_fid *fid;	/* NULL or valid; never ERR_PTR */
> +	bool on_heap;
> +	u8 buf[EXT4_LUFID_INLINE_SIZE];
> +};
> +
> +/*
> + * ext4_lufid_snapshot - copy the LUFID record from a directory entry
> + *
> + * Fills @snap with a copy of the on-disk LUFID record.  For payloads up=
 to
> + * EXT4_LUFID_INLINE_SIZE bytes the inline buffer is used; larger payloa=
ds
> + * fall back to a heap allocation.  Returns 0 on success (snap->fid is N=
ULL
> + * when no LUFID is present), or -ENOMEM when a heap allocation fails.
> + * Call ext4_lufid_snap_release() when done.
> + */
> +static int ext4_lufid_snapshot(struct ext4_dir_entry_2 *de,
> +			       unsigned int blocksize,
> +			       struct ext4_lufid_snap *snap)
> +{
> +	unsigned int ddh_off =3D EXT4_BASE_DIR_LEN + de->name_len + 1;
> +	unsigned int rec_len =3D ext4_rec_len_from_disk(de->rec_len, blocksize);
> +	struct ext4_dirent_fid *disk_fid;
> +	unsigned int dlen;
> +
> +	snap->fid =3D NULL;
> +	snap->on_heap =3D false;
> +
> +	if (!(de->file_type & EXT4_DIRENT_LUFID))
> +		return 0;
> +	if (ddh_off + sizeof(disk_fid->df_header) > rec_len)
> +		return 0;
> +	disk_fid =3D (struct ext4_dirent_fid *)((char *)de + ddh_off);
> +	dlen =3D disk_fid->df_header.ddh_length;
> +	if (dlen < sizeof(disk_fid->df_header) || ddh_off + dlen > rec_len)
> +		return 0;
> +
> +	if (dlen <=3D sizeof(snap->buf)) {
> +		memcpy(snap->buf, disk_fid, dlen);
> +		snap->fid =3D (struct ext4_dirent_fid *)snap->buf;
> +	} else {
> +		snap->fid =3D kmemdup(disk_fid, dlen, GFP_NOFS);
> +		if (!snap->fid)
> +			return -ENOMEM;
> +		snap->on_heap =3D true;
> +	}
> +	return 0;
> +}

[Severity: Medium]
Can a concurrent modification to the underlying buffer_head cause a
double-fetch of ddh_length in ext4_lufid_snapshot() and an out-of-bounds re=
ad
from snap->fid?

ext4_lufid_snapshot() reads dlen from disk_fid->df_header.ddh_length in the
directory buffer, validates dlen against rec_len, and then copies dlen bytes
from disk_fid into snap->buf or a kmemdup(..., GFP_NOFS) buffer (which may
sleep in reclaim before copying). During memcpy() or kmemdup(),
disk_fid->df_header.ddh_length is fetched a second time from the buffer into
snap->fid->df_header.ddh_length.

If the buffer data is concurrently modified via the underlying block device
page cache (the same threat model guarded against with
READ_ONCE(ddh->ddh_length) in the earlier commit "ext4: add dirdata format
definitions and access helpers"), snap->fid->df_header.ddh_length can become
larger than dlen (up to 255).

When ext4_rename() or ext4_setent() later reads
old_snap.fid->df_header.ddh_length or src_fid->df_header.ddh_length:

	if (!new.bh && old_snap.fid) {
		unsigned fid_size =3D old_snap.fid->df_header.ddh_length;

		edp =3D kmalloc(offsetof(struct ext4_dentry_param,
				       edp_dfid) + fid_size, GFP_NOFS);
		...
		memcpy(&edp->edp_dfid, old_snap.fid, fid_size);
	}

and in ext4_setent():

	unsigned int copy_len =3D src_fid->df_header.ddh_length;
	...
	memcpy(ddh, src_fid, copy_len);

wouldn't memcpy() read past the end of old_snap.buf or the dlen-byte
kmemdup() allocation? Should ext4_lufid_snapshot() use
READ_ONCE(disk_fid->df_header.ddh_length) and explicitly set
snap->fid->df_header.ddh_length =3D dlen after the copy?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029122413.2304=
09-1-ablagodarenko@thelustrecollective.com?part=3D9
