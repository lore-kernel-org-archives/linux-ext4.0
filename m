From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: inplace xattr block update fails to deduplicate
 blocks
Date: Sat, 15 Jul 2017 02:49:05 -0700
Message-ID: <EAEB944F-E38E-41CE-ACE6-AC9BE0E28598@dilger.ca>
References: <20170715002529.31045-1-tahsin@google.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_AB4F50EF-CD72-44C4-A88F-16FD54D723DF";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35099 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbdGOJtJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Jul 2017 05:49:09 -0400
Received: by mail-io0-f196.google.com with SMTP id 84so4059886iop.2
        for <linux-ext4@vger.kernel.org>; Sat, 15 Jul 2017 02:49:09 -0700 (PDT)
In-Reply-To: <20170715002529.31045-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_AB4F50EF-CD72-44C4-A88F-16FD54D723DF
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jul 14, 2017, at 5:25 PM, Tahsin Erdogan <tahsin@google.com> wrote:
>=20
> When an xattr block has a single reference, block is updated inplace
> and it is reinserted to the cache. Later, a cache lookup is performed
> to see whether an existing block has the same contents. This cache
> lookup will most of the time return the just inserted entry so
> deduplication is not achieved.
>=20
> Running the following test script will produce two xattr blocks which
> can be observed in "File ACL: " line of debugfs output:
>=20
>  mke2fs -b 1024 -I 128 -F -O extent /dev/sdb 1G
>  mount /dev/sdb /mnt/sdb
>=20
>  touch /mnt/sdb/{x,y}
>=20
>  setfattr -n user.1 -v aaa /mnt/sdb/x
>  setfattr -n user.2 -v bbb /mnt/sdb/x
>=20
>  setfattr -n user.1 -v aaa /mnt/sdb/y
>  setfattr -n user.2 -v bbb /mnt/sdb/y
>=20
>  debugfs -R 'stat x' /dev/sdb | cat
>  debugfs -R 'stat y' /dev/sdb | cat
>=20
> This patch defers the reinsertion to the cache so that we can locate
> other blocks with the same contents.
>=20
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/ext4/xattr.c | 4 +---
> 1 file changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index cff4f41ced61..ad4ea1cf685f 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -1815,9 +1815,6 @@ ext4_xattr_block_set(handle_t *handle, struct =
inode *inode,
> 			ea_bdebug(bs->bh, "modifying in-place");
> 			error =3D ext4_xattr_set_entry(i, s, handle, =
inode,
> 						     true /* is_block =
*/);
> -			if (!error)
> -				=
ext4_xattr_block_cache_insert(ea_block_cache,
> -							      bs->bh);
> 			ext4_xattr_block_csum_set(inode, bs->bh);
> 			unlock_buffer(bs->bh);
> 			if (error =3D=3D -EFSCORRUPTED)
> @@ -1973,6 +1970,7 @@ ext4_xattr_block_set(handle_t *handle, struct =
inode *inode,
> 		} else if (bs->bh && s->base =3D=3D bs->bh->b_data) {
> 			/* We were modifying this block in-place. */
> 			ea_bdebug(bs->bh, "keeping this block");
> +			ext4_xattr_block_cache_insert(ea_block_cache, =
bs->bh);
> 			new_bh =3D bs->bh;
> 			get_bh(new_bh);
> 		} else {
> --
> 2.13.2.932.g7449e964c-goog
>=20


Cheers, Andreas






--Apple-Mail=_AB4F50EF-CD72-44C4-A88F-16FD54D723DF
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZaeURpIg59Q01vtYRAoScAKCWtX3V+9+QBhTOwdM2wE+fa0s2RgCgqCwI
p90evrQoCTr9YtL41A3Uc20=
=Udac
-----END PGP SIGNATURE-----

--Apple-Mail=_AB4F50EF-CD72-44C4-A88F-16FD54D723DF--
