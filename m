From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] fs: ext4: inode->i_generation not assigned 0.
Date: Wed, 28 Jun 2017 20:32:10 -0600
Message-ID: <20A40B3C-E179-432B-B56F-BDAAF0CD2E1F@dilger.ca>
References: <c9f7090b2a58364998ad4a49cfdac379b905c7e9.1498687302.git.kkc6196@fb.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_C75BFE3F-33DB-479E-87CB-3FACC32D6A8B";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, kernel-team@fb.com,
        "J. Bruce Fields" <bfields@fieldses.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Trond Myklebust <trond.myklebust@primarydata.com>
To: Kyungchan Koh <kkc6196@fb.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <c9f7090b2a58364998ad4a49cfdac379b905c7e9.1498687302.git.kkc6196@fb.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_C75BFE3F-33DB-479E-87CB-3FACC32D6A8B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 28, 2017, at 4:06 PM, Kyungchan Koh <kkc6196@fb.com> wrote:
>=20
> In fs/ext4/super.c, the function ext4_nfs_get_inode takes as input
> "generation" that can be used to specify the generation of the inode =
to
> be returned. When 0 is given as input, then inodes of any generation =
can
> be returned. Therefore, generation 0 is a special case that should be
> avoided when assigning generation to inodes.

I'd agree with this change to avoid assigning generation =3D=3D 0 to =
real inodes.

Also, the separate question arises about whether we need to allow file =
handle
lookup with generation =3D=3D 0?  That allows FID guessing easily, while =
requiring
a non-zero generation makes that a lot harder.

What are the cases where generation =3D=3D 0 are used?

> A new inline function, ext4_inode_set_gen, will take care of the
> problem.  Now, inodes cannot have a generation of 0, so this patch =
fixes
> the issue.
>=20
> Signed-off-by: Kyungchan Koh <kkc6196@fb.com>
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 3219154..74c6677 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1549,6 +1549,14 @@ static inline int ext4_valid_inum(struct =
super_block *sb, unsigned long ino)
> 		 ino <=3D =
le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count));
> }
>=20
> +static inline void ext4_inode_set_gen(struct inode *inode,
> +				      struct ext4_sb_info *sbi)
> +{
> +	inode->i_generation =3D sbi->s_next_generation++;
> +	if (!inode->i_generation)

This should be marked "unlikely()" since it happens at most once every =
4B
file creations (though likely even less since it is unlikely that so =
many
files will be created in a single mount).

> +		inode->i_generation =3D sbi->s_next_generation++;
> +}
> +
>=20
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 98ac2f1..d33f6f0 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -1072,7 +1072,7 @@ struct inode *__ext4_new_inode(handle_t *handle, =
struct inode	}
> 	spin_lock(&sbi->s_next_gen_lock);
> -	inode->i_generation =3D sbi->s_next_generation++;
> +	ext4_inode_set_gen(inode, sbi);
> 	spin_unlock(&sbi->s_next_gen_lock);
>=20
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 0c21e22..d52a467 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -160,8 +160,8 @@ static long swap_inode_boot_loader(struct =
super_block *sb,
>=20
> 	spin_lock(&sbi->s_next_gen_lock);
> -	inode->i_generation =3D sbi->s_next_generation++;
> -	inode_bl->i_generation =3D sbi->s_next_generation++;
> +	ext4_inode_set_gen(inode, sbi);
> +	ext4_inode_set_gen(inode_bl, sbi);
> 	spin_unlock(&sbi->s_next_gen_lock);
>=20


Cheers, Andreas






--Apple-Mail=_C75BFE3F-33DB-479E-87CB-3FACC32D6A8B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZVGaspIg59Q01vtYRAsxhAKCMK35Dso7VYcjurgcOBZuw35JtggCeJTO2
/3U+vNyZZyA6AnJKxBknlbA=
=7Ycu
-----END PGP SIGNATURE-----

--Apple-Mail=_C75BFE3F-33DB-479E-87CB-3FACC32D6A8B--
