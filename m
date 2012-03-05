From: Jacek Luczak <difrost.kernel@gmail.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Mon, 5 Mar 2012 12:32:45 +0100
Message-ID: <CADDYkjQ+N1O0x=_JUdCAdNgrp6mQM44VBzZf6V8e2B5OK6fp1A@mail.gmail.com>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
	<E15A491F-62E2-4518-939F-07B3AB4C3E65@mit.edu>
	<20120301143859.GX5054@shiny>
	<CADDYkjQ8jgWUo7=eAeMjve0iRmVZMcrjjbqnvPq0SchE5W9Fqg@mail.gmail.com>
	<20120302140038.GD5054@shiny>
	<CADDYkjT8apYQpdZqr1gZKiHbm9xfTaLr=8GEJF0VKF9neHwgOg@mail.gmail.com>
	<20120302142651.GH5054@shiny>
	<CADDYkjRyQruZgFHDsyAgAV7J3yvunU5YuwmmbxK=1WXJLHw98Q@mail.gmail.com>
	<CADDYkjSWpWAW0dxmMEWjHaRV=jS+U5obeau_GPEgwnJuPBLe3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Chris Mason <chris.mason@oracle.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53183 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866Ab2CELcr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Mar 2012 06:32:47 -0500
In-Reply-To: <CADDYkjSWpWAW0dxmMEWjHaRV=jS+U5obeau_GPEgwnJuPBLe3w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/3/4 Jacek Luczak <difrost.kernel@gmail.com>:
> 2012/3/3 Jacek Luczak <difrost.kernel@gmail.com>:
>> 2012/3/2 Chris Mason <chris.mason@oracle.com>:
>>> On Fri, Mar 02, 2012 at 03:16:12PM +0100, Jacek Luczak wrote:
>>>> 2012/3/2 Chris Mason <chris.mason@oracle.com>:
>>>> > On Fri, Mar 02, 2012 at 11:05:56AM +0100, Jacek Luczak wrote:
>>>> >>
>>>> >> I've took both on tests. The subject is acp and spd_readdir use=
d with
>>>> >> tar, all on ext4:
>>>> >> 1) acp: http://91.234.146.107/~difrost/seekwatcher/acp_ext4.png
>>>> >> 2) spd_readdir: http://91.234.146.107/~difrost/seekwatcher/tar_=
ext4_readir.png
>>>> >> 3) both: http://91.234.146.107/~difrost/seekwatcher/acp_vs_spd_=
ext4.png
>>>> >>
>>>> >> The acp looks much better than spd_readdir but directory copy w=
ith
>>>> >> spd_readdir decreased to 52m 39sec (30 min less).
>>>> >
>>>> > Do you have stats on how big these files are, and how fragmented=
 they
>>>> > are? =A0For acp and spd to give us this, I think something has g=
one wrong
>>>> > at writeback time (creating individual fragmented files).
>>>>
>>>> How big? Which files?
>>>
>>> All the files you're reading ;)
>>>
>>> filefrag will tell you how many extents each file has, any file wit=
h
>>> more than one extent is interesting. =A0(The ext4 crowd may have be=
tter
>>> suggestions on measuring fragmentation).
>>>
>>> Since you mention this is a compile farm, I'm guessing there are a =
bunch
>>> of .o files created by parallel builds. =A0There are a lot of chanc=
es for
>>> delalloc and the kernel writeback code to do the wrong thing here.
>>>
>>
> [Most of files are B and K size]
>>
>> All files scanned: 1978149
>> Files fragmented: 313 (0.015%) where 11 have 3+ extents
>> Total size of fragmented files: 7GB (~13% of dir size)
>
> BTRFS: Non of files according to filefrag are fragmented - all fit
> into one extent.
>
>> tar cf on fragmented files:
>> 1) time: 7sec
>> 2) sw graph: http://91.234.146.107/~difrost/seekwatcher/tar_fragment=
ed.png
>> 3) sw graph with spd_readdir:
>> http://91.234.146.107/~difrost/seekwatcher/tar_fragmented_spd.png
>> 4) both on one:
>> http://91.234.146.107/~difrost/seekwatcher/tar_fragmented_pure_spd.p=
ng
>
> BTRFS: tar on ext4 fragmented files
> 1) time: 6sec
> 2) sw graph: http://91.234.146.107/~difrost/seekwatcher/tar_fragmente=
d_btrfs.png
>
>> tar cf of fragmented files disturbed with [40,50) K files (in total
>> 4373 files). K files before fragmented M files:
>> 1) size: 7.2GB
>> 2) time: 1m 14sec
>> 3) sw graph: http://91.234.146.107/~difrost/seekwatcher/tar_disturbe=
d.png
>> 4) sw graph with spd_readdir:
>> http://91.234.146.107/~difrost/seekwatcher/tar_disturbed_spd.png
>> 5) both on one:
>> http://91.234.146.107/~difrost/seekwatcher/tar_disturbed_pure_spd.pn=
g
>
> BTRFS: tar on [40,50) K and ext4 fragmented
> 1) time: 56sec
> 2) sw graph: http://91.234.146.107/~difrost/seekwatcher/tar_disturbed=
_btrfs.png
>
> New test I've included - randomly selected files:
> - size 240MB
> 1) ext4 (time: 34sec) sw graph:
> http://91.234.146.107/~difrost/seekwatcher/tar_random_ext4.png
> 2) btrfs (time: 55sec) sw graph:
> http://91.234.146.107/~difrost/seekwatcher/tar_random_btrfs.png

Yet another test. The original issue is in the directory data
handling. In my case a lot of dirs are introduced due to extra .svn.
Let's then see how does tar on those dirs looks like.

Number of .svn directories: 61605
1) Ext4:
 - tar time: 10m 53sec
 - sw tar graph: http://91.234.146.107/~difrost/seekwatcher/svn_dir_ext=
4.png
 - sw tar graph with spd_readdir:
http://91.234.146.107/~difrost/seekwatcher/svn_dir_spd_ext4.png
2) Btrfs:
 - tar time: 4m 35sec
 - sw tar graph: http://91.234.146.107/~difrost/seekwatcher/svn_dir_btr=
fs.png
 - sw tar graph with ext4:
http://91.234.146.107/~difrost/seekwatcher/svn_dir_btrfs_ext4.png

IMO this is not a writeback issue (well it could be but then it mean
that it broken in general), it's not fragmentation. Sorting files in
readdir helps a bit but is still far behind the btrfs.

Any ideas? Is this a issue or the things are like they are and one
need to live with it.

-Jacek
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
