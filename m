From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] filefrag: fix wrong extent count calculation when using FIBMAP
Date: Mon, 6 Oct 2014 16:29:24 -0600
Message-ID: <D45CE881-3D50-4ACD-9C97-6F84B4C273BB@dilger.ca>
References: <5422CAC2.7080409@redhat.com> <1412593539-18328-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_CD1DB16B-49D4-4647-99C0-6579F96B7DC7"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, darrick.wong@oracle.com
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:49257 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaJFW3E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Oct 2014 18:29:04 -0400
Received: by mail-pd0-f180.google.com with SMTP id fp1so3931735pdb.25
        for <linux-ext4@vger.kernel.org>; Mon, 06 Oct 2014 15:29:03 -0700 (PDT)
In-Reply-To: <1412593539-18328-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_CD1DB16B-49D4-4647-99C0-6579F96B7DC7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 6, 2014, at 5:05 AM, Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com> =
wrote:
> When using FIBMAP and '-e' option is specified, the calculation for
> fiemap_extent is wrong, we wrongly updated fm_ext.fe_logical for every =
iteration, please see the code in the end of 'for' loop in
> fm_ext.fe_logical().
>=20
> In an ext2 file system(block size is 1024 bytes),
>  dd if=3D/dev/zero of=3Dtestfile bs=3D1k count=3D15
>  Using debugfs, corresponding physical blocks are "2049 2050 2051 2052 =
2053 2054
> 2055 2056 2057 2058 2059 2060 1025 2061 2062 2063",  1025 is this =
indirect block.
> Before this patch, filefrag's output would be:
>  filefrag -B -e testfile
>  Filesystem type is: ef53
>  Filesystem cylinder groups approximately 16
>  File size of testfile is 15360 (15 blocks of 1024 bytes)
>   ext:     logical_offset:        physical_offset: length:   expected: =
flags:
>     0:        1..       2:       2050..      2051:      2:       2051: =
merged
>     1:        3..       4:       2052..      2053:      2:       2053: =
merged
>     2:        5..       6:       2054..      2055:      2:       2055: =
merged
>     3:        7..       8:       2056..      2057:      2:       2057: =
merged
>     4:        9..      10:       2058..      2059:      2:       2059: =
merged
>     5:       11..      12:       2060..      2061:      2:       2062: =
merged
>     6:       13..      14:       2062..      2063:      2:       2063: =
merged,eof
>     7:       14..      14:       2063..      2063:      1:       2063: =
merged,eof
> This output is not reasonable.

Definitely agree.

> Fix this bug and try to make it readable. After this patch, the output =
would be:
>  ./filefrag -B -e mntpoint/testfile
>  Filesystem type is: ef53
>  Filesystem cylinder groups approximately 16
>  File size of mntpoint/testfile is 15360 (15 blocks of 1024 bytes)
>   ext:     logical_offset:        physical_offset: length:   expected: =
flags:
>     0:        0..      11:       2049..      2060:     12:       2062: =
merged
>     1:       12..      14:       2061..      2063:      3:       2063: =
merged,eof
>  mntpoint/testfile: 2 extents found, perfection would be 1 extent

Why would this not be shown as a single extent:

    0:      0..14:       2049..2063:    15:          merged,eof

It isn't clear why "expected" is 2062 instead of 2061.

Cheers, Andreas

> Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
> ---
> misc/filefrag.c | 37 +++++++++++++++++++++++--------------
> 1 file changed, 23 insertions(+), 14 deletions(-)
>=20
> diff --git a/misc/filefrag.c b/misc/filefrag.c
> index c1a8684..e9f7e68 100644
> --- a/misc/filefrag.c
> +++ b/misc/filefrag.c
> @@ -315,32 +315,41 @@ static int filefrag_fibmap(int fd, int =
blk_shift, int *num_extents,
> 			return rc;
> 		if (block =3D=3D 0)
> 			continue;
> +		count++;
> +
> 		if (*num_extents =3D=3D 0) {
> 			(*num_extents)++;
> 			if (force_extent) {
> 				print_extent_header();
> +				fm_ext.fe_logical =3D logical;
> 				fm_ext.fe_physical =3D block * =
st->st_blksize;
> +				fm_ext.fe_length =3D st->st_blksize;
> 			}
> +			last_block =3D block;
> +			continue;
> 		}
> -		count++;
> -		if (force_extent && last_block !=3D 0 &&
> -		    (block !=3D last_block + 1 ||
> -		     fm_ext.fe_logical + fm_ext.fe_length !=3D logical)) =
{
> -			print_extent_info(&fm_ext, *num_extents - 1,
> -					  (last_block + 1) * =
st->st_blksize,
> -					  blk_shift, st);
> -			fm_ext.fe_length =3D 0;
> -			(*num_extents)++;
> +
> +		if (force_extent) {
> +			if (block !=3D last_block + 1 ||
> +			    fm_ext.fe_length + fm_ext.fe_logical !=3D =
logical) {
> +				print_extent_info(&fm_ext, *num_extents =
- 1,
> +						  (last_block + 1) *
> +						  st->st_blksize,
> +						  blk_shift, st);
> +				fm_ext.fe_logical =3D logical;
> +				fm_ext.fe_physical =3D block * =
st->st_blksize;
> +				fm_ext.fe_length =3D st->st_blksize;
> +				(*num_extents)++;
> +			} else {
> +				fm_ext.fe_length +=3D st->st_blksize;
> +			}
> 		} else if (last_block && (block !=3D last_block + 1)) {
> -			if (verbose)
> +			if (verbose) {
> 				printf("Discontinuity: Block %ld is at =
%lu (was "
> 				       "%lu)\n", i, block, last_block + =
1);
> -			fm_ext.fe_length =3D 0;
> +			}
> 			(*num_extents)++;
> 		}
> -		fm_ext.fe_logical =3D logical;
> -		fm_ext.fe_physical =3D block * st->st_blksize;
> -		fm_ext.fe_length +=3D st->st_blksize;
> 		last_block =3D block;
> 	}
>=20
> --=20
> 1.8.2.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_CD1DB16B-49D4-4647-99C0-6579F96B7DC7
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVDMXxXKl2rkXzB/gAQIy1Q//fVP9jkQTEIQkX+jQDUtz0m/5WyWbLFF3
qbtglQU/G0Fnn6n/03+zjtpo+Ivj3ZDerFrcZ9yM+VBgW9WVjmDJ0NfCcsrNaW65
OrSKCdhuLsk964GhYaIc31kB3TWGUmXErks1cVxYw1aZqmp7ndfZKFn3um1lFZAp
GBPjCZotQ9sm/YyiK2iFs+RJpo8NJUEUYnu5Ojboti+OGPKJgzzYbiU3yqKzI9qm
Kf8UL5BNyZCMiIa1PN4DXgYfaxjCu7E9TcFAcE2ooWoUrzPSD6hymytrTal0Sah2
nbf76K8UOh0bbuwoCTUM7SSZAv3I6hK+vWTJBKw83kE7zXuEu2pGayKkK7BQnSM4
vMEhpsWIyJCy7zZlK1Ve71cFkDafECGqgv6cNaoDAMQQEW2fI1ZJ0jNnaHntWUqf
vlo4lcbhaOvWNEzPG0LhRaxLN+t5vUF/myWfkPbnf0dD9XzrmSb0awqSUcOTpxep
0YLdBti/DBjSXkivvVcQRGoIBwN0Hvcne9AAef1zlWI111P6ejlPz0X5yNnSKym6
K8w6b12hu/JQO2v1taFB87muLc1UvyeOo2eU8TVz6FZz8VkB9RLT5c7eU4kxKQdo
xfwj4LtyXgKFlUCNnwXRE2tE+tcLJ5YvjLPvwyidTWHYLAK8ZY50R4ooAZt/nAOR
56hk/vsyubw=
=nnbk
-----END PGP SIGNATURE-----

--Apple-Mail=_CD1DB16B-49D4-4647-99C0-6579F96B7DC7--
