Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793715448;
	b=pMu8643geXXqxoTsgF5UxI1h4n/zi1nVyJE5MtRT4OyGbAgZ40nZ1foXbcWIQr7mO+0f
	 tcorhclwbg+0dbTAElu82hL1WCaIZXe5LuVUiMDN3n8M/MglIVVMvag0XztdFhSg4sXc4
	 Kghu9RUK13J/sNXdG8P2+jDscczQL73SdbUpNAry0QRLA04vuIFfncG2Qxs0J7sTTUW5I
	 4CqTZtY72Nm24S18+NCOSosVy5yz0l6ZhjebRb0SDkeNGuIgXjmtlXu8IPUCcCfjQ/+RD
	 cBTYcwkX5y+qK9/GrJ+Os03PcAGP0yaUu2g4MjZZNYO1uXexJmDL0cZwTfFEb33P48w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793715448;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=OvrBxHSsFD3RX6ErGCgn5nDsYIVFUpJC+JCDtmWyXJQ=;
	b=2Tye00fsXZZSnbmt1q4SiyOv99OsZ2FycaRE9miHMyeEgeFlRCTFSRSO9YOj1SL3n3bR
	 FqSMsp4FucRxEGJ9RmsD0kcfzboxHu3LkLzmKTyQwVkq5hCEB0RgBP/DdbO4rb59OVqaD
	 wKdEynVz92y6AnUeNjkeaYHpfY2JY8CFkyh1lLmcNuCxvD15F4jzjpWmncxhmAGppTXad
	 4dqoQEsyzMm+TU9W7Q6VOL/y/MqfPXtjtOKm+S1XhofW4ypnNaOCm9psbeoDkbBYyIHsb
	 QQEI5CnPKBtsZ7SF6L95IaBNss2U76ZXpan/7HGLtHNLFFuU9nPZk4klc9ID0wk1mKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bkigTTP8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98969606A326
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 14:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bkigTTP8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032211F000C1;
	Tue,  3 Nov 2026 14:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793715448;
	bh=OvrBxHSsFD3RX6ErGCgn5nDsYIVFUpJC+JCDtmWyXJQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bkigTTP8ckJx1+aB+kcl8Stk+izltfnlRscLtkMhEpZwbi0Pa+/dLmiWuptX4m12p
	 G3/qEbKKcJ+WJcN7wZsNZNkDgetUIAjRjKnVuuCiWHpC8YcaiCUcZVlf8DJOK9B1c4
	 MBid6DZMkAsCyqlkfVRdphvquwVY3RcKX51dt2JhHbs6y5nLFAmoZQFYZCXoR+Mz06
	 /44t5zghfQ+uD7W8M7Kx+2S+e7BQ55Plcxiy76JMQSRXIdIomQT6r2nWsKaElJEHuj
	 yJbh/Q0uHxqOsF1EVPNbdXr+k0ybiakTH1df9AlVBXwUEqsNtbJJO4NWQX8fBZk/qH
	 Su4tA5E4dzZYw==
Message-ID: <sashiko-outbox-195432@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 10/12] ext4: add dirdata LUFID support for directory
 entry rename
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Blagodarenko" <artem.blagodarenko@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261103134921.610047-11-ablagodarenko@thelustrecollective.com>
References: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
 <20261103134921.610047-11-ablagodarenko@thelustrecollective.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:17:27 +0000
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
- [High] ext4: ext4_resetent() drops existing LUFID on pre-whiteout error i=
n ext4_rename()
--

commit 134d71d4fc529ad068469d7e4f0b83ba20d737e8
Author: Artem Blagodarenko <artem.blagodarenko@gmail.com>

ext4: add dirdata LUFID support for directory entry rename

This commit extends ext4_setent(), ext4_rename(), and ext4_cross_rename()
to preserve the source directory entry's LUFID dirdata payload across
renames.

> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 4f0465d498877..bd0f4760f1e31 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c

[ ... ]

> @@ -4077,29 +4236,65 @@ static int ext4_rename(struct mnt_idmap *idmap, s=
truct inode *old_dir,
>  	force_reread =3D (new.dir->i_ino =3D=3D old.dir->i_ino &&
>  			ext4_test_inode_flag(new.dir, EXT4_INODE_INLINE_DATA));
> =20
> +	if (ext4_has_feature_dirdata(old.dir->i_sb)) {
> +		/* Snapshot before whiteout's ext4_setent() clears the LUFID
> +		 * flag in old.de; the snapshot is also needed for the !new.bh
> +		 * path below where we must carry the LUFID to the new entry. */
> +		retval =3D ext4_lufid_snapshot(old.de,
> +					     old.dir->i_sb->s_blocksize,
> +					     &old_snap);
> +		if (retval)
> +			goto end_rename;
> +		if (!old_snap.fid)
> +			old_file_type &=3D ~EXT4_DIRENT_LUFID;
> +	}

[ ... ]

> @@ -4184,10 +4379,11 @@ static int ext4_rename(struct mnt_idmap *idmap, s=
truct inode *old_dir,
>  	retval =3D 0;
> =20
>  end_rename:
> +	kfree(edp);
>  	if (whiteout) {
>  		if (retval) {
> -			ext4_resetent(handle, &old,
> -				      old.inode->i_ino, old_file_type);
> +			ext4_resetent(handle, &old, old.inode->i_ino,
> +				      old_file_type, old_snap.fid);

[Severity: High]
Can this drop the existing LUFID from old.de if a RENAME_WHITEOUT rename
fails before old.de is overwritten with the whiteout?

In ext4_rename(), whiteout is allocated before the S_ISDIR(old.inode->i_mod=
e)
checks and before ext4_lufid_snapshot() is called:

fs/ext4/namei.c:ext4_rename() {
	...
	whiteout =3D ext4_whiteout_for_rename(idmap, &old, credits, &handle);
	...
	if (S_ISDIR(old.inode->i_mode)) {
		if (new.inode) {
			retval =3D -ENOTEMPTY;
			if (!ext4_empty_dir(new.inode))
				goto end_rename;
		} else {
			retval =3D -EMLINK;
			if (new.dir !=3D old.dir && EXT4_DIR_LINK_MAX(new.dir))
				goto end_rename;
		}
		retval =3D ext4_rename_dir_prepare(handle, &old, new.dir !=3D old.dir);
		if (retval)
			goto end_rename;
	}
	...
	if (ext4_has_feature_dirdata(old.dir->i_sb)) {
		retval =3D ext4_lufid_snapshot(old.de,
					     old.dir->i_sb->s_blocksize,
					     &old_snap);
		if (retval)
			goto end_rename;
	...
}

If any of those directory checks fail (such as -ENOTEMPTY or -EMLINK), or
if kmemdup() in ext4_lufid_snapshot() fails with -ENOMEM on a LUFID larger
than EXT4_LUFID_INLINE_SIZE, execution jumps to end_rename while
old_snap.fid is still NULL and before ext4_setent() has modified old.de.

At end_rename, whiteout is non-NULL, so ext4_resetent() is called with
old_snap.fid =3D=3D NULL:

ext4_rename()
  -> ext4_resetent(handle, &old, old.inode->i_ino, old_file_type, NULL)
    -> ext4_setent(handle, &old, ino, file_type, NULL)
      -> ext4_dirent_drop_lufid(ent->de, rec_len)

This strips the LUFID record and clears EXT4_DIRENT_LUFID on the untouched
source directory entry, then commits that modification when
ext4_journal_stop(handle) runs.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103134921.6100=
47-1-ablagodarenko@thelustrecollective.com?part=3D10
