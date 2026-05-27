Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E0DF507
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2026 22:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779920912; cv=none; b=qI/uBuKjnvKkIS7vXJxTApuzh+UCjTiDfi7KrYJn4ztxQmIxfGBNss7Al+MIbz0XgyG/6lvmy2Natg+Gy/THmTaD8qy0d+35JBIOkK4isLjiVC3cTnWxxsnRBQzU0mWcnlhZFH+1/WxK1K0v5/JBINS9tX10zaqEC8vzpPattQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779920912; c=relaxed/simple;
	bh=Gkb1bw5wBNyEhPvp0kAjhaB0Tua0a9cHcG3llBt+TxE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=CmgMpXpxlEG4c2JKxMiyg/4pRqJS20qduD6Y91CkWiBbglTMcLFS4eBtc+A8BdYR35EjCKSNdUghmxBeik2VuqGdy/BwtERorS87VSp2gmt4GKCiO3G+S6mKpxodQnDdm1YFV2vbhU8V4JhhvAJKTwNOWD03q8FbpL4i3ldJStg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=USv1eENI; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="USv1eENI"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-367d88b9940so8061982a91.1
        for <linux-ext4@vger.kernel.org>; Wed, 27 May 2026 15:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1779920910; x=1780525710; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eKHhuWO17ikzcf2yfAwhr0CCr8lB4bNMKmalYKDaXaE=;
        b=USv1eENIqr5oDR61H7aktqEDGbjUF329RNXxgIjWvfH91xkbi/jN4SY65UEvWCj5Gb
         y+1PBh99U2si83qdRku9dF5hYXw9cHyE6cannHuouINvWVC2ThPLPqabiDJ6z3KY1gzS
         GJRkpZZTdZ5oXArDphCiMk9Ndnfe4UJ2hTN8yPXHy1LvXNY972jKLPz2/187iVW6/JgD
         Mm7NaGEzMmHHApB8AbYB+6uuDXoK2xBGHVmGBW6qemQUfVeYuDGlP+1YpigHQBBoPevi
         RWjToGMLbvIPzNSWwTAK8qwCPZqWPYzZCYaw66ff3EL8xmJUBei4S+G3XXEglH544pPy
         eB8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779920910; x=1780525710;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eKHhuWO17ikzcf2yfAwhr0CCr8lB4bNMKmalYKDaXaE=;
        b=JpEaGK0Z1R63mq0+nkcsXILiarFcVcTdv+imQBAhf5NpPBO4MWjvXbIlBDjB7TNkvx
         K86Qc69zFMBIa7mXfO1onM1SwQr2uilM5LRps5zGMzjqi638B7dRc7UijAahKFfigWrx
         L+pAuuFycT4Tayrpv+OcfeZuFZSQ5KU5TeUcr8u23yujagX0sbaKE2z1rx4AMK+5hqWS
         XXenZ5TK5mvjkxXTGJbsH0Hd2Ubb8GZr49mKxpOkbQ+jscjrEglZU6LGN3cwETt6ZaLo
         L8NdWcNw3UgBLBS6leIPXwGyB/Dk1+yzRZaaxtGV0peDYq4ndG58ItMPtq87v294Cb4/
         dUhg==
X-Forwarded-Encrypted: i=1; AFNElJ8UiYk2rNnUdmbJntvxxwl3ITK3VEW1s5FnDaIwTrmXt6FqM9N9BHYZGg0MDtDkOezAb6lp1D5sB+UJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb/T7ZfzENTxlI28ICaD3Sxhs2IyxvsR/lELtYkKMwGGZJCPNm
	/xYIGz19ux32GKYlTUowqUU0DbWic1EpDEa0UUiVimZUHXQIZ3EftNoTO9ue/WzZqAY=
X-Gm-Gg: Acq92OECNPzWz86gkUC4WmQlcCrqCSf+SIqIAkoA/blYkdfIAuMZDAL9kU5jU5LetNI
	j2PgvVMnoOvhO5z/nuTFqxFkTvhhA6fPOU0RymcqucwsyD/yczTwHu/dfFHJuDQhF7q8E1GyJ8Y
	SDhrcpVUrGKpgbmbpBrUBbF6rEDF1Cs+kW6HO04vpbpQjJzZP+qUiiUhV+UFROqMF4OvhCn50rL
	9dOTu0O8Oj88jPc6IRhoZZEyarNhj5nUwYE19Gg/Kf5OVELSS5S3wr37ebU7UX194a1PdHkLwPp
	iAqodzJEipCZ4yY2FyUlzBJdiuLs0mB4oFY9heNwcnPapigdFDk+8s/zwW87+6h1RP0UNBzz6TP
	II+q7RbWiRdB1LDzg/OMAIuhQIpCl03f0Kkg5LNE50BGq29/64y9QbQF5y+AWKNOKnRqK1zA3CH
	mv1wCKfFXKdhugL9qVoPvt8o8q28OgtYLJBavch55r0uvAM7f6Lw/YLE8DGA9j6xhtYtLTYuwM4
	hGKrtykr+2WKiVI
X-Received: by 2002:a17:903:24c:b0:2b2:ec46:dfed with SMTP id d9443c01a7336-2beb067a16emr263360475ad.31.1779920909404;
        Wed, 27 May 2026 15:28:29 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb5903bcasm171486555ad.77.2026.05.27.15.28.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 May 2026 15:28:28 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH] ext4: replace ext4_dir_entry with ext4_dir_entry_2
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260526233608.7600-1-ablagodarenko@thelustrecollective.com>
Date: Wed, 27 May 2026 16:28:17 -0600
Cc: Theodore Ts'o <tytso@mit.edu>,
 linux-ext4@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <DF4C7597-62B1-4386-8623-BCB223C6F615@dilger.ca>
References: <20260526233608.7600-1-ablagodarenko@thelustrecollective.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On May 26, 2026, at 17:36, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
>=20
> Replace remaining uses of struct ext4_dir_entry in namei.c
> with struct ext4_dir_entry_2.
>=20
> The code paths affected by this change already depend on the
> filetype feature, so using struct ext4_dir_entry_2 is
> appropriate and avoids mixing the two directory entry types
> unnecessarily.
>=20
> This change does not affect support for 16-bit rec_len.
>=20
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca =
<mailto:adilger@dilger.ca>>

> ---
> fs/ext4/namei.c | 36 ++++++++++++++++++------------------
> 1 file changed, 18 insertions(+), 18 deletions(-)
>=20
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 4a47fbd8dd30..a316fc2ac41b 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -102,7 +102,7 @@ static struct buffer_head *ext4_append(handle_t =
*handle,
> }
>=20
> static int ext4_dx_csum_verify(struct inode *inode,
> -       struct ext4_dir_entry *dirent);
> +       struct ext4_dir_entry_2 *dirent);
>=20
> /*
>  * Hints to ext4_read_dirblock regarding whether we expect a directory
> @@ -128,7 +128,7 @@ static struct buffer_head =
*__ext4_read_dirblock(struct inode *inode,
> unsigned int line)
> {
> struct buffer_head *bh;
> - struct ext4_dir_entry *dirent;
> + struct ext4_dir_entry_2 *dirent;
> int is_dx_block =3D 0;
>=20
> if (block >=3D inode->i_size >> inode->i_blkbits) {
> @@ -160,7 +160,7 @@ static struct buffer_head =
*__ext4_read_dirblock(struct inode *inode,
> }
> if (!bh)
> return NULL;
> - dirent =3D (struct ext4_dir_entry *) bh->b_data;
> + dirent =3D (struct ext4_dir_entry_2 *) bh->b_data;
> /* Determine whether or not we have an index block */
> if (is_dx(inode)) {
> if (block =3D=3D 0)
> @@ -317,13 +317,13 @@ static struct ext4_dir_entry_tail =
*get_dirent_tail(struct inode *inode,
> int blocksize =3D EXT4_BLOCK_SIZE(inode->i_sb);
>=20
> #ifdef PARANOID
> - struct ext4_dir_entry *d, *top;
> + struct ext4_dir_entry_2 *d, *top;
>=20
> - d =3D (struct ext4_dir_entry *)bh->b_data;
> - top =3D (struct ext4_dir_entry *)(bh->b_data +
> + d =3D (struct ext4_dir_entry_2 *)bh->b_data;
> + top =3D (struct ext4_dir_entry_2 *)(bh->b_data +
> (blocksize - sizeof(struct ext4_dir_entry_tail)));
> while (d < top && ext4_rec_len_from_disk(d->rec_len, blocksize))
> - d =3D (struct ext4_dir_entry *)(((void *)d) +
> + d =3D (struct ext4_dir_entry_2 *)(((void *)d) +
>    ext4_rec_len_from_disk(d->rec_len, blocksize));
>=20
> if (d !=3D top)
> @@ -410,10 +410,10 @@ int ext4_handle_dirty_dirblock(handle_t *handle,
> }
>=20
> static struct dx_countlimit *get_dx_countlimit(struct inode *inode,
> -       struct ext4_dir_entry *dirent,
> +       struct ext4_dir_entry_2 *dirent,
>       int *offset)
> {
> - struct ext4_dir_entry *dp;
> + struct ext4_dir_entry_2 *de;
> struct dx_root_info *root;
> int count_offset;
> int blocksize =3D EXT4_BLOCK_SIZE(inode->i_sb);
> @@ -422,10 +422,10 @@ static struct dx_countlimit =
*get_dx_countlimit(struct inode *inode,
> if (rlen =3D=3D blocksize)
> count_offset =3D 8;
> else if (rlen =3D=3D 12) {
> - dp =3D (struct ext4_dir_entry *)(((void *)dirent) + 12);
> - if (ext4_rec_len_from_disk(dp->rec_len, blocksize) !=3D blocksize - =
12)
> + de =3D (struct ext4_dir_entry_2 *)(((void *)dirent) + 12);
> + if (ext4_rec_len_from_disk(de->rec_len, blocksize) !=3D blocksize - =
12)
> return NULL;
> - root =3D (struct dx_root_info *)(((void *)dp + 12));
> + root =3D (struct dx_root_info *)(((void *)de + 12));
> if (root->reserved_zero ||
>    root->info_length !=3D sizeof(struct dx_root_info))
> return NULL;
> @@ -438,7 +438,7 @@ static struct dx_countlimit =
*get_dx_countlimit(struct inode *inode,
> return (struct dx_countlimit *)(((void *)dirent) + count_offset);
> }
>=20
> -static __le32 ext4_dx_csum(struct inode *inode, struct ext4_dir_entry =
*dirent,
> +static __le32 ext4_dx_csum(struct inode *inode, struct =
ext4_dir_entry_2 *dirent,
>   int count_offset, int count, struct dx_tail *t)
> {
> struct ext4_inode_info *ei =3D EXT4_I(inode);
> @@ -456,7 +456,7 @@ static __le32 ext4_dx_csum(struct inode *inode, =
struct ext4_dir_entry *dirent,
> }
>=20
> static int ext4_dx_csum_verify(struct inode *inode,
> -       struct ext4_dir_entry *dirent)
> +       struct ext4_dir_entry_2 *dirent)
> {
> struct dx_countlimit *c;
> struct dx_tail *t;
> @@ -485,7 +485,7 @@ static int ext4_dx_csum_verify(struct inode =
*inode,
> return 1;
> }
>=20
> -static void ext4_dx_csum_set(struct inode *inode, struct =
ext4_dir_entry *dirent)
> +static void ext4_dx_csum_set(struct inode *inode, struct =
ext4_dir_entry_2 *dirent)
> {
> struct dx_countlimit *c;
> struct dx_tail *t;
> @@ -515,7 +515,7 @@ static inline int =
ext4_handle_dirty_dx_node(handle_t *handle,
>    struct inode *inode,
>    struct buffer_head *bh)
> {
> - ext4_dx_csum_set(inode, (struct ext4_dir_entry *)bh->b_data);
> + ext4_dx_csum_set(inode, (struct ext4_dir_entry_2 *)bh->b_data);
> return ext4_handle_dirty_metadata(handle, inode, bh);
> }
>=20
> @@ -1488,7 +1488,7 @@ int ext4_search_dir(struct buffer_head *bh, char =
*search_buf, int buf_size,
> }
>=20
> static int is_dx_internal_node(struct inode *dir, ext4_lblk_t block,
> -       struct ext4_dir_entry *de)
> +       struct ext4_dir_entry_2 *de)
> {
> struct super_block *sb =3D dir->i_sb;
>=20
> @@ -1619,7 +1619,7 @@ static struct buffer_head =
*__ext4_find_entry(struct inode *dir,
> }
> if (!buffer_verified(bh) &&
>    !is_dx_internal_node(dir, block,
> - (struct ext4_dir_entry *)bh->b_data) &&
> + (struct ext4_dir_entry_2 *)bh->b_data) &&
>    !ext4_dirblock_csum_verify(dir, bh)) {
> EXT4_ERROR_INODE_ERR(dir, EFSBADCRC,
>     "checksumming directory "
> --=20
> 2.43.7
>=20


Cheers, Andreas





