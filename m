From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: fragmentation optimization
Date: Sat, 23 Sep 2017 11:12:34 -0600
Message-ID: <333A80A7-9254-41C8-ACCE-5094CFD050EA@dilger.ca>
References: <6f6eb640-cd31-7080-a575-b7c6c4dd9e3f@uls.co.za>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_EE8B45EF-8898-41FD-B8CD-3A942A4A6C77";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>
To: Jaco Kroon <jaco@uls.co.za>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:52743 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751382AbdIWRMo (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Sep 2017 13:12:44 -0400
Received: by mail-it0-f50.google.com with SMTP id c195so3680435itb.1
        for <linux-ext4@vger.kernel.org>; Sat, 23 Sep 2017 10:12:44 -0700 (PDT)
In-Reply-To: <6f6eb640-cd31-7080-a575-b7c6c4dd9e3f@uls.co.za>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_EE8B45EF-8898-41FD-B8CD-3A942A4A6C77
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 23, 2017, at 1:49 AM, Jaco Kroon <jaco@uls.co.za> wrote:
>=20
> Hi Ted, Everyone,
>=20
> During our last discussions you mentioned the following (2017/08/16 =
5:06 SAST/GMT+2):
>=20
> "One other thought.  There is an ext4 block allocator optimization
> "feature" which is biting us here.  At the moment we have an
> optimization where if there is small "hole" in the logical block
> number space, we leave a "hole" in the physical blocks allocated to
> the file."
>=20
> You proceeded to provide the example regarding writing of object files =
as per binutils (ld specifically).
>=20
> As per the data I provided you previously rsync (with --sparse) is =
generating a lot of "holes" for us due to this.  As a result I end up =
with a rather insane amount of fragmentation:
>=20
> Blocksize: 4096 bytes
> Total blocks: 13153337344
> Free blocks: 1272662587 (9.7%)
>=20
> Min. free extent: 4 KB
> Max. free extent: 17304 KB
> Avg. free extent: 44 KB
> Num. free extent: 68868260
>=20
> HISTOGRAM OF FREE EXTENT SIZES:
> Extent Size Range :  Free extents   Free Blocks  Percent
>    4K...    8K-  :      28472490      28472490    2.24%
>    8K...   16K-  :      27005860      55030426    4.32%
>   16K...   32K-  :       2595993      14333888    1.13%
>   32K...   64K-  :       2888720      32441623    2.55%
>   64K...  128K-  :       2745121      62071861    4.88%
>  128K...  256K-  :       2303439     103166554    8.11%
>  256K...  512K-  :       1518463     134776388   10.59%
>  512K... 1024K-  :        902691     163108612   12.82%
>    1M...    2M-  :        314858     105445496    8.29%
>    2M...    4M-  :         97174      64620009    5.08%
>    4M...    8M-  :         22501      28760501    2.26%
>    8M...   16M-  :           945       2069807    0.16%
>   16M...   32M-  :             5         21155    0.00%
>=20
> Based on the behavior I notice by watching how rsync works[1] I =
greatly suspect that writes are sequential from start of file to end of =
file.  Regarding the above "feature" you further proceeded to mention:
>=20
> "However, it obviously doesn't do the right thing for rsync --sparse,
> and these days, thanks to delayed allocation, so long as binutils can
> finish writing the blocks within 30 seconds, it doesn't matter if GNU
> ld writes the blocks in a completely random order, since we will only
> attempt to do the writeback to the disk after all of the holes in the
> .o file have been filled in.  So perhaps we should turn off this ext4
> block allocator optimization if delayed allocation is enabled (which
> is the default these days)."
>=20
> You mentioned a few pros and cons of this approach as well, and also =
mentioned that it won't help my existing filesystem, however, I suspect =
it might in combination with a e4defrag sweep (which if it takes a few =
weeks in the background that's fine by me).  Also, I suspect disabling =
this might help avoid future holes, and since persistence of files =
varies (from a week to a year) I suspect it may help to over time slowly =
improve performance.
>=20
> I'm also relatively comfortable to make the 30s write limit even =
longer (as you pointed out the files causing the problems are typically =
300GB+ even though on average my files are very small), permitting that =
I won't introduce additional file-system corruption risk.  Also keeping =
in mind that I run anything from 10 to 20 concurrent rsync instances at =
any point in time.

The 30s limit is imposed by the VFS, which begins flushing dirty data =
pages
from memory if they are old, if some other mechanism hasn't done it =
sooner.

> I would like to attempt such a patch, so if you (or someone else) =
could possibly point me in an appropriate direction of where to start =
work on this I would really appreciate the help.
>=20
> Another approach for me may be to simply switch off --sparse since =
especially now I'm unsure of it's benefit.  I'm guessing that I could do =
a sweep of all inodes to determine how much space is really being saved =
by this.

You can do this on a per-file basis with the "filefrag" utility to =
determine how
many extents the file is written in.  Anything reporting only 1 extent =
can be
ignored since it can't get better. Even on large files there will be =
multiple
extents (maximum extent size is 128MB, but may be limited to ~122MB =
depending on
formatting options).  That said, anything larger than ~4MB doesn't =
improve the
I/O performance in any significant way because the HDD seek rate 100/sec =
* 4MB/s
exceeds the disk bandwidth.

The other option is the "fsstats" utility =
(https://github.com/adilger/fsstats
though I didn't write it) will scan the whole filesystem/tree and report =
all
kinds of useful stats, but most importantly how many files are sparse.


> [1] My observed behaviour when syncing a file (without --inplace which =
is in my opinion a bad idea in general unless you're severely space =
constrained, and then I honestly don't know how this situation would be =
affected) is that rsync will create a new file, and then the file size =
of this file will grow slowly (not, not disk usage, but size as reported =
by ls) until it reaches the file size of the new file, and at this point =
rsync will use rename(2) to replace the old file with the new one (which =
is the right approach).

The reason the size is growing, but not the blocks count, is because of =
delayed
allocation.  The ext4 code will keep the dirty pages only in memory =
until they
need to be written (due to age or memory pressure), to better determine =
what to
allocate on disk.  This lets it fit small files into small free chunks =
on disk,
and large files get (multiple) large free chunks of disk.

Cheers, Andreas






--Apple-Mail=_EE8B45EF-8898-41FD-B8CD-3A942A4A6C77
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZxpYEpIg59Q01vtYRAtU/AJ4tmvmQT3s3ITzqoTN/X9H27rbPHQCeMhXx
xpzCWk3VWFlapmNXTiXjSHs=
=wPfT
-----END PGP SIGNATURE-----

--Apple-Mail=_EE8B45EF-8898-41FD-B8CD-3A942A4A6C77--
