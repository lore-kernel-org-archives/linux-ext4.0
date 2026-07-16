Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5563339B978
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 20:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784234523; cv=none; b=kdNz8mzx1GiT0COuoSQKxZ+BTjluT+cOYt4I8j+D5PxWf7doRPDCIQjtZuUZfZ21QnLaGpr6Mz+zKsOiqOmFG/elsH6Ya8V9HmRazYBnDOO/glXblacEsiCbaMy8EHLljXdloOmHQNztAdWqkvUCjKTL5kf9+eJyzD6D8amL8zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784234523; c=relaxed/simple;
	bh=C+cizh8R2PtRngSywaJYbleS7FfD9JYiIPAiMtyR2ZU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=bujGCPjjRl0nOhWehhRm0wGaq9fVZ/m0489rhlB/XvkCId2jFAxicnsGGLHo0F9CUKbu88CMMucjdIz73OwIOxoS+jIKG7q10/E8E3WG2dha7JAlEvgbjdrsnO8xD30cNrI+NCWf/2fR1RJoi5+4i6SWDdlbRTlgCFxTckegScA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=c1gowSzI; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="c1gowSzI"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-381ed661712so7390758a91.2
        for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 13:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1784234518; x=1784839318; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XthHO6D3HBL+PvzieSSh/CkFb38oW/LuqZ8SezNU3Hg=;
        b=c1gowSzITzT63YLUookDGOfdgVn/SHaCBb96WqC5pb6GXGaDGpiINrQgo52AbkgLJ2
         oSJeZ0uB+GqjvKrDB0Iom5Lmy2ccsGrK9Spu/5J/XF0WXN4oz4tOLTjj0Wg6JpG5Wwfx
         yLHlCMTh9TrrD3TsFu4usdOGTh8Mboi3go4x7E4kBUIRDak6chHInUmaBA8fHMkrbTof
         ZkJetrEBdcBFrjOx37npjoHVk6p2AOTCVUXcWnNxmHqyjd/u+lX/LEuF1TiUXN/MDIID
         JZ8wM7gUeD5FfZnGlYdijQ97CVoKk0P5/PAlhYlnx2yxNQIwg+qenRhxJCGwZvbd/5N9
         A2PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784234518; x=1784839318;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XthHO6D3HBL+PvzieSSh/CkFb38oW/LuqZ8SezNU3Hg=;
        b=nkctO38EOzxhGltVY70e81gMjkmVVxwt4RhslOrzR1vJViNPAVucM9O4ptv0BHxI+0
         gKLEO1n0RzEfQURqytormPzltRFWC7hN1gj8+9My//79wBpFkc2OQxFpapkRNYNG4Iia
         JfsCuysJYrycVHnBTRlKtZlkACv20HgsyQHOtgYkSmCnhpFU/cPiSgJAmnREfRGErz4g
         /HDqjFoKTrKE8m2pGuYxJ4NMHckFbZQkyzyvuqCf9rOaCveYdYWI2lBVlLCi2alZHrFS
         r0xcW9gwT8T8ZFYMWMYtFA5aNhuL0CTB5BL47I9xf4sXzgwcMGIBJ1UgxE0q2nhDJoGI
         uEyg==
X-Gm-Message-State: AOJu0YyuExf2XQ4vEAbce6kdRhK9A0cZHwS+mtoEu14UnRol4BSiK1z+
	w/7nWF8QcHr8ZiRX3njgSaWT+z2IkBkgBW7dn/M4YM6lCl8tCu+svDROq329cB1Av/U=
X-Gm-Gg: AfdE7cm4WYOHjogoylVh6Ni5RdpYYOqsfXohGtL0aipLFGwTLWpwVu4wNaK4JaNLCxX
	itbPOyGfpOLJAr8vl5FlCuFIT9FyWcVsHNcRRPAgfyFi5HjuvG7u/gjgCne7X4hV4yzMRZhet6Y
	6CUkWmqLcKop+JkNOczxfQa7kuciVq+1Oh9UAYUddB0lJZrelDNXer+99o7tmmCS/1tae4a8cah
	ld6qG8y+DqtuX0Aj9YfoNIZmTo+SYPEeWqE95rZzGCiBJfvX/zHzryA/hg/JYPEn6Rly7tCS1qZ
	xsiG74Yru4XlAgLI9n/WZv9C/WzmWrft53+qhUgtWw7u+FeR3ZpxdjaFTsmpErwWVKggQeBrsqv
	otQ2rTb6MqDtuCXtbY4PPOooTUd4ShQSDz6luK0++CIdg9DB1i3hWyuaIViQ0USB7XeZBr5DOdd
	WtqzK3C9K6JYurCsh2DiEq1lbp4gLQQ3w3zi7hv/8utA==
X-Received: by 2002:a17:90b:3b8b:b0:38d:dbc7:5179 with SMTP id 98e67ed59e1d1-38e1af35e87mr11363705a91.30.1784234517623;
        Thu, 16 Jul 2026 13:41:57 -0700 (PDT)
Received: from smtpclient.apple ([2604:3d09:3a84:1700:3854:7eec:417a:89dd])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e46b18ce9sm170328a91.0.2026.07.16.13.41.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jul 2026 13:41:56 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH v5 09/11] ext4: add dirdata LUFID support for directory
 entry rename
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260714125111.14699-10-ablagodarenko@thelustrecollective.com>
Date: Thu, 16 Jul 2026 14:41:45 -0600
Cc: linux-ext4@vger.kernel.org,
 Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A189E97C-CB25-4C44-8143-C110C8B40707@dilger.ca>
References: <20260714125111.14699-1-ablagodarenko@thelustrecollective.com>
 <20260714125111.14699-10-ablagodarenko@thelustrecollective.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)


On Jul 14, 2026, at 06:51, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> ext4_setent() updates the inode number and file_type in an existing
> directory entry but did not handle the dirdata extension payload.
> Extend it with a src_fid parameter so that the source LUFID travels
> with the inode through rename.
>=20
> When src_fid is non-NULL and the destination slot carries a LUFID of
> the same on-disk size, the source payload is copied into the =
destination
> before the file_type merge.  When src_fid is NULL (source has no =
LUFID),
> EXT4_DIRENT_LUFID is cleared from the destination entry.
>=20
> CFHASH bytes are left in place: CFHASH is a property of the =
destination
> filename, not the inode, and it always precedes CFHASH in the =
extension
> layout so its offset is unaffected by the LUFID copy.
>=20
> Both ext4_rename() and ext4_cross_rename() snapshot the source LUFID
> into a stack buffer before any setent() call, so that a =
cross-directory
> swap reads both sides before either is overwritten.
>=20
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Rather than allocating one or two separate buffers for the lufid =
information,
it would seem more robust and efficient to just store them on the stack?
Perhaps a fixed buffer (e.g. 65 bytes is enough for 4x 16-byte FIDs + =
size)
would cover virtually all possible uses, and only in the very rare case =
that
the lufid field is larger would it need to allocate a buffer.

The maximum possible size would be 256 bytes, but that may be too large =
to
put the stack, especially two of them.

Cheers, Andreas

> ---
> fs/ext4/namei.c | 124 ++++++++++++++++++++++++++++++++++++++++++++----
> 1 file changed, 115 insertions(+), 9 deletions(-)
>=20
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 4a6f7ffa656f..168ffd3751cb 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3731,7 +3731,8 @@ static int ext4_rename_dir_finish(handle_t =
*handle, struct ext4_renament *ent,
> }
>=20
> static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
> -       unsigned ino, unsigned file_type)
> +       unsigned ino, unsigned file_type,
> +       const struct ext4_dirent_fid *src_fid)
> {
> int retval, retval2;
>=20
> @@ -3741,8 +3742,57 @@ static int ext4_setent(handle_t *handle, struct =
ext4_renament *ent,
> if (retval)
> return retval;
> ent->de->inode =3D cpu_to_le32(ino);
> - if (ext4_has_feature_filetype(ent->dir->i_sb))
> - ent->de->file_type =3D file_type;
> + if (ext4_has_feature_filetype(ent->dir->i_sb)) {
> + /* Copy the source LUFID payload into the destination slot when
> + * both carry a LUFID of the same on-disk size.  LUFID is
> + * inode-specific and must travel with the inode through rename.
> + * CFHASH bytes are left in-place: CFHASH is a function of the
> + * destination filename, and its bytes sit at the correct offset
> + * because LUFID always precedes CFHASH in the extension layout.
> + * When src_fid is NULL, the LUFID flag is synced to the LUFID
> + * bit already present in file_type: callers that clear LUFID
> + * (rename of a non-LUFID inode, whiteout) pass file_type with
> + * LUFID=3D0; ext4_resetent passes the original file_type so the
> + * flag is restored for error recovery without overwriting the
> + * LUFID bytes that are still intact on disk. */
> + if (ext4_has_feature_dirdata(ent->dir->i_sb)) {
> + if (src_fid && (ent->de->file_type & EXT4_DIRENT_LUFID)) {
> + unsigned int rec_len =3D
> + ext4_rec_len_from_disk(ent->de->rec_len,
> + ent->dir->i_sb->s_blocksize);
> + unsigned int ddh_off =3D
> + EXT4_BASE_DIR_LEN + ent->de->name_len + 1;
> + struct ext4_dirent_data_header *ddh =3D
> + (struct ext4_dirent_data_header *)
> + ((char *)ent->de + ddh_off);
> + unsigned int copy_len =3D src_fid->df_header.ddh_length;
> +
> + if (ddh_off + sizeof(*ddh) > rec_len ||
> +    ddh->ddh_length !=3D copy_len ||
> +    ddh_off + copy_len > rec_len) {
> + /* Cannot copy: clear the flag so the
> + * slot does not advertise a stale LUFID
> + * from the old inode. */
> + ent->de->file_type &=3D ~EXT4_DIRENT_LUFID;
> + } else {
> + memcpy(ddh, src_fid, copy_len);
> + }
> + } else if (!src_fid) {
> + /* Sync the LUFID flag with what file_type requests.
> + * For normal rename (source has no LUFID) and for
> + * the whiteout setent, file_type carries LUFID=3D0,
> + * so we clear the stale flag.  For ext4_resetent
> + * (error recovery), file_type is the original
> + * file_type with LUFID=3D1, so we restore the flag =E2=80=94
> + * the LUFID bytes are still on disk untouched. */
> + ent->de->file_type =3D
> + (ent->de->file_type & ~EXT4_DIRENT_LUFID) |
> + (file_type & EXT4_DIRENT_LUFID);
> + }
> + }
> + ent->de->file_type =3D (file_type & EXT4_FT_MASK) |
> +     (ent->de->file_type & ~EXT4_FT_MASK);
> + }
> inode_inc_iversion(ent->dir);
> inode_set_mtime_to_ts(ent->dir, inode_set_ctime_current(ent->dir));
> retval =3D ext4_mark_inode_dirty(handle, ent->dir);
> @@ -3779,7 +3829,7 @@ static void ext4_resetent(handle_t *handle, =
struct ext4_renament *ent,
> return;
> }
>=20
> - ext4_setent(handle, &old, ino, file_type);
> + ext4_setent(handle, &old, ino, file_type, NULL);
> brelse(old.bh);
> }
>=20
> @@ -3878,6 +3928,32 @@ static struct inode =
*ext4_whiteout_for_rename(struct mnt_idmap *idmap,
> return wh;
> }
>=20
> +/*
> + * ext4_lufid_snapshot - copy the LUFID record from a directory entry
> + *
> + * Allocates and returns a kmemdup'd copy of the full on-disk LUFID =
record
> + * (header + FID payload of arbitrary length).  Returns NULL if no =
LUFID is
> + * present, the record is malformed, or allocation fails.  Caller =
must kfree().
> + */
> +static struct ext4_dirent_fid *
> +ext4_lufid_snapshot(struct ext4_dir_entry_2 *de, unsigned int =
blocksize)
> +{
> + unsigned int ddh_off =3D EXT4_BASE_DIR_LEN + de->name_len + 1;
> + unsigned int rec_len =3D ext4_rec_len_from_disk(de->rec_len, =
blocksize);
> + struct ext4_dirent_fid *disk_fid;
> + unsigned int dlen;
> +
> + if (!(de->file_type & EXT4_DIRENT_LUFID))
> + return NULL;
> + if (ddh_off + sizeof(disk_fid->df_header) > rec_len)
> + return NULL;
> + disk_fid =3D (struct ext4_dirent_fid *)((char *)de + ddh_off);
> + dlen =3D disk_fid->df_header.ddh_length;
> + if (dlen < sizeof(disk_fid->df_header) || ddh_off + dlen > rec_len)
> + return NULL;
> + return kmemdup(disk_fid, dlen, GFP_NOFS);
> +}
> +
> /*
>  * Anybody can rename anything with this: the permission checks are =
left to the
>  * higher-level routines.
> @@ -3906,6 +3982,7 @@ static int ext4_rename(struct mnt_idmap *idmap, =
struct inode *old_dir,
> struct inode *whiteout =3D NULL;
> int credits;
> u8 old_file_type;
> + struct ext4_dirent_fid *old_fid =3D NULL;
>=20
> if (new.inode && new.inode->i_nlink =3D=3D 0) {
> EXT4_ERROR_INODE(new.inode,
> @@ -4017,7 +4094,7 @@ static int ext4_rename(struct mnt_idmap *idmap, =
struct inode *old_dir,
> * to be still pointing to the valid old entry.
> */
> retval =3D ext4_setent(handle, &old, whiteout->i_ino,
> -     EXT4_FT_CHRDEV);
> +     EXT4_FT_CHRDEV, NULL);
> if (retval)
> goto end_rename;
> retval =3D ext4_mark_inode_dirty(handle, whiteout);
> @@ -4030,8 +4107,18 @@ static int ext4_rename(struct mnt_idmap *idmap, =
struct inode *old_dir,
> if (retval)
> goto end_rename;
> } else {
> + if (ext4_has_feature_dirdata(old.dir->i_sb)) {
> + old_fid =3D ext4_lufid_snapshot(old.de,
> +      old.dir->i_sb->s_blocksize);
> + if (old_fid)
> + ext4_fc_mark_ineligible(old.dir->i_sb,
> + EXT4_FC_REASON_DIRDATA,
> + handle);
> + else
> + old_file_type &=3D ~EXT4_DIRENT_LUFID;
> + }
> retval =3D ext4_setent(handle, &new,
> -     old.inode->i_ino, old_file_type);
> +     old.inode->i_ino, old_file_type, old_fid);
> if (retval)
> goto end_rename;
> }
> @@ -4118,6 +4205,7 @@ static int ext4_rename(struct mnt_idmap *idmap, =
struct inode *old_dir,
> retval =3D 0;
>=20
> end_rename:
> + kfree(old_fid);
> if (whiteout) {
> if (retval) {
> ext4_resetent(handle, &old,
> @@ -4154,8 +4242,9 @@ static int ext4_cross_rename(struct inode =
*old_dir, struct dentry *old_dentry,
> .dentry =3D new_dentry,
> .inode =3D d_inode(new_dentry),
> };
> - u8 new_file_type;
> + u8 new_file_type, old_de_file_type;
> int retval;
> + struct ext4_dirent_fid *old_fid =3D NULL, *new_fid =3D NULL;
>=20
> if ((ext4_test_inode_flag(new_dir, EXT4_INODE_PROJINHERIT) &&
>     !projid_eq(EXT4_I(new_dir)->i_projid,
> @@ -4234,12 +4323,27 @@ static int ext4_cross_rename(struct inode =
*old_dir, struct dentry *old_dentry,
> goto end_rename;
> }
>=20
> + if (ext4_has_feature_dirdata(old.dir->i_sb)) {
> + old_fid =3D ext4_lufid_snapshot(old.de, old.dir->i_sb->s_blocksize);
> + new_fid =3D ext4_lufid_snapshot(new.de, new.dir->i_sb->s_blocksize);
> + if (old_fid || new_fid)
> + ext4_fc_mark_ineligible(old.dir->i_sb,
> + EXT4_FC_REASON_DIRDATA, handle);
> + }
> +
> + old_de_file_type =3D old.de->file_type;
> + if (!old_fid)
> + old_de_file_type &=3D ~EXT4_DIRENT_LUFID;
> new_file_type =3D new.de->file_type;
> - retval =3D ext4_setent(handle, &new, old.inode->i_ino, =
old.de->file_type);
> + if (!new_fid)
> + new_file_type &=3D ~EXT4_DIRENT_LUFID;
> + retval =3D ext4_setent(handle, &new, old.inode->i_ino, =
old_de_file_type,
> +     old_fid);
> if (retval)
> goto end_rename;
>=20
> - retval =3D ext4_setent(handle, &old, new.inode->i_ino, =
new_file_type);
> + retval =3D ext4_setent(handle, &old, new.inode->i_ino, =
new_file_type,
> +     new_fid);
> if (retval)
> goto end_rename;
>=20
> @@ -4272,6 +4376,8 @@ static int ext4_cross_rename(struct inode =
*old_dir, struct dentry *old_dentry,
> retval =3D 0;
>=20
> end_rename:
> + kfree(old_fid);
> + kfree(new_fid);
> brelse(old.dir_bh);
> brelse(new.dir_bh);
> brelse(old.bh);
> --=20
> 2.43.7
>=20


Cheers, Andreas





