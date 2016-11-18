From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: fix reading new encrypted symlinks on no-journal filesystems
Date: Fri, 18 Nov 2016 14:52:22 -0700
Message-ID: <75C88E0E-FF89-4D20-B11C-8F705E249BDD@dilger.ca>
References: <1479318627-143193-1-git-send-email-ebiggers@google.com> <2FD4E662-B708-4C34-B1FC-8D42083322A2@dilger.ca> <20161118184704.GA73496@google.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_F40BB0CF-D86E-4D11-A587-A7862748B4FF"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33169 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752301AbcKRVwY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Nov 2016 16:52:24 -0500
Received: by mail-pf0-f196.google.com with SMTP id 144so14208038pfv.0
        for <linux-ext4@vger.kernel.org>; Fri, 18 Nov 2016 13:52:24 -0800 (PST)
In-Reply-To: <20161118184704.GA73496@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_F40BB0CF-D86E-4D11-A587-A7862748B4FF
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Nov 18, 2016, at 11:47 AM, Eric Biggers <ebiggers@google.com> =
wrote:
>=20
> On Thu, Nov 17, 2016 at 07:20:24PM -0700, Andreas Dilger wrote:
>> On Nov 16, 2016, at 10:50 AM, Eric Biggers <ebiggers@google.com> =
wrote:
>>>=20
>>> On a filesystem with no journal, a symlink longer than about 32
>>> characters (exact length depending on padding for encryption) could =
not
>>> be followed or read immediately after being created in an encrypted
>>> directory.  This happened because when the symlink data went through =
the
>>> delayed allocation path instead of the journaling path, the symlink =
was
>>> incorrectly detected as a "fast" symlink rather than a "slow" =
symlink
>>> until its data was written out.
>>=20
>> IMHO, this again exposes an issue that we've seen with "fast" vs. =
"slow"
>> symlink detection several times in the past whenever there is a data =
block
>> allocated for a fast symlink (e.g. when xattrs were allowed on =
symlinks).
>>=20
>> int ext4_inode_is_fast_symlink(struct inode *inode)
>> {
>>        int ea_blocks =3D EXT4_I(inode)->i_file_acl ?
>>                EXT4_CLUSTER_SIZE(inode->i_sb) >> 9 : 0;
>>=20
>>        if (ext4_has_inline_data(inode))
>>                return 0;
>>=20
>>        return (S_ISLNK(inode->i_mode) && inode->i_blocks - ea_blocks =
=3D=3D 0);
>> }
>>=20
>> Instead of depending on the i_blocks count to detect slow symlinks, =
we
>> should just check the i_size < EXT4_N_BLOCKS * 4 (or <=3D, need to =
verify).
>> I believe this has always been true for fast symlinks, so it should =
be
>> OK to make this change.  That will isolate us from future changes =
that
>> may add block allocations to symlinks.
>>=20
>=20
> Yes, this would be a much nicer way to detect fast symlinks.
>=20
> The only thing I'd be concerned about is the possibility of =
pre-existing
> "slow" symlinks that actually have targets short enough to be "fast"
> symlinks, perhaps in filesystems created by old drivers or by external
> tools.  If such links happened to work before, then a change to check
> i_size would break them.
>=20
> This may not be an issue in practice.  I checked some old ext4 =
versions,
> ext2 from Linux 0.99.7, e2fsprogs, Android's ext4_utils, and FreeBSD's
> ext2 driver.
> They all create "fast" symlinks if the length of the symlink target =
length
> excluding the terminating null (i_size) is < 60.

I did a similar analysis with similar results.


Cheers, Andreas






--Apple-Mail=_F40BB0CF-D86E-4D11-A587-A7862748B4FF
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWC94F3Kl2rkXzB/gAQiCew/9GYFIi3bUgjx+08nt7xEVrWY+zVK0x5tS
Gq7r08dTt8FCieiTfDdp2+ZKjlw8V0w3Vf2mHDhqO4EgXf1m27jivf/GfTN1HENY
VFT2gF9hJF1kP4bLlWiPDyJNzn+U1G+llg1uMW16v4VzIg/yajEzASCB6Skz84uj
TK96wcX8kYAgQvCpSrB/zIuLcx+pFCKU2qkEVfeMkBwcfcL8mV2CWAeb6gbXpV6h
BQoxHaDb17HXQcsvMKSZxfjqSQKg3oM+C2RUuAQElRiyNfUDSxowYmrTf9PImAPL
u0JvAF08ru1xdWkYTHqE+lGo7rpn58hsLh3lquHl9kDJ7ePqczNadq3AoctYBMyQ
spZNdC8uAPa5kKp/d6uRi5Ui73WkWisgxhKduycuqdsjsAZ47hDgUyC5VVYpNQVk
xRqQYm1cOWTmKI/BjP04S9RDZqBJ3ER2xqBrzjkpugUA0+O0qKJyqTDUrb6ORpo1
0LSSn3XwALZEW+A7KP9e70RnM2Lgs1kyvRUZvf2GoFUWv44/FuiieyIz3IZ5aje6
I/ee1XjqyTNTQKZcPp/O1t1K3GQe6+VI+LSGBhevExN3nTuPCDVqrsxEVTNOg08S
AWlrO6NaKNOMCmZPdh7nE/X9BdV6Sc8jJCWwYpn+2vUrIZPfvZstCD17Vx/blnSE
hihAdmC6gDQ=
=cZ4O
-----END PGP SIGNATURE-----

--Apple-Mail=_F40BB0CF-D86E-4D11-A587-A7862748B4FF--
