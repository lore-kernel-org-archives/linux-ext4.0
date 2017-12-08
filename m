From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Scaling e2fsck
Date: Fri, 8 Dec 2017 08:45:54 -0700
Message-ID: <6BDD58C5-E001-4F72-BBD3-BCC7A9EBEBA9@dilger.ca>
References: <0CBF344F-F470-48F1-A366-226D017C71A8@gmail.com>
 <A3DE234A-93FC-4C6D-94BA-ED2507F48C66@dilger.ca>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_DF476E22-7B2A-4421-BDFD-C86B789C0B73";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: =?utf-8?B?0JHQu9Cw0LPQvtC00LDRgNC10L3QutC+INCQ0YDRgtGR0Lw=?=
        <artem.blagodarenko@gmail.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:42200 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754124AbdLHPqD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Dec 2017 10:46:03 -0500
Received: by mail-it0-f53.google.com with SMTP id p139so5710670itb.1
        for <linux-ext4@vger.kernel.org>; Fri, 08 Dec 2017 07:46:02 -0800 (PST)
In-Reply-To: <A3DE234A-93FC-4C6D-94BA-ED2507F48C66@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_DF476E22-7B2A-4421-BDFD-C86B789C0B73
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


On Dec 6, 2017, at 1:08 PM, =D0=91=D0=BB=D0=B0=D0=B3=D0=BE=D0=B4=D0=B0=D1=80=
=D0=B5=D0=BD=D0=BA=D0=BE =D0=90=D1=80=D1=82=D1=91=D0=BC =
<artem.blagodarenko@gmail.com> wrote:
> I get a question about fsck today again and recall our previous =
discussion.
> You suggested to change e2fsck and make it more =E2=80=9Cparallel=E2=80=9D=
. Also I remember
> your idea that ext4 can allow even format change if this helps to =
scale it.
>=20
> I think e2fsck scaling can be my next task after 64bit node counter, =
but I
> afraid I missed some existed projects or discussion about this topic. =
Could
> you please point me to such projects or if you are ready entrust this =
task
> to me share you thoughts so I have something to start?
>=20
> My first idea - change ext4 format and =E2=80=9Csplit=E2=80=9D =
storage, so it has not only
> one entry point (superblock?), but M/N points, there M - storage size =
and
> N - some rate. This points can be calculated. Also this parts should =
not be
> cross referenced. Very rough idea yet. Thinking about this now.

I think that before you start looking at format changes to improve =
e2fsck,
that you look at what can be done to improve e2fsck performance on =
existing
filesystems.  I think there is a lot that can be done, especially with =
SSD
or RAID-10 storage that is mostly idle during the scan.  This has the =
benefit
that it helps all filesystems, instead of only new ones, and =
improvements
that do not change the disk format are more easily merged.

There was work done in 1.42 or 1.43 to do async readahead of inode =
tables
and other blocks, which improved e2fsck performance, but I suspect there
is more that could be done in this area.

Firstly, an example e2fsck run on my home OST and MDT filesystem:

myth-OST0000: clean, 359496/947456 files, 781092161/970194944 blocks
e2fsck 1.42.13.wc5 (15-Apr-2016)
Pass 1: Checking inodes, blocks, and sizes
Pass 1: Memory used: 5116k/932k (4903k/214k), time: 181.93/ 4.12/ 1.84
Pass 1: I/O read: 160MB, write: 0MB, rate: 0.88MB/s
Pass 2: Checking directory structure
Pass 2: Memory used: 11532k/1084k (4614k/6919k), time:  3.51/ 2.59/ 0.12
Pass 2: I/O read: 37MB, write: 0MB, rate: 10.53MB/s
Pass 3: Checking directory connectivity
Pass 3A: Memory used: 11532k/1084k (4617k/6916k), time:  0.00/ 0.00/ =
0.00
Pass 3A: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 3: Memory used: 11532k/1084k (4612k/6921k), time:  0.00/ 0.00/ 0.00
Pass 3: I/O read: 1MB, write: 0MB, rate: 225.43MB/s
Pass 4: Checking reference counts
Pass 4: Memory used: 5196k/932k (3932k/1265k), time:  0.09/ 0.09/ 0.00
Pass 4: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 5: Checking group summary information
Pass 5: Memory used: 7680k/932k (3917k/3764k), time: 227.05/ 1.72/ 3.03
Pass 5: I/O read: 187MB, write: 0MB, rate: 0.82MB/s

myth-MDT0000: clean, 1872215/3932160 files, 824210/3932160 blocks
e2fsck 1.42.13.wc5 (15-Apr-2016)
Pass 1: Checking inodes, blocks, and sizes
Pass 1: Memory used: 13092k/17500k (12876k/217k), time: 19.98/ 5.52/ =
1.72
Pass 1: I/O read: 1104MB, write: 0MB, rate: 55.26MB/s
Pass 2: Checking directory structure
Pass 2: Memory used: 21012k/8468k (13732k/7281k), time: 23.28/ 7.54/ =
2.25
Pass 2: I/O read: 1113MB, write: 0MB, rate: 47.81MB/s
Pass 3: Checking directory connectivity
Pass 3A: Memory used: 21624k/8468k (14212k/7413k), time:  0.00/ 0.01/ =
0.00
Pass 3A: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 3: Memory used: 21624k/5572k (13731k/7893k), time:  0.06/ 0.05/ =
0.00
Pass 3: I/O read: 1MB, write: 0MB, rate: 15.44MB/s
Pass 4: Checking reference counts
Pass 4: Memory used: 21624k/484k (2638k/18987k), time:  0.42/ 0.45/ 0.00
Pass 4: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 5: Checking group summary information
Pass 5: Memory used: 21624k/0k (2637k/18988k), time:  1.30/ 0.38/ 0.00
Pass 5: I/O read: 1MB, write: 0MB, rate: 0.77MB/s


It shows that a large amount of time is spent in pass1 (inode/block =
scan).
The inode checking could be almost trivially multi-threaded, since each
inode is independent.  It would need locking of shared structures.  I
would make this an event-driven (producer/consumer) process, with =
threads
doing prefetch reads of inode tables, then processing the first group
on the shared list. This avoids threads sitting idle with a static
division of block groups if some groups are used more than others.

Pass2 (directory structure) is trivial on an OST because it has so few
directories, but is relatively longer on the MDT (which is SSD based).
During the pass 1 inode scan, a list of directory inodes will be =
generated,
which could start prefetching some directory leaf blocks to do leaf =
block
scanning. Again, this can be done largely in parallel as long as there =
is
reasonable locking on the bitmaps and a few other structures.  It would
be good to have some sort of elevator for async directory block =
readahead,
to avoid random IO on HDD-based storage.

Pass 5 is slow on the OST filesystem because it is HDD based and is not
using flexbg, so there lots of seeking to read/update groups and =
bitmaps.
That probably doesn't need to be multi-threaded on any modern =
filesystem.


As for how to approach development, I'd start with a simple threading
model (pthreads) and add locking to the bitmap and list structures =
(maybe
a 64-slot hashed lock for bitmaps like include/linux/blockgroup_lock.h =
in
the kernel, instead of one lock per bitmap block, since most are =
unused).
For ease of acceptance, it should be possible to disable threading and
locking at compile time for single-threaded use (e.g. embedded or =
non-linux).

Then, a producer/consumer model for processing inode table blocks could
just be split on a per-group basis with very little change to the code.
Even just a simple counter for "last processed group" to track which
group an idle thread should work on next might be enough.  These threads
would also submit async inode table readahead of maybe 3*num_threads
(about 1GB/1M inodes) to ensure threads are not waiting on disk IO.

Finally, a separate producer/consumer model for processing directories
that are found during pass1 could be added.  I'm not sure, without
checking the code, whether pass 2 can be started before pass1 is done.

With the addition of larger directory support, this would benefit from
being able to shrink ext4 directories online, so that directories shrink
as old entries are removed.  There have been many discussions on how to
implement ext4 directory shrinking, so let me know if this is something
you are interested in.

Cheers, Andreas



--Apple-Mail=_DF476E22-7B2A-4421-BDFD-C86B789C0B73
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFaKrO0pIg59Q01vtYRApY0AJ4kC7GIB5MsQQJ/0IJqptNfTVAMWwCdFrc0
jlgUDnDKu/vqmF2bBN61AY8=
=8yK9
-----END PGP SIGNATURE-----

--Apple-Mail=_DF476E22-7B2A-4421-BDFD-C86B789C0B73--
