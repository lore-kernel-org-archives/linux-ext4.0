From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 5/7] nonblocking aio: ext4
Date: Tue, 14 Feb 2017 12:52:17 -0700
Message-ID: <5C94A069-0A0C-4B99-9B32-C6750AD2388B@dilger.ca>
References: <20170214024603.9563-1-rgoldwyn@suse.de>
 <20170214024603.9563-6-rgoldwyn@suse.de>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_BDC9A4CF-CE3B-49AC-8852-1081693B6D51";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        linux-ext4@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170214024603.9563-6-rgoldwyn@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_BDC9A4CF-CE3B-49AC-8852-1081693B6D51
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Feb 13, 2017, at 7:46 PM, Goldwyn Rodrigues <rgoldwyn@suse.de> =
wrote:
>=20
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>=20
> Return EAGAIN if any of the following checks fail for direct I/O:
> + i_rwsem is lockable
> + Writing beyond end of file (will trigger allocation)
> + Blocks are allocated at the write location
>=20
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
> fs/ext4/file.c | 28 ++++++++++++++++++++++------
> 1 file changed, 22 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 2a822d3..c8d1e41 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -93,11 +93,16 @@ ext4_file_write_iter(struct kiocb *iocb, struct =
iov_iter *from)
> {
> 	struct inode *inode =3D file_inode(iocb->ki_filp);
> 	int o_direct =3D iocb->ki_flags & IOCB_DIRECT;
> +	int nonblocking =3D iocb->ki_flags & IOCB_NONBLOCKING;
> 	int unaligned_aio =3D 0;
> 	int overwrite =3D 0;
> 	ssize_t ret;
>=20
> -	inode_lock(inode);
> +	if (o_direct && nonblocking) {
> +		if (!inode_trylock(inode))
> +			return -EAGAIN;

Why do these all return -EAGAIN instead of -EWOULDBLOCK?  -EAGAIN is =
already
used in a number of places, and -EWOULDBLOCK seems more correct in the
"nonblocking" case?

> +	} else
> +		inode_lock(inode);

(style) "else" blocks should have braces when the "if" block has braces

> 	ret =3D generic_write_checks(iocb, from);
> 	if (ret <=3D 0)
> 		goto out;
> @@ -132,12 +137,18 @@ ext4_file_write_iter(struct kiocb *iocb, struct =
iov_iter *from)
> 	if (o_direct) {
> 		size_t length =3D iov_iter_count(from);
> 		loff_t pos =3D iocb->ki_pos;
> +		unsigned int blkbits =3D inode->i_blkbits;
> +
> +		if (nonblocking
> +			&& (pos + length > =
EXT4_BLOCK_ALIGN(i_size_read(inode), blkbits))) {

(style) "&&" should go at the end of the previous line
(style) continued lines should align after '(' on previous line
(style) no need for parenthesis around that comparison

> +			ret =3D -EAGAIN;
> +			goto out;
> +		}
>=20
> 		/* check whether we do a DIO overwrite or not */
> -		if (ext4_should_dioread_nolock(inode) && !unaligned_aio =
&&
> -		    pos + length <=3D i_size_read(inode)) {
> +		if ((ext4_should_dioread_nolock(inode) && !unaligned_aio =
&&
> +			    pos + length <=3D i_size_read(inode)) || =
nonblocking) {

(style) continued line should align after second '(' of previous line

> 			struct ext4_map_blocks map;
> -			unsigned int blkbits =3D inode->i_blkbits;
> 			int err, len;
>=20
> 			map.m_lblk =3D pos >> blkbits;
> @@ -157,8 +168,13 @@ ext4_file_write_iter(struct kiocb *iocb, struct =
iov_iter *from)
> 			 * non-flags are returned.  So we should check
> 			 * these two conditions.
> 			 */
> -			if (err =3D=3D len && (map.m_flags & =
EXT4_MAP_MAPPED))
> -				overwrite =3D 1;
> +			if (err =3D=3D len) {
> +			       if (map.m_flags & EXT4_MAP_MAPPED)
> +				       overwrite =3D 1;
> +			} else if (nonblocking) {
> +				ret =3D -EAGAIN;
> +				goto out;
> +			}
> 		}
> 	}
>=20
> --
> 2.10.2
>=20


Cheers, Andreas






--Apple-Mail=_BDC9A4CF-CE3B-49AC-8852-1081693B6D51
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFYo1/ypIg59Q01vtYRAhorAKC4oNL/LY8JqmtkXjAEt8ElCxeXuwCgw+pL
rihl7skbHFXBTdK040EwgFk=
=Rjyc
-----END PGP SIGNATURE-----

--Apple-Mail=_BDC9A4CF-CE3B-49AC-8852-1081693B6D51--
