From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/3] ext4: don't read out of bounds when checking for in-inode xattrs
Date: Mon, 28 Nov 2016 12:43:55 -0700
Message-ID: <9D7DBB36-D40D-419B-B150-5F79C3A07119@dilger.ca>
References: <1480228786-106775-1-git-send-email-ebiggers@google.com> <1480228786-106775-2-git-send-email-ebiggers@google.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_A4517A94-A22B-40BE-AD39-4C52A88693B0"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36523 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752406AbcK1ToB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Nov 2016 14:44:01 -0500
Received: by mail-io0-f196.google.com with SMTP id k19so24732892iod.3
        for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2016 11:44:00 -0800 (PST)
In-Reply-To: <1480228786-106775-2-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_A4517A94-A22B-40BE-AD39-4C52A88693B0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 26, 2016, at 11:39 PM, Eric Biggers <ebiggers@google.com> wrote:
>=20
> With i_extra_isize equal to or close to the available space, it was
> possible for us to read past the end of the inode when trying to =
detect
> or validate in-inode xattrs.  Fix this by checking for the needed =
extra
> space first.
>=20
> This patch shouldn't have any noticeable effect on
> non-corrupted/non-malicious filesystems.
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Except for minor style issues (below), looks fine.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/ext4/inode.c | 4 +++-
> fs/ext4/xattr.c | 5 ++---
> 2 files changed, 5 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index bc99ebe..e52f41a 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4519,7 +4519,9 @@ static inline void ext4_iget_extra_inode(struct =
inode *inode,
> {
> 	__le32 *magic =3D (void *)raw_inode +
> 			EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize;
> -	if (*magic =3D=3D cpu_to_le32(EXT4_XATTR_MAGIC)) {
> +	if (EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize + =
sizeof(__le32)
> +			<=3D EXT4_INODE_SIZE(inode->i_sb) &&

(style) operators should go at the end of the previous continued line
(style) continued line should align after first '(' on previous line

> +	    *magic =3D=3D cpu_to_le32(EXT4_XATTR_MAGIC)) {
> 		ext4_set_inode_state(inode, EXT4_STATE_XATTR);
> 		ext4_find_inline_data_nolock(inode);
> 	} else
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 1846e91..59c9ec7 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -231,13 +231,12 @@ static int
> __xattr_check_inode(struct inode *inode, struct =
ext4_xattr_ibody_header *header,
> 			 void *end, const char *function, unsigned int =
line)
> {
> -	struct ext4_xattr_entry *entry =3D IFIRST(header);
> 	int error =3D -EFSCORRUPTED;
>=20
> -	if (((void *) header >=3D end) ||
> +	if (end - (void *)header < sizeof(*header) + sizeof(u32) ||
> 	    (header->h_magic !=3D cpu_to_le32(EXT4_XATTR_MAGIC)))
> 		goto errout;
> -	error =3D ext4_xattr_check_names(entry, end, entry);
> +	error =3D ext4_xattr_check_names(IFIRST(header), end, =
IFIRST(header));
> errout:
> 	if (error)
> 		__ext4_error_inode(inode, function, line, 0,
> --
> 2.8.0.rc3.226.g39d4020
>=20


Cheers, Andreas






--Apple-Mail=_A4517A94-A22B-40BE-AD39-4C52A88693B0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWDyI/HKl2rkXzB/gAQg7Bw/6A659n7TTjlI3lX3CnjBCOMqAuE1XgneH
aGs8tyk3HNL1LRRWNg+3p01zXzypkgd9FF+2cUiDj19hWR1/qczt9suDRm6eynnW
fPvJ7LhZwWdsLQ7D7VY2ReB8jst1MTwnafSDa9bMe50aHpui8OwK81LuH6GJ8ncV
iw7bJFliQTS2TktbisskHiVlBm82tKmOUmA3HV4w6SVTWf5NeYn49zCR9zRCkW8e
fVtiOV2o1xaQr6DPBkcw1hp13X56qberrSG7jiRED1O8OwtemYxrvS2G+X0QjZoB
L9qvzToFJqiB/66bVkZiFhKIcnOMPVpT52OOpPBnNxphE5no+c9fcSHxfxmDl++N
rHpos/2dzpMuLIdpCZhyiA1DrRYSsIIz4ni0WQQyyEhkJhxpPolvmqrsBzEnak18
OZZUdxmynmr/DFRK+Kux7yRSohPrGn99VfKN6jVoctWVeiGEIF78IMrjoPVgAEYW
/8GCr1jkG2elxhNmjqd0C4dSdI9GdpUnFAL2ceB020gYY3hdeTRaTDxiJhruJjBn
bVhWJh26bO+QMrnC4zyuXz2KXo0sdc26SmakSJRNym5L6NOpSrqhGN2/10QOGtUL
97ElaXD7VUxssELNozvfKST7ZTOWHYy4OzV20eq7IKRlA7kyaP8Si6KmfXbtonjX
IZoyRyGKVQA=
=irQT
-----END PGP SIGNATURE-----

--Apple-Mail=_A4517A94-A22B-40BE-AD39-4C52A88693B0--
