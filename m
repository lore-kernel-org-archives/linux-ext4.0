From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: e2fsck: set dir_nlink feature if large dir exists
Date: Wed, 30 Aug 2017 01:43:30 -0600
Message-ID: <604C57FC-C3A6-478F-BDA6-E8550555C70F@dilger.ca>
References: <1503080382-37376-1-git-send-email-adilger@dilger.ca>
 <20170830022000.b7mgzksytvcwirx5@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_924DAB50-016B-46DF-801E-4349059A839C";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:33105 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751298AbdH3Hni (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Aug 2017 03:43:38 -0400
Received: by mail-io0-f194.google.com with SMTP id s101so531385ioe.0
        for <linux-ext4@vger.kernel.org>; Wed, 30 Aug 2017 00:43:37 -0700 (PDT)
In-Reply-To: <20170830022000.b7mgzksytvcwirx5@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_924DAB50-016B-46DF-801E-4349059A839C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Aug 29, 2017, at 8:20 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>=20
> On Fri, Aug 18, 2017 at 12:19:42PM -0600, Andreas Dilger wrote:
>> If there is a directory with more than EXT2_LINK_MAX (65000)
>> subdirectories, but the DIR_NLINK feature is not set in the
>> superblock, the feature should be set before continuing on
>> to change the on-disk directory link count to 1.
>>=20
>> While most filesystems should have DIR_NLINK set (it was set
>> by default for all ext4 filesystems, and the kernel before
>> 4.12 automatically set it if the directory link count grew
>> too large), it is possible that this flag is lost due to disk
>> corruption or for an upgraded filesystem.  We no longer want
>> the kernel to automatically enable this feature.
>>=20
>> Addresses: https://bugzilla.kernel.org/show_bug.cgi?id=3D196405
>> Signed-off-by: Andreas Dilger <adilger@dilger.ca>
>=20
> The f_large_dir test is now failing after I apply this patch:
>=20
> debugfs 1.43.6 (29-Aug-2017)
> ./test_one: 38: =
/usr/projects/e2fsprogs/e2fsprogs/tests/f_large_dir/script: arithmetic =
expression: division by zero: "i / ELAPSED"
> f_large_dir: optimize 3 level htree directories: failed

You must have a faster test system than I do...

I can send an updated patch with a fix for this, as well as the
improvement for expand_dir as previously discussed.

On a related note, I was trying to implement the optimization for
more efficient ext2fs_link() insertion, but this has proven to be
much more complex than I expected.  I was thinking I would just
call the link_proc() function directly to handle insertion of the
new name, using block number of the previous caller.  However, this
function depends on the directory leaf buffers having been read
from disk, and being passed a dirent pointer to the free space after
being called through a series of callback indirections.

I thought it would be a bit cleaner to call ext2fs_process_dir_block()
(despite the warning that this function is for internal use only)
with the previously saved block numbers, but that also depends on
the dir_context state being initialzed, which didn't seem very clean.

Am I doing down the wrong road here?

Cheers, Andreas






--Apple-Mail=_924DAB50-016B-46DF-801E-4349059A839C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZpmykpIg59Q01vtYRAjqkAJ4uPwMKR3Ol5srBHs52pfFucNYbgwCcDqKC
HX1cJoTTbcCTpuq8u+KTn5M=
=QO3o
-----END PGP SIGNATURE-----

--Apple-Mail=_924DAB50-016B-46DF-801E-4349059A839C--
