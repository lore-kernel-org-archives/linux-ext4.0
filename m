From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: validate s_first_meta_bg at mount time
Date: Tue, 29 Nov 2016 15:52:24 -0700
Message-ID: <1FA5BB14-BCE7-4FC2-AE75-7DC0A162484C@dilger.ca>
References: <20161129055717.4154-1-guaneryu@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_8FA06C64-B8E5-413A-852E-3D8D4321208D"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34916 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752167AbcK2Ww3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Nov 2016 17:52:29 -0500
Received: by mail-io0-f194.google.com with SMTP id h133so32608197ioe.2
        for <linux-ext4@vger.kernel.org>; Tue, 29 Nov 2016 14:52:29 -0800 (PST)
In-Reply-To: <20161129055717.4154-1-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_8FA06C64-B8E5-413A-852E-3D8D4321208D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Nov 28, 2016, at 10:57 PM, Eryu Guan <guaneryu@gmail.com> wrote:
>=20
> Ralf Spenneberg reported that he hit a kernel crash when mounting a
> modified ext4 image. And it turns out that kernel crashed when
> calculating fs overhead (ext4_calculate_overhead()), this is because
> the image has very large s_first_meta_bg (debug code shows it's
> 842150400), and ext4 overruns the memory in count_overhead() when
> setting bitmap buffer, which is PAGE_SIZE.
>=20
> ext4_calculate_overhead():
>  buf =3D get_zeroed_page(GFP_NOFS);  <=3D=3D=3D PAGE_SIZE buffer
>  blks =3D count_overhead(sb, i, buf);
>=20
> count_overhead():
>  for (j =3D ext4_bg_num_gdb(sb, grp); j > 0; j--) { <=3D=3D=3D j =3D =
842150400
>          ext4_set_bit(EXT4_B2C(sbi, s++), buf);   <=3D=3D=3D buffer =
overrun
>          count++;
>  }
>=20
> This can be reproduced easily for me by this script:
>=20
>  #!/bin/bash
>  rm -f fs.img
>  mkdir -p /mnt/ext4
>  fallocate -l 16M fs.img
>  mke2fs -t ext4 -O bigalloc,meta_bg,^resize_inode -F fs.img
>  debugfs -w -R "ssv first_meta_bg 842150400" fs.img
>  mount -o loop fs.img /mnt/ext4
>=20
> Fix it by validating s_first_meta_bg first at mount time, and
> refusing to mount if its value exceeds the largest possible meta_bg
> number.
>=20
> Reported-by: Ralf Spenneberg <ralf@os-t.de>
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
>=20
> In e2fsprogs, we avoided a similar buffer overrun:
> f66e6ce libext2fs: avoid buffer overflow if s_first_meta_bg is too big
>=20
> and e2fsck could detect & fix large s_first_meta_bg:
> 7a4352d e2fsck: fix file systems with an overly large s_first_meta_bg
>=20
> But I suspect that there's an off-by-one bug in e2fsck code, shouldn't =
the
> upper boundary of s_first_meta_bg be (fs->desc_blocks - 1)? Something =
like:
>=20
> e2fsck/super.c:643
>        if (ext2fs_has_feature_meta_bg(fs->super) &&
> -           (fs->super->s_first_meta_bg > fs->desc_blocks)) {
> -               pctx.group =3D fs->desc_blocks;
> +           (fs->super->s_first_meta_bg >=3D fs->desc_blocks)) {
> +               pctx.group =3D fs->desc_blocks - 1;
>                pctx.num =3D fs->super->s_first_meta_bg;
>=20
> fs/ext4/super.c | 9 +++++++++
> 1 file changed, 9 insertions(+)
>=20
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 52b0530..8f46a07 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3814,6 +3814,15 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> 			(EXT4_MAX_BLOCK_FILE_PHYS / =
EXT4_BLOCKS_PER_GROUP(sb)));
> 	db_count =3D (sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb) - 1) =
/
> 		   EXT4_DESC_PER_BLOCK(sb);
> +	if (ext4_has_feature_meta_bg(sb)) {
> +		if (le32_to_cpu(es->s_first_meta_bg) >=3D db_count) {
> +			ext4_msg(sb, KERN_WARNING,
> +				 "first meta block group too large: %u "
> +				 "(group descriptor block count %u)",
> +				 le32_to_cpu(es->s_first_meta_bg), =
db_count);
> +			goto failed_mount;
> +		}
> +	}
> 	sbi->s_group_desc =3D ext4_kvmalloc(db_count *
> 					  sizeof(struct buffer_head *),
> 					  GFP_KERNEL);
> --
> 2.9.3
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_8FA06C64-B8E5-413A-852E-3D8D4321208D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWD4GqXKl2rkXzB/gAQi4rw/9EzXz79CWf227LDDp49zyxdHXqvaX94c1
0difRaIOj4aP9bMESby00wfWYXI5qj3qQW/kZydwK72BBDxy6n+h4S7X2O2PnPNP
z2fexQAsNjn7+DArlaJ/p0ew7kJWpwdxLiJHphIPcq5OjtFuVh0QDMVGwXOLt6I0
yBCNr/dwvy8xybNu6O6PXbnS8Em7267znghbGuxeja+wRHYD6o7230X+DQWqhgFo
X/tXkwh9a5qDZ037/bI5DJBK0voAzEOAQEIvGoZqVBTAV4OhCXuzIiml9lN9FtHT
ae7b3mWqZByNVOMfdV64CLwPZK3yqA5wNnVJ73qEV85k2JypcGRBaGv9nsUTHSki
KDB8Ffv07Z0bBIj9EZfo1JqnP/l7dMly8z1cJS6ZyTZzU8HXZIIaS94PCHLbvEbL
eCX5NYVU/EY5fcS+M/d2lMuEPV7grrTBGFxvqqUlYPHK9y9gDIyFQvayEUTGj6nC
J8LdAUl+prCfrCTsgQ7Piy37CATsrW7hDvRFG5sjWoP8hu1galD+2JWanULTJLRC
H16ep7y3f/Z12XW4XynNnpLrCcqBEvfEZtNh59IRUXPYlyO9CjhnPqrWAPr3V9xB
vV08O4bqz1PkYZd50Xhj3LQsb4pn5eteB0vj60xZDUtGbpEQPxYexv2H1VkMrdWF
uQak+2NbKRM=
=OBOT
-----END PGP SIGNATURE-----

--Apple-Mail=_8FA06C64-B8E5-413A-852E-3D8D4321208D--
