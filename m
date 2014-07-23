From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 0/5] ext4: RFC: Encryption
Date: Wed, 23 Jul 2014 16:39:43 -0600
Message-ID: <7C8F8758-DE9E-46D3-AB30-236EB20F8A4B@dilger.ca>
References: <1406150608-19351-1-git-send-email-mhalcrow@google.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_A26C5EA1-035C-4086-938C-EE0A052BFE8E"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	zohar@linux.vnet.ibm.com, herbert@gondor.apana.org.au,
	pavel@ucw.cz, hch@infradead.org, lczerner@redhat.com,
	tytso@mit.edu, tyhicks@canonical.com, serge.hallyn@canonical.com
To: Michael Halcrow <mhalcrow@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:38828 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933635AbaGWWj4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jul 2014 18:39:56 -0400
Received: by mail-pa0-f53.google.com with SMTP id kq14so2540533pab.26
        for <linux-ext4@vger.kernel.org>; Wed, 23 Jul 2014 15:39:56 -0700 (PDT)
In-Reply-To: <1406150608-19351-1-git-send-email-mhalcrow@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_A26C5EA1-035C-4086-938C-EE0A052BFE8E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jul 23, 2014, at 3:23 PM, Michael Halcrow <mhalcrow@google.com> =
wrote:
> This patchset proposes a method for encrypting in EXT4 data read and
> write paths. It's a proof-of-concept/prototype only right now.

Maybe it is worthwhile to take a step back and explain what your overall
goal is?  What is the benefit of implementing crypto at the filesystem
level over at the block device level?  Are you targeting per-user crypto
keys?  Fast secure deletion of files by having per-inode keys that are
encrypted by the filesystem/user key and then clobbered at deletion =
time?

What is the threat model?  Without knowing that, there isn't any point
in designing or implementing anything.

Hopefully you are already aware of the ext4 metadata checksum feature =
that
is in newer kernels?  That might be useful for storing your strong =
crypto
integrity hashes for filesystem metadata.

We've also previously discussed storing file-data checksums in some =
form.
One of the leading candidates being either a per-block table of =
checksums
that are statically mapped either for every block in the filesystem, or
only to the "data" blocks of the filesystem (i.e. those that don't =
contain
fixed metadata that already has its own checksums such as inode tables,
bitmaps, and backup group descriptors/superblocks).  The other =
possibility
is storing checksums with each extent, with the option to make the =
extents
as small or large as needed.  See thread starting at:
http://www.spinics.net/lists/linux-ext4/msg42620.html

Once we understand what the actual security goals and threat model are,
then it will be easier to determine the best way to implement this.

Cheers, Andreas

> Outstanding issues:
>=20
> * While it seems to work well with complex tasks like a parallel
>   kernel build, fsx is pretty good at reliably breaking it in its
>   current form. I think it's trying to decrypt a page of all zeros
>   when doing a mmap'd write after an falloc. I want to get feedback
>   on the overall approach before I spend too much time bug-hunting.
>=20
> * It has not undergone a security audit/review. It isn't IND-CCA2
>   secure, and that's the goal. We need a way to store (at least)
>   page-granular metadata.
>=20
> * Only the file data is encrypted. I'd like to look into also
>   encrypting the file system metadata with a mount-wide key. That's
>   for another phase of development.
>=20
> * The key management isn't fleshed out. I've hacked in some eCryptfs
>   stuff because it was the fastest way for me to stand up the
>   prototype with real crypto keys. Use ecryptfs-add-passphrase to add
>   a key to the keyring, and then pass the hex sig as the
>   encrypt_key_sig mount option:
>=20
> # apt-get install ecryptfs-utils
> # echo -n "hunter2" | ecryptfs-add-passphrase=20
> Passphrase:=20
> Inserted auth tok with sig [4cb927ea0c564410] into the user session =
keyring
> # mount -o encrypt_key_sig=3D4cb927ea0c564410 /dev/sdb1 /mnt/ext4crypt
>=20
> * The EXT4 block size must be the same as the page size. I'm not yet
>   sure whether I will want to try to support block-granular
>   encryption or page-granular encryption. There are implications with
>   respect to how much the integrity data occupies in relation to the
>   encrypted data.
>=20
> Mimi, maybe an approach like this one will work out for IMA. We've
> just got to figure out where to store the block- or page-granular
> integrity data.
>=20
> I've broken up the patches so that not only can each one build after
> application, but discrete steps of functionality can be tested one
> patch at a time.
>=20
> A couple of other thoughts:
>=20
> * Maybe the write submit path can complete on the encryption
>   callback. Not sure what that might buy us.
>=20
> * Maybe a key with a specific descriptor in each user's keyring
>   (e.g. "EXT4_DEFAULT_KEY") can be used when creating new files so
>   that each user can use his own key in a common EXT4 mount. Or maybe
>   we can specify an encryption context in the parent directory xattr.
>=20
> Michael Halcrow (5):
>  ext4: Adds callback support for bio read completion
>  ext4: Adds EXT4 encryption facilities
>  ext4: Implements the EXT4 encryption write path
>  ext4: Adds EXT4 encryption read callback support
>  ext4: Implements real encryption in the EXT4 write and read paths
>=20
> fs/buffer.c                 |  46 +++-
> fs/ext4/Makefile            |   9 +-
> fs/ext4/crypto.c            | 629 =
++++++++++++++++++++++++++++++++++++++++++++
> fs/ext4/ext4.h              |  50 ++++
> fs/ext4/file.c              |   9 +-
> fs/ext4/inode.c             | 196 +++++++++++++-
> fs/ext4/namei.c             |   3 +
> fs/ext4/page-io.c           | 182 ++++++++++---
> fs/ext4/super.c             |  34 ++-
> fs/ext4/xattr.h             |   1 +
> include/linux/bio.h         |   3 +
> include/linux/blk_types.h   |   4 +
> include/linux/buffer_head.h |   8 +
> 13 files changed, 1118 insertions(+), 56 deletions(-)
> create mode 100644 fs/ext4/crypto.c
>=20
> --=20
> 2.0.0.526.g5318336
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_A26C5EA1-035C-4086-938C-EE0A052BFE8E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU9A5r3Kl2rkXzB/gAQKQ8w//ZZaMc0DkZ1a7zL54HefC7voHF7is9rxv
93ThTjlWhapFwEfnI4Vr3IjIeirXF+aA15q0jxYL4qWURKGkJe+tDmRO8+WhOi4b
1B92meJuc7sb65GPoijk7JXo1e//Zc4qNlSSORAMK5Drf/WS7Mr3L2f4GvMgqiEy
X1qTsKBf+/kbRk8pdHm9ayyu0Fz/HwTke4ASG3gQGbTnj8CRRYDd3fC+/OiHkzj0
xKf8NIPR9V7bI4QEkUpE4GFNKQlUrnhtjQAIiSENidL1SmrD2KpiGuo4imzYmWAY
FYesdq0Vw5uHH6G16vUA56AIYSeDLCC0to+15zdQUiHi1KOPbDNKxo7/Jdku9Bvq
vwx/YG95j4RZu1qJ1s+O4Yl3iTOL4W3luv+4eItsKn/R++O+lC7uzWZ4E3tfPvrX
1+rrtIA1Gfq46wQjqFa3xaumZZvJM0iMcyXu94XCx/ZFnMu+Rn70b8hST4Z96Ryc
Bs7lBYBzxHhfz3mjK8Xx8w3tUo1177CEtHHdrlcoF9vjsFiMxKyHQaUwDsnQFvP4
aIiLqIWal36oWhAUElNnZkyxaJyBZ01y/BYKAeZIy4iWjnZzHkeneXMkYdm2fVWN
hhDu9JT84dN0d7tAwDFPjjZmQNnST4kHm58lzIIXHBuca63hWRHn4NdBtjwFPsM6
WxPltz7urWE=
=ibI5
-----END PGP SIGNATURE-----

--Apple-Mail=_A26C5EA1-035C-4086-938C-EE0A052BFE8E--
