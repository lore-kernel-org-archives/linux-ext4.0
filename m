From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Y2038 bug in ext4 recently_deleted() function
Date: Fri, 18 Aug 2017 10:09:07 -0600
Message-ID: <AB3E8CB7-76CE-4F1D-B47C-57D63E56E6D7@dilger.ca>
References: <20170808050517.7160-1-wshilong@ddn.com>
 <20170816164211.GA31117@quack2.suse.cz>
 <3ED34739A4E85E4F894367D57617CDEFEDA401CE@LAX-EX-MB2.datadirect.datadirectnet.com>
 <20170817091959.GB7644@quack2.suse.cz>
 <20170817092153.GA14074@quack2.suse.cz>
 <BCA34CA8-FDDF-49FA-A5B4-9CCCEAC0C8D0@dilger.ca>
 <CABeXuvqtDdtjgjEznXPgdUfaZiG-KJ3AURpT_AuUACcPATaoDw@mail.gmail.com>
 <CAK8P3a2mu9SGdZhWX59OhSK-fokSEpjKsK4_HC1OC-XxZU8eTw@mail.gmail.com>
 <CABeXuvpHvyOq09JQW0XtrJ4fGZNBjmC=MBDRS2eKoVsmpi3g4Q@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_0351BD39-2D53-4966-82E7-5A808BCE8156";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Arnd Bergmann <arnd@arndb.de>, Theodore Ts'o <tytso@mit.edu>,
        Wang Shilong <wshilong@ddn.com>,
        Wang Shilong <wangshilong1991@gmail.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Shuichi Ihara <sihara@ddn.com>, Li Xi <lixi@ddn.com>,
        Jan Kara <jack@suse.cz>
To: Deepa Dinamani <deepa.kernel@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:38226 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750987AbdHRQJ3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Aug 2017 12:09:29 -0400
Received: by mail-io0-f180.google.com with SMTP id g71so34393508ioe.5
        for <linux-ext4@vger.kernel.org>; Fri, 18 Aug 2017 09:09:28 -0700 (PDT)
In-Reply-To: <CABeXuvpHvyOq09JQW0XtrJ4fGZNBjmC=MBDRS2eKoVsmpi3g4Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_0351BD39-2D53-4966-82E7-5A808BCE8156
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Aug 18, 2017, at 9:38 AM, Deepa Dinamani <deepa.kernel@gmail.com> =
wrote:
>=20
> On Fri, Aug 18, 2017 at 2:31 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Fri, Aug 18, 2017 at 3:23 AM, Deepa Dinamani =
<deepa.kernel@gmail.com> wrote:
>>>=20
>>>> One thing I did notice when looking at it is that there is a Y2038 =
bug in
>>>> recently_deleted(), as it is comparing 32-bit i_dtime directly with =
64-bit
>>>> get_seconds().
>>>=20
>>> I don't think dtime has widened on the disk layout for ext4 =
according
>>> to https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout. So I am
>>> not sure how fixing the internal implementation would be useful =
until
>>> we do that. Is there a plan for that?
>>>=20
>>> As far as get_seconds() is concerned, get_seconds() returns unsigned
>>> long which is 64 bits on a 64 bit arch and 32 bit on a 32 bit arch.
>>> Since dtime variable is declared as unsigned long in this function,
>>> same holds for the size of this variable.
>>>=20
>>> There is no y2038 problem on a 64 bit machine.
>>=20
>> I think what Andreas was saying is that it's actually the opposite:
>> on a 32-bit machine, the code will work correctly for 32-bit unsigned
>> long values as long as 'dtime' and 'now' are in the same epoch,
>> e.g. both are before 2106 or both are after.
>> On 64-bit systems it's always wrong after 2106.
>=20
> There is some confusion here.
> I was only referring to the current implementation:
>=20
> static int recently_deleted(struct super_block *sb, ext4_group_t =
group, int ino)
> {
> .
> .
> .
>   unsigned long dtime, now;
>   int offset, ret =3D 0, recentcy =3D RECENTCY_MIN;
> .
> .
> .
>    offset =3D (ino % inodes_per_block) * EXT4_INODE_SIZE(sb);
>    raw_inode =3D (struct ext4_inode *) (bh->b_data + offset);
>    dtime =3D le32_to_cpu(raw_inode->i_dtime);
>    now =3D get_seconds();
>    if (buffer_dirty(bh))
>    recentcy +=3D RECENTCY_DIRTY;
>=20
>    if (dtime && (dtime < now) && (now < dtime + recentcy))
>         ret =3D 1;
> .
> .
> .
> }
>=20
> In the above implementation, I do not see any problem on a 64 bit =
machine.
> The only problem is that dtime on disk representation is signed 32 =
bits only.
> If that were not a problem then this would be fine from time =
prespective.

The 32-bit dtime is the root of the problem.  There is no plan to extend
the dtime field on disk, because it is used so little (mostly as a =
boolean
value, and for forensics).

>>> So moving to the case of a 32 bit machine:
>>>=20
>>> get_seconds() can return values until year 2106. And, recentcy at =
max
>>> can only be 35. Analyzing the current line:
>>>=20
>>> if (dtime && (dtime < now) && (now < dtime + recentcy))
>>>=20
>>> The above equation should work fine at least until 35 seconds before
>>> y2038 deadline.
>>=20
>> Since it's all unsigned arithmetic, it should be fine until 2106.
>> However, we should get rid of get_seconds() long before then
>> and use ktime_get_real_seconds() instead, as most other users
>> of get_seconds() are (more) broken.
>=20
> Dtime on disk representation again breaks this for certain values in
> 2038 even though everything is unsigned.
>=20
> I was just saying that whatever we do here depends on how dtime on
> disk is interpreted.
>=20
> Agree that ktime_get_real_seconds() should be used here. But, the way
> we handle new values would rely on this new interpretation of dtime.
> Also, using time64_t variables on stack only matters after this. Once
> the types are corrected, maybe the comparison expression need not
> change at all (after new dtime interpretation is in place).

There will not be a new dtime format on disk, but since the calculation
here only depends on relative times (within a few minutes), then it =
would
be fine to use only 32-bit timestamps, and truncate off the high bits
from get_seconds()/ktime_get_real_seconds().

Cheers, Andreas






--Apple-Mail=_0351BD39-2D53-4966-82E7-5A808BCE8156
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZlxEnpIg59Q01vtYRAvCHAKCwwBVIbVO8QfWniUoCtXeUP9nDzwCePrak
lhSiPHQ1uZ+9F+qEesajkvY=
=/GD2
-----END PGP SIGNATURE-----

--Apple-Mail=_0351BD39-2D53-4966-82E7-5A808BCE8156--
