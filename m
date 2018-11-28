Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39604 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbeK2GMJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Nov 2018 01:12:09 -0500
Received: by mail-pl1-f196.google.com with SMTP id 101so11560116pld.6
        for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2018 11:09:29 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <050FAC09-2437-417C-AF69-7637613BA7BB@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_2322F7DF-FF46-4EA9-81C5-39504745ABAC";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] Fix tst_super_size after ext2_super_block changes
Date: Wed, 28 Nov 2018 12:09:26 -0700
In-Reply-To: <20181128160834.1729-1-artem.blagodarenko@gmail.com>
Cc: linux-ext4@vger.kernel.org
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
References: <20181128160834.1729-1-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_2322F7DF-FF46-4EA9-81C5-39504745ABAC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 28, 2018, at 9:08 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> Commits "Reserve feature bit and SB field bit for filename encoding"
> and "Add timestamp extension bits to superblock" change
> ext2_super_block structure, but don't change tst_super_size test,
> so "make check" fails with message:
>=20
> error: s_reserved size 380 should be 392

How did these patches even land without "make check" being run once?
Does this test failure not cause "make check" to fail?

Anyway, you can add:

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
> ---
> lib/ext2fs/tst_super_size.c | 11 ++++++++++-
> 1 file changed, 10 insertions(+), 1 deletion(-)
>=20
> diff --git a/lib/ext2fs/tst_super_size.c b/lib/ext2fs/tst_super_size.c
> index 0adac411..a932685d 100644
> --- a/lib/ext2fs/tst_super_size.c
> +++ b/lib/ext2fs/tst_super_size.c
> @@ -142,7 +142,16 @@ int main(int argc, char **argv)
> 	check_field(s_lpf_ino, 4);
> 	check_field(s_prj_quota_inum, 4);
> 	check_field(s_checksum_seed, 4);
> -	check_field(s_reserved, 98 * 4);
> +	check_field(s_wtime_hi, 1);
> +	check_field(s_mtime_hi, 1);
> +	check_field(s_mkfs_time_hi, 1);
> +	check_field(s_lastcheck_hi, 1);
> +	check_field(s_first_error_time_hi, 1);
> +	check_field(s_last_error_time_hi, 1);
> +	check_field(s_pad, 2);
> +	check_field(s_encoding, 2);
> +	check_field(s_encoding_flags, 2);
> +	check_field(s_reserved, 95 * 4);
> 	check_field(s_checksum, 4);
> 	do_field("Superblock end", 0, 0, cur_offset, 1024);
> #endif
> --
> 2.14.3
>=20


Cheers, Andreas






--Apple-Mail=_2322F7DF-FF46-4EA9-81C5-39504745ABAC
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlv+5+YACgkQcqXauRfM
H+BQuA/8CZF3/oCCowKErx3KLHjESHa7F+lVLJ7EaXhou0jMgTk5R/+9GuOW44ty
uZdSmKpuDUcou2COYJBXfzWQkb8L9yqqt2Sm2XeGEboSuDOpoad0Ol017LlExsgo
ekdVWMkYwU/FvbHmDvpCLaaXiXqPTQP7kYSdEKKPBr5R9S+d2Tqg6IZHhPsH1qBG
Kbe4LrKy6cwub4z5LyurotmajH1OG80z2A74KIpwhSwQEsguf6fwSt11/nk6/j+G
ya052xt3VWwR7vPbv3WuLCnjW0tx0IAUlkZVfRYe5DLVrW9ETXN/cMdRjDo+tZaE
b/SggyHJ2CzXhHUZyTWVUqPZemR918op2jnEMftTEDTaVz9Qu/tl1Mo2w+2UNd/o
ZlhkHYmtATABqVcLjHazwhqyZN/hoDE6DTp9yzPmpMhozVJzRyH2oQeDm372mj+N
0H8+nKUueZOAgNrfFjVruTpLcpNXLhzbbS/iRiz0TsnANc42MleEcfNvUV0FJ/rR
YvZaL2z41FBj9zssWvI7XL+PBhp9Bo7N9OfwIjpKx76qecfbxpKCGBmDA0fjHDG/
XTnTiFseR9vZ4BiA6v4QpQGu7R+sL5RH3vH1xZk5IvN7zeaePSOe0cvHyqhIgCZq
WSrRoKc1piAl0u60hRF0Q+yqqF+f4dLSoYVOk+JVrAQKCMTMUEc=
=6xBT
-----END PGP SIGNATURE-----

--Apple-Mail=_2322F7DF-FF46-4EA9-81C5-39504745ABAC--
