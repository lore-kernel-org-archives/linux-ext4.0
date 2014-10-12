From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/2] ext4: Replace open coded mdata csum feature to helper function
Date: Mon, 13 Oct 2014 00:58:05 +0400
Message-ID: <871tqdxaxu.fsf@openvz.org>
References: <1413139754-17296-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:65164 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaJLU6O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 12 Oct 2014 16:58:14 -0400
Received: by mail-wg0-f48.google.com with SMTP id k14so7322899wgh.31
        for <linux-ext4@vger.kernel.org>; Sun, 12 Oct 2014 13:58:13 -0700 (PDT)
Received: from smtp.gmail.com ([195.214.234.4])
        by mx.google.com with ESMTPSA id gg18sm9991219wic.21.2014.10.12.13.58.11
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 Oct 2014 13:58:12 -0700 (PDT)
In-Reply-To: <1413139754-17296-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Dmitry Monakhov <dmonakhov@openvz.org> writes:
<Snim>
ext4_fill_super:
> -	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
> -				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
Oh Crap. Next two lines shows that I've not tested this patch with
metadata_csum enabled :( .Please ignore this version. I'll send updated ver=
sion.
> +	if (ext4_has_metadata_csum(sb)) {
>  		sbi->s_chksum_driver =3D crypto_alloc_shash("crc32c", 0, 0);

>  		if (IS_ERR(sbi->s_chksum_driver)) {
>  			ext4_msg(sb, KERN_ERR, "Cannot load crc32c driver.");
> @@ -3508,8 +3501,7 @@ static int ext4_fill_super(struct super_block *sb, =
void *data, int silent)
>  	}
>=20=20
>  	/* Precompute checksum seed for all metadata */
> -	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
> -			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> +	if (ext4_has_metadata_csum(sb))
>  		sbi->s_csum_seed =3D ext4_chksum(sbi, ~0, es->s_uuid,
>  					       sizeof(es->s_uuid));
>=20=20
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 42823ab..1e09fc7 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -142,8 +142,7 @@ static int ext4_xattr_block_csum_verify(struct inode =
*inode,
>  					sector_t block_nr,
>  					struct ext4_xattr_header *hdr)
>  {
> -	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> -		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
> +	if (ext4_has_metadata_csum(inode->i_sb) &&
>  	    (hdr->h_checksum !=3D ext4_xattr_block_csum(inode, block_nr, hdr)))
>  		return 0;
>  	return 1;
> @@ -153,8 +152,7 @@ static void ext4_xattr_block_csum_set(struct inode *i=
node,
>  				      sector_t block_nr,
>  				      struct ext4_xattr_header *hdr)
>  {
> -	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> -		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> +	if (!ext4_has_metadata_csum(inode->i_sb))
>  		return;
>=20=20
>  	hdr->h_checksum =3D ext4_xattr_block_csum(inode, block_nr, hdr);
> --=20
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUOutdAAoJEFzOBSYIXfvekKwP/2z68KYzcEpyrYKXzZrgVKES
JDLyL4h81v5QEMbasGKB5hz9hCu9I3IWxvYoPnAP2PsNWKS8czKnnAldLA+RUbnR
kSdgP79baUfoCgdOW/P0xqhY23ytQEB3acI2WUNUiZYScEzHvib6uQBAGZwPH4hf
t5V2xzgB0fijsh8zj0cI74sOFF1oJhZghbzn8ceU1kypsI8/9kCDNjf4LBLxRkNV
MaTz0rn1oHiebfCXAS3s6SNSM6tDWTpGzjSuGgBsyKs5GzL88k0SrgnyLky3hV05
vQb/IvpVt2Vq0ge1OEa9qqOeM94SghvSO9m+BZL7nhbHH2Sw/n/4U792HEfN9c0I
KPXGv8zfdWJpwqIcdYWrRks0AznVSRrjW/+08aVGERXsWjXKZh9rTkSxCN+MbzXF
tvpNo9D+4a9kjYCIlDZEATMGPM8yYJ+6PSBULD9dy/V5upHwsCxRRZn/DJmdNyHc
z/5vD3cCRz57UUw6q/cXLQNbDENrhU91xNjO9XZJhoF9OlFp9SYmEmxMClz4BxUr
/XAHWQAuIIMqyHQp9HePw4rcoSKz1x5SEuqNI6201z6kCYXQpfW5ipMMp4lZIgZd
xJehgcBWKPqGF/8fHJad3HZQP2szdcL4oKzcbsGTGIj9MVcxChFOx405i7wle0GP
eHW2FfzFNHWb/9/NgFJA
=hqV5
-----END PGP SIGNATURE-----
--=-=-=--
