From: Shaohua Li <shli@fusionio.com>
Subject: Re: ext4 write performance regression in 3.6-rc1 on RAID0/5
Date: Wed, 22 Aug 2012 12:07:26 +0800
Message-ID: <50345AFE.1070700@fusionio.com>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com> <20120816024654.GB3781@thunk.org> <20120816111051.GA16036@localhost> <20120816152513.GA31346@thunk.org> <20120817060915.GB28786@localhost> <20120817134039.GB11439@thunk.org> <20120817142526.GA1059@localhost> <20120822035702.GF2570@yliu-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Fengguang Wu <fengguang.wu@intel.com>, NeilBrown <neilb@suse.de>,
	Theodore Ts'o <tytso@mit.edu>,
	Marti Raudsepp <marti@juffo.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>,
	"maze@google.com" <maze@google.com>,
	"Shi, Alex" <alex.shi@intel.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	linux RAID <linux-raid@vger.kernel.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120822035702.GF2570@yliu-dev.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 8/22/12 11:57 AM, Yuanhan Liu wrote:
>  On Fri, Aug 17, 2012 at 10:25:26PM +0800, Fengguang Wu wrote:
> > [CC md list]
> >
> > On Fri, Aug 17, 2012 at 09:40:39AM -0400, Theodore Ts'o wrote:
> >> On Fri, Aug 17, 2012 at 02:09:15PM +0800, Fengguang Wu wrote:
> >>> Ted,
> >>>
> >>> I find ext4 write performance dropped by 3.3% on average in the
> >>> 3.6-rc1 merge window. xfs and btrfs are fine.
> >>>
> >>> Two machines are tested. The performance regression happens in the
> >>> lkp-nex04 machine, which is equipped with 12 SSD drives. lkp-st02 does
> >>> not see regression, which is equipped with HDD drives. I'll continue
> >>> to repeat the tests and report variations.
> >>
> >> Hmm... I've checked out the commits in "git log v3.5..v3.6-rc1 --
> >> fs/ext4 fs/jbd2" and I don't see anything that I would expect would
> >> cause that. The are the lock elimination changes for Direct I/O
> >> overwrites, but that shouldn't matter for your tests which are
> >> measuring buffered writes, correct?
> >>
> >> Is there any chance you could do me a favor and do a git bisect
> >> restricted to commits involving fs/ext4 and fs/jbd2?
> >
> > I noticed that the regressions all happen in the RAID0/RAID5 cases.
> > So it may be some interactions between the RAID/ext4 code?
> >
> > I'll try to get some ext2/3 numbers, which should have less changes 
on the fs side.
> >
> > wfg@bee /export/writeback% ./compare -g ext4 
lkp-nex04/*/*-{3.5.0,3.6.0-rc1+}
> > 3.5.0 3.6.0-rc1+
> > ------------------------ ------------------------
> > 720.62 -1.5% 710.16 lkp-nex04/JBOD-12HDD-thresh=1000M/ext4-100dd-1-3.5.0
> > 706.04 -0.0% 705.86 lkp-nex04/JBOD-12HDD-thresh=1000M/ext4-10dd-1-3.5.0
> > 702.86 -0.2% 701.74 lkp-nex04/JBOD-12HDD-thresh=1000M/ext4-1dd-1-3.5.0
> > 702.41 -0.0% 702.06 lkp-nex04/JBOD-12HDD-thresh=1000M/ext4-1dd-2-3.5.0
> > 779.52 +6.5% 830.11 lkp-nex04/JBOD-12HDD-thresh=100M/ext4-100dd-1-3.5.0
> > 646.70 +4.9% 678.59 lkp-nex04/JBOD-12HDD-thresh=100M/ext4-10dd-1-3.5.0
> > 704.49 +2.6% 723.00 lkp-nex04/JBOD-12HDD-thresh=100M/ext4-1dd-1-3.5.0
> > 704.21 +1.2% 712.47 lkp-nex04/JBOD-12HDD-thresh=100M/ext4-1dd-2-3.5.0
> > 705.26 -1.2% 696.61 lkp-nex04/JBOD-12HDD-thresh=8G/ext4-100dd-1-3.5.0
> > 703.37 +0.1% 703.76 lkp-nex04/JBOD-12HDD-thresh=8G/ext4-10dd-1-3.5.0
> > 701.66 -0.1% 700.83 lkp-nex04/JBOD-12HDD-thresh=8G/ext4-1dd-1-3.5.0
> > 701.17 +0.0% 701.36 lkp-nex04/JBOD-12HDD-thresh=8G/ext4-1dd-2-3.5.0
> > 675.08 -10.5% 604.29 
lkp-nex04/RAID0-12HDD-thresh=1000M/ext4-100dd-1-3.5.0
> > 676.52 -2.7% 658.38 lkp-nex04/RAID0-12HDD-thresh=1000M/ext4-10dd-1-3.5.0
> > 512.70 +4.0% 533.22 lkp-nex04/RAID0-12HDD-thresh=1000M/ext4-1dd-1-3.5.0
> > 524.61 -0.3% 522.90 lkp-nex04/RAID0-12HDD-thresh=1000M/ext4-1dd-2-3.5.0
> > 709.76 -15.7% 598.44 lkp-nex04/RAID0-12HDD-thresh=100M/ext4-100dd-1-3.5.0
> > 681.39 -2.1% 667.25 lkp-nex04/RAID0-12HDD-thresh=100M/ext4-10dd-1-3.5.0
> > 524.16 +0.8% 528.25 lkp-nex04/RAID0-12HDD-thresh=100M/ext4-1dd-2-3.5.0
> > 699.77 -19.2% 565.54 lkp-nex04/RAID0-12HDD-thresh=8G/ext4-100dd-1-3.5.0
> > 675.79 -1.9% 663.17 lkp-nex04/RAID0-12HDD-thresh=8G/ext4-10dd-1-3.5.0
> > 484.84 -7.4% 448.83 lkp-nex04/RAID0-12HDD-thresh=8G/ext4-1dd-1-3.5.0
> > 470.40 -3.2% 455.31 lkp-nex04/RAID0-12HDD-thresh=8G/ext4-1dd-2-3.5.0
> > 167.97 -38.7% 103.03 
lkp-nex04/RAID5-12HDD-thresh=1000M/ext4-100dd-1-3.5.0
> > 243.67 -9.1% 221.41 lkp-nex04/RAID5-12HDD-thresh=1000M/ext4-10dd-1-3.5.0
> > 248.98 +12.2% 279.33 lkp-nex04/RAID5-12HDD-thresh=1000M/ext4-1dd-1-3.5.0
> > 208.45 +14.1% 237.86 lkp-nex04/RAID5-12HDD-thresh=1000M/ext4-1dd-2-3.5.0
> > 71.18 -34.2% 46.82 lkp-nex04/RAID5-12HDD-thresh=100M/ext4-100dd-1-3.5.0
> > 145.84 -7.3% 135.25 lkp-nex04/RAID5-12HDD-thresh=100M/ext4-10dd-1-3.5.0
> > 255.22 +6.7% 272.35 lkp-nex04/RAID5-12HDD-thresh=100M/ext4-1dd-1-3.5.0
> > 243.09 +20.7% 293.30 lkp-nex04/RAID5-12HDD-thresh=100M/ext4-1dd-2-3.5.0
> > 209.24 -23.6% 159.96 lkp-nex04/RAID5-12HDD-thresh=8G/ext4-100dd-1-3.5.0
> > 243.73 -10.9% 217.28 lkp-nex04/RAID5-12HDD-thresh=8G/ext4-10dd-1-3.5.0
>
>  Hi,
>
>  About this issue, I did some investigation. And found we are blocked at
>  get_active_stripes() in most times. It's reasonable, since max_nr_stripes
>  is set to 256 now. It's a kind of small value, thus I tried with
>  different value. Please see the following patch for detailed numbers.
>
>  The test machine is same as above.
>
>  From 85c27fca12b770da5bc8ec9f26a22cb414e84c68 Mon Sep 17 00:00:00 2001
>  From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
>  Date: Wed, 22 Aug 2012 10:51:48 +0800
>  Subject: [RFC PATCH] md/raid5: increase NR_STRIPES to 1024
>
>  Stripe head is a must held resource before doing any IO. And it's
>  limited to 256 by default. With 10dd case, we found that it is
>  blocked at get_active_stripes() in most times(please see the ps
>  output attached).
>
>  Thus I did some tries with different value set to NR_STRIPS, and
>  here are some numbers(EXT4 only) I got with different NR_STRIPS set:
>
>  write bandwidth:
>  ================
>  3.5.0-rc1-256+: (Here 256 means with max strip head set to 256)
>  write bandwidth: 280
>  3.5.0-rc1-1024+:
>  write bandwidth: 421 (+50.4%)
>  3.5.0-rc1-4096+:
>  write bandwidth: 506 (+80.7%)
>  3.5.0-rc1-32768+:
>  write bandwidth: 615 (+119.6%)
>
>  (Here 'sh' means with Shaohua's "multiple threads to handle strips" 
patch [0])
>  3.5.0-rc3-strip-sh+-256:
>  write bandwidth: 465
>
>  3.5.0-rc3-strip-sh+-1024:
>  write bandwidth: 599
>
>  3.5.0-rc3-strip-sh+-32768:
>  write bandwidth: 615
>
>  The kernel maybe a bit older but I found that the data are still kind of
>  valid. Though, I haven't tried Shaohua's latest patch.
>
>  As you can see from those data above: the write bandwidth is increased
>  (a lot) as we increase NR_STRIPES. Thus the bigger NR_STRIPES set, the
>  better write bandwidth we get. But we can't set NR_STRIPES with a too
>  large number, especially by default, or it need lots of memory. Due to
>  the number I got with Shaohua's patch applied, I guess 1024 would be
>  nice value; it's not too big but we gain above 110% performance.
>
>  Comments? BTW, I have a more flexible(more stupid, in the meantime) way:
>  change the max_nr_stripes dynamically based on need?
>
>  Here I also attached more data: the script I used to get those number,
>  ps output, and iostat -kx 3 output.
>
>  The script does it's job in a straight way: start NR dd in background,
>  trace the writeback/global_dirty_state event in background to count the
>  write bandwidth, sample the ps out regularly.
>
>  ---
>  [0]: patch: http://lwn.net/Articles/500200/
>
>  Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
>  ---
>  drivers/md/raid5.c | 2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
>  diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>  index adda94d..82dca53 100644
>  --- a/drivers/md/raid5.c
>  +++ b/drivers/md/raid5.c
>  @@ -62,7 +62,7 @@
>  * Stripe cache
>  */
>
>  -#define NR_STRIPES 256
>  +#define NR_STRIPES 1024
>  #define STRIPE_SIZE PAGE_SIZE
>  #define STRIPE_SHIFT (PAGE_SHIFT - 9)
>  #define STRIPE_SECTORS (STRIPE_SIZE>>9)

does revert commit 8811b5968f6216e fix the problem?

Thanks,
Shaohua
