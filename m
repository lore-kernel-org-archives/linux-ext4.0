From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/6] ext4: sysfs: print ext4_super_block fields as
 little-endian
Date: Thu, 21 Jun 2018 11:49:08 -0600
Message-ID: <4D58091B-6028-4E24-9EDD-0B4D53314FB8@dilger.ca>
References: <20180620153322.54221-1-arnd@arndb.de>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_C93D473D-5749-4058-B51D-09805EDD47E7";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        y2038@lists.linaro.org,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        stable@vger.kernel.org, Tyson Nottingham <tgnottingham@gmail.com>,
        Riccardo Schirone <sirmy15@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180620153322.54221-1-arnd@arndb.de>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_C93D473D-5749-4058-B51D-09805EDD47E7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 20, 2018, at 9:32 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>=20
> While working on extended rand for last_error/first_error timestamps,
> I noticed that the endianess is wrong, we access the little-endian
> fields in struct ext4_super_block as native-endian when we print them.
>=20
> This adds a special case in ext4_attr_show() and ext4_attr_store()
> to byteswap the superblock fields if needed.
>=20
> In older kernels, this code was part of super.c, it got moved to =
sysfs.c
> in linux-4.4.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 52c198c6820f ("ext4: add sysfs entry showing whether the fs =
contains errors")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

I was wondering why this didn't just use le32_to_cpu() all the time,
but I see that these functions are being used for both ext4_super_block
(on-disk) fields, as well as ext4_sb_info (in-memory) fields.  A bit
ugly, but I don't think there is a better solution.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/ext4/sysfs.c | 13 ++++++++++---
> 1 file changed, 10 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
> index f34da0bb8f17..b970a200f20c 100644
> --- a/fs/ext4/sysfs.c
> +++ b/fs/ext4/sysfs.c
> @@ -274,8 +274,12 @@ static ssize_t ext4_attr_show(struct kobject =
*kobj,
> 	case attr_pointer_ui:
> 		if (!ptr)
> 			return 0;
> -		return snprintf(buf, PAGE_SIZE, "%u\n",
> -				*((unsigned int *) ptr));
> +		if (a->attr_ptr =3D=3D ptr_ext4_super_block_offset)
> +			return snprintf(buf, PAGE_SIZE, "%u\n",
> +					le32_to_cpup(ptr));
> +		else
> +			return snprintf(buf, PAGE_SIZE, "%u\n",
> +					*((unsigned int *) ptr));
> 	case attr_pointer_atomic:
> 		if (!ptr)
> 			return 0;
> @@ -308,7 +312,10 @@ static ssize_t ext4_attr_store(struct kobject =
*kobj,
> 		ret =3D kstrtoul(skip_spaces(buf), 0, &t);
> 		if (ret)
> 			return ret;
> -		*((unsigned int *) ptr) =3D t;
> +		if (a->attr_ptr =3D=3D ptr_ext4_super_block_offset)
> +			*((__le32 *) ptr) =3D cpu_to_le32(t);
> +		else
> +			*((unsigned int *) ptr) =3D t;
> 		return len;
> 	case attr_inode_readahead:
> 		return inode_readahead_blks_store(sbi, buf, len);
> --
> 2.9.0
>=20


Cheers, Andreas






--Apple-Mail=_C93D473D-5749-4058-B51D-09805EDD47E7
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlsr5RQACgkQcqXauRfM
H+CP/BAAposFKM14Olv6fh+b6UclqOHR8MbfNo8ihie1dSxlWTvZQSzytRJiOueh
J76d2Hs1eXBT40Q7SFeeoP4CYwPW/mafKsHBaYxkY+D9bnMzCan0S12XWyHz4Tw0
RKiC706NbkAYg/BsL/r0UxOu66zEs/mIbO8CbXBMXzOb5D5W5/WA40Gc7jALLCf2
m+bAFqb16flJsp7mrC8tuLi8iVflqK4pGu5p1WJI8wsvwB1cmF0PwvixMkhYeDpf
cvjQP3aisJjHW3CAAxjPPKhCF0omEwQumXpu+SyqnldOqcrZ0pUyL1LC8b4fJJcM
k3SkbCWT+AgTpOYkAayzM5D93osDeYN+vpoIV9kC7X71UOGQrgtEw5VZGhSiWtQ+
F2WadBxG5ekJio364V7tJ/+Gs96cqCtsamAnSdIKDan2PcBi+/ZoQj5XRJjfKSCV
1oB2SSeyeHEWqQxGZ8snErnFpJr0fK903XAlnOV65T8ZGkCp8uZOkfD7Gr1n7ifp
zsx5tVm92iMbhTMXQshN5OeAsVucKCjeIKPzT+bbBwG+F+/ND8pQSksUoPzM/0QO
58Rb+jtngDXf2T+BhybD8kQrs3lbtEywxWl9o2b9MQKzl6dbcu6eXCzvrvcUd2j4
UgKEzp5tO+qxbCXcZGKMn3LXNQ2XjkjMauwq7295JjgwDh9gMbQ=
=fV5z
-----END PGP SIGNATURE-----

--Apple-Mail=_C93D473D-5749-4058-B51D-09805EDD47E7--
