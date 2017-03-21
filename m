From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] Add largedir feature
Date: Tue, 21 Mar 2017 11:38:53 -0400
Message-ID: <0E38FE2B-4451-47B1-BBEA-CCD4D105B49C@dilger.ca>
References: <20170319133425.gxeg3mba3brvztjf@thunk.org>
 <2F91584E-6351-4523-9821-54AD6A7CD889@dilger.ca>
 <AC9DD60D-37A5-458B-AFA2-5EDDAAFD5E9E@gmail.com>
 <20170320142030.s2acios7q2qytzak@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_C150C7D8-15F5-4CFE-BC20-C867D10E0F1A";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Alexey Lyashkov <alexey.lyashkov@gmail.com>,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Yang Sheng <yang.sheng@intel.com>,
        Zhen Liang <liang.zhen@intel.com>,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:35503 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756711AbdCUPjI (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Mar 2017 11:39:08 -0400
Received: by mail-qk0-f193.google.com with SMTP id o135so22583619qke.2
        for <linux-ext4@vger.kernel.org>; Tue, 21 Mar 2017 08:39:07 -0700 (PDT)
In-Reply-To: <20170320142030.s2acios7q2qytzak@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_C150C7D8-15F5-4CFE-BC20-C867D10E0F1A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Mar 20, 2017, at 10:20 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>=20
> On Mon, Mar 20, 2017 at 02:34:31PM +0300, Alexey Lyashkov wrote:
>>=20
>> To make picture clean. OST side is regular FS with 32 directories =
where a stripe objects is live.  With current 4G inodes limit each =
directory will
>> filled with up 100k regular files.  Files allocated in batch, up to =
20k files per batch. Allocated object used on MDT side to make mapping =
between metadata objects and data for such file.
>>=20
>> I worry about it part, not about MDT. these directories have a large =
number creations/unlinks and performance degradation started after 3M-5M =
creations/unlinks.
>> With Large dir feature i think this performance problems may deeper.
>=20
> This makes no sense.  On the Object Store side, if the maximum
> directory size is 100k regular files, you're never going to run into
> two-levle htree limit, so the presense (or absense) of largedir is
> largely irrelevant.  So how can it make the performance problem worse?

I believe Alexey meant to write "100M" regular files (theoretically up =
to
32 dirs x 128M files to reach the ext4 4B inode limit).

I was thinking of the largedir code from the MDS side, where we have no
option but to have a single large directory that reflects what the user
created.  For Alexey's issue, the OST directories are instead just =
storing
a large sequentially-incremented integer as the filename in the =
directory.

This wasn't typically an issue in the past because the average Lustre
file size is large (e.g. 1-32MB) and in < 32TB OST filesystem this would
only be 1-32M files spread across 32 directories.  With the 400TB ext4
filesystems that Seagate is using this becomes an actual problem.

As Ted suggested earlier, there is a possibility to use a different hash
function (TEA hash?) that is better suited to be used on OSTs compared
to MDTs since the OST object filenames are mostly sequential integers.

The other option is to (also?) fix this at the Lustre OST level, to use
more directories in the object "O/d*" hierarchy, since that is not =
exposed
to userspace, and there is no specific reason that we need to stick with
32 subdirectories here.  32 subdirs was a fine option for OSTs in the
past, but there is actually the capability to use a different number of
subdirs on the OST (see struct lr_server_data.lsd_subdir_count), but =
we've
just never used it and it needs some fixing (e.g. if the last_rcvd file =
is
lost and needs to  be recreated it should check the actual number of d*
subdirs instead of just assuming it is OBJ_SUBDIR_COUNT).

Also, instead of just increasing this to 128 subdirs (or whatever), we
should consider to change to creating new object subdirs every 128M =
objects
allocated (or similar), so that on huge OSTs there are automatically =
enough
subdirs allocated, and old subdirectory trees do not need to be kept in =
RAM
if they are not currently being used.  That would be more memory =
efficient
than having many subdirs that are all in use at the same time.  This =
would
need to have ext4 directory shrinking so that the old directories shrink
when they become empty, and could be removed completely once empty.

We have something similar to this "new object subdirectory" =
functionality
already with the OST FID sequence allocation that we use for DNE today,
since each sequence gets a different subdirectory tree on the OST.  What
would need to be changed is that the MDS needs to use OST FID SEQs even
when DNE isn't used (that should work for all in-use Lustre versions).
Secondly, the objects allocated per sequence (LUSTRE_DATA_SEQ_MAX_WIDTH)
needs to be reduced from the current 4B-1 to 128M or similar.


Cheers, Andreas






--Apple-Mail=_C150C7D8-15F5-4CFE-BC20-C867D10E0F1A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFY0UkPpIg59Q01vtYRAg1FAKCoQ6IC0K6jYoBSTpJV0AhI9r9b8wCgkTKl
O1//M8YsWYKJEBllZxajySw=
=YWZl
-----END PGP SIGNATURE-----

--Apple-Mail=_C150C7D8-15F5-4CFE-BC20-C867D10E0F1A--
