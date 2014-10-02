From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: fix reservation overflow in ext4_da_write_begin
Date: Thu, 2 Oct 2014 15:00:23 -0600
Message-ID: <979DAB3D-0F2D-4CF2-BDF2-EF101713829B@dilger.ca>
References: <542C7331.4070200@redhat.com> <542D6F2A.70006@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_BE1A439F-2959-4207-BF5B-57315E256A6C"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:47688 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaJBVAS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Oct 2014 17:00:18 -0400
Received: by mail-pa0-f53.google.com with SMTP id kq14so3405812pab.12
        for <linux-ext4@vger.kernel.org>; Thu, 02 Oct 2014 14:00:18 -0700 (PDT)
In-Reply-To: <542D6F2A.70006@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_BE1A439F-2959-4207-BF5B-57315E256A6C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 2, 2014, at 9:28 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> Delalloc write journal reservations only reserve 1 credit,
> to update the inode if necessary.  However, it may happen
> once in a filesystem's lifetime that a file will cross
> the 2G threshold, and require the LARGE_FILE feature to
> be set in the superblock as well, if it was not set already.
>=20
> This overruns the transaction reservation, and can be
> demonstrated simply on any ext4 filesystem without the LARGE_FILE
> feature already set:
>=20
> dd if=3D/dev/zero of=3Dtestfile bs=3D1 seek=3D2147483646 count=3D1 \
> 	conv=3Dnotrunc of=3Dtestfile
> sync
> dd if=3D/dev/zero of=3Dtestfile bs=3D1 seek=3D2147483647 count=3D1 \
> 	conv=3Dnotrunc of=3Dtestfile
>=20
> leads to:
>=20
> EXT4-fs: ext4_do_update_inode:4296: aborting transaction: error 28 in =
__ext4_handle_dirty_super
> EXT4-fs error (device loop0) in ext4_do_update_inode:4301: error 28
> EXT4-fs error (device loop0) in ext4_reserve_inode_write:4757: =
Readonly filesystem
> EXT4-fs error (device loop0) in ext4_dirty_inode:4876: error 28
> EXT4-fs error (device loop0) in ext4_da_write_end:2685: error 28
>=20
> Adjust the number of credits based on whether the flag is
> already set, and whether the current write may extend past the
> LARGE_FILE limit.
>=20
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---=20
>=20
> Ok, how's this ... I do like this a lot better than the set-flag-on-
> mount-or-remount, which started to get a bit icky.
>=20
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 3aa26e9..8d362c2 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2515,6 +2515,20 @@ static int ext4_nonda_switch(struct super_block =
*sb)
> 	return 0;
> }
>=20
> +/* We always reserve for an inode update; the superblock could be =
there too */
> +static int ext4_da_write_credits(struct inode *inode, loff_t pos, =
unsigned len)
> +{
> +	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,

This could be marked "likely()" I suspect, but not critical.

> +                                EXT4_FEATURE_RO_COMPAT_LARGE_FILE))
> +		return 1;
> +
> +	if (pos + len <=3D 0x7fffffffULL)
> +		return 1;
> +
> +	/* We might need to update the superblock to set LARGE_FILE */
> +	return 2;
> +}
> +
> static int ext4_da_write_begin(struct file *file, struct address_space =
*mapping,
> 			       loff_t pos, unsigned len, unsigned flags,
> 			       struct page **pagep, void **fsdata)
> @@ -2565,7 +2579,8 @@ retry_grab:
> 	 * of file which has an already mapped buffer.
> 	 */
> retry_journal:
> -	handle =3D ext4_journal_start(inode, EXT4_HT_WRITE_PAGE, 1);
> +	handle =3D ext4_journal_start(inode, EXT4_HT_WRITE_PAGE,
> +			ext4_da_write_credits(inode, pos, len));
> 	if (IS_ERR(handle)) {
> 		page_cache_release(page);
> 		return PTR_ERR(handle);
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_BE1A439F-2959-4207-BF5B-57315E256A6C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVC2853Kl2rkXzB/gAQIF+Q/+LXaOzDfI22WyW2Ny/TxxqEXmA/+bvkPT
k/Y3RRcfuGc8lljQOIBFWn0myBTxPxdOCpGAdQhSTV2gUzVBA3cKTQWyyEv2ZKf2
jSYnkE2awkJVvTCuQQHkB6lcvAQ8zrO1H5CtA8TNTkqaRbaF3NO/8Do8ynM5CyEv
9MgFyO4tvfoEavqQKphNPQpsvfDkJ26OngCmYKbF88VfgVMs+OO3ZA6rfsMKH5QN
OrvSx/lgJSJ6Z/WIPbHlgdhlUSnbSrt5Cj2Qv6vCWwEy4djaAIY+7/fpzJZkJ7l6
WqCGCzVnWpmD88Y1WNTeGBCi5qGLV27dP+0q9KWbbTjMncXS0Dcx1VEdSVQFaQFY
ZepKTvS6NWQD/Rth2VFdnuV3/M8gy85Wz7rg/Ysn/PK7xwoJSsqOwWUe97IVgkBG
k672XvsqBQF/ADModhKBBi2J8TjBlrMJ8YkMd12xLJfIhgwUjXklSPNA8h11Pinl
zhULozKLcvvKEEokihppelCd6wz6pyfpSXsy1iO23B6/uHIM2EiFjKi5y0mKqjZO
5TnOFYhaKHKjWv4aIuKhPd2bpn8b1ekPBTtszAmP6YnZ5nATLYON7IxkfnwKc+VR
gccxktq/meIGp3CZnTgTVvRC6zhJVZcANwbYCJ77vV/aHbxly5Rk0yn6ZxzPAH6O
Q0525WbZeFg=
=NS/T
-----END PGP SIGNATURE-----

--Apple-Mail=_BE1A439F-2959-4207-BF5B-57315E256A6C--
