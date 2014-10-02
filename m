From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: ensure LARGE_FILE feature when mounting delalloc
Date: Wed, 1 Oct 2014 19:26:22 -0600
Message-ID: <AA97FC30-5235-4E7E-AC17-14BC6C813F17@dilger.ca>
References: <542C7331.4070200@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_2F799DB6-B14D-476E-B7B2-19BEEE7FC9FA"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:52614 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbaJBB0U (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Oct 2014 21:26:20 -0400
Received: by mail-pd0-f176.google.com with SMTP id fp1so1157336pdb.7
        for <linux-ext4@vger.kernel.org>; Wed, 01 Oct 2014 18:26:19 -0700 (PDT)
In-Reply-To: <542C7331.4070200@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_2F799DB6-B14D-476E-B7B2-19BEEE7FC9FA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 1, 2014, at 3:33 PM, Eric Sandeen <sandeen@redhat.com> wrote:
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
> It simplifies things if we ensure that when we are running
> with delalloc, we have LARGE_FILE set already; that way we
> don't have to potentially set it later during a file write.
>=20
> For any fs of sufficient size, LARGE_FILE is usually set
> simply due to the size of the resize inode.  And for ext4,
> HUGE_FILE is set by default.
>=20
> LARGE_FILE is a decades-old compatibility flag, so at this
> point there is little risk of backwards compatibility problems
> by enabling it when the filesystem is mounted as ext4.
>=20
> So just set LARGE_FILE if we are mounted delalloc, if it's
> not set already, and be done with it.
>=20
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---=20
>=20
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 0b28b36..8e56d7e 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3576,6 +3576,20 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> 			clear_opt(sb, DELALLOC);
> 	}
>=20
> +	/*
> +	 * Adding the LARGE_FILES feature to the superblock adds
> +	 * unnecessary complication to journal credit calculations
> +	 * when delalloc is enabled.  This is a decades-old feature,
> +	 * so just enable it now to simplify things.
> +	 */
> +	if (test_opt(sb, DELALLOC) && !(sb->s_flags & MS_RDONLY) &&
> +	    EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL) =
&&
> +	    !EXT4_HAS_RO_COMPAT_FEATURE(sb, =
EXT4_FEATURE_RO_COMPAT_LARGE_FILE)) {
> +		ext4_update_dynamic_rev(sb);
> +		EXT4_SET_RO_COMPAT_FEATURE(sb,
> +					   =
EXT4_FEATURE_RO_COMPAT_LARGE_FILE);

This sets the superblock flag, but doesn't actually mark the superblock
dirty.  Later in ext4_fill_super() it is possible that this buffer_head
is discarded without writing it out:

        if (sb->s_blocksize !=3D blocksize) {
                :
                :
                brelse(bh);

While this isn't completely fatal (the next mount would enable this
flag again), it could cause some errors to appear in e2fsck if large
files are created without the large_file feature in the superblock.
It would probably be safer to mark the superblock dirty in this case
so that it is written out.  No need to sync it I think

                ext4_commit_super(sb, 0);

Also, it looks like it is possible to enable delalloc via remount, so
this feature check/set should also be added there?

Cheers, Andreas

> +	}
> +
> 	sb->s_flags =3D (sb->s_flags & ~MS_POSIXACL) |
> 		(test_opt(sb, POSIX_ACL) ? MS_POSIXACL : 0);
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_2F799DB6-B14D-476E-B7B2-19BEEE7FC9FA
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVCypvnKl2rkXzB/gAQJylxAAslCp/J2E05yc1+76dHUhByY5XCZcMAlK
kaOlFrUExNCqpCkugWrmgmtMMmM9UQ7H6XvsVLUzVYU72jyAz3+ykCVz7x97PlP4
fmtwWQLUelWeRxUvO1Yk2HIzGVpB2vyDQzWfguqG6+1UQnmWF8pJBwgnIWT85Oxh
SgaqgitbTse4pqYnxE3l572UppvfnCsUT5K8kgjDUexTHa6QSxFIh2+bxhjatG9A
aBvqrwvA/5tDYDU+4O/scqj8iUk4C5w8ir7xvaBJkiBg+sJ2+C9LvVSbURKOIyw2
B3c8Yd2AsrJVV3s3xag1+4aUUXrw0sCyIDPEtyXTH/YSkJh9cpgfSc96xfQ05DTu
O/6uBy9hVezaxFilJv3TtOyWj83D06zrQz07qDa8Nj/BTK77KLu99IrOb7k+yfG0
iS0SuRiSACUUZ93ehUDsPmk21cIn5GAN3Fgah1m8R4dz4T7gDMdlJP4KPp6GKmQk
qSg79Z81gTSqvtuDNXvogieEuf1CkCRD4nFzNGflINZzahHG6eqO2xU650oAnt3a
OIu+CI6+x469Dhtqhk7VJjhKtUIG2HeLxV7EfnRWIrmKUILohi40WtszW0jRgNLz
peuFI6CuEDPFaPa+aLSNFCBJ+uZzggRHhbBCBhE5ttLmqTmCSSk6VV3C3JK/ugP3
l6ui/sBkkT8=
=FQaX
-----END PGP SIGNATURE-----

--Apple-Mail=_2F799DB6-B14D-476E-B7B2-19BEEE7FC9FA--
