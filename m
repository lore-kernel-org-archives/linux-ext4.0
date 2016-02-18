From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/2] ext4: Prevent panic for destroyed devices
Date: Thu, 18 Feb 2016 12:35:34 +0300
Message-ID: <87d1ru2wex.fsf@openvz.org>
References: <1455618965-26699-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:36778 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1425873AbcBRJgE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Feb 2016 04:36:04 -0500
Received: by mail-lb0-f175.google.com with SMTP id x1so24775079lbj.3
        for <linux-ext4@vger.kernel.org>; Thu, 18 Feb 2016 01:36:03 -0800 (PST)
In-Reply-To: <1455618965-26699-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Dmitry Monakhov <dmonakhov@openvz.org> writes:

> Some devices(nbd) can becomes unoperatable via kill_bdev
> so its pagecache will be invalidated and all buffers becomes unmapped.
> In that situation we will trigger BUGON on submit_bh.
>
> #Testcase
> mkdir  -p a/mnt
> cd a
> truncate -s 1G img
> mkfs.ext4 -F img
> qemu-nbd -c /dev/nbd0 img
> mount /dev/nbd0 /mnt
> cp -r /bin/ /mnt&
> # Disconnect nbd while cp is active
> qemu-nbd -d /dev/nbd0
> sync

Hm...
Actually there are many places where we submit BHs w/o checks
nojournal code is full of such places.
It looks like we need some sort of AOP_TRUNCATE_PAGE error code
for generic buffer submission path

diff --git a/fs/buffer.c b/fs/buffer.c
index e1632ab..1cf94ec 100644
=2D-- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3127,6 +3127,10 @@ int __sync_dirty_buffer(struct buffer_head *bh, int =
rw)
=20
        WARN_ON(atomic_read(&bh->b_count) < 1);
        lock_buffer(bh);
+       if(unlikely(!buffer_mapped(bh))) {
+               unlock_buffer(bh);
+               return AOP_TRUNCATE_PAGE; /* or EIO */
+       }
        if (test_clear_buffer_dirty(bh)) {
                get_bh(bh);
                bh->b_end_io =3D end_buffer_write_sync;

>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/super.c | 24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 3ed01ec..617d8b4a 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4320,7 +4320,7 @@ static int ext4_commit_super(struct super_block *sb=
, int sync)
>  	struct buffer_head *sbh =3D EXT4_SB(sb)->s_sbh;
>  	int error =3D 0;
>=20=20
> -	if (!sbh || block_device_ejected(sb))
> +	if (!sbh || !buffer_mapped(sbh) || block_device_ejected(sb))
>  		return error;
>  	if (buffer_write_io_error(sbh)) {
>  		/*
> @@ -4368,8 +4368,26 @@ static int ext4_commit_super(struct super_block *s=
b, int sync)
>  	ext4_superblock_csum_set(sb);
>  	mark_buffer_dirty(sbh);
>  	if (sync) {
> -		error =3D __sync_dirty_buffer(sbh,
> -			test_opt(sb, BARRIER) ? WRITE_FUA : WRITE_SYNC);
> +		lock_buffer(sbh);
> +		/* superblock bh may be invalidated due to drive failure */
> +		if (!buffer_mapped(sbh)) {
> +			unlock_buffer(sbh);
> +			ext4_msg(sb, KERN_ERR, "Can not write superblock "
> +				 "because disk cache was invalidated");
> +			return -EIO;
> +		}
> +		if (test_clear_buffer_dirty(sbh)) {
> +			get_bh(sbh);
> +			sbh->b_end_io =3D end_buffer_write_sync;
> +			error =3D submit_bh(test_opt(sb, BARRIER) ?
> +					  WRITE_FUA : WRITE_SYNC, sbh);
> +			wait_on_buffer(sbh);
> +			if (!error && !buffer_uptodate(sbh))
> +				error =3D -EIO;
> +		} else {
> +			unlock_buffer(sbh);
> +		}
> +
>  		if (error)
>  			return error;
>=20=20
> --=20
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJWxZBmAAoJELhyPTmIL6kBE3MIALGLvJADK/BAVx/isVpr6geS
tScjshnAB0nOBrR3v5yRpC1erW7Vst6AWGfR6zyLyY8nXjTUHF0v8G3FCQ0+BTt9
HBdLLmGckb8AYbYlZ1OqLeRqgLyfyZOFFtsiXvo55q+cueV93nXGfrn7ap0kB6D8
zxPm+/Pd5aswIDp62jIn+EjuNcn7jQ4HUJYoMo2WY08famkGZ7uRRvM/IxqZled5
KMybZ+NP1ZYG5ER95kIWYf1TJvdgtBuLfynQxJ/1VyHDem00iqpiMDvJithFpS3H
yC1pU8ojAohMwdSYpHf1qUbA+uVVKn6gSQxWzkOlXiE9HMZHGylug9/h6le9iEY=
=gcy6
-----END PGP SIGNATURE-----
--=-=-=--
