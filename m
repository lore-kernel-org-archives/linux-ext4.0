From: Chris Mason <chris.mason@oracle.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Fri, 2 Mar 2012 09:26:51 -0500
Message-ID: <20120302142651.GH5054@shiny>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
 <E15A491F-62E2-4518-939F-07B3AB4C3E65@mit.edu>
 <20120301143859.GX5054@shiny>
 <CADDYkjQ8jgWUo7=eAeMjve0iRmVZMcrjjbqnvPq0SchE5W9Fqg@mail.gmail.com>
 <20120302140038.GD5054@shiny>
 <CADDYkjT8apYQpdZqr1gZKiHbm9xfTaLr=8GEJF0VKF9neHwgOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
To: Jacek Luczak <difrost.kernel@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CADDYkjT8apYQpdZqr1gZKiHbm9xfTaLr=8GEJF0VKF9neHwgOg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Mar 02, 2012 at 03:16:12PM +0100, Jacek Luczak wrote:
> 2012/3/2 Chris Mason <chris.mason@oracle.com>:
> > On Fri, Mar 02, 2012 at 11:05:56AM +0100, Jacek Luczak wrote:
> >>
> >> I've took both on tests. The subject is acp and spd_readdir used w=
ith
> >> tar, all on ext4:
> >> 1) acp: http://91.234.146.107/~difrost/seekwatcher/acp_ext4.png
> >> 2) spd_readdir: http://91.234.146.107/~difrost/seekwatcher/tar_ext=
4_readir.png
> >> 3) both: http://91.234.146.107/~difrost/seekwatcher/acp_vs_spd_ext=
4.png
> >>
> >> The acp looks much better than spd_readdir but directory copy with
> >> spd_readdir decreased to 52m 39sec (30 min less).
> >
> > Do you have stats on how big these files are, and how fragmented th=
ey
> > are? =A0For acp and spd to give us this, I think something has gone=
 wrong
> > at writeback time (creating individual fragmented files).
>=20
> How big? Which files?

All the files you're reading ;)

filefrag will tell you how many extents each file has, any file with
more than one extent is interesting.  (The ext4 crowd may have better
suggestions on measuring fragmentation).

Since you mention this is a compile farm, I'm guessing there are a bunc=
h
of .o files created by parallel builds.  There are a lot of chances for
delalloc and the kernel writeback code to do the wrong thing here.

-chris
