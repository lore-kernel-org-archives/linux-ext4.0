From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: allow inode expansion for nojournal file systems
Date: Tue, 25 Oct 2016 15:54:16 -0600
Message-ID: <AAF1FFC4-7D4B-4E62-89D2-8C7978D16C35@dilger.ca>
References: <20161025211405.GA15502@localhost.localdomain>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_AB64A142-DA5B-4F77-9D39-45C98DF34F5E"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33947 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752794AbcJYVyh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Oct 2016 17:54:37 -0400
Received: by mail-oi0-f67.google.com with SMTP id p136so9465112oic.1
        for <linux-ext4@vger.kernel.org>; Tue, 25 Oct 2016 14:54:22 -0700 (PDT)
In-Reply-To: <20161025211405.GA15502@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_AB64A142-DA5B-4F77-9D39-45C98DF34F5E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 25, 2016, at 3:14 PM, Eric Whitney <enwlinux@gmail.com> wrote:
>=20
> Runs of xfstest ext4/022 on nojournal file systems result in failures
> because the inodes of some of its test files do not expand as =
expected.
> The cause is a conditional in ext4_mark_inode_dirty() that prevents =
inode
> expansion unless the test file system has a journal.  Remove this
> unnecessary restriction.

I think the reason we required that the filesystem be journaled to =
expand
the inode reserved space is to ensure that the update was an =
all-or-nothing
approach.  If there are in-inode xattrs that need to be moved to an =
external
xattr block, and that block needs allocation and such, it is possible =
that
a nojournal filesystem could result in the xattrs being moved and the =
inode
is written (w/o the xattrs), but the xattr block is not written to disk
before a crash.

That said, this check could potentially be moved later in the xattr =
handling,
since most xattrs will stay within the inode (when growing only a few =
bytes),
which is always safe.  If moving xattrs to an external block, we could =
sync
write the xattr block before marking the inode dirty to ensure that the =
xattr
is not lost in a crash (though it may be duplicated, e2fsck should =
handle
that?).  However, that has a potentially large performance cost.

Cheers, Andreas

>=20
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> ---
> fs/ext4/inode.c | 12 +++++++-----
> 1 file changed, 7 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9c06472..260da4d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5455,18 +5455,20 @@ int ext4_mark_inode_dirty(handle_t *handle, =
struct inode *inode)
> 	err =3D ext4_reserve_inode_write(handle, inode, &iloc);
> 	if (err)
> 		return err;
> -	if (ext4_handle_valid(handle) &&
> -	    EXT4_I(inode)->i_extra_isize < sbi->s_want_extra_isize &&
> +	if (EXT4_I(inode)->i_extra_isize < sbi->s_want_extra_isize &&
> 	    !ext4_test_inode_state(inode, EXT4_STATE_NO_EXPAND)) {
> 		/*
> -		 * We need extra buffer credits since we may write into =
EA block
> +		 * In nojournal mode, we can immediately attempt to =
expand
> +		 * the inode.  When journaled, we first need to obtain =
extra
> +		 * buffer credits since we may write into the EA block
> 		 * with this same handle. If journal_extend fails, then =
it will
> 		 * only result in a minor loss of functionality for that =
inode.
> 		 * If this is felt to be critical, then e2fsck should be =
run to
> 		 * force a large enough s_min_extra_isize.
> 		 */
> -		if ((jbd2_journal_extend(handle,
> -			     EXT4_DATA_TRANS_BLOCKS(inode->i_sb))) =3D=3D =
0) {
> +		if (!ext4_handle_valid(handle) ||
> +		    jbd2_journal_extend(handle,
> +			     EXT4_DATA_TRANS_BLOCKS(inode->i_sb)) =3D=3D =
0) {
> 			ret =3D ext4_expand_extra_isize(inode,
> 						      =
sbi->s_want_extra_isize,
> 						      iloc, handle);
> --
> 2.1.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_AB64A142-DA5B-4F77-9D39-45C98DF34F5E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWA/UinKl2rkXzB/gAQhKFQ//RhnrQQz2fuhyXIdZv20WScqvULkOLPKN
5n8A9Ctnc4yb6NCH34qEmEo+NcLN0D8KCN46khWATn/NzS+y4UtWvUBnlOn9ZGsA
hMb6XsHNCcxOLzIiUaTF8AAOlc60fgxtuiCNXN1WZgFBgFmes5VCdIA9FDrmX1k/
7QJfudIIloiTcp1rksT0zfP74dtp31PP/GYpAgNy8iVtuZExwYlNmX+kefFDNkgt
0/Gj6RLPCeEMeNv5DmCPz1NFTqBkh97Dbsya83/qevEZpRI43+LwskLF3JoHA8a2
lwStuTH28uNlVb1gmPOgZN4dsXkPBPb1FIaS5mUEXz7r53n1Uc4kqhgsrDC+cv+w
RJO1gIXYNX4oj7uuNqNpuK/ZbX1xTiYu8C2DI3dPOCFLbir3KCQcUgNMzCfklH3W
nLODHI4srHsZftUW49fTk4eNHJDYCYy3nErYiBs+DnKzhi87LDzf84UcI+UmHXI2
Pr57Jie91Z9yEinn2PP0sFMaJgiWcdcFaWrxtrChNZ8IF0ke2z+qXBDVuOoei6t0
7qFXIeh4bP0wUeSVEPkLJy6UUqC4E77CpuJj/XhKBbsPAaFBKxxy/t6wSeSotSeO
5sf7DiCVdlx6cug+bRJosIzN6Qi9wFeCGTSSt7fKDcBzxZ/uJWzm6bI3ftwz/OB+
3y58AOrhyYY=
=I1r+
-----END PGP SIGNATURE-----

--Apple-Mail=_AB64A142-DA5B-4F77-9D39-45C98DF34F5E--
