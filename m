From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Add missing KERN_CONT to a few more debugging uses
Date: Thu, 13 Oct 2016 15:23:11 -0600
Message-ID: <979B5118-0012-411A-B094-3045A9989CBB@dilger.ca>
References: <98ce665bb759e671506bf269041238553a3df8f1.1476384526.git.joe@perches.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_DE98D687-54C1-4E34-B807-EFC165458F3E"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <98ce665bb759e671506bf269041238553a3df8f1.1476384526.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_DE98D687-54C1-4E34-B807-EFC165458F3E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 13, 2016, at 12:50 PM, Joe Perches <joe@perches.com> wrote:
>=20
> Recent commits require line continuing printks to always use
> pr_cont or KERN_CONT.  Add these markings to a few more printks.
>=20
> Miscellaneaous:
>=20
> o Integrate the ea_idebug and ea_bdebug macros to use a single
>  call to printk(KERN_DEBUG instead of 3 separate printks
> o Use the more common varargs macro style
>=20
> Signed-off-by: Joe Perches <joe@perches.com>

Looks fine.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/ext4/block_validity.c |  4 ++--
> fs/ext4/mballoc.h        | 17 ++++++++---------
> fs/ext4/namei.c          | 18 ++++++++++--------
> fs/ext4/xattr.c          | 18 ++++++------------
> 4 files changed, 26 insertions(+), 31 deletions(-)
>=20
> diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
> index 02ddec6d8a7d..fdb19543af1e 100644
> --- a/fs/ext4/block_validity.c
> +++ b/fs/ext4/block_validity.c
> @@ -128,12 +128,12 @@ static void debug_print_tree(struct ext4_sb_info =
*sbi)
> 	node =3D rb_first(&sbi->system_blks);
> 	while (node) {
> 		entry =3D rb_entry(node, struct ext4_system_zone, node);
> -		printk("%s%llu-%llu", first ? "" : ", ",
> +		printk(KERN_CONT "%s%llu-%llu", first ? "" : ", ",
> 		       entry->start_blk, entry->start_blk + entry->count =
- 1);
> 		first =3D 0;
> 		node =3D rb_next(node);
> 	}
> -	printk("\n");
> +	printk(KERN_CONT "\n");
> }
>=20
> int ext4_setup_system_zone(struct super_block *sb)
> diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
> index 3ef1df6ae9ec..1aba469f8220 100644
> --- a/fs/ext4/mballoc.h
> +++ b/fs/ext4/mballoc.h
> @@ -27,16 +27,15 @@
> #ifdef CONFIG_EXT4_DEBUG
> extern ushort ext4_mballoc_debug;
>=20
> -#define mb_debug(n, fmt, a...)	                                 =
       \
> -	do {								=
\
> -		if ((n) <=3D ext4_mballoc_debug) {		        =
\
> -			printk(KERN_DEBUG "(%s, %d): %s: ",		=
\
> -			       __FILE__, __LINE__, __func__);		=
\
> -			printk(fmt, ## a);				=
\
> -		}							=
\
> -	} while (0)
> +#define mb_debug(n, fmt, ...)	                                 =
       \
> +do {									=
\
> +	if ((n) <=3D ext4_mballoc_debug) {				=
\
> +		printk(KERN_DEBUG "(%s, %d): %s: " fmt,			=
\
> +		       __FILE__, __LINE__, __func__, ##__VA_ARGS__);	=
\
> +	}								=
\
> +} while (0)
> #else
> -#define mb_debug(n, fmt, a...)		no_printk(fmt, ## a)
> +#define mb_debug(n, fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
> #endif
>=20
> #define EXT4_MB_HISTORY_ALLOC		1	/* allocation */
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index f92f10d4f66a..104f8bfba718 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -577,12 +577,13 @@ static inline unsigned dx_node_limit(struct =
inode *dir)
> static void dx_show_index(char * label, struct dx_entry *entries)
> {
> 	int i, n =3D dx_get_count (entries);
> -	printk(KERN_DEBUG "%s index ", label);
> +	printk(KERN_DEBUG "%s index", label);
> 	for (i =3D 0; i < n; i++) {
> -		printk("%x->%lu ", i ? dx_get_hash(entries + i) :
> -				0, (unsigned long)dx_get_block(entries + =
i));
> +		printk(KERN_CONT " %x->%lu",
> +		       i ? dx_get_hash(entries + i) : 0,
> +		       (unsigned long)dx_get_block(entries + i));
> 	}
> -	printk("\n");
> +	printk(KERN_CONT "\n");
> }
>=20
> struct stats
> @@ -679,7 +680,7 @@ static struct stats dx_show_leaf(struct inode =
*dir,
> 		}
> 		de =3D ext4_next_entry(de, size);
> 	}
> -	printk("(%i)\n", names);
> +	printk(KERN_CONT "(%i)\n", names);
> 	return (struct stats) { names, space, 1 };
> }
>=20
> @@ -798,7 +799,7 @@ dx_probe(struct ext4_filename *fname, struct inode =
*dir,
> 		q =3D entries + count - 1;
> 		while (p <=3D q) {
> 			m =3D p + (q - p) / 2;
> -			dxtrace(printk("."));
> +			dxtrace(printk(KERN_CONT "."));
> 			if (dx_get_hash(m) > hash)
> 				q =3D m - 1;
> 			else
> @@ -810,7 +811,7 @@ dx_probe(struct ext4_filename *fname, struct inode =
*dir,
> 			at =3D entries;
> 			while (n--)
> 			{
> -				dxtrace(printk(","));
> +				dxtrace(printk(KERN_CONT ","));
> 				if (dx_get_hash(++at) > hash)
> 				{
> 					at--;
> @@ -821,7 +822,8 @@ dx_probe(struct ext4_filename *fname, struct inode =
*dir,
> 		}
>=20
> 		at =3D p - 1;
> -		dxtrace(printk(" %x->%u\n", at =3D=3D entries ? 0 : =
dx_get_hash(at),
> +		dxtrace(printk(KERN_CONT " %x->%u\n",
> +			       at =3D=3D entries ? 0 : dx_get_hash(at),
> 			       dx_get_block(at)));
> 		frame->entries =3D entries;
> 		frame->at =3D at;
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index c15d63389957..151027736c84 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -61,18 +61,12 @@
> #include "acl.h"
>=20
> #ifdef EXT4_XATTR_DEBUG
> -# define ea_idebug(inode, f...) do { \
> -		printk(KERN_DEBUG "inode %s:%lu: ", \
> -			inode->i_sb->s_id, inode->i_ino); \
> -		printk(f); \
> -		printk("\n"); \
> -	} while (0)
> -# define ea_bdebug(bh, f...) do { \
> -		printk(KERN_DEBUG "block %pg:%lu: ",		   \
> -		       bh->b_bdev, (unsigned long) bh->b_blocknr); \
> -		printk(f); \
> -		printk("\n"); \
> -	} while (0)
> +# define ea_idebug(inode, fmt, ...)					=
\
> +	printk(KERN_DEBUG "inode %s:%lu: " fmt "\n",			=
\
> +	       inode->i_sb->s_id, inode->i_ino, ##__VA_ARGS__)
> +# define ea_bdebug(bh, fmt, ...)					=
\
> +	printk(KERN_DEBUG "block %pg:%lu: " fmt "\n",			=
\
> +	       bh->b_bdev, (unsigned long)bh->b_blocknr, ##__VA_ARGS__)
> #else
> # define ea_idebug(inode, fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
> # define ea_bdebug(bh, fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
> --
> 2.10.0.rc2.1.g053435c
>=20


Cheers, Andreas






--Apple-Mail=_DE98D687-54C1-4E34-B807-EFC165458F3E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBV//7QXKl2rkXzB/gAQhc/xAAgbTyyeFYvhOXcsJeUjUGoZ5ZS7zbzRWY
EPD3lWmG+gSQfGqrKtPMO8nexXOz7mCEcakuMzBhBSXpBLpJQP3KBUJS54mkGC1X
yFC0qisj0mn3Q1eKRZzQcNaqGUARshcfKXcX4EvDuxcNZX5Qvzfmyl296oyDx3wM
2yL95SwdAE5FcGd3KXgR0XilUkgYoB1Y9F4TLWqysV6AZ9WHJPe2E0ck/5cM8WAT
5f1WpbIkcCXZskePf0T/G+fCaYHTfT4SZfgmn9oD3CzChzCv0rdu6FO2tNr5Gv0Q
2FsL4jKSKgVSonItVE5OuWxYm6ke2SZJexNebPQhzpXTanxFRdMw6R1056wavU3V
AAZo0MmhmYQiBIImCO+O9T+ajFGDebMRarfARwfYbbbgc6Q55iU4G8/NGxTM6sXT
nVb55KUTyr+k01nkRZNfz7uhZNAKby6JUL3DZ7WGItxmbI1662ZrawFHzWrbC2/F
6xyrjGkXaIKPgsIpE3ibIgSrcpQGDCgl9AolHm6hrGr22c36F1QQDb9Od+eraj4d
F4hb4dFSC+amg/L1MFEF7R+5B5iDkM/bT39F9WMw/yeF0QiMWHImM2Tfw6M7Mhv0
q8AfIFApgbMdBYaln215Q3vTfmjbdR0CC3blw99n9BIaS5KJDK7f33SztQnlHlkA
2oTEgsULIfs=
=Zop/
-----END PGP SIGNATURE-----

--Apple-Mail=_DE98D687-54C1-4E34-B807-EFC165458F3E--
