Return-Path: <SRS0=0ehA=O2=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46928 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728393AbeLQWy3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Dec 2018 17:54:29 -0500
Received: by mail-pf1-f194.google.com with SMTP id c73so7078208pfe.13
        for <linux-ext4@vger.kernel.org>; Mon, 17 Dec 2018 14:54:28 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <A3D72248-487E-412E-B341-7450C773E81F@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_AFDB6CDE-895F-45EB-9F24-FEEFB7682708";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] ext4: avoid declaring fs inconsistent due to invalid file
 handles
Date: Mon, 17 Dec 2018 15:53:46 -0700
In-Reply-To: <20181213175107.29464-1-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        stable@kernel.org
To: Theodore Ts'o <tytso@mit.edu>
References: <20181213175107.29464-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_AFDB6CDE-895F-45EB-9F24-FEEFB7682708
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Dec 13, 2018, at 10:51 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>=20
> If we receive a file handle, either from NFS or open_by_handle_at(2),
> and it points at an inode which has not been initialized, and the file
> system has metadata checksums enabled, we shouldn't try to get the
> inode, discover the checksum is invalid, and then declare the file
> system as being inconsistent.
>=20
> This can be reproduced by creating a test file system via "mke2fs -t
> ext4 -O metadata_csum /tmp/foo.img 8M", mounting it, cd'ing into that
> directory, and then running the following program.
>=20
> #define _GNU_SOURCE
> #include <fcntl.h>
>=20
> struct handle {
> 	struct file_handle fh;
> 	unsigned char fid[MAX_HANDLE_SZ];
> };
>=20
> int main(int argc, char **argv)
> {
> 	struct handle h =3D {{8, 1 }, { 12, }};
>=20
> 	open_by_handle_at(AT_FDCWD, &h.fh, O_RDONLY);
> 	return 0;
> }
>=20
> Addresses-Google-Bug: #120690101
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@kernel.org
> ---
> fs/ext4/ext4.h   | 12 +++++++++--
> fs/ext4/ialloc.c |  2 +-
> fs/ext4/inode.c  | 54 +++++++++++++++++++++++++++++++++---------------
> fs/ext4/ioctl.c  |  2 +-
> fs/ext4/namei.c  |  4 ++--
> fs/ext4/resize.c |  4 ++--
> fs/ext4/super.c  | 19 +++++------------
> fs/ext4/xattr.c  |  5 +++--
> 8 files changed, 61 insertions(+), 41 deletions(-)
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index b4621277e259..20eaa66705cc 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2454,8 +2454,16 @@ int do_journal_get_write_access(handle_t =
*handle,
> #define FALL_BACK_TO_NONDELALLOC 1
> #define CONVERT_INLINE_DATA	 2
>=20
> -extern struct inode *ext4_iget(struct super_block *, unsigned long);
> -extern struct inode *ext4_iget_normal(struct super_block *, unsigned =
long);
> +extern struct inode *__ext4_iget(struct super_block *sb, unsigned =
long ino,
> +				 int flags, const char *function,
> +				 unsigned int line);
> +
> +#define EXT4_IGET_NORMAL	1
> +#define EXT4_IGET_HANDLE	2

It would be better to make this:


 enum ext4_iget_flags {
        EXT4_IGET_RESERVED =3D 0x00,	/* just guessing, see further =
below */
	EXT4_IGET_NORMAL   =3D 0x01,
	EXT4_IGET_HANDLE   =3D 0x02,
 };

so that it is clear which "flags" are being passed to ext4_iget().  =
There are
hundreds of "flags" arguments to different functions that are sometimes =
hard
to separate when looking at code.  That also gives the compiler some =
chance to
warn if they are used incorrectly.

> +#define ext4_iget(sb, ino, flags) \
> +	__ext4_iget((sb), (ino), (flags), __func__, __LINE__)
> +
> extern int  ext4_write_inode(struct inode *, struct writeback_control =
*);
> extern int  ext4_setattr(struct dentry *, struct iattr *);
> extern int  ext4_getattr(const struct path *, struct kstat *, u32, =
unsigned int);
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 014f6a698cb7..06aa3b6c3f18 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -1225,7 +1225,7 @@ struct inode *ext4_orphan_get(struct super_block =
*sb, unsigned long ino)
> 	if (!ext4_test_bit(bit, bitmap_bh->b_data))
> 		goto bad_orphan;
>=20
> -	inode =3D ext4_iget(sb, ino);
> +	inode =3D ext4_iget(sb, ino, 0);

What does "0" mean?  It isn't in the list of EXT4_IGET_* flags.  I'm =
guessing it
means that access to reserved or otherwise invalid inodes is allowed?

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 22a9d8159720..07fc7a12508e 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4817,7 +4817,9 @@ static inline u64 ext4_inode_peek_iversion(const =
struct inode *inode)
> 		return inode_peek_iversion(inode);
> }
>=20
> -struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
> +struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
> +			  int flags, const char *function,

			   enum ext4_iget_flags flags, ...

> @@ -4831,6 +4833,18 @@ struct inode *ext4_iget(struct super_block *sb, =
unsigned long ino)
> 	gid_t i_gid;
> 	projid_t i_projid;
>=20
> +	if (((flags & EXT4_IGET_NORMAL) &&
> +	     (ino < EXT4_FIRST_INO(sb) && ino !=3D EXT4_ROOT_INO)) ||
> +	    (ino < EXT4_ROOT_INO) ||

This check seems redundant with "ino < EXT4_FIRST_INO(sb)" on the =
previous line?

> +	    (ino > le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count))) {
> +		if (flags & EXT4_IGET_HANDLE)
> +			return ERR_PTR(-ESTALE);
> +		__ext4_error(sb, function, line,
> +			     "inode #%lu: comm %s: iget: illegal inode =
#",
> +			     ino, current->comm);
> +		return ERR_PTR(-EFSCORRUPTED);
> +	}


Cheers, Andreas






--Apple-Mail=_AFDB6CDE-895F-45EB-9F24-FEEFB7682708
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlwYKPsACgkQcqXauRfM
H+CKRA/+MQO1c3hMYRyxrOPnoplA26pgRz6lecg3ZWD21kNIGr1kZJwzPyQDVpCm
u5nbhpihAtXGsxAs0o47YthUjO/v9cYO324snfFuuHst1OH2j7SlRAU23D0q6B/v
pJDoUxedBKu2+dwwPnc/ah6j+72sC/mJjjlDkwPZwTdNDFxqIuvj718HzrMIWgcb
ptmDxfKsL+uNTnsBv9ObWvlKXkBTwBzIJ5ThJISQ88mQLiRcRc6iVSnf06fBy8LF
PI8L5VQrwqAjRl/AkQE5lP4fR5RbM2yw2KGp/oTVlmblBgR4FnQ1690G8a1mw1/P
iB3HnMLbHy5hU2hFFXHHuKlnjtuxEoJfPMfvvdrUMaol6FEm067OpNaheQKhq1jr
IPdxp0nhkcK+v1hNSd9amMwMaUTYwWQE8k9F73v9lihjUCbbxGqaROC84uVrqyK4
j4LAUtfbtqVp8GKVAKbu0X7TquAlSUqmTUJSAD5QRfCoqggO2acBm6YpsM72hsuH
8kIdYeMTfMt85VasXriQ78D5fTGA2p7iqsUIMrM9CVXwPNBGXT7Yfa/hexwtnXBE
WebtIPwDr8FaeA9QJ817W1MXNrNkLUB3Fl38zAyIZ4OXF5c1e2MlDG312QF9GkNx
lKA3axq/Iw18lMuL9uCKMRNGLJKGQYA4i5YFwF1QtJyqKhQ0XCE=
=mHPF
-----END PGP SIGNATURE-----

--Apple-Mail=_AFDB6CDE-895F-45EB-9F24-FEEFB7682708--
