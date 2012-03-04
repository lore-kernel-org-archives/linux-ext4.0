From: Jacek Luczak <difrost.kernel@gmail.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Sun, 4 Mar 2012 11:25:08 +0100
Message-ID: <CADDYkjSWpWAW0dxmMEWjHaRV=jS+U5obeau_GPEgwnJuPBLe3w@mail.gmail.com>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
	<E15A491F-62E2-4518-939F-07B3AB4C3E65@mit.edu>
	<20120301143859.GX5054@shiny>
	<CADDYkjQ8jgWUo7=eAeMjve0iRmVZMcrjjbqnvPq0SchE5W9Fqg@mail.gmail.com>
	<20120302140038.GD5054@shiny>
	<CADDYkjT8apYQpdZqr1gZKiHbm9xfTaLr=8GEJF0VKF9neHwgOg@mail.gmail.com>
	<20120302142651.GH5054@shiny>
	<CADDYkjRyQruZgFHDsyAgAV7J3yvunU5YuwmmbxK=1WXJLHw98Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Chris Mason <chris.mason@oracle.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CADDYkjRyQruZgFHDsyAgAV7J3yvunU5YuwmmbxK=1WXJLHw98Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2012/3/3 Jacek Luczak <difrost.kernel@gmail.com>:
> 2012/3/2 Chris Mason <chris.mason@oracle.com>:
>> On Fri, Mar 02, 2012 at 03:16:12PM +0100, Jacek Luczak wrote:
>>> 2012/3/2 Chris Mason <chris.mason@oracle.com>:
>>> > On Fri, Mar 02, 2012 at 11:05:56AM +0100, Jacek Luczak wrote:
>>> >>
>>> >> I've took both on tests. The subject is acp and spd_readdir used=
 with
>>> >> tar, all on ext4:
>>> >> 1) acp: http://91.234.146.107/~difrost/seekwatcher/acp_ext4.png
>>> >> 2) spd_readdir: http://91.234.146.107/~difrost/seekwatcher/tar_e=
xt4_readir.png
>>> >> 3) both: http://91.234.146.107/~difrost/seekwatcher/acp_vs_spd_e=
xt4.png
>>> >>
>>> >> The acp looks much better than spd_readdir but directory copy wi=
th
>>> >> spd_readdir decreased to 52m 39sec (30 min less).
>>> >
>>> > Do you have stats on how big these files are, and how fragmented =
they
>>> > are? =A0For acp and spd to give us this, I think something has go=
ne wrong
>>> > at writeback time (creating individual fragmented files).
>>>
>>> How big? Which files?
>>
>> All the files you're reading ;)
>>
>> filefrag will tell you how many extents each file has, any file with
>> more than one extent is interesting. =A0(The ext4 crowd may have bet=
ter
>> suggestions on measuring fragmentation).
>>
>> Since you mention this is a compile farm, I'm guessing there are a b=
unch
>> of .o files created by parallel builds. =A0There are a lot of chance=
s for
>> delalloc and the kernel writeback code to do the wrong thing here.
>>
>
[Most of files are B and K size]
>
> All files scanned: 1978149
> Files fragmented: 313 (0.015%) where 11 have 3+ extents
> Total size of fragmented files: 7GB (~13% of dir size)

BTRFS: Non of files according to filefrag are fragmented - all fit
into one extent.

> tar cf on fragmented files:
> 1) time: 7sec
> 2) sw graph: http://91.234.146.107/~difrost/seekwatcher/tar_fragmente=
d.png
> 3) sw graph with spd_readdir:
> http://91.234.146.107/~difrost/seekwatcher/tar_fragmented_spd.png
> 4) both on one:
> http://91.234.146.107/~difrost/seekwatcher/tar_fragmented_pure_spd.pn=
g

BTRFS: tar on ext4 fragmented files
1) time: 6sec
2) sw graph: http://91.234.146.107/~difrost/seekwatcher/tar_fragmented_=
btrfs.png

> tar cf of fragmented files disturbed with [40,50) K files (in total
> 4373 files). K files before fragmented M files:
> 1) size: 7.2GB
> 2) time: 1m 14sec
> 3) sw graph: http://91.234.146.107/~difrost/seekwatcher/tar_disturbed=
=2Epng
> 4) sw graph with spd_readdir:
> http://91.234.146.107/~difrost/seekwatcher/tar_disturbed_spd.png
> 5) both on one:
> http://91.234.146.107/~difrost/seekwatcher/tar_disturbed_pure_spd.png

BTRFS: tar on [40,50) K and ext4 fragmented
1) time: 56sec
2) sw graph: http://91.234.146.107/~difrost/seekwatcher/tar_disturbed_b=
trfs.png

New test I've included - randomly selected files:
- size 240MB
1) ext4 (time: 34sec) sw graph:
http://91.234.146.107/~difrost/seekwatcher/tar_random_ext4.png
2) btrfs (time: 55sec) sw graph:
http://91.234.146.107/~difrost/seekwatcher/tar_random_btrfs.png

-Jacek
