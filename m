From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: ext2/4 large inode xattr mismash?
Date: Tue, 28 Feb 2017 17:53:32 -0700
Message-ID: <BE5EA526-2AEB-490F-A579-D25292DEE755@dilger.ca>
References: <20170227181056.GA5266@birch.djwong.org>
 <B757EF06-0644-4596-B02E-E9E39142DD77@dilger.ca>
 <3cfeb410-b45a-f4d6-a338-d035a4fb0b65@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_985C070A-1389-43FD-911C-C4C3B247CB07";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>
To: Kaho Ng <ngkaho1234@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:36430 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751618AbdCAAzZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Feb 2017 19:55:25 -0500
Received: by mail-it0-f67.google.com with SMTP id w185so3384509ita.3
        for <linux-ext4@vger.kernel.org>; Tue, 28 Feb 2017 16:53:37 -0800 (PST)
In-Reply-To: <3cfeb410-b45a-f4d6-a338-d035a4fb0b65@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_985C070A-1389-43FD-911C-C4C3B247CB07
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Feb 28, 2017, at 10:49 AM, Kaho Ng <ngkaho1234@gmail.com> wrote:
>=20
> On 02/28/2017 06:42 AM, Andreas Dilger wrote:
>> On Feb 27, 2017, at 11:10 AM, Darrick J. Wong =
<darrick.wong@oracle.com> wrote:
>>>=20
>>> Hi Ted,
>>>=20
>>> Today ngkaho1234 pointed out on IRC that if you do the following:
>>>=20
>>> $ mkfs.ext2 /dev/sda -F
>>> $ mount /dev/sda /mnt -t ext4
>>> $ touch /mnt/x
>>> $ setfattr -n user.name1 -v moo /mnt/x
>>> $ umount /mnt
>>> $ mount /dev/sda /mnt -t ext2
>>> $ setfattr -n user.name1 -v urk /mnt/x
>>> $ umount /mnt
>>>=20
>>> Then you get this broken looking result:
>>> $ mount /dev/sda /mnt -e ext4
>>> $ getfattr /mnt/x
>>> getfattr: Removing leading '/' from absolute path names
>>> # file: mnt/x
>>> user.name1
>>> user.name1
>>>=20
>>> Looking through debugfs, it seems that ext4 wrote user.name1=3Dmoo =
as an
>>> ibody xattr, then ext2 wrote user.name1=3Durk into an external xattr =
block
>>> and set i_file_acl.  ext4 sees the attr it wrote, ext2 sees the attr =
it
>>> wrote, and neither can see the attr the other wrote.
>>>=20
>>> $ debugfs -R 'features' /dev/sda
>>> Filesystem features: ext_attr resize_inode dir_index filetype =
sparse_super large_file
>>>=20
>>> $ debugfs -R 'stat /x' /dev/sda
>>> Inode: 12   Type: regular    Mode:  0644   Flags: 0x0
>>> Generation: 2341792653    Version: 0x00000000:00000001
>>> User:     0   Group:     0   Project:     0   Size: 0
>>> File ACL: 617    Directory ACL: 0
>>> Links: 1   Blockcount: 8
>>> Fragment:  Address: 0    Number: 0    Size: 0
>>> ctime: 0x58b45e2b:926e39a8 -- Mon Feb 27 09:13:15 2017
>>> atime: 0x58b45e21:c4f666c0 -- Mon Feb 27 09:13:05 2017
>>> mtime: 0x58b45e21:c4f666c0 -- Mon Feb 27 09:13:05 2017
>>> crtime: 0x58b45e21:c4f666c0 -- Mon Feb 27 09:13:05 2017
>>> Size of extra inode fields: 32
>>> Extended attributes:
>>> user.name1 (3) =3D "moo"
>>> user.name1 (3) =3D "urk"
>>> BLOCKS:
>>>=20
>>> This is wrong -- we don't have RO_COMPAT_EXTRA_ISIZE set, so ext4 =
should
>>> /not/ be setting i_extra_isize=3D32.  Unfortunately, it does set
>>> i_extra_isize, which enables ext4_xattr_ibody_set to write xattrs =
into
>>> the inode body.  That's a problem, because ext2 doesn't know about
>>> inline attrs or i_extra_isize.
>>=20
>> I suspect that this isn't a big problem in real life, since most =
systems
>> these days are using ext4 to mount ext2 filesystems, instead of using =
the
>> separate ext2 module, and it could understand the extra data anyway.
>>=20
>> The thing to check/fix in the ext4 code is to not set i_extra_isize =
if the
>> EXTRA_ISIZE feature isn't set.  Also, e2fsck should set the feature =
flag
>> if it finds valid extra inode data beyond 128 bytes, since this is =
already
>> true out in the wild, so we don't want to clobber existing (meta)data =
in
>> large inodes.
>>=20
>> Unfortunately, our policy is to not enable features in-kernel =
automatically,
>> to avoid the problem of potentially making the filesystem =
unmountable,
>> otherwise we could do the same in ext4.  That said, e2fsck will =
prompt the
>> user to fix this if needed.
>>=20
>>> It occurred to me to check the s_inode_size, which is 256 on this
>>> supposedly ext2 filesystem.  I'd have thought _fill_super would =
check
>>> this value, but apparently its only criteria are that s_inode_size =
is at
>>> least 128, a power of 2, and no larger than a block.  But AFAIK ext2 =
has
>>> no ability to use any inode space beyond the first 128 bytes, so =
what
>>> good are large inodes?
>>=20
>> I don't think the 256-byte inode size should be considered a problem =
on
>> ext2 by itself.  The old code understands the larger inode size, it =
just
>> didn't do anything with that larger size until ext3 had fast xattrs =
and
>> the added timestamp fields.  The other thought is to just get rid of =
the
>> ext2 code completely, and the problem would be gone...  I don't think
>> there are (m)any cases where ext2 is faster than ext4, if nojournal
>> is used to level the playing field.
>>=20
>>> Oh, and e2fsck apparently doesn't notice if there are inodes with
>>> i_extra_isize set even if ro_compat_extra_isize is not set.
>>>=20
>>> I could see a bunch of fixes to resolve this problem:
>>>=20
>>> 1) Teach ext4 not to set i_extra_isize unless the feature bit is =
set.
>>> 2) ext2_iget grows the ability to return -EFSCORRUPTED for inodes =
that
>>>  have big inodes and i_extra_isize set, to encourage people to run
>>>  e2fsck.
>>=20
>> No, it shouldn't be accessing that space if the feature flag isn't =
set,
>> and should return an error at mount if it is (if not read-only).  =
That
>> is the reason the EXTRA_ISIZE was created as a read-only feature, so
>> that ext2 can't add xattrs or change the extended timestamps that =
conflict
>> with values in the large inode.
>>=20
>>> 3) e2fsck will move attrs and zap i_extra_isize if i_extra_isize is =
set
>>>  on a filesystem that doesn't support it.
>>=20
>> Wouldn't it be better to set the feature flag rather than deleting =
the
>> xattrs (which may not fit into the xattr block and/or may consume the
>> free space of the filesystem, and at a minimum will hurt =
performance)?
>>=20
>>> 4) mke2fs probably should stop allocating 256 byte inodes with the =
ext2
>>>  and ext3 profiles, though it's not clear to me why the ext2 driver
>>>  even allows this -- maybe there's some context here I don't know?
>>=20
>> Well, this in itself isn't harmful, and allows those filesystems to =
be
>> updated to ext4 easily in the future.  I think the root of the =
problem
>> is that ext4 is enabling a feature without checking the feature flag.
>>=20
>>> So ... /me isn't sure how to deal with this.  List? :)
>>>=20
>>> --D
>>=20
>>=20
>> Cheers, Andreas
>>=20
>>=20
>>=20
>>=20
>>=20
>=20
> I think making use of ext2_feature_set_ok() may be another solution. =
Since ext3.ko doesn't make use of RO_COMPAT_EXTRA_ISIZE either, but =
still will try to access beyond the first 128 bytes of inode to support =
fast EA if possible, ext2_feature_set_ok() may sounds like a good =
candidate to help differentiate ext2 fs from ext3/ext4 fs.

I guess the first question is how this problem became visible in the =
first
place?  Was the filesystem formatted with mkfs.ext2 and then mounted =
with
ext4, and then mounted on an embedded system with the ext2 driver =
(presumably
to reduce kernel memory usage, at the expense of performance from using =
ext4)?

Alternately, it could have been an upgrade/downgrade problem?  What =
kernels
and distros are involved?  All recent RHEL/SLES kernels are using the =
ext4
driver to load ext2 filesystems, so in that case the fix would be =
relatively
straight forward.  If the "real" ext2 driver is in use this becomes =
tricky.

If the ext4 driver is in use for ext2, all that is needed is to set the
EXTRA_ISIZE flag (a fixed e2fsck or manually) and the next mount will =
just use
ext4 since this is not in the EXT[23]_FEATURE_RO_COMPAT_SUPP mask.  I =
agree
if the inode is large and has fast xattrs (i_extra_isize=3D4) then it is =
an ext3
filesystem instead of ext2, regardless of whether the EXTRA_ISIZE flag =
is set.

Separately, e2fsck needs to be fixed to check for duplicate xattr names =
in
the in-inode xattr space and the external block.

Cheers, Andreas






--Apple-Mail=_985C070A-1389-43FD-911C-C4C3B247CB07
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFYthuMpIg59Q01vtYRArSjAKCXytfJZyZL5qClpDi8mEw8lqU8QwCg5ro3
lT9L+AFevciFe6JXlFiDTMs=
=qU6w
-----END PGP SIGNATURE-----

--Apple-Mail=_985C070A-1389-43FD-911C-C4C3B247CB07--
