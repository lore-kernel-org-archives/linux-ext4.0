Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639079;
	b=b+82N8dudOAfi32YbsiJnoAjSz27vergbAG+9TzKW9oOKtI7iCv7DH9pBNoQDNXh7G9a
	 lWNj392U8dM3/0JTorMUk4EvOKweigkzB3gpbxk8jPbaUL+JvdgrR4K3AjKPeCiC/6zg9
	 eg/wGkF2nZ6rQJGm2mNahT9AJOezhzu6NCGl4VumMqSPfzDbI+wJiF9aioDcq+i6gITGF
	 Uv4NIlNTe5eprEy07hz4WeVkNV28Xb+g5+Nz9upuIgu23iwiTFuoqIRWoU3CeLKzqRBgj
	 autNZjFAWhXdJDQGjGYH6PmQwCBXrdPSyYTAUxR7QCuEk26JT0FsD99ux0SWyfaK+DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639079;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=i+N4LbUUyWfClUPWjWS9ez93aTXKpD52iDDk7qfIBV8=;
	b=FTyinPRTFLfnJr+V/ISgX+UZb2LkcIp9KKLRgOyvYE3Lj3QY5a3sbKeBUjZhG6a0btJ1
	 dZup32938hTTx1pP0hK3n00eLlwEZv4WkA4de0TXYiu+W6w1l29gKKlMAdNla3G9Tq9jZ
	 y1oZPZ2BVhP/FpbFQCfDbzVgj1YRJ9eHAjAA4hgIqIJdViTf0ghfT32QzmhI5f50NMhj4
	 Wv8PWyLt2iuFKUE60YrIt9HsRcg7GEu5RnuANfZEc9xtyhcG9vtoUg2wbH6Y4/Skxp3vK
	 OLlZMFSpqKT74XkW8MWg8CGtNhKGpW/1hXJIaQnm8Um9TFDd9Dcglcj1Ym9K7UL81sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LDrkHslD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262C8606A338;
	Thu, 22 Oct 2026 03:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LDrkHslD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7081F000CC;
	Thu, 22 Oct 2026 03:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639079;
	bh=i+N4LbUUyWfClUPWjWS9ez93aTXKpD52iDDk7qfIBV8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LDrkHslDMJ0m/gTcR6J8Q/2/EbSQHbSRJ88UnkPb41U2xT3Z5UOyMBY+jqqVf2uat
	 Q3MlU3S/iRgNfSm8vd2K0zXVClUMkMSpxOY0p4mxeqv5NecyzP3p3KnDwCsiFtnc/k
	 k2ExUBNSqsngf9eKhXgxcn8jpFTNr1S/TmFqcwghkfOuCodIruf8yQLWwg2mBA/XrA
	 OyRJcpHepDw406sBqXztMQRS+YisPVJeeKwwm+9SMIj+e1C2P2eW/7qyZQnLjgG4eA
	 wNQhRUWHamuqO42zkkNLppomrWzl3q3MW7ErYLvwkZnq31Ugjv8x4ml9gBk7DeRwVg
	 oeJd6wF/GzcbQ==
Message-ID: <sashiko-outbox-180932@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 31/41] ext4: add the uid_r feature for UUID and
 GUID owners
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Jan Kara" <jack@suse.cz>, =?utf-8?b?VGhlb2RvcmUgWS4gVHMnbw==?= <tytso@mit.edu>, "Paul
 Moore" <paul@paul-moore.com>, "Arnd Bergmann" <arnd@arndb.de>, linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, keyrings@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <1ced8bf416de4e9600904aafeefd29ed20fd2064.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <1ced8bf416de4e9600904aafeefd29ed20fd2064.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:57 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [High] ext4: unverified extra_isize expansion in ext4_make_room_for_id_r()
- [Medium] ext4: UUID/GUID owners lost in ext4_xattr_inode_create() and ext=
4_ext_migrate()
- [Medium] ext4: debug_want_extra_isize can set s_want_extra_isize too smal=
l for uid_r
- [Medium] ext4: NO_UID32 clobbers 0xffffffff sentinel in ext4_fill_raw_ino=
de()
- [Medium] ext4: race in ext4_make_room_for_id_r() with concurrent inode ex=
pansion
- [Medium] ext4: unsynchronized 20-byte i_uid and i_gid accesses in ext4_fi=
ll_raw_inode()
--

commit f1bc4b92fd7bffda167e28ce9ca4459d00337211
Author: Jan Koester <jan.koester@tuxist.de>

ext4: add the uid_r feature for UUID and GUID owners

This commit adds the read-only compatible uid_r feature to ext4, extending
struct ext4_inode with i_uid_r_type, i_gid_r_type, i_uid_r, and i_gid_r to
store 16-byte UUID and GUID owners and groups while storing 0xffffffff in
the classic i_uid and i_gid fields. It also sets SB_I_UID_R on the
superblock and expands existing inodes in ext4_setattr() when assigning a
UUID or GUID owner or group.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 26f0f9714f03c..bed8d535a6e4e 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4780,6 +4780,75 @@ static int ext4_inode_blocks_set(struct ext4_inode=
 *raw_inode,
>  	return 0;
>  }
> =20
> +/*
> + * uid_r: a UUID or GUID owner and group live in i_uid_r and i_gid_r of
> + * inodes with room for them; i_uid and i_gid then hold 0xffffffff.
> + */
> +static int ext4_inode_set_id_r(struct inode *inode, struct ext4_inode *r=
aw_inode)
> +{
> +	struct ext4_inode_info *ei =3D EXT4_I(inode);
> +	bool fits =3D EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
> +		    EXT4_FITS_IN_INODE(raw_inode, ei, i_gid_r);
> +	bool legacy =3D uid_is_legacy(inode->i_uid) && gid_is_legacy(inode->i_g=
id);
> +
> +	if (!legacy && (!ext4_has_feature_uid_r(inode->i_sb) || !fits))
> +		return -EOVERFLOW;
> +	if (!fits || !ext4_has_feature_uid_r(inode->i_sb))
> +		return 0;
> +
> +	raw_inode->i_id_r_reserved =3D 0;
> +	if (uid_is_legacy(inode->i_uid)) {
> +		raw_inode->i_uid_r_type =3D EXT4_ID_R_LEGACY;
> +		memset(raw_inode->i_uid_r, 0, sizeof(raw_inode->i_uid_r));
> +	} else {
> +		BUILD_BUG_ON(KID_UUID !=3D EXT4_ID_R_UUID ||
> +			     KID_GUID !=3D EXT4_ID_R_GUID);
> +		raw_inode->i_uid_r_type =3D inode->i_uid.type;
> +		memcpy(raw_inode->i_uid_r, inode->i_uid.uuid.b,
> +		       sizeof(raw_inode->i_uid_r));
> +	}
> +	if (gid_is_legacy(inode->i_gid)) {
> +		raw_inode->i_gid_r_type =3D EXT4_ID_R_LEGACY;
> +		memset(raw_inode->i_gid_r, 0, sizeof(raw_inode->i_gid_r));
> +	} else {
> +		raw_inode->i_gid_r_type =3D inode->i_gid.type;
> +		memcpy(raw_inode->i_gid_r, inode->i_gid.uuid.b,
> +		       sizeof(raw_inode->i_gid_r));
> +	}
> +	return 0;
> +}

[Severity: Medium]
With UUID and GUID support, kuid_t and kgid_t are 20-byte structures, so
reads and writes of inode->i_uid and inode->i_gid are multi-word and not
atomic.

In fs/ext4/inode.c, ext4_setattr() updates inode->i_uid and inode->i_gid
under inode->i_rwsem without holding EXT4_I(inode)->i_raw_lock:

fs/ext4/inode.c:ext4_setattr() {
    ...
    i_uid_update(idmap, attr, inode);
    i_gid_update(idmap, attr, inode);
    error =3D ext4_mark_inode_dirty(handle, inode);
}

Concurrently, paths that dirty the inode without holding inode->i_rwsem
(such as touch_atime() -> ext4_dirty_inode(), or unwritten extent
conversion in ext4_end_io_rsv_work() -> ext4_mark_inode_dirty()) call
ext4_do_update_inode() -> ext4_fill_raw_inode() -> ext4_inode_set_id_r()
under ei->i_raw_lock, and __ext4_get_inode_loc() also calls
ext4_fill_raw_inode() under lock_buffer(bh).

Because ext4_fill_raw_inode() first reads inode->i_uid and inode->i_gid via
i_uid_read() and i_gid_read(), and ext4_inode_set_id_r() then re-reads
inode->i_uid and inode->i_gid multiple times, can a concurrent chown race
with ext4_fill_raw_inode() and write a torn 16-byte UUID/GUID or mismatched
classic i_uid/i_gid and i_uid_r/i_gid_r fields (with a valid metadata
checksum computed over that inconsistent state) into raw_inode?

[ ... ]

> @@ -4792,8 +4861,10 @@ static int ext4_fill_raw_inode(struct inode *inode=
, struct ext4_inode *raw_inode
>  	err =3D ext4_inode_blocks_set(raw_inode, ei);
> =20
>  	raw_inode->i_mode =3D cpu_to_le16(inode->i_mode);
> +	/* a UUID or GUID owner: 0xffffffff here, the id in i_uid_r */
>  	i_uid =3D i_uid_read(inode);
>  	i_gid =3D i_gid_read(inode);
> +	err =3D err ?: ext4_inode_set_id_r(inode, raw_inode);

[Severity: Medium]
When an inode has a UUID or GUID owner or group, i_uid_read(inode) and
i_gid_read(inode) return (uid_t)-1 (0xffffffff).

Both ext4_xattr_inode_create() in fs/ext4/xattr.c and ext4_ext_migrate() in
fs/ext4/migrate.c copy the parent inode's owner into a uid_t owner[2] array
using i_uid_read() and i_gid_read() and pass that array to ext4_new_inode():

fs/ext4/xattr.c:ext4_xattr_inode_create() {
    struct inode *ea_inode =3D NULL;
    uid_t owner[2] =3D { i_uid_read(inode), i_gid_read(inode) };
    ...
    ea_inode =3D ext4_new_inode(handle, inode->i_sb->s_root->d_inode,
                              S_IFREG | 0600, NULL, inode->i_ino + 1, owner,
                              EXT4_EA_INODE_FL);
}

fs/ext4/migrate.c:ext4_ext_migrate() {
    ...
    owner[0] =3D i_uid_read(inode);
    owner[1] =3D i_gid_read(inode);
    tmp_inode =3D ext4_new_inode(handle, d_inode(inode->i_sb->s_root),
                               S_IFREG, NULL, goal, owner, 0);
}

In fs/ext4/ialloc.c, __ext4_new_inode() then passes those 32-bit values to
i_uid_write() and i_gid_write() before calling dquot_initialize():

fs/ext4/ialloc.c:__ext4_new_inode() {
    if (owner) {
        inode->i_mode =3D mode;
        i_uid_write(inode, owner[0]);
        i_gid_write(inode, owner[1]);
    }
    ...
    err =3D dquot_initialize(inode);
}

Because make_kuid(&init_user_ns, (uid_t)-1) produces INVALID_UID (with
KID_LEGACY and value -1) rather than preserving the UUID or GUID,
qid_has_mapping() in dqget() returns false and causes dquot_initialize() to
fail with -EINVAL when quotas are enabled, or writes out the helper inode
with EXT4_ID_R_LEGACY and i_uid 0xffffffff when quotas are disabled.

Should ext4_xattr_inode_create() and ext4_ext_migrate() preserve the full
kuid_t and kgid_t owner and group when creating helper inodes for a UUID or
GUID owned file?

[ ... ]

> @@ -6006,6 +6079,40 @@ static void ext4_wait_for_tail_page_commit(struct =
inode *inode)
>   *
>   * Called with inode->i_rwsem down.
>   */
> +/*
> + * An inode from before uid_r, or with in-inode xattrs in the way, may
> + * lack room for i_uid_r and i_gid_r: make it, before it gets a UUID or
> + * GUID owner or group.
> + */
> +static int ext4_make_room_for_id_r(struct mnt_idmap *idmap,
> +				   struct inode *inode, struct iattr *attr)
> +{
> +	struct ext4_iloc iloc;
> +	bool legacy =3D true;
> +	int err;
> +
> +	if (attr->ia_valid & ATTR_UID)
> +		legacy =3D uid_is_legacy(from_vfsuid(idmap, i_user_ns(inode),
> +						   attr->ia_vfsuid));
> +	if (attr->ia_valid & ATTR_GID)
> +		legacy &=3D gid_is_legacy(from_vfsgid(idmap, i_user_ns(inode),
> +						    attr->ia_vfsgid));
> +	if (legacy)
> +		return 0;
> +	if (!ext4_has_feature_uid_r(inode->i_sb))
> +		return -EOVERFLOW;
> +
> +	err =3D ext4_get_inode_loc(inode, &iloc);
> +	if (err)
> +		return err;
> +	if (EXT4_FITS_IN_INODE(ext4_raw_inode(&iloc), EXT4_I(inode), i_gid_r)) {
> +		brelse(iloc.bh);
> +		return 0;
> +	}

[Severity: Medium]
In ext4_make_room_for_id_r(), EXT4_FITS_IN_INODE() is checked without
holding EXT4_I(inode)->xattr_sem before calling ext4_expand_extra_isize()
with EXT4_EXTRA_ISIZE_UID_R.

Concurrently, paths that dirty the inode without holding inode->i_rwsem
(such as ext4_dirty_inode(), ext4_page_mkwrite(), or
ext4_end_io_rsv_work()) can call __ext4_mark_inode_dirty() ->
ext4_try_to_expand_extra_isize(), which acquires xattr_sem via
ext4_write_trylock_xattr() and sets EXT4_STATE_NO_EXPAND while xattr_sem is
held.

If ext4_expand_extra_isize() runs during that window, it checks
EXT4_STATE_NO_EXPAND before taking xattr_sem:

fs/ext4/inode.c:ext4_expand_extra_isize() {
    if (ext4_test_inode_state(inode, EXT4_STATE_NO_EXPAND)) {
        brelse(iloc->bh);
        return -EOVERFLOW;
    }
    ...
}

Furthermore, if ext4_expand_extra_isize() passes that check and blocks on
ext4_write_lock_xattr() while ext4_try_to_expand_extra_isize() expands
ei->i_extra_isize to sbi->s_want_extra_isize (when sbi->s_want_extra_isize
exceeds EXT4_EXTRA_ISIZE_UID_R), __ext4_expand_extra_isize() will then see
new_extra_isize < ei->i_extra_isize and return -EINVAL:

fs/ext4/inode.c:__ext4_expand_extra_isize() {
    if ((new_extra_isize < ei->i_extra_isize) ||
        (new_extra_isize < 4) ||
        (new_extra_isize > inode_size - EXT4_GOOD_OLD_INODE_SIZE))
        return -EINVAL;	/* Should never happen */
}

Could this race cause ext4_make_room_for_id_r() to spuriously fail a chown
operation with -EOVERFLOW even when sufficient extra inode space is
available?

> +	err =3D ext4_expand_extra_isize(inode, EXT4_EXTRA_ISIZE_UID_R, &iloc);
> +	return err ? -EOVERFLOW : 0;
> +}

[Severity: High]
What happens here if ext4_expand_extra_isize() returns 0 without expanding
i_extra_isize all the way to EXT4_EXTRA_ISIZE_UID_R?

When an inode has in-inode extended attributes (EXT4_STATE_XATTR) that
cannot be moved out to free 36 bytes (for example, inline data or an
external xattr block without enough free space), ext4_expand_extra_isize()
-> __ext4_expand_extra_isize() -> ext4_expand_extra_isize_ea() falls back
to s_min_extra_isize (typically 32 bytes) on -ENOSPC and jumps to retry:

fs/ext4/xattr.c:ext4_expand_extra_isize_ea() {
retry:
    isize_diff =3D new_extra_isize - EXT4_I(inode)->i_extra_isize;
    if (EXT4_I(inode)->i_extra_isize >=3D new_extra_isize)
        return 0;
    ...
    if (error) {
        if (error =3D=3D -ENOSPC && !tried_min_extra_isize &&
            s_min_extra_isize) {
            tried_min_extra_isize++;
            new_extra_isize =3D s_min_extra_isize;
            error =3D 0;
            goto retry;
        }
        goto cleanup;
    }
}

When i_extra_isize is already at least s_min_extra_isize (such as 32 bytes
on an inode created before uid_r), ext4_expand_extra_isize_ea() returns 0
at the retry label while i_extra_isize is still smaller than
EXT4_EXTRA_ISIZE_UID_R.

ext4_make_room_for_id_r() then returns 0, so ext4_setattr() updates
inode->i_uid and inode->i_gid in memory to the UUID/GUID and calls
ext4_mark_inode_dirty() -> ext4_do_update_inode() -> ext4_fill_raw_inode()
-> ext4_inode_set_id_r(), which sees !legacy && !fits, returns -EOVERFLOW,
and triggers a false-positive filesystem corruption error:

fs/ext4/inode.c:ext4_do_update_inode() {
    err =3D ext4_fill_raw_inode(inode, raw_inode);
    spin_unlock(&ei->i_raw_lock);
    if (err) {
        EXT4_ERROR_INODE(inode, "corrupted inode contents");
        goto out_brelse;
    }
}

Should ext4_make_room_for_id_r() verify that i_gid_r actually fits in the
inode after ext4_expand_extra_isize() returns?

[ ... ]

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index d636b89090a24..34ac087c32dcb 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4613,9 +4613,17 @@ static int ext4_inode_info_init(struct super_block=
 *sb,
>  		sb->s_time_min =3D EXT4_TIMESTAMP_MIN;
>  	}
> =20
> +	if (ext4_has_feature_uid_r(sb) &&
> +	    sbi->s_inode_size < EXT4_GOOD_OLD_INODE_SIZE + EXT4_EXTRA_ISIZE_UID=
_R) {
> +		ext4_msg(sb, KERN_ERR, "uid_r needs inodes of at least %zu bytes",
> +			 EXT4_GOOD_OLD_INODE_SIZE + EXT4_EXTRA_ISIZE_UID_R);
> +		return -EINVAL;
> +	}
> +
>  	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE) {
> -		sbi->s_want_extra_isize =3D sizeof(struct ext4_inode) -
> -			EXT4_GOOD_OLD_INODE_SIZE;
> +		/* room for the uid_r fields in new inodes only if needed */
> +		sbi->s_want_extra_isize =3D ext4_has_feature_uid_r(sb) ?
> +			EXT4_EXTRA_ISIZE_UID_R : EXT4_EXTRA_ISIZE_BASE;

[Severity: Medium]
In __ext4_fill_super(), ext4_inode_info_init() initializes
sbi->s_want_extra_isize to EXT4_EXTRA_ISIZE_UID_R, but
parse_apply_sb_mount_options(), ext4_check_opt_consistency(), and
ext4_apply_options() run right afterwards (and on remount in
__ext4_remount()) and overwrite sbi->s_want_extra_isize when the
debug_want_extra_isize mount option is specified.

Because ext4_check_opt_consistency() only checks the upper bound of
ctx->s_want_extra_isize:

fs/ext4/super.c:ext4_check_opt_consistency() {
    if (ctx->s_want_extra_isize >
        (sbi->s_inode_size - EXT4_GOOD_OLD_INODE_SIZE)) {
        ext4_msg(NULL, KERN_ERR,
             "Invalid want_extra_isize %d",
             ctx->s_want_extra_isize);
        return -EINVAL;
    }
}

mounting or remounting a uid_r filesystem with debug_want_extra_isize
smaller than EXT4_EXTRA_ISIZE_UID_R causes __ext4_new_inode() to initialize
ei->i_extra_isize to that smaller value.

If a new inode is then created with a UUID or GUID owner or group, won't
ext4_mark_inode_dirty() -> ext4_do_update_inode() -> ext4_fill_raw_inode()
-> ext4_inode_set_id_r() return -EOVERFLOW and trigger
EXT4_ERROR_INODE(inode, "corrupted inode contents")?

>  		if (ext4_has_feature_extra_isize(sb)) {
>  			unsigned v, max =3D (sbi->s_inode_size -
>  					   EXT4_GOOD_OLD_INODE_SIZE);
> @@ -5437,6 +5445,10 @@ static int __ext4_fill_super(struct fs_context *fc=
, struct super_block *sb)
>  	/* HSM events are allowed by default. */
>  	sb->s_iflags |=3D SB_I_ALLOW_HSM;
> =20
> +	/* uid_r: inodes can have UUID and GUID owners */
> +	if (ext4_has_feature_uid_r(sb) && !test_opt(sb, NO_UID32))
> +		sb->s_iflags |=3D SB_I_UID_R;

[Severity: Medium]
While __ext4_fill_super() avoids setting SB_I_UID_R when NO_UID32 is
enabled at mount time, __ext4_remount() allows enabling NO_UID32 on remount
without clearing SB_I_UID_R, and ext4_inode_get_id_r() loads UUID and GUID
owners into inode->i_uid and inode->i_gid regardless of NO_UID32.

When an inode with a UUID or GUID owner or group is dirtied and written out
in ext4_fill_raw_inode() while NO_UID32 is set, i_uid_read(inode) and
i_gid_read(inode) return 0xffffffff, and the NO_UID32 branch converts them
with fs_high2lowuid() and fs_high2lowgid():

fs/ext4/inode.c:ext4_fill_raw_inode() {
    if (!(test_opt(inode->i_sb, NO_UID32))) {
        ...
    } else {
        raw_inode->i_uid_low =3D cpu_to_le16(fs_high2lowuid(i_uid));
        raw_inode->i_gid_low =3D cpu_to_le16(fs_high2lowgid(i_gid));
        raw_inode->i_uid_high =3D 0;
        raw_inode->i_gid_high =3D 0;
    }
}

Doesn't this overwrite the on-disk 0xffffffff sentinel in i_uid and i_gid
with 0x0000fffe (65534) while leaving i_uid_r_type and i_gid_r_type set to
EXT4_ID_R_UUID or EXT4_ID_R_GUID?

> +
>  	err =3D ext4_check_feature_compatibility(sb, es, silent);
>  	if (err)
>  		goto failed_mount;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D31
