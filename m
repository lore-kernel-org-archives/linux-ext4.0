From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] test-appliance: add new test configuration:
 ext4/lustre_mds
Date: Fri, 23 Jun 2017 16:00:05 -0600
Message-ID: <3625058A-4B6D-4C28-B231-61DFED33F0B4@dilger.ca>
References: <20170609035943.26447-1-tytso@mit.edu>
 <CAO3qy=EVQtVVe2hvEvaYOTyArPpK7U6AYA9abu6Zum-p_sWqpg@mail.gmail.com>
 <20170609175910.shwqocbi3npfmoid@thunk.org>
 <087C00FA-AF13-498F-8D6A-B67A115D8DCE@dilger.ca>
 <20170623214109.3kwtxj3owi4noxda@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_72398421-2C57-4F7D-B9F9-ADD6CB9867C9";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Artem Blagodarenko <artem.blagodarenko@seagate.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:36124 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753306AbdFWWAK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Jun 2017 18:00:10 -0400
Received: by mail-it0-f66.google.com with SMTP id 185so8445282itv.3
        for <linux-ext4@vger.kernel.org>; Fri, 23 Jun 2017 15:00:10 -0700 (PDT)
In-Reply-To: <20170623214109.3kwtxj3owi4noxda@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_72398421-2C57-4F7D-B9F9-ADD6CB9867C9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 23, 2017, at 3:41 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>=20
> On Fri, Jun 09, 2017 at 03:00:56PM -0600, Andreas Dilger wrote:
>>=20
>> I didn't include large_dir because it isn't included in the upstream
>> kernels yet, and we haven't been using this in production due to lack
>> of e2fsck support (which Seagate has finally implemented, thank you).
>=20
> Also, does Lustre use large_dir on the MDS server, or on the Lustre
> data server?  Because I noticed that on the MDS server you're
> apparently not using extents:
>=20
> export EXT_MKFS_OPTIONS=3D"-I 2048 -O =
^64bit,mmp,uninit_bg,^extents,dir_nlink,...
>                                                          ^^^^^^^^
> Are you really using large_dir on a file system that is using indirect
> block mapped files?

Like I wrote above, we haven't been using large_dir in production yet.
My plan was only to use it on the MDT, which is where the filesystem
namespace is located.  Indeed, we don't use extents on the MDT because:
a) ext4 MDTs are strictly less than 16TB in size (usually < 8TB, even =
with
   4B inodes) because of using "-I 2048" to limit the space per inode,
   so they never need more than 2^32 blocks
b) the only files of any size on the MDT are directories or other log
   files, which are rarely created with contiguous block allocations,
   so extents usually take more space than indirect blocks (12 bytes vs =
4).


I think Seagate was also considering it on their huge OSTs (which always
have extents enabled) since they may have large numbers of objects that
are currently referenced by a limited number of directories (32 =
currently).

I think the OST case would be better handled by creating multiple object
subdirectories[*], since the internal object directory layout is not
externally visible.  If the objects are grouped temporally into =
directories,
then they avoid consuming RAM when they are no longer actively in use, =
and
empty directories can be shrunk or deleted over time when they are =
empty.

This in turn would make it desirable to implement online directory =
shrinking
as has been discussed many times in the past, but even "e2fsck -fD" =
would
be able to shrink the old object directories offline as they become =
empty,
rather than a huge directory that has completely random leaf block =
access.

Cheers, Andreas

[*] based on the FID sequence number like with DNE




--Apple-Mail=_72398421-2C57-4F7D-B9F9-ADD6CB9867C9
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZTY9lpIg59Q01vtYRAtRzAJ0dbA56swaFjLndE9GLF+YaETsLeQCgk72B
Jn3ZOXwmkBlrPoX2/WeB5SA=
=Tqrz
-----END PGP SIGNATURE-----

--Apple-Mail=_72398421-2C57-4F7D-B9F9-ADD6CB9867C9--
