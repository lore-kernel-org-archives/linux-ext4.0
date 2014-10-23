From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: move_extent explicitly invalidate page buffers
Date: Thu, 23 Oct 2014 17:03:31 +0400
Message-ID: <87a94n0wgs.fsf@openvz.org>
References: <1414064938-2496-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Cc: tytso@mit.edu, wangxg.fnst@cn.fujitsu.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:53061 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760AbaJWNDl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Oct 2014 09:03:41 -0400
Received: by mail-wg0-f42.google.com with SMTP id z12so1050513wgg.25
        for <linux-ext4@vger.kernel.org>; Thu, 23 Oct 2014 06:03:39 -0700 (PDT)
In-Reply-To: <1414064938-2496-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Dmitry Monakhov <dmonakhov@openvz.org> writes:

> In hard core test-cases such as ext4/301, ext4/302 some bh may
> becomes dirty so try_to_release_page() will fail and result in
> false positive EBUSY failures. We can easily fix that by
> explicit ->invalidatepage() after we holds page which is locked
> and uptodate.
Sorry. This patch is not correct. Please ignore it.
>
> Tested-by: Xiaoguang Wang<wangxg.fnst@cn.fujitsu.com>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/move_extent.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> index c2b2b02..76c45b6 100644
> --- a/fs/ext4/move_extent.c
> +++ b/fs/ext4/move_extent.c
> @@ -348,8 +348,9 @@ again:
>  		     !try_to_release_page(pagep[0], 0)) ||
>  		    (page_has_private(pagep[1]) &&
>  		     !try_to_release_page(pagep[1], 0))) {
> -			*err =3D -EBUSY;
> -			goto drop_data_sem;
> +			/* One of buffers is busy, fall back data copy */
> +			ext4_double_up_write_data_sem(orig_inode, donor_inode);
> +			goto data_copy;
>  		}
>  		replaced_count =3D ext4_swap_extents(handle, orig_inode,
>  						   donor_inode, orig_blk_offset,
> @@ -360,12 +361,15 @@ again:
>  		goto unlock_pages;
>  	}
>  data_copy:
> -	*err =3D mext_page_mkuptodate(pagep[0], from, from + replaced_size);
> +	/* In order to drop all buffers we have to make page fully uptodate */
> +	*err =3D mext_page_mkuptodate(pagep[0], 0, PAGE_CACHE_SIZE);
>  	if (*err)
>  		goto unlock_pages;
>=20=20
>  	/* At this point all buffers in range are uptodate, old mapping layout
>  	 * is no longer required, try to drop it now. */
> +	do_invalidatepage(pagep[0], 0, PAGE_CACHE_SIZE);
> +	do_invalidatepage(pagep[1], 0, PAGE_CACHE_SIZE);
>  	if ((page_has_private(pagep[0]) && !try_to_release_page(pagep[0], 0)) ||
>  	    (page_has_private(pagep[1]) && !try_to_release_page(pagep[1], 0))) {
>  		*err =3D -EBUSY;
> --=20
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSPyjAAoJEFzOBSYIXfve1tcP/R97WsswVraJVTNVXzp7Xs2b
xJHaJupaej9caz9JBRwXQ9IPCesuf65wJQXw/sKKct44Wy+3P2lrweZSR2wa9ak2
hOqhVwPVXsWscJdrUwCtMNW5HMAGvrtAYp8gZ5Oy+j/vKrWtd1LSs+tlTdzT+kdZ
+u7rdpqy3uw0nN4BKeqBCYnY1lK2wi4xG9dvrT5/KxBwCHHVl/DQNI72eiXI1pjc
IiEhFr+Z9RrehmUd4Bt6AQIAFxBI+Enrz2YL/Rf1Opx3yo4/BWqVHETyH81zyh5N
Tqv3HTgOlI3F6CDyYMk3IBeHlO8RXA05uWzLSgUjBc9DTFvn5Kdm942l15wvgtM/
TYu2Yq2v8FrkUKfJmI4iu+ww7/wM4DCGLFtnKXm2Vjv0Klpx/Gb7yJQCyN2V0bVb
bzmnlroFyonUOxQtrWu9V36/iQIbAexDiDdmapNDETDZ+NOCqthVQI70frk6CqFs
ocHYH0cuJX7y03PdsbFjeH3AU0QULphCzPtTnZUhFfh/m4TJuA/GOl4c/ScTiyk0
IPu2Jsr5ua/C9V3e7QRIxmv/U6y5zWSTtkCzAufd/eHbx+oJBJSA2Dl2CsDJBRyL
tLpswz25gZSu5X9iiG2jAFnaPsteK+xM3IcWy7RtsMj+5+eeySpYfekqy0OdE7Gi
N8rih4mPDBnSlhMS74mD
=HhVp
-----END PGP SIGNATURE-----
--=-=-=--
