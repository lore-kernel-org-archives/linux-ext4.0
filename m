Return-Path: <SRS0=zSAL=OS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-lf1-f66.google.com ([209.85.167.66]:36331 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbeLIOpP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 9 Dec 2018 09:45:15 -0500
MIME-Version: 1.0
References: <CGME20181130093318eucas1p24feb8e649c8f244ce149a7f87e43c828@eucas1p2.samsung.com>
 <1543570361-3168-1-git-send-email-huijin.park@samsung.com> <20181130195607.GA27411@vader>
In-Reply-To: <20181130195607.GA27411@vader>
From: Huijin Park <bbanghj.park@gmail.com>
Date: Sun, 9 Dec 2018 23:44:59 +0900
Message-ID: <CAMy0x0kYs7-oK7__GK0uqaNdAwyH_y3RG+misbyKc2f=cgDeAA@mail.gmail.com>
Subject: Re: [PATCH,1/2] genhd: avoid overflow of sectors in disk_stats
To: osandov@osandov.com
Cc: huijin.park@samsung.com, adilger.kernel@dilger.ca,
        michaelcallahan@fb.com, osandov@fb.com, js07.lee@samsung.com,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Omar Sandoval,

On Sat, Dec 1, 2018 at 4:56 AM Omar Sandoval <osandov@osandov.com> wrote:
>
> On Fri, Nov 30, 2018 at 04:32:40AM -0500, Huijin Park wrote:
> > From: "huijin.park" <huijin.park@samsung.com>
> >
> > This patch changes the 'sectors' type to an u64.
> > In 32 bit system, the 'sectors' can accumulate up to about 2TiB.
> > If a 32 bit system makes i/o over 2TiB while running,
> > the 'sectors' will overflow.
> > As a result, the part_stat_read(sectors), the diskstats in proc and
> > the (lifetime|session)_write_kbytes in sysfs return invalid statistic.
>
> What about parsers which expect it to be an unsigned long? E.g., iostat:
> https://github.com/sysstat/sysstat/blob/v12.1.1/rd_stats.c#L736
>
> At least with glibc, scanf seems to truncate sanely, but this appears to
> be undefined.

The glibc APIs such as scanf and strtoul set return value and errno
to ULONG_MAX and ERANGE in overflow case.
I think ULONG_MAX and ERANGE are better than reset to zero because
of overflow. At least, application can notice overflow with errno.
Besides nowadays, a 32 bit is not enough size to show
an i/o accumulated size.
I met a problem like below. So I suggested this patch.

sh-3.2# mount | grep p19
/dev/mmcblk0p19 on /ext4_dir type ext4 (rw,relatime,data=ordered)
sh-3.2# cat /sys/fs/ext4/mmcblk0p19/session_write_kbytes
2147467268
sh-3.2# cat /sys/fs/ext4/mmcblk0p19/lifetime_write_kbytes
2147568561
sh-3.2# dd if=/dev/zero of=/ext4_dir/temp.bin bs=1M count=20 oflag=sync
20+0 records in
20+0 records out
20971520 bytes (21 MB) copied,
0.621939 s, 33.7 MB/s
sh-3.2# cat /sys/fs/ext4/mmcblk0p19/session_write_kbytes
4524
sh-3.2# cat /sys/fs/ext4/mmcblk0p19/lifetime_write_kbytes
105817

>
> > Signed-off-by: huijin.park <huijin.park@samsung.com>
> > ---
> >  block/genhd.c         |    6 +++---
> >  include/linux/genhd.h |    2 +-
> >  2 files changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/block/genhd.c b/block/genhd.c
> > index 0145bcb..7518dcd 100644
> > --- a/block/genhd.c
> > +++ b/block/genhd.c
> > @@ -1343,10 +1343,10 @@ static int diskstats_show(struct seq_file *seqf, void *v)
> >               part_stat_unlock();
> >               part_in_flight(gp->queue, hd, inflight);
> >               seq_printf(seqf, "%4d %7d %s "
> > -                        "%lu %lu %lu %u "
> > -                        "%lu %lu %lu %u "
> > +                        "%lu %lu %llu %u "
> > +                        "%lu %lu %llu %u "
> >                          "%u %u %u "
> > -                        "%lu %lu %lu %u\n",
> > +                        "%lu %lu %llu %u\n",
> >                          MAJOR(part_devt(hd)), MINOR(part_devt(hd)),
> >                          disk_name(gp, hd->partno, buf),
> >                          part_stat_read(hd, ios[STAT_READ]),
> > diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> > index 0c5ee17..5bf86f9 100644
> > --- a/include/linux/genhd.h
> > +++ b/include/linux/genhd.h
> > @@ -84,7 +84,7 @@ struct partition {
> >
> >  struct disk_stats {
> >       u64 nsecs[NR_STAT_GROUPS];
> > -     unsigned long sectors[NR_STAT_GROUPS];
> > +     u64 sectors[NR_STAT_GROUPS];
> >       unsigned long ios[NR_STAT_GROUPS];
> >       unsigned long merges[NR_STAT_GROUPS];
> >       unsigned long io_ticks;
> > --
> > 1.7.9.5
> >

Thanks,
Huijin
