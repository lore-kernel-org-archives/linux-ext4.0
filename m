Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639063;
	b=RzrmZ93Q4E0TwUVhPbAMY4xZ1NjJPRR4mdlWqlAB4+ynQbHOEpCuZuAgZ9d2fgR0oans
	 AItKrdb/9SL8hblIvqksyvXPjjqBOFbQk+HICTyt/CNGG9VpkShZvq13DnUDbhJ852YQu
	 1bCwO0wZP12OeWCRCvCMO+x6c1Nd162g/hyXyNxCvBmypBrXWX6WZsjcp5PTCFMuycQix
	 4fkoTYaPE6x0rH8pPVwRm58+1bwM77tkFmOXCbIzoTIGeZ9azZ0NnAgIy63rB0mp9H36P
	 sKvJTTHx9/NVdfRd2Fz01PIciLsjNdvTNfJCKpRb+7fazNB0zz2hab06cUcLHiH4TKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639063;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=zo2Tb32+IKEt2npZMaOafG7jIQLj+yFukRmwwfNigLU=;
	b=0zG8sdD4oAzLJ5c9Y6HSA90f+MTaelV++LJo2MWCtA2LQoHyPwUv9Vblx9P+vu9HnxjW
	 aJnfAJoybuD7cgjcww+nLsXcXCslF3fFhSLolFhEScIOibjTxhz97kSIHjW6mSa4snsyo
	 p8KyREqVk+qlwpxIoDyp0OH7WGuRzwfJlviUokmQo6+B+wSSeNMd99Ryd3UrxSecrrtFt
	 b+JIXqIwdnujQDFKV/U6CjNpnq4dxwYqMkZ+84a4rV9L3IPLGD+qz0OLydjwk8hEes7Em
	 p2dtXlHDYE32eGWrCngh6/m+p9mfJXa3VfLPHrXr/9xTyiD43zJQE4Mke3QPwvjOjqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B5QhHoW4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FFE60A263F;
	Thu, 22 Oct 2026 03:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B5QhHoW4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7500E1F000CB;
	Thu, 22 Oct 2026 03:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639063;
	bh=zo2Tb32+IKEt2npZMaOafG7jIQLj+yFukRmwwfNigLU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B5QhHoW4TwfPlYBEMytyaqJSPQjSAu104/Y/NUneBhh8kgVRGdHidlTVD/U+cyr57
	 OXM69YZitMDCqVGPldyz0cemHcHzgjK/b3AEfQX3c/3Zb4uFgbEFQ8VP6imTF9SeLj
	 qO+0rrPM5nAhRK8xwYpe0OpsHPhBiqDUNwB+DalZg/beRdEQux60aQHsh3fsN2IL4n
	 0YHeowEH+0GqfwyJrsWJPpAHYpchIyEaH/XatoNHE6Pb1TxVEwDdl1rIsVwI+h3BRu
	 KP9ruUeM/uspBy44RGp5GD9aEfkwjV/jLWpQ7aypCPAL/P4kXyBAeMDhFgN0DDFCzH
	 M7VvgHf4CR72A==
Message-ID: <sashiko-outbox-180919@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 18/41] fs: keep UUID and GUID owners off
 filesystems that can't store them
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Jan Kara" <jack@suse.cz>, =?utf-8?b?VGhlb2RvcmUgWS4gVHMnbw==?= <tytso@mit.edu>, "Paul
 Moore" <paul@paul-moore.com>, "Arnd Bergmann" <arnd@arndb.de>, linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, keyrings@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <d67ff709d9b2a9a8eb0948cebbba445ed48276d1.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <d67ff709d9b2a9a8eb0948cebbba445ed48276d1.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:42 +0000
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
- [High] fs: vfs_rename() with RENAME_WHITEOUT skips fsuidgid_has_mapping()=
 when target exists
- [Medium] fs: UUID/GUID owner check bypassed in ocfs2_may_create() and f2f=
s atomic write
--

commit 3d0ae6a640c537e68d1d11095789815bcc76e4cd
Author: Jan Koester <jan.koester@tuxist.de>

fs: keep UUID and GUID owners off filesystems that can't store them

This commit adds the SB_I_UID_R superblock flag for filesystems that can
store UUID and GUID inode owners, and updates notify_change() and
fsuidgid_has_mapping() to reject UUID and GUID owners on filesystems
without that flag.

> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index deb411e866617..05c4611c87744 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1563,14 +1563,35 @@ static inline void inode_fsgid_set(struct inode *=
inode,
>  	inode->i_gid =3D mapped_fsgid(idmap, i_user_ns(inode));
>  }
> =20
> +/**
> + * sb_can_own_kuid() - check whether a filesystem can store an owner
> + * @sb: the superblock
> + * @kuid: the owner
> + *
> + * Classic ids fit any filesystem; UUIDs and GUIDs only those that set
> + * SB_I_UID_R. Elsewhere i_uid_read() would turn them into -1.
> + *
> + * Return: true if @sb can store @kuid.
> + */
> +static inline bool sb_can_own_kuid(const struct super_block *sb, kuid_t =
kuid)
> +{
> +	return uid_is_legacy(kuid) || (sb->s_iflags & SB_I_UID_R);
> +}
> +
> +static inline bool sb_can_own_kgid(const struct super_block *sb, kgid_t =
kgid)
> +{
> +	return gid_is_legacy(kgid) || (sb->s_iflags & SB_I_UID_R);
> +}
> +
>  /**
>   * fsuidgid_has_mapping() - check whether caller's fsuid/fsgid is mapped
>   * @sb: the superblock we want a mapping in
>   * @idmap: idmap of the relevant mount
>   *
>   * Check whether the caller's fsuid and fsgid have a valid mapping in the
> - * s_user_ns of the superblock @sb. If the caller is on an idmapped moun=
t map
> - * the caller's fsuid and fsgid according to the @idmap first.
> + * s_user_ns of the superblock @sb, and whether @sb can store them as ow=
ner
> + * of a new inode. If the caller is on an idmapped mount map the caller's
> + * fsuid and fsgid according to the @idmap first.
>   *
>   * Return: true if fsuid and fsgid is mapped, false if not.
>   */
> @@ -1582,10 +1603,10 @@ static inline bool fsuidgid_has_mapping(struct su=
per_block *sb,
>  	kgid_t kgid;
> =20
>  	kuid =3D mapped_fsuid(idmap, fs_userns);
> -	if (!uid_valid(kuid))
> +	if (!uid_valid(kuid) || !sb_can_own_kuid(sb, kuid))
>  		return false;

[Severity: High]
Can a caller with a UUID or GUID fsuid or fsgid bypass fsuidgid_has_mapping=
()
during a whiteout rename when the target dentry already exists?

In fs/namei.c, sys_renameat2() -> filename_renameat2() -> vfs_rename() only
calls may_create_dentry() (which checks fsuidgid_has_mapping()) when target
is NULL:

fs/namei.c:vfs_rename() {
    ...
	if (!target) {
		error =3D may_create_dentry(rd->mnt_idmap, new_dir, new_dentry);
	} else {
		new_is_dir =3D d_is_dir(new_dentry);

		if (!(flags & RENAME_EXCHANGE))
			error =3D may_delete_dentry(rd->mnt_idmap, new_dir,
						  new_dentry, is_dir);
		else
			error =3D may_delete_dentry(rd->mnt_idmap, new_dir,
						  new_dentry, new_is_dir);
	}
    ...
}

When target is non-NULL and flags includes RENAME_WHITEOUT, vfs_rename()
only calls may_delete_dentry() on old_dentry and new_dentry, which validates
the existing victim inodes and directory permissions without checking
fsuidgid_has_mapping(old_dir->i_sb, rd->mnt_idmap).

vfs_rename() then invokes old_dir->i_op->rename(..., RENAME_WHITEOUT), which
allocates a new whiteout inode in old_dir and initializes its i_uid and i_g=
id
from current_fsuid() and current_fsgid() via inode_init_owner(), such as in
fs/ext4/namei.c:

fs/ext4/namei.c:ext4_rename() {
    ...
	if (!(flags & RENAME_WHITEOUT)) {
		handle =3D ext4_journal_start(old.dir, EXT4_HT_DIR, credits);
		if (IS_ERR(handle)) {
			retval =3D PTR_ERR(handle);
			goto release_bh;
		}
	} else {
		whiteout =3D ext4_whiteout_for_rename(idmap, &old, credits, &handle);
		if (IS_ERR(whiteout)) {
			retval =3D PTR_ERR(whiteout);
			goto release_bh;
		}
	}
    ...
}

The same whiteout creation occurs in ext4_rename() ->
ext4_whiteout_for_rename() -> __ext4_new_inode(), btrfs_rename() ->
new_whiteout_inode(), f2fs_rename() -> f2fs_create_whiteout(), and
xfs_rename() -> xfs_rename_alloc_whiteout().

On filesystems without SB_I_UID_R (such as btrfs, f2fs, xfs, ubifs, and ext4
prior to the later commit "ext4: add the uid_r feature for UUID and GUID
owners"), the whiteout inode's owner is written to disk via i_uid_read() and
i_gid_read() as (uid_t)-1 / (gid_t)-1 (0xffffffff). When read back from dis=
k,
that becomes INVALID_UID / INVALID_GID and leaves the whiteout entry
undeletable because may_delete_dentry() rejects inodes with invalid vfsuid =
or
vfsgid with -EOVERFLOW.

Additionally, once the later commit "ext4: add the uid_r feature for UUID a=
nd
GUID owners" is applied, __ext4_new_inode() -> ext4_mark_inode_dirty() ->
ext4_do_update_inode() -> ext4_fill_raw_inode() -> ext4_inode_set_id_r()
fails with -EOVERFLOW on an ext4 filesystem without the uid_r feature and
calls EXT4_ERROR_INODE() and ext4_std_error(), aborting the journal and
remounting the filesystem read-only (or panicking when mounted with
errors=3Dpanic).

Should vfs_rename() also check fsuidgid_has_mapping(old_dir->i_sb,
rd->mnt_idmap) when flags & RENAME_WHITEOUT is set?

>  	kgid =3D mapped_fsgid(idmap, fs_userns);
> -	if (!gid_valid(kgid))
> +	if (!gid_valid(kgid) || !sb_can_own_kgid(sb, kgid))
>  		return false;

[Severity: Medium]
Are there also filesystem-internal inode creation paths that initialize new
inodes with inode_init_owner() without going through fsuidgid_has_mapping()?

Because sb_can_own_kuid() and sb_can_own_kgid() are only checked in
fsuidgid_has_mapping() (called by may_create_dentry(), may_o_create(), and
vfs_tmpfile()), callers that allocate new inodes through private helpers sk=
ip
this check:

1. In fs/ocfs2/refcounttree.c, ioctl(OCFS2_IOC_REFLINK) ->
ocfs2_reflink_ioctl() -> ocfs2_vfs_reflink() checks permissions with
ocfs2_may_create() rather than may_create_dentry():

fs/ocfs2/refcounttree.c:ocfs2_may_create() {
	if (d_really_is_positive(child))
		return -EEXIST;
	if (IS_DEADDIR(dir))
		return -ENOENT;
	return inode_permission(&nop_mnt_idmap, dir, MAY_WRITE | MAY_EXEC);
}

When preserve is false, a caller with a UUID or GUID fsuid or fsgid creates=
 a
new inode via ocfs2_reflink() -> ocfs2_create_inode_in_orphan() ->
ocfs2_get_init_inode() -> inode_init_owner() in fs/ocfs2/namei.c.
__ocfs2_mknod_locked() then writes i_uid_read(inode) and i_gid_read(inode) =
as
-1 to fe->i_uid and fe->i_gid on disk and calls ocfs2_populate_inode(), whi=
ch
sets the in-memory inode's i_uid and i_gid to INVALID_UID and INVALID_GID
before ocfs2_mv_orphaned_inode_to_new() links it into the target directory.

2. In fs/f2fs/file.c, f2fs_ioc_start_atomic_write() checks
inode_owner_or_capable() (which does not check fsgid, and permits a UUID or
GUID fsuid if the caller has CAP_FOWNER) and then allocates a COW inode via
f2fs_get_tmpfile() -> __f2fs_tmpfile() -> f2fs_new_inode() ->
inode_init_owner() without calling vfs_tmpfile() or fsuidgid_has_mapping():

fs/f2fs/file.c:f2fs_ioc_start_atomic_write() {
    ...
	if (fi->cow_inode =3D=3D NULL) {
		struct dentry *dentry =3D file_dentry(filp);
		struct inode *dir =3D d_inode(dentry->d_parent);

		ret =3D f2fs_get_tmpfile(idmap, dir, &fi->cow_inode);
    ...
}

This causes f2fs_update_inode() to write (uid_t)-1 / (gid_t)-1 to the on-di=
sk
COW inode.

Should ocfs2_may_create() and f2fs_ioc_start_atomic_write() (or the common
inode allocation path) also verify fsuidgid_has_mapping()?

>  	return kuid_has_mapping(fs_userns, kuid) &&
>  	       kgid_has_mapping(fs_userns, kgid);

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D18
