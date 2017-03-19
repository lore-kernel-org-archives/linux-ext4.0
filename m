From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] Add largedir feature
Date: Sat, 18 Mar 2017 23:38:38 -0600
Message-ID: <175204AC-DBDD-4894-8944-BBD98388F547@dilger.ca>
References: <1489657877-34478-1-git-send-email-artem.blagodarenko@seagate.com>
 <CE3A3FB1-8DE6-476A-8386-94D590B17A23@dilger.ca>
 <E3BFD2D7-CCEF-4A10-A4E6-ED634C56436F@gmail.com>
 <07B442BA-D335-4079-8691-0AB1FAD7368F@dilger.ca>
 <18FAA61C-DE3C-42C7-A8A4-BB2CDD3C5D24@gmail.com>
 <20170318162953.ubn3lvglxqq6ux2e@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_4A080790-C333-4A45-83BF-62B1AA9C29B6";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Alexey Lyashkov <alexey.lyashkov@gmail.com>,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Yang Sheng <yang.sheng@intel.com>,
        Zhen Liang <liang.zhen@intel.com>,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:35106 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751186AbdCSFjF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Mar 2017 01:39:05 -0400
Received: by mail-it0-f65.google.com with SMTP id y18so11364446itc.2
        for <linux-ext4@vger.kernel.org>; Sat, 18 Mar 2017 22:38:45 -0700 (PDT)
In-Reply-To: <20170318162953.ubn3lvglxqq6ux2e@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_4A080790-C333-4A45-83BF-62B1AA9C29B6
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

On Mar 18, 2017, at 10:29 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>=20
> On Sat, Mar 18, 2017 at 11:16:26AM +0300, Alexey Lyashkov wrote:
>> Andreas,
>>=20
>> it not about a feature flag. It=E2=80=99s about a situation in whole.
>> Yes, we may increase a directory size, but it open a number a large =
problems.
>=20
>> 1) readdir. It tries to read all entries in memory before send to
>> the user. currently it may eats 20*10^6 * 256 so several gigs, so
>> increasing it size may produce a problems for a system.
>=20
> That's not true.  We normally only read in one block a time.  If there
> is a hash collision, then we may need to insert into the rbtree in a
> subsequent block's worth of dentries to make sure we have all of the
> directory entries corresponding to a particular hash value.  I think
> you misunderstood the code.
>=20
>> 2) inode allocation. Current code tries to allocate an inode as near =
as possible to the directory inode, but one GD may hold 32k entries =
only, so increase a directory size will use up 1k GD for now and more =
than it, after it. It increase a seek time with file allocation. It was =
i mean when say - =C2=ABdramatically decrease a file creation rate=C2=BB.
>=20
> But there are also only 32k blocks in a group descriptor, and we try
> to keep the blocks allocated close to the inode.  So if you are using
> a huge directory, and you are using a storage device with a
> significant seek penalty, then yes, no matter what as the directory
> grows, the time to iterate over all of the files does grow.  But there
> is more to life than microbenchmarks which creates huge numbers of =
zero
> length files!  If we assume that the files are going to need to
> contain _data_, and the data blocks should be close to the inodes,
> then there are going to be some performance impacts no matter what.

Actually, on a Lustre MDT there _are_ only zero-length files, since all
of the data is stored in another filesystem.  Fortunately, the parent
directory stores the last group successfully used for allocation
(i_alloc_group) so that new inode allocation doesn't have to scan the
whole filesystem each time from the parent's group.

>> 3) current limit with 4G inodes - currently 32-128 directories may =
eats a full inode number space. =46rom it perspective large dir don=E2=80=99=
t need to be used.
>=20
> I can imagine a new feature flag which defines the use a 64-bit inode
> number, but that's more for people who are creating a file system that
> takes advantage of 64-bit block numbers, and they are intending on
> using all of that space to store small (< 4k or < 8k) files.

The 4-billion inode limit is somewhat independent of large directories.
That said, the DIRDATA feature that is used for Lustre is also designed
to allow storing the high 32 bits of the inode number in the directory.
This would allow compatible upgrade of a directory to storing both
32-bit and 64-bit inode numbers without the need for wholescale =
conversion
of directories, or having space for 64-bit inode numbers even if most
of the inodes are only 32-bit values.


Cheers, Andreas






--Apple-Mail=_4A080790-C333-4A45-83BF-62B1AA9C29B6
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFYzhlgpIg59Q01vtYRAr2OAJ4riHhlYOQNLAYZb1ztFHblvctpyACgxNLP
3JNaDV4mhOVF55U2AX9cXHs=
=28xt
-----END PGP SIGNATURE-----

--Apple-Mail=_4A080790-C333-4A45-83BF-62B1AA9C29B6--
