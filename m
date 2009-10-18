From: Jon Burgess <jburgess777@googlemail.com>
Subject: Re: optimising filesystem for many small files
Date: Sun, 18 Oct 2009 16:07:37 +0100
Message-ID: <1255878457.27380.138.camel@localhost.localdomain>
References: <84c89ac10910162352x5cdeca37icfbf0af2f2325d7c@mail.gmail.com>
	 <4AD9D599.3000306@redhat.com>
	 <84c89ac10910171056i773dfb93wc2e917a086dd8ef0@mail.gmail.com>
	 <20091017222619.GA10074@mit.edu>
	 <84c89ac10910180231p202fb5f1r2e192e9ac0b51509@mail.gmail.com>
	 <20091018114100.GA26721@eagle102.home.lan>
	 <84c89ac10910180614l5d2d476ehb91d210820761039@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Matija Nalis <mnalis-ml@voyager.hr>, linux-ext4@vger.kernel.org,
	ext3-users@redhat.com
To: Viji V Nair <viji@fedoraproject.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:41700 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbZJRPHg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Oct 2009 11:07:36 -0400
Received: by ewy4 with SMTP id 4so762841ewy.37
        for <linux-ext4@vger.kernel.org>; Sun, 18 Oct 2009 08:07:39 -0700 (PDT)
In-Reply-To: <84c89ac10910180614l5d2d476ehb91d210820761039@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 2009-10-18 at 18:44 +0530, Viji V Nair wrote:
> On Sun, Oct 18, 2009 at 5:11 PM, Matija Nalis <mnalis-ml@voyager.hr> wrote:
> > On Sun, Oct 18, 2009 at 03:01:46PM +0530, Viji V Nair wrote:
> >> The application which we are using are modified versions of mapnik and
> >> tilecache, these are single threaded so we are running 4 process at a
> >
> > How does it scale if you reduce the number or processes - especially if you
> > run just one of those ? As this is just a single disk, 4 simultaneous
> > readers/writers would probably *totally* kill it with seeks.
> >
> > I suspect it might even run faster with just 1 process then with 4 of
> > them...
> 
> with one process it is giving me 6 seconds

That seems a little slow. Have you looked in optimising your mapnik
setup? The mapnik-users list or IRC channel is a good place to ask[1].

For comparison, the OpenStreetMap tile server typically renders a 8x8
block of 64 tiles in about 1 second, although the time varies greatly
depending on the amount of data within the tiles.

> >
> >> time. We can say only four images are created at a single point of
> >> time. Some times a single image is taking around 20 sec to create. I
> >
> > is that 20 secs just the write time for an precomputed file of 10k ?
> > Or does it also include reading and processing and writing ?
> 
> this include processing and writing
> 
> >
> >> can see lots of system resources are free, memory, processors etc
> >> (these are 4G, 2 x 5420 XEON)

4GB may be a little small. Have you checked whether the IO reading your
data sources is the bottleneck?

> > If you can modify hardware setup, RAID10 (better with many smaller disks
> > than with fewer bigger ones) should help *very* much. Flash-disk-thingies of
> > appropriate size are even better option (as the seek issues are few orders
> > of magnitude smaller problem). Also probably more RAM (unless you full
> > dataset is much smaller than 2 GB, which I doubt).
> >
> > On the other hand, have you tried testing some other filesystems ?
> > I've had much better performance with lots of small files of XFS (but that
> > was on big RAID5, so YMMV), for example.
> >
> > --
> > Opinions above are GNU-copylefted.
> >
> 
> I have not tried XFS, but tried reiserfs. I could not see a large
> difference when compared with mkfs.ext4 -T small. I could see that
> reiser is giving better performance on overwrite, not on new writes.
> some times we overwrite existing image with new ones.
> 
> Now the total files are 50Million, soon (with in an year) it will grow
> to 1 Billion. I know that we should move ahead with the hardware
> upgrades, also files system access is a large concern for us. There
> images are accessed over the internet and expecting a 100 million
> visits every month. For each user we need to transfer at least 3Mb of
> data.

Serving 3MB is about 1000 tiles. This is a total of 100M * 1000 = 1e11
tiles/month or about 40,000 requests per second. If every request needed
an IO from a hard disk managing 100 IOPs then you would need about 400
disks. Having a decent amount of RAM should dramatically cut the number
of request reaching the disks. Alternatively you might be able to do
this all with just a few SSDs. The Intel X25-E is rated at >35,000 IOPs
for random 4kB reads[2].

I can give you some performance numbers about the OSM server for
comparision: At last count the OSM tile server had 568M tiles cached
using about 500GB of disk space[3]. The hardware is described on the
wiki[4]. It regularly serves 500+ tiles per second @ 50Mbps[5]. This is
about 40 million HTTP requests per day and several TB of traffic per
month.

	Jon


1: http://trac.mapnik.org/
2: http://download.intel.com/design/flash/nand/extreme/extreme-sata-ssd-product-brief.pdf
3: http://wiki.openstreetmap.org/wiki/Tile_Disk_Usage
4: http://wiki.openstreetmap.org/wiki/Servers/yevaud
5: http://munin.openstreetmap.org/openstreetmap/yevaud.openstreetmap.html



