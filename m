From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: error should be cleared if ea_inode isn't added to
 the cache
Date: Wed, 12 Jul 2017 22:17:58 -0700
Message-ID: <B1CD93E6-0D69-4837-BC0F-8548A5E8473A@dilger.ca>
References: <1499831813-13218-1-git-send-email-emoly.liu@intel.com>
 <CAAeU0aP-v4YZN05MH=gREEpE2AORUmHSqUKkxuOQ43BvWD268g@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_A624D9C8-7728-40F0-A6EA-5E1AB91AE6CC";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Emoly Liu <emoly.liu@intel.com>, Theodore Ts'o <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:32797 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750748AbdGMFR6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Jul 2017 01:17:58 -0400
Received: by mail-pg0-f67.google.com with SMTP id u62so5572803pgb.0
        for <linux-ext4@vger.kernel.org>; Wed, 12 Jul 2017 22:17:57 -0700 (PDT)
In-Reply-To: <CAAeU0aP-v4YZN05MH=gREEpE2AORUmHSqUKkxuOQ43BvWD268g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_A624D9C8-7728-40F0-A6EA-5E1AB91AE6CC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jul 11, 2017, at 9:37 PM, Tahsin Erdogan <tahsin@google.com> wrote:
>=20
> Reviewed-by: tahsin@google.com
>=20
> On Tue, Jul 11, 2017 at 8:56 PM, Emoly Liu <emoly.liu@intel.com> =
wrote:
>> For Lustre, if ea_inode fails in hash validation but passes parent
>> inode and generation checks, it won't be added to the cache as well
>> as the error "-EFSCORRUPTED" should be cleared, otherwise it will
>> cause "Structure needs cleaning" when running getfattr command.
>>=20
>> Signed-off-by: Emoly Liu <emoly.liu@intel.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

This could also include:

  Fixes: dec214d00e0d78a08b947d7dccdfdb84407a9f4d

unless this fix is merged into the original patch.

>> Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-9723
>> ---
>> fs/ext4/xattr.c | 1 +
>> 1 file changed, 1 insertion(+)
>>=20
>> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
>> index cff4f41..de217a0 100644
>> --- a/fs/ext4/xattr.c
>> +++ b/fs/ext4/xattr.c
>> @@ -451,6 +451,7 @@ static int ext4_xattr_inode_iget(struct inode =
*parent, unsigned long ea_ino,
>>                }
>>                /* Do not add ea_inode to the cache. */
>>                ea_inode_cache =3D NULL;
>> +               err =3D 0;
>>        } else if (err)
>>                goto out;




Cheers, Andreas






--Apple-Mail=_A624D9C8-7728-40F0-A6EA-5E1AB91AE6CC
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZZwKHpIg59Q01vtYRAqajAKCIV+ssfJiqD8oVYws5B7Ak3WQgbQCfY0no
OGItZoXV5vYtktVvZaogJBo=
=1Zb7
-----END PGP SIGNATURE-----

--Apple-Mail=_A624D9C8-7728-40F0-A6EA-5E1AB91AE6CC--
