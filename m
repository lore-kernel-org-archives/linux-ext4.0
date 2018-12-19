Return-Path: <SRS0=7ScE=O4=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41421 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbeLSEz4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Dec 2018 23:55:56 -0500
Received: by mail-pg1-f196.google.com with SMTP id m1so7253468pgq.8
        for <linux-ext4@vger.kernel.org>; Tue, 18 Dec 2018 20:55:55 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <6112C6BB-1356-45D8-8435-A93FC2AD4C2D@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_B60DCA2C-6A3F-4D09-8EC8-EB5182E64A27";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH 2/2] ext4: clean up group state test macros with predicate
 functions
Date: Tue, 18 Dec 2018 21:55:49 -0700
In-Reply-To: <0173dff1-127d-96d8-cd70-e94935e6230c@huawei.com>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, Wang Shilong <wshilong@ddn.com>,
        Miao Xie <miaoxie@huawei.com>
To: "zhangyi (F)" <yi.zhang@huawei.com>
References: <1545134401-104523-1-git-send-email-yi.zhang@huawei.com>
 <1545134401-104523-2-git-send-email-yi.zhang@huawei.com>
 <1095F3A1-32A9-42A7-BE1C-40A7212015D0@dilger.ca>
 <0173dff1-127d-96d8-cd70-e94935e6230c@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_B60DCA2C-6A3F-4D09-8EC8-EB5182E64A27
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 18, 2018, at 9:47 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>=20
> On 2018/12/19 3:51, Andreas Dilger Wrote:
>> On Dec 18, 2018, at 5:00 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>>=20
>>> Create separate predicate functions to test/set/clear/test_and_set
>>> bb_state flags in ext4_group_info like features testing, and then
>>> replace all old macros and the places where we use
>>> EXT4_GROUP_INFO_XXX_BIT directly.
>>>=20
>>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>>> ---
>>>=20
>>> +EXT4_MB_GROUP_STATE_FUNCS(need_init, NEED_INIT)
>>> +EXT4_MB_GROUP_STATE_FUNCS(trimmed, WAS_TRIMMED)
>>> +EXT4_MB_GROUP_STATE_FUNCS(bbitmap_corrupt, BBITMAP_CORRUPT)
>>> +EXT4_MB_GROUP_STATE_FUNCS(ibitmap_corrupt, IBITMAP_CORRUPT)
>>=20
>> One problem with macros like this that internally expand to multiple
>> functions is that there is now nowhere in this code where, for =
example,
>> the declaration of ext4_mb_grp_test_and_set_bbitmap_corrupt() can be
>> found.  That makes it hard to understand the code, because tags for =
this
>> function name will not work, and even a grep through the entire code =
for
>> this string will not show the function implementation, only users.  =
One
>> would have to search for only the "ext4_mb_grp_test_and_set" part, or
>> "ext4_mb_grp_clear" to find the above macros.
>>=20
>> If such macros-that-generate-functions are being used, my preference =
is
>> that at least a comment block is added that spells out the full =
function
>> names, so that at least a grep will find them, like:
>>=20
>> /*
>> * These macros implement the following functions:
>> * - ext4_mb_grp_need_init(), ext4_mb_grp_test_and_set_need_init(),
>> *   ext4_mb_grp_set_need_init(), ext4_mb_grp_clear_need_init()
>> * - ...
>> * - ...
>> */
>>=20
>> Yes, this is a bit cumbersome the rare times a new function is added, =
but
>> it really makes the code easier to understand in the future, without =
forcing
>> a cut-and-paste of the body of each function.  I don't know how many =
times
>> I've had to search for commonly-used functions like buffer_uptodate() =
or
>> buffer_dirty() in the code without being able to find them easily.
>>=20
>=20
> Thanks for your comments. Indeed, I also had the same hard time as you =
said.
> I am not so sure why we have been using these maco functions for ext4 =
features
> and ext4_inode_info bit flags. But I think it's still worth to unify =
them.
>=20
> I will add the comment block as your suggested and post the second =
version,
> BTW, I read the commit 3f61c0cc706 "ext4: add prototypes for =
macro-generated
> functions" you posted, it's also a good choice.

Indeed, adding static function prototypes is even better than putting =
the
function names in a comment, since tags/ctags/etags will find them for =
you.
I'd forgotten about that patch.

Cheers, Andreas






--Apple-Mail=_B60DCA2C-6A3F-4D09-8EC8-EB5182E64A27
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlwZz1YACgkQcqXauRfM
H+AELQ//YohMm1zCxe7yo8ynKYraxOeF19zXJ+A5ROBKOZnAF6xE3nSQHE+yHD0b
i4CwlKYURTeVw7qua1CiAeIik5fQwf5iN3UjoMVIc2y8WKWv4gFzz49Sf5hmcRQr
Ses3l30uqRHa8Cp3mnk3eys2B947fpeVDQIxMb3Bdht1sN8Hrl5Pc2WiAMCaAGLF
W3EXrtrA5OermsaYMZcjRqZWRsysV/kLE/GvwzF2ZgtEz5V5w3f8m+xNXLuxGgLc
Tyf26IJtJrTYCNNTqqWs1f+zfUSgUg/q7zrYSoHh15NLD0YyEeXblTgluVoW8UBm
oQJQPXz0jvqrLgtfxpdFvQrLJMIau1F/4yl7vfJxwR123NCsOO+ujfOt2Xa8MciO
eKDyB7V0xWI3n/BQDvPVAbHKYo4v73kOvMl++DGVHN8Bw2pcu5W+rVFWQlnP28hy
nJ3dG7zuwGAMa8zWT0pn4OxM29TAqUxUqJwNQIfsTNE9/YPrG45Yo7VQ7MRGeywN
oCb4MINNU392RDGfaKyfqG9CIMga3l4934CvUQPr4e2iVixq/z2pRSF72dTfGyW0
Kp5Y0B5YS/l45ddQFip9hu567dYlmm401SCJO5u77g+jKppMoJvtz2qJNK+k/CKl
uJbDTyN1yUo4Zvwak5s/EaLyQjIoCPLrssi6RcWccfxjOS8TDCE=
=2b0q
-----END PGP SIGNATURE-----

--Apple-Mail=_B60DCA2C-6A3F-4D09-8EC8-EB5182E64A27--
