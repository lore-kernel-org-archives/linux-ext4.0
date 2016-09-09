From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH]:ext4 these lines are too long while reading
Date: Fri, 9 Sep 2016 14:05:55 -0600
Message-ID: <EB88063A-4241-4E91-916B-43511656405D@dilger.ca>
References: <57D281D1.6020208@huawei.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_2F3F825C-BC67-472F-B104-D88E6D12E37C"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: norton <norton.zhu@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35909 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751120AbcIIUGC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Sep 2016 16:06:02 -0400
Received: by mail-oi0-f67.google.com with SMTP id s71so8835720oih.3
        for <linux-ext4@vger.kernel.org>; Fri, 09 Sep 2016 13:06:02 -0700 (PDT)
In-Reply-To: <57D281D1.6020208@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_2F3F825C-BC67-472F-B104-D88E6D12E37C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 9, 2016, at 3:33 AM, norton <norton.zhu@huawei.com> wrote:
>=20
> Hi, all
>=20
> I'm a freshman in ext4 file system and I'm reading its source code =
now.
> This patch did nothing but make it looks better.(
> some lines are too long in vim :( ).
>=20
> Thanks.
>=20
> Signed-off-by: Norton <norton.zhu@huawei.com>
>=20
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 3ec8708..09314f8 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -109,7 +109,8 @@ static void ext4_clear_request_list(void);
>  * transaction start -> page lock(s) -> i_data_sem (rw)
>  */
>=20
> -#if !defined(CONFIG_EXT2_FS) && !defined(CONFIG_EXT2_FS_MODULE) && =
defined(CONFIG_EXT4_USE_FOR_EXT2)
> +#if !defined(CONFIG_EXT2_FS) && !defined(CONFIG_EXT2_FS_MODULE) && \
> +	defined(CONFIG_EXT4_USE_FOR_EXT2)
> static struct file_system_type ext2_fs_type =3D {
> 	.owner		=3D THIS_MODULE,
> 	.name		=3D "ext2",
> @@ -1751,7 +1752,9 @@ static int handle_mount_opt(struct super_block =
*sb, char *opt, int token,
> 	} else if (m->flags & MOPT_DATAJ) {
> 		if (is_remount) {
> 			if (!sbi->s_journal)
> -				ext4_msg(sb, KERN_WARNING, "Remounting =
file system with no journal so ignoring journalled data option");
> +				ext4_msg(sb, KERN_WARNING, "Remounting =
file "
> +					"system with no journal so "
> +					"ignoring journalled data =
option");
> 			else if (test_opt(sb, DATA_FLAGS) !=3D =
m->mount_opt) {
> 				ext4_msg(sb, KERN_ERR,
> 					 "Cannot change data mode on =
remount");
> @@ -5412,7 +5415,8 @@ static struct dentry *ext4_mount(struct =
file_system_type *fs_type, int flags,
> 	return mount_bdev(fs_type, flags, dev_name, data, =
ext4_fill_super);
> }
>=20
> -#if !defined(CONFIG_EXT2_FS) && !defined(CONFIG_EXT2_FS_MODULE) && =
defined(CONFIG_EXT4_USE_FOR_EXT2)
> +#if !defined(CONFIG_EXT2_FS) && !defined(CONFIG_EXT2_FS_MODULE) && \
> +	defined(CONFIG_EXT4_USE_FOR_EXT2)
> static inline void register_as_ext2(void)
> {
> 	int err =3D register_filesystem(&ext2_fs_type);
> @@ -5555,7 +5559,8 @@ static void __exit ext4_exit_fs(void)
> 	ext4_exit_es();
> }
>=20
> -MODULE_AUTHOR("Remy Card, Stephen Tweedie, Andrew Morton, Andreas =
Dilger, Theodore Ts'o and others");
> +MODULE_AUTHOR("Remy Card, Stephen Tweedie, Andrew Morton, Andreas =
Dilger, \
> +		Theodore Ts'o and others");

In addition to the other comments from Ted and Eric, the above change is
actually broken, as it would insert two tabs into the middle of the =
string.

Firstly, the linefeed escape '\' is only for CPP, and not needed for C.

Secondly, to split a string across lines you need to terminate it, and
the compiler will merge adjacent strings:

+MODULE_AUTHOR("Remy Card, Stephen Tweedie, Andrew Morton, Andreas =
Dilger, "
+	       "Theodore Ts'o and others");

Don't forget the space inside the string at the end of the first line.

Cheers, Andreas






--Apple-Mail=_2F3F825C-BC67-472F-B104-D88E6D12E37C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBV9MWJXKl2rkXzB/gAQgMEw//dYUbSkWPL9eGn9JP7P4PysNXnFejLyD3
z/BJdxUCLij/+nt9mgvolmJqqY/gpOBK3+aXfEeD1krTrqo8mLxqZPsXLx1j2y7M
KC+wj8BHs8s66Y3zUqb0HvP4smrv/FAcWAgcRc1WWlrHSUXR/znbKfeQVvTDf+M8
XNC/mJ9vHASISf/I3wm1HIXL8ge3fkzm0tt+COBxQ9lnxEZa1OalZy64SJeWZge0
CByiMJQ1YfAlPfH2y6TrtV5uZ5I4jYGE000KtDBWTOQ6Mz95O6DP+0vgThaUuMl8
1COxkNwc/py/rRx+VdAbZZdUSf9blBKOr/j11G2TY2rwflDcyno4vjOmqwumDBR7
RIi8qjMq7fY9JZ+y81dMpEd0ZFRFFMSZG0QreQPf/4xDr6Mdp4YG4gftRmy6zbzy
WJygW/2gaEplAEOkazMtstEmU1D7yHMyXgdCzTNfOAvoEI1nBiIwNGIRWyMyBNIf
kMbLvSRuzuCOeQO6+vh+OHZr3uUU++sHm3NfHnQmbADeVE2G4fqxpWRvtcnNx0/T
8K+s/AlaWgA37ngLz9kswJbbeUd2HYo2M8X3NcO4kBO1IjGDoNzOEpYcKkgr8HWC
kW/K/rvuC4eKEwq3O04XGHzrVTdUqQDsRddMui7JTgLMIiZGF4MrlzaSYG8NqzsS
z+vJ4Q9haJI=
=pM2V
-----END PGP SIGNATURE-----

--Apple-Mail=_2F3F825C-BC67-472F-B104-D88E6D12E37C--
