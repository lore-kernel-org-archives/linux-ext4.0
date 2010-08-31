From: Bill Fink <billfink@mindspring.com>
Subject: Re: [RFC PATCH] ext4: fix 50% disk write performance regression
Date: Mon, 30 Aug 2010 21:44:20 -0400
Message-ID: <20100830214420.51c920de.billfink@mindspring.com>
References: <20100829231126.8d8b2086.billfink@mindspring.com>
	<20100830174000.GA6647@thunk.org>
	<20100830164958.edb64c63.bill@wizard.sci.gsfc.nasa.gov>
	<20100831003710.GA4272@thunk.org>
	<AANLkTi=pfVCKmURAnhageAuQFT7yUMy+5NzJ8C9NunXt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>,
	Bill Fink <bill@wizard.sci.gsfc.nasa.gov>,
	"adilger@sun.com" <adilger@sun.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Fink, William E. (GSFC-6061)" <william.e.fink@nasa.gov>
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from elasmtp-masked.atl.sa.earthlink.net ([209.86.89.68]:58689 "EHLO
	elasmtp-masked.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756426Ab0HaBoX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Aug 2010 21:44:23 -0400
In-Reply-To: <AANLkTi=pfVCKmURAnhageAuQFT7yUMy+5NzJ8C9NunXt@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 30 Aug 2010, Justin Maggard wrote:

> On Mon, Aug 30, 2010 at 5:37 PM, Ted Ts'o <tytso@mit.edu> wrote:
> > On Mon, Aug 30, 2010 at 04:49:58PM -0400, Bill Fink wrote:
> >> > Thanks for reporting it. =A0I'm going to have to take a closer l=
ook at
> >> > why this makes a difference. =A0I'm going to guess though that w=
hat's
> >> > going on is that we're posting writes in such a way that they're=
 no
> >> > longer aligned or ending at the end of a RAID5 stripe, causing a
> >> > read-modify-write pass. =A0That would easily explain the write
> >> > performance regression.
> >>
> >> I'm not sure I understand. =A0How could calling or not calling
> >> ext4_num_dirty_pages() (unpatched versus patched 2.6.35 kernel)
> >> affect the write alignment?
> >
> > Suppose you have 8 disks, with stripe size of 16k. =A0Assuming that
> > you're only using one parity disk (i.e., RAID 5) and no spare disks=
,
> > that means the optimal I/O size is 7*16k =3D=3D 112k. =A0If we do a=
 write
> > which is smaller than 112k, or which is not a multiple of 112k, the=
n
> > the RAID subsystem will need to do a read-modify-write to update th=
e
> > parity disk. =A0Furthermore, the write had better be aligned on an =
112k
> > byte boundary. =A0The block allocator will guarantee that block #0 =
is
> > aligned on a 112k block, but writes have to also be right size in
> > order to avoid the read-modify-write.
> >
> > If we end up doing very small writes, then it can end up being quit=
e
> > disatrous for write performance.
>=20
> I'd have to agree that this is likely the case.  Just to add a little
> more data here, I tried the same 32GB dd test against a 12-disk MD
> RAID 6 64k chunk array today with and without the patch (although
> against a 2.6.33.7 kernel), and my write performance dropped from
> ~420MB/sec down to 350MB/sec when I used the patched kernel.

I'm curious.  Since you're using 12 disks where I was only
using 8, I'm wondering what performance you would get if you
changed the multiplier to say 16, i.e.

	desired_nr_to_write =3D wbc->nr_to_write * 16;

It seems you should be getting better than 420 MB/sec on a
12-disk raid, although perhaps the overhead of doing RAID6
is an issue.  I use md RAID0 to combine 2 of the hardware
RAID5 arrays (total of 16 disks), and I'm seeing (with my
patch) 1.3 GB/sec write performance.

					-Bill
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
