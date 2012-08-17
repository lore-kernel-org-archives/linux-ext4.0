From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: ext4 write performance regression in 3.6-rc1 on RAID0/5
Date: Fri, 17 Aug 2012 22:25:26 +0800
Message-ID: <20120817142526.GA1059@localhost>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
 <20120816024654.GB3781@thunk.org>
 <20120816111051.GA16036@localhost>
 <20120816152513.GA31346@thunk.org>
 <20120817060915.GB28786@localhost>
 <20120817134039.GB11439@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux RAID <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>,
	Li Shaohua <shli@fusionio.com>
To: Theodore Ts'o <tytso@mit.edu>, Marti Raudsepp <marti@juffo.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com,
	"Shi, Alex" <alex.shi@intel.com>, linux-fsdevel@vger.kernel.org
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120817134039.GB11439@thunk.org>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

[CC md list]

On Fri, Aug 17, 2012 at 09:40:39AM -0400, Theodore Ts'o wrote:
> On Fri, Aug 17, 2012 at 02:09:15PM +0800, Fengguang Wu wrote:
> > Ted,
> > 
> > I find ext4 write performance dropped by 3.3% on average in the
> > 3.6-rc1 merge window. xfs and btrfs are fine.
> > 
> > Two machines are tested. The performance regression happens in the
> > lkp-nex04 machine, which is equipped with 12 SSD drives. lkp-st02 does
> > not see regression, which is equipped with HDD drives. I'll continue
> > to repeat the tests and report variations.
> 
> Hmm... I've checked out the commits in "git log v3.5..v3.6-rc1 --
> fs/ext4 fs/jbd2" and I don't see anything that I would expect would
> cause that.  The are the lock elimination changes for Direct I/O
> overwrites, but that shouldn't matter for your tests which are
> measuring buffered writes, correct?
> 
> Is there any chance you could do me a favor and do a git bisect
> restricted to commits involving fs/ext4 and fs/jbd2?

I noticed that the regressions all happen in the RAID0/RAID5 cases.
So it may be some interactions between the RAID/ext4 code?

I'll try to get some ext2/3 numbers, which should have less changes on the fs side.

wfg@bee /export/writeback% ./compare -g ext4 lkp-nex04/*/*-{3.5.0,3.6.0-rc1+}     
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  720.62        -1.5%       710.16  lkp-nex04/JBOD-12HDD-thresh=1000M/ext4-100dd-1-3.5.0
                  706.04        -0.0%       705.86  lkp-nex04/JBOD-12HDD-thresh=1000M/ext4-10dd-1-3.5.0
                  702.86        -0.2%       701.74  lkp-nex04/JBOD-12HDD-thresh=1000M/ext4-1dd-1-3.5.0
                  702.41        -0.0%       702.06  lkp-nex04/JBOD-12HDD-thresh=1000M/ext4-1dd-2-3.5.0
                  779.52        +6.5%       830.11  lkp-nex04/JBOD-12HDD-thresh=100M/ext4-100dd-1-3.5.0
                  646.70        +4.9%       678.59  lkp-nex04/JBOD-12HDD-thresh=100M/ext4-10dd-1-3.5.0
                  704.49        +2.6%       723.00  lkp-nex04/JBOD-12HDD-thresh=100M/ext4-1dd-1-3.5.0
                  704.21        +1.2%       712.47  lkp-nex04/JBOD-12HDD-thresh=100M/ext4-1dd-2-3.5.0
                  705.26        -1.2%       696.61  lkp-nex04/JBOD-12HDD-thresh=8G/ext4-100dd-1-3.5.0
                  703.37        +0.1%       703.76  lkp-nex04/JBOD-12HDD-thresh=8G/ext4-10dd-1-3.5.0
                  701.66        -0.1%       700.83  lkp-nex04/JBOD-12HDD-thresh=8G/ext4-1dd-1-3.5.0
                  701.17        +0.0%       701.36  lkp-nex04/JBOD-12HDD-thresh=8G/ext4-1dd-2-3.5.0
                  675.08       -10.5%       604.29  lkp-nex04/RAID0-12HDD-thresh=1000M/ext4-100dd-1-3.5.0
                  676.52        -2.7%       658.38  lkp-nex04/RAID0-12HDD-thresh=1000M/ext4-10dd-1-3.5.0
                  512.70        +4.0%       533.22  lkp-nex04/RAID0-12HDD-thresh=1000M/ext4-1dd-1-3.5.0
                  524.61        -0.3%       522.90  lkp-nex04/RAID0-12HDD-thresh=1000M/ext4-1dd-2-3.5.0
                  709.76       -15.7%       598.44  lkp-nex04/RAID0-12HDD-thresh=100M/ext4-100dd-1-3.5.0
                  681.39        -2.1%       667.25  lkp-nex04/RAID0-12HDD-thresh=100M/ext4-10dd-1-3.5.0
                  524.16        +0.8%       528.25  lkp-nex04/RAID0-12HDD-thresh=100M/ext4-1dd-2-3.5.0
                  699.77       -19.2%       565.54  lkp-nex04/RAID0-12HDD-thresh=8G/ext4-100dd-1-3.5.0
                  675.79        -1.9%       663.17  lkp-nex04/RAID0-12HDD-thresh=8G/ext4-10dd-1-3.5.0
                  484.84        -7.4%       448.83  lkp-nex04/RAID0-12HDD-thresh=8G/ext4-1dd-1-3.5.0
                  470.40        -3.2%       455.31  lkp-nex04/RAID0-12HDD-thresh=8G/ext4-1dd-2-3.5.0
                  167.97       -38.7%       103.03  lkp-nex04/RAID5-12HDD-thresh=1000M/ext4-100dd-1-3.5.0
                  243.67        -9.1%       221.41  lkp-nex04/RAID5-12HDD-thresh=1000M/ext4-10dd-1-3.5.0
                  248.98       +12.2%       279.33  lkp-nex04/RAID5-12HDD-thresh=1000M/ext4-1dd-1-3.5.0
                  208.45       +14.1%       237.86  lkp-nex04/RAID5-12HDD-thresh=1000M/ext4-1dd-2-3.5.0
                   71.18       -34.2%        46.82  lkp-nex04/RAID5-12HDD-thresh=100M/ext4-100dd-1-3.5.0
                  145.84        -7.3%       135.25  lkp-nex04/RAID5-12HDD-thresh=100M/ext4-10dd-1-3.5.0
                  255.22        +6.7%       272.35  lkp-nex04/RAID5-12HDD-thresh=100M/ext4-1dd-1-3.5.0
                  243.09       +20.7%       293.30  lkp-nex04/RAID5-12HDD-thresh=100M/ext4-1dd-2-3.5.0
                  209.24       -23.6%       159.96  lkp-nex04/RAID5-12HDD-thresh=8G/ext4-100dd-1-3.5.0
                  243.73       -10.9%       217.28  lkp-nex04/RAID5-12HDD-thresh=8G/ext4-10dd-1-3.5.0
                  214.25        +5.6%       226.32  lkp-nex04/RAID5-12HDD-thresh=8G/ext4-1dd-1-3.5.0
                  207.16       +13.4%       234.98  lkp-nex04/RAID5-12HDD-thresh=8G/ext4-1dd-2-3.5.0
                17572.12        -1.9%     17240.05  TOTAL write_bw

Thanks,
Fengguang
