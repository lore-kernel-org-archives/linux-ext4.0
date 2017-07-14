From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: make xattr inode reads faster
Date: Fri, 14 Jul 2017 14:13:16 -0700
Message-ID: <705A22C6-4583-47D4-8FB0-B2820F7051F3@dilger.ca>
References: <20170712082932.31844-1-tahsin@google.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_1145495D-0BDE-4545-82CD-C0DCD00EE91A";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170712082932.31844-1-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_1145495D-0BDE-4545-82CD-C0DCD00EE91A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jul 12, 2017, at 1:29 AM, Tahsin Erdogan <tahsin@google.com> wrote:
>=20
> ext4_xattr_inode_read() currently reads each block sequentially while
> waiting for io operation to complete before moving on to the next
> block. This prevents request merging in block layer.
>=20
> Fix this by starting reads for all blocks then wait for completions.

It surprises me that ext4/VFS doesn't already have a helper routine to =
do this.
It looks like ext4_find_entry() is doing something similar for =
read-ahead of
directory blocks, so it may be worthwhile to consider moving that code =
over
to use ext4_bread_batch(), but it looks like it would need to add a flag =
for
whether to wait on the buffers to be uptodate or not.

> Signed-off-by: Tahsin Erdogan <tahsin@google.com>
> ---
> fs/ext4/ext4.h  |  2 ++
> fs/ext4/inode.c | 36 ++++++++++++++++++++++++++++++++++++
> fs/ext4/xattr.c | 50 =
+++++++++++++++++++++++++++++++-------------------
> 3 files changed, 69 insertions(+), 19 deletions(-)
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 9ebde0cd632e..12f0a16ad500 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2462,6 +2462,8 @@ extern void ext4_process_freed_data(struct =
super_block *sb, tid_t commit_tid);
> int ext4_inode_is_fast_symlink(struct inode *inode);
> struct buffer_head *ext4_getblk(handle_t *, struct inode *, =
ext4_lblk_t, int);
> struct buffer_head *ext4_bread(handle_t *, struct inode *, =
ext4_lblk_t, int);
> +int ext4_bread_batch(struct inode *inode, ext4_lblk_t block, int =
bh_count,
> +		     struct buffer_head **bhs);
> int ext4_get_block_unwritten(struct inode *inode, sector_t iblock,
> 			     struct buffer_head *bh_result, int create);
> int ext4_get_block(struct inode *inode, sector_t iblock,
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 3c600f02673f..5b8ae1b66f09 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1015,6 +1015,42 @@ struct buffer_head *ext4_bread(handle_t =
*handle, struct inode *inode,
> 	return ERR_PTR(-EIO);
> }
>=20
> +/* Read a contiguous batch of blocks. */
> +int ext4_bread_batch(struct inode *inode, ext4_lblk_t block, int =
bh_count,
> +		     struct buffer_head **bhs)
> +{
> +	int i, err;
> +
> +	for (i =3D 0; i < bh_count; i++) {
> +		bhs[i] =3D ext4_getblk(NULL, inode, block + i, 0 /* =
map_flags */);


It's nice to have the parameter annotation, since it can often be =
confusing if
there are multiple int/bool arguments to a function, but, I'd write this =
as:

	ret =3D ext4_getblk(NULL, inode, block + i, /* map_flags =3D */ =
0);

I don't know if there is some kind of convention for this kind of =
comment?

> +		if (IS_ERR(bhs[i])) {
> +			err =3D PTR_ERR(bhs[i]);
> +			while (i--)
> +				brelse(bhs[i]);

It would be better to do the error cleanup once at the end of the =
function,
instead of multiple times in the code, like:

		if (IS_ERR(bhs[i])) {
			err =3D PTR_ERR(bhs[i]);
			bh_count =3D i;
			goto out_brelse;
		}
	:
	:
out_brelse:
	for (i =3D 0; i < bh_count; i++) {
		brelse[bhs[i]);
		bhs[i] =3D NULL;
	}
	return err;


The "bhs[i] =3D NULL" isn't strictly necessary, but better to not leave =
stray
pointers around in this array.

> +			return err;
> +		}
> +	}
> +
> +	for (i =3D 0; i < bh_count; i++)
> +		/* Note that NULL bhs[i] is valid because of holes. */
> +		if (bhs[i] && !buffer_uptodate(bhs[i]))
> +			ll_rw_block(REQ_OP_READ, REQ_META | REQ_PRIO, 1,
> +				    &bhs[i]);
> +
> +	for (i =3D 0; i < bh_count; i++)
> +		if (bhs[i])
> +			wait_on_buffer(bhs[i]);
> +
> +	for (i =3D 0; i < bh_count; i++) {
> +		if (bhs[i] && !buffer_uptodate(bhs[i])) {
> +			for (i =3D 0; i < bh_count; i++)
> +				brelse(bhs[i]);

The "out_brelse:" label could also be used here.

> +			return -EIO;
> +		}
> +	}
> +	return 0;
> +}
> +
> int ext4_walk_page_buffers(handle_t *handle,
> 			   struct buffer_head *head,
> 			   unsigned from,
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index cff4f41ced61..f7364a842ff4 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -317,28 +317,40 @@ static void ext4_xattr_inode_set_hash(struct =
inode *ea_inode, u32 hash)
>  */
> static int ext4_xattr_inode_read(struct inode *ea_inode, void *buf, =
size_t size)
> {
> -	unsigned long block =3D 0;
> -	struct buffer_head *bh;
> -	int blocksize =3D ea_inode->i_sb->s_blocksize;
> -	size_t csize, copied =3D 0;
> -	void *copy_pos =3D buf;
> -
> -	while (copied < size) {
> -		csize =3D (size - copied) > blocksize ? blocksize : size =
- copied;
> -		bh =3D ext4_bread(NULL, ea_inode, block, 0);
> -		if (IS_ERR(bh))
> -			return PTR_ERR(bh);
> -		if (!bh)
> -			return -EFSCORRUPTED;
> +	int blocksize =3D 1 << ea_inode->i_blkbits;
> +	int bh_count =3D (size + blocksize - 1) >> ea_inode->i_blkbits;
> +	int tail_size =3D (size % blocksize) ?: blocksize;
> +	struct buffer_head *bhs_inline[8];

> +	struct buffer_head **bhs =3D bhs_inline;
> +	int i, ret;
> +
> +	if (bh_count > ARRAY_SIZE(bhs_inline)) {
> +		bhs =3D kmalloc_array(bh_count, sizeof(*bhs), GFP_NOFS);
> +		if (!bhs)
> +			return -ENOMEM;
> +	}
>=20
> -		memcpy(copy_pos, bh->b_data, csize);
> -		brelse(bh);
> +	ret =3D ext4_bread_batch(ea_inode, 0 /* block */, bh_count, =
bhs);


	ret =3D ext4_bread_batch(ea_inode, /* block =3D */ 0, bh_count, =
bhs);  ?

> +	if (ret)
> +		goto free_bhs;
>=20
> -		copy_pos +=3D csize;
> -		block +=3D 1;
> -		copied +=3D csize;
> +	for (i =3D 0; i < bh_count; i++) {
> +		/* There shouldn't be any holes in ea_inode. */
> +		if (!bhs[i]) {
> +			ret =3D -EFSCORRUPTED;
> +			goto put_bhs;
> +		}
> +		memcpy((char *)buf + blocksize * i, bhs[i]->b_data,
> +		       i < bh_count - 1 ? blocksize : tail_size);
> 	}
> -	return 0;
> +	ret =3D 0;
> +put_bhs:
> +	for (i =3D 0; i < bh_count; i++)
> +		brelse(bhs[i]);
> +free_bhs:
> +	if (bhs !=3D bhs_inline)
> +		kfree(bhs);
> +	return ret;
> }
>=20
> static int ext4_xattr_inode_iget(struct inode *parent, unsigned long =
ea_ino,
> --
> 2.13.2.932.g7449e964c-goog
>=20


Cheers, Andreas






--Apple-Mail=_1145495D-0BDE-4545-82CD-C0DCD00EE91A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZaTPtpIg59Q01vtYRAuDwAJ9L6Wny2gPekjx5dNdwl6MyCWYr2ACgpKxJ
58sGFZxhN5Jkk8JxmwUSkuc=
=SbMq
-----END PGP SIGNATURE-----

--Apple-Mail=_1145495D-0BDE-4545-82CD-C0DCD00EE91A--
