Return-Path: <SRS0=P4kf=OT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41015 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbeLJUOM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Dec 2018 15:14:12 -0500
Received: by mail-pf1-f196.google.com with SMTP id b7so5923123pfi.8
        for <linux-ext4@vger.kernel.org>; Mon, 10 Dec 2018 12:14:11 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <1A8D0C2B-EB45-4807-9802-C7CB6DB544E3@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_9A2FDFC8-54C2-4692-85DC-58DDAC7B6B18";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] ext4: fix unsafe extent initialization
Date: Mon, 10 Dec 2018 13:14:02 -0700
In-Reply-To: <38cb83c5-600b-c523-8006-5aab0a3eb9b0@huawei.com>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Miao Xie <miaoxie@huawei.com>
To: "zhangyi (F)" <yi.zhang@huawei.com>
References: <20181208142558.47955-1-yi.zhang@huawei.com>
 <20181210051037.GG1840@mit.edu>
 <38cb83c5-600b-c523-8006-5aab0a3eb9b0@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_9A2FDFC8-54C2-4692-85DC-58DDAC7B6B18
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 10, 2018, at 2:26 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>=20
> On 2018/12/10 13:10, Theodore Y. Ts'o Wrote:
>> On Sat, Dec 08, 2018 at 10:25:58PM +0800, zhangyi (F) wrote:
>>> Current ext4 will call ext4_ext_convert_to_initialized() to split =
and
>>> initialize an unwritten extent if someone write something to it. It =
may
>>> also zeroout the nearby blocks and expand the split extent if the
>>> allocated extent is fully inside i_size or new_size. But it may lead =
to
>>> inode inconsistency when system crash or the power fails.
>>>=20
>>> Consider the following case:
>>> - Create an empty file and buffer write from block A to D (with =
delay
>>>   allocate). It will update the i_size to D.
>>> - Zero range from part of block B to D. It will allocate an =
unwritten
>>>   extent from B to D.
>>> - The write back worker write block B and initialize the unwritten
>>>   extent from B to D, and then update the i_disksize to B.
>>> - System crash.
>>> - Remount and fsck complain about the extent size exceeds the inode
>>>   size.
>>>=20
>>> This patch add checking i_disksize and chose the small one between
>>> i_size to make sure it's safe to convert extent to initialized.
>>>=20
>>> ---------------------
>>>=20
>>> This problem can reproduce by xfstests generic/482 with fsstress =
seed
>>> 1544025012.
>>=20
>> Hmm, your explanation is great and the patch makes sense.  I haven't
>> been able to reproduce the problem by adding -s 1544025012 to the
>> fsstress arguments.  This may be because fsstress being run with two
>> processes (-p 2) and the failure may be timing dependent?
>>=20
> Yes, it is timing dependent and not quite easy to make a simple fast =
reproducer.
> The default parameter of fsstress (tested by generic/482) on my =
machine is:
>=20
> ./ltp/fsstress -w -d /mnt/scratch -n 512 -p 8 -s 1544025012 -v
>=20
>> How easily can you replicate the problem?
>=20
> It is about 2~5% probability to replicate this problem under =
generic/482 on my
> machine, and it can also appear in generic/019 and generic/455.
>=20
> After reproducing and checking this problem again, I think the above =
explanation
> is not accurate. I simplify the running process in generic/482 and the =
real case
> could be:
>=20
> - Create an empty file and buffer write from block A to D (with delay =
allocate).
> - Buffer write from X to Z, now the i_size of this inode is updated to =
Z.
> - Zero range from part of block B to D, it will allocate an unwritten =
extent
>   from B to D. Note that it also will skip disksize update in
>   ext4_zero_range() -> ext4_update_disksize_before_punch() because the =
i_size
>   is large than the end of this zero range.
> - The write back kworker write block B and initialize the whole =
unwritten
>   extent from B to D, and then update the i_disksize to the end of B.

On a related note, should this just refuse to allocate uninitialized =
extents
for regions that are smaller than the threshold that they would =
immediately
be expanded into initialized extents on when they are modified?  This =
would
avoid churn in the extent tree at the expense of (potentially) a few =
extra
zero blocks written to disk.

Cheers, Andreas






--Apple-Mail=_9A2FDFC8-54C2-4692-85DC-58DDAC7B6B18
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlwOyQoACgkQcqXauRfM
H+BNcRAAgYnKYxnlF9PPpsDO66A02QiIXrcbal/E9QDB2zZsH7ha4uHKZazgGc95
SXrzPrVR0kv5bIvGM4gVvTVQE6DU8LLcgEW/8GiGGtsxYWHKRAx01JJjammiyfdg
xXpTyfZpS9ic6zjE3YZumCQeVU334Z1Dx1IukW1BOmkAs4wjOP5BmVNmvCP1fipq
3Ni29/QCRV64e5+Il8FupVc5Q6cmkM82/ppJdNemamyuUB7ubVpHEFfFNR1kjkQr
dmhwdgyx9Bx8O9EPi1K4DN6sFlMQWgdBEyasrVXuPrYWgSp4C+XErK386QzGev9/
Tn8f0ooE+Qk9Wm5kceK0wpNSJwofkMuYfNjikNmZ8YtE6/QvPHTrOwtNJTNlmCTM
Uz3TZ/2zmz2VIlv/ik39iIwSKvZ59z5VEvH/jrV6K/8O4jAPsDuJ96r7xmO0Nywg
WJEXqP7U3q0IYKYSA8HvC4VEuOoz2rMpzZGFoiTpkrW6jkt6cODTjulGK2j0oVDF
tmy9SkO/IJn7whu9vRC8m5mZ6lHyDzpBdrAPltdsI6tFW6O/07lgImrDdKbExuFN
qHhSuZoxGL2nR5klBrqSJa0d1ySsV1WGFO2ii8i/O3YLLsk3E5awFgYNyR3ejq8Q
Wp3axxhdBjpyg0ErgAY9B/7Q7rREXeuh60VW12Faflx62w8M8/w=
=4dQv
-----END PGP SIGNATURE-----

--Apple-Mail=_9A2FDFC8-54C2-4692-85DC-58DDAC7B6B18--
