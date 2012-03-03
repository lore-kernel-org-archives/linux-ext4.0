From: Jacek Luczak <difrost.kernel@gmail.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Sat, 3 Mar 2012 23:41:46 +0100
Message-ID: <CADDYkjRyQruZgFHDsyAgAV7J3yvunU5YuwmmbxK=1WXJLHw98Q@mail.gmail.com>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
	<E15A491F-62E2-4518-939F-07B3AB4C3E65@mit.edu>
	<20120301143859.GX5054@shiny>
	<CADDYkjQ8jgWUo7=eAeMjve0iRmVZMcrjjbqnvPq0SchE5W9Fqg@mail.gmail.com>
	<20120302140038.GD5054@shiny>
	<CADDYkjT8apYQpdZqr1gZKiHbm9xfTaLr=8GEJF0VKF9neHwgOg@mail.gmail.com>
	<20120302142651.GH5054@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Chris Mason <chris.mason@oracle.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120302142651.GH5054@shiny>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2012/3/2 Chris Mason <chris.mason@oracle.com>:
> On Fri, Mar 02, 2012 at 03:16:12PM +0100, Jacek Luczak wrote:
>> 2012/3/2 Chris Mason <chris.mason@oracle.com>:
>> > On Fri, Mar 02, 2012 at 11:05:56AM +0100, Jacek Luczak wrote:
>> >>
>> >> I've took both on tests. The subject is acp and spd_readdir used =
with
>> >> tar, all on ext4:
>> >> 1) acp: http://91.234.146.107/~difrost/seekwatcher/acp_ext4.png
>> >> 2) spd_readdir: http://91.234.146.107/~difrost/seekwatcher/tar_ex=
t4_readir.png
>> >> 3) both: http://91.234.146.107/~difrost/seekwatcher/acp_vs_spd_ex=
t4.png
>> >>
>> >> The acp looks much better than spd_readdir but directory copy wit=
h
>> >> spd_readdir decreased to 52m 39sec (30 min less).
>> >
>> > Do you have stats on how big these files are, and how fragmented t=
hey
>> > are? =A0For acp and spd to give us this, I think something has gon=
e wrong
>> > at writeback time (creating individual fragmented files).
>>
>> How big? Which files?
>
> All the files you're reading ;)
>
> filefrag will tell you how many extents each file has, any file with
> more than one extent is interesting. =A0(The ext4 crowd may have bett=
er
> suggestions on measuring fragmentation).
>
> Since you mention this is a compile farm, I'm guessing there are a bu=
nch
> of .o files created by parallel builds. =A0There are a lot of chances=
 for
> delalloc and the kernel writeback code to do the wrong thing here.
>

This took some time be here it goes ...

* B size files - total: 1064462 (53.81%)
| Size range    | File cnt      | Fragmented    | Fragmented %  |
| [0,100)       | 288702        | 0             | 0             |
| [100,200)     | 165997        | 0             | 0             |
| [200,300)     | 45993         | 0             | 0             |
| [300,400)     | 64883         | 0             | 0             |
| [400,500)     | 39282         | 0             | 0             |
| [500,600)     | 61612         | 0             | 0             |
| [600,700)     | 208822        | 0             | 0             |
| [700,800)     | 64016         | 0             | 0             |
| [800,900)     | 58181         | 0             | 0             |
| [900,1024)    | 66974         | 0             | 0             |

* K size files - total: 907375 (45.86%)
| Size range    | File cnt      | Fragmented    | Fragmented %  |
| [1,2)         | 285481        | 0             | 0             |
| [2,3)         | 148461        | 0             | 0             |
| [3,4)         | 102569        | 0             | 0             |
| [4,5)         | 45089         | 0             | 0             |
| [5,6)         | 44223         | 0             | 0             |
| [6,10)        | 94202         | 0             | 0             |
| [10,20)       | 83760         | 0             | 0             |
| [20,30)       | 42548         | 0             | 0             |
| [30,40)       | 15274         | 0             | 0             |
| [40,50)       | 4060          | 0             | 0             |
| [50,60)       | 3517          | 0             | 0             |
| [60,100)      | 7834          | 0             | 0             |
| [100,1024)    | 30357         | 0             | 0             |

*M size files - total: 6312 (0.33%)
| Size range    | File cnt      | Fragmented    | Fragmented %  |
| [1.10)        | 5806          | 100           | 1.72          |
| [10,100)      | 482           | 200           | 41.49         |
| [100,1024)    | 24            | 13            | 54.16         |

All files scanned: 1978149
=46iles fragmented: 313 (0.015%) where 11 have 3+ extents
Total size of fragmented files: 7GB (~13% of dir size)

tar cf on fragmented files:
1) time: 7sec
2) sw graph: http://91.234.146.107/~difrost/seekwatcher/tar_fragmented.=
png
3) sw graph with spd_readdir:
http://91.234.146.107/~difrost/seekwatcher/tar_fragmented_spd.png
4) both on one:
http://91.234.146.107/~difrost/seekwatcher/tar_fragmented_pure_spd.png

tar cf of fragmented files disturbed with [40,50) K files (in total
4373 files). K files before fragmented M files:
1) size: 7.2GB
2) time: 1m 14sec
3) sw graph: http://91.234.146.107/~difrost/seekwatcher/tar_disturbed.p=
ng
4) sw graph with spd_readdir:
http://91.234.146.107/~difrost/seekwatcher/tar_disturbed_spd.png
5) both on one:
http://91.234.146.107/~difrost/seekwatcher/tar_disturbed_pure_spd.png

I will perform same tests on btrfs tomorrow.

-Jacek
