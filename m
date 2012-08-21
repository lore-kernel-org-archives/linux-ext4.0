From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: ext4 write performance regression in 3.6-rc1 on RAID0/5
Date: Tue, 21 Aug 2012 17:42:21 +0800
Message-ID: <20120821094221.GA18919@localhost>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
 <20120816024654.GB3781@thunk.org>
 <20120816111051.GA16036@localhost>
 <20120816152513.GA31346@thunk.org>
 <20120817060915.GB28786@localhost>
 <20120817134039.GB11439@thunk.org>
 <20120817142526.GA1059@localhost>
 <20120818064457.7e94d266@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Marti Raudsepp <marti@juffo.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com,
	"Shi, Alex" <alex.shi@intel.com>, linux-fsdevel@vger.kernel.org,
	linux RAID <linux-raid@vger.kernel.org>,
	Li Shaohua <shli@fusionio.com>
To: NeilBrown <neilb@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120818064457.7e94d266@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Aug 18, 2012 at 06:44:57AM +1000, NeilBrown wrote:
> On Fri, 17 Aug 2012 22:25:26 +0800 Fengguang Wu <fengguang.wu@intel.com>
> wrote:
> 
> > [CC md list]
> > 
> > On Fri, Aug 17, 2012 at 09:40:39AM -0400, Theodore Ts'o wrote:
> > > On Fri, Aug 17, 2012 at 02:09:15PM +0800, Fengguang Wu wrote:
> > > > Ted,
> > > > 
> > > > I find ext4 write performance dropped by 3.3% on average in the
> > > > 3.6-rc1 merge window. xfs and btrfs are fine.
> > > > 
> > > > Two machines are tested. The performance regression happens in the
> > > > lkp-nex04 machine, which is equipped with 12 SSD drives. lkp-st02 does
> > > > not see regression, which is equipped with HDD drives. I'll continue
> > > > to repeat the tests and report variations.
> > > 
> > > Hmm... I've checked out the commits in "git log v3.5..v3.6-rc1 --
> > > fs/ext4 fs/jbd2" and I don't see anything that I would expect would
> > > cause that.  The are the lock elimination changes for Direct I/O
> > > overwrites, but that shouldn't matter for your tests which are
> > > measuring buffered writes, correct?
> > > 
> > > Is there any chance you could do me a favor and do a git bisect
> > > restricted to commits involving fs/ext4 and fs/jbd2?
> > 
> > I noticed that the regressions all happen in the RAID0/RAID5 cases.
> > So it may be some interactions between the RAID/ext4 code?
> 
> I'm aware of some performance regression in RAID5 which I will be drilling
> down into next week.  Some things are faster, but some are slower :-(
> 
> RAID0 should be unchanged though - I don't think I've changed anything there.
> 
> Looking at your numbers, JBOD ranges from  +6.5% to -1.5%
>                         RAID0 ranges from  +4.0% to -19.2%
>                         RAID5 ranges from +20.7% to -39.7%
> 
> I'm guessing + is good and - is bad?

Yes.

> The RAID5 numbers don't surprise me.  The RAID0 do.

You are right. I did more tests and it's now obvious that RAID0 is
mostly fine. The major regressions are in the RAID5 10/100dd cases.
JBOD is performing better in 3.6.0-rc1 :-)

> > 
> > I'll try to get some ext2/3 numbers, which should have less changes on the fs side.
> 
> Thanks.  That will be useful.

Here are the more complete results.

   RAID5     ext4    100dd    -7.3%
   RAID5     ext4     10dd    -2.2%
   RAID5     ext4      1dd   +12.1%
   RAID5     ext3    100dd    -3.1%
   RAID5     ext3     10dd   -11.5%
   RAID5     ext3      1dd    +8.9%
   RAID5     ext2    100dd   -10.5%
   RAID5     ext2     10dd    -5.2%
   RAID5     ext2      1dd   +10.0%
   RAID0     ext4    100dd    +1.7%
   RAID0     ext4     10dd    -0.9%
   RAID0     ext4      1dd    -1.1%
   RAID0     ext3    100dd    -4.2%
   RAID0     ext3     10dd    -0.2%
   RAID0     ext3      1dd    -1.0%
   RAID0     ext2    100dd   +11.3%
   RAID0     ext2     10dd    +4.7%
   RAID0     ext2      1dd    -1.6%
    JBOD     ext4    100dd    +5.9%
    JBOD     ext4     10dd    +6.0%
    JBOD     ext4      1dd    +0.6%
    JBOD     ext3    100dd    +6.1%
    JBOD     ext3     10dd    +1.9%
    JBOD     ext3      1dd    +1.7%
    JBOD     ext2    100dd    +9.9%
    JBOD     ext2     10dd    +9.4%
    JBOD     ext2      1dd    +0.5%

wfg@bee /export/writeback% ./compare-groups 'RAID5 RAID0 JBOD' 'ext4 ext3 ext2' '100dd 10dd 1dd' lkp-nex04/*/*-{3.5.0,3.6.0-rc1+}          
RAID5 ext4 100dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  167.97       -38.7%       103.03  lkp-nex04/RAID5-12HDD-thresh=1000M/ext4-100dd-1-3.5.0
                  130.42       -21.7%       102.06  lkp-nex04/RAID5-12HDD-thresh=1000M/ext4-100dd-2-3.5.0
                   83.45       +10.2%        91.96  lkp-nex04/RAID5-12HDD-thresh=1000M/ext4-100dd-3-3.5.0
                  105.97       +11.5%       118.12  lkp-nex04/RAID5-12HDD-thresh=1000M/ext4-100dd-4-3.5.0
                   71.18       -34.2%        46.82  lkp-nex04/RAID5-12HDD-thresh=100M/ext4-100dd-1-3.5.0
                   52.79        +1.1%        53.36  lkp-nex04/RAID5-12HDD-thresh=100M/ext4-100dd-2-3.5.0
                   40.75        -5.1%        38.69  lkp-nex04/RAID5-12HDD-thresh=100M/ext4-100dd-3-3.5.0
                   42.79       +14.5%        48.99  lkp-nex04/RAID5-12HDD-thresh=100M/ext4-100dd-4-3.5.0
                  209.24       -23.6%       159.96  lkp-nex04/RAID5-12HDD-thresh=8G/ext4-100dd-1-3.5.0
                  176.21       +11.3%       196.16  lkp-nex04/RAID5-12HDD-thresh=8G/ext4-100dd-2-3.5.0
                  158.12        +3.7%       163.99  lkp-nex04/RAID5-12HDD-thresh=8G/ext4-100dd-3-3.5.0
                  180.18        +6.4%       191.74  lkp-nex04/RAID5-12HDD-thresh=8G/ext4-100dd-4-3.5.0
                 1419.08        -7.3%      1314.88  TOTAL write_bw

RAID5 ext4 10dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  243.67        -9.1%       221.41  lkp-nex04/RAID5-12HDD-thresh=1000M/ext4-10dd-1-3.5.0
                  212.84       +16.7%       248.39  lkp-nex04/RAID5-12HDD-thresh=1000M/ext4-10dd-2-3.5.0
                  145.84        -7.3%       135.25  lkp-nex04/RAID5-12HDD-thresh=100M/ext4-10dd-1-3.5.0
                  124.61        +3.2%       128.65  lkp-nex04/RAID5-12HDD-thresh=100M/ext4-10dd-2-3.5.0
                  243.73       -10.9%       217.28  lkp-nex04/RAID5-12HDD-thresh=8G/ext4-10dd-1-3.5.0
                  229.35        -2.8%       222.82  lkp-nex04/RAID5-12HDD-thresh=8G/ext4-10dd-2-3.5.0
                 1200.03        -2.2%      1173.81  TOTAL write_bw

RAID5 ext4 1dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  248.98       +12.2%       279.33  lkp-nex04/RAID5-12HDD-thresh=1000M/ext4-1dd-1-3.5.0
                  208.45       +14.1%       237.86  lkp-nex04/RAID5-12HDD-thresh=1000M/ext4-1dd-2-3.5.0
                  255.22        +6.7%       272.35  lkp-nex04/RAID5-12HDD-thresh=100M/ext4-1dd-1-3.5.0
                  243.09       +20.7%       293.30  lkp-nex04/RAID5-12HDD-thresh=100M/ext4-1dd-2-3.5.0
                  214.25        +5.6%       226.32  lkp-nex04/RAID5-12HDD-thresh=8G/ext4-1dd-1-3.5.0
                  207.16       +13.4%       234.98  lkp-nex04/RAID5-12HDD-thresh=8G/ext4-1dd-2-3.5.0
                 1377.15       +12.1%      1544.14  TOTAL write_bw

RAID5 ext3 100dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                   72.75        -5.8%        68.50  lkp-nex04/RAID5-12HDD-thresh=1000M/ext3-100dd-1-3.5.0
                   52.04        +0.8%        52.45  lkp-nex04/RAID5-12HDD-thresh=1000M/ext3-100dd-2-3.5.0
                   48.85       +19.2%        58.21  lkp-nex04/RAID5-12HDD-thresh=1000M/ext3-100dd-3-3.5.0
                   47.04        +9.4%        51.44  lkp-nex04/RAID5-12HDD-thresh=1000M/ext3-100dd-4-3.5.0
                   53.89        -7.4%        49.90  lkp-nex04/RAID5-12HDD-thresh=100M/ext3-100dd-1-3.5.0
                   43.00       -10.7%        38.39  lkp-nex04/RAID5-12HDD-thresh=100M/ext3-100dd-2-3.5.0
                   37.82        +0.8%        38.11  lkp-nex04/RAID5-12HDD-thresh=100M/ext3-100dd-3-3.5.0
                   39.59        -4.0%        38.02  lkp-nex04/RAID5-12HDD-thresh=100M/ext3-100dd-4-3.5.0
                   54.45       -15.0%        46.26  lkp-nex04/RAID5-12HDD-thresh=8G/ext3-100dd-1-3.5.0
                   45.81        -4.5%        43.77  lkp-nex04/RAID5-12HDD-thresh=8G/ext3-100dd-2-3.5.0
                   51.20       -12.6%        44.75  lkp-nex04/RAID5-12HDD-thresh=8G/ext3-100dd-3-3.5.0
                   47.39        -3.9%        45.53  lkp-nex04/RAID5-12HDD-thresh=8G/ext3-100dd-4-3.5.0
                  593.84        -3.1%       575.32  TOTAL write_bw

RAID5 ext3 10dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                   50.29       -10.2%        45.14  lkp-nex04/RAID5-12HDD-thresh=1000M/ext3-10dd-1-3.5.0
                   48.46        -7.1%        45.04  lkp-nex04/RAID5-12HDD-thresh=1000M/ext3-10dd-2-3.5.0
                   67.11       -17.8%        55.16  lkp-nex04/RAID5-12HDD-thresh=100M/ext3-10dd-1-3.5.0
                   75.45       -28.2%        54.21  lkp-nex04/RAID5-12HDD-thresh=100M/ext3-10dd-2-3.5.0
                   42.08        +6.4%        44.78  lkp-nex04/RAID5-12HDD-thresh=8G/ext3-10dd-1-3.5.0
                   40.48        +4.8%        42.44  lkp-nex04/RAID5-12HDD-thresh=8G/ext3-10dd-2-3.5.0
                  323.87       -11.5%       286.76  TOTAL write_bw

RAID5 ext3 1dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  190.20       +14.5%       217.69  lkp-nex04/RAID5-12HDD-thresh=1000M/ext3-1dd-1-3.5.0
                  192.30        +9.4%       210.43  lkp-nex04/RAID5-12HDD-thresh=1000M/ext3-1dd-2-3.5.0
                  193.63       +14.0%       220.64  lkp-nex04/RAID5-12HDD-thresh=100M/ext3-1dd-1-3.5.0
                  224.33        -6.8%       209.07  lkp-nex04/RAID5-12HDD-thresh=100M/ext3-1dd-2-3.5.0
                  188.30       +14.6%       215.83  lkp-nex04/RAID5-12HDD-thresh=8G/ext3-1dd-1-3.5.0
                  179.04       +10.7%       198.17  lkp-nex04/RAID5-12HDD-thresh=8G/ext3-1dd-2-3.5.0
                 1167.79        +8.9%      1271.83  TOTAL write_bw

RAID5 ext2 100dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                   76.75       -17.9%        62.98  lkp-nex04/RAID5-12HDD-thresh=1000M/ext2-100dd-1-3.5.0
                   72.32        -7.7%        66.73  lkp-nex04/RAID5-12HDD-thresh=1000M/ext2-100dd-2-3.5.0
                   56.48        +2.2%        57.75  lkp-nex04/RAID5-12HDD-thresh=1000M/ext2-100dd-3-3.5.0
                   56.81        -1.8%        55.81  lkp-nex04/RAID5-12HDD-thresh=1000M/ext2-100dd-4-3.5.0
                   58.58        -5.0%        55.67  lkp-nex04/RAID5-12HDD-thresh=100M/ext2-100dd-1-3.5.0
                   60.02        -3.1%        58.15  lkp-nex04/RAID5-12HDD-thresh=100M/ext2-100dd-2-3.5.0
                   54.01        -9.1%        49.12  lkp-nex04/RAID5-12HDD-thresh=100M/ext2-100dd-3-3.5.0
                   61.00       -22.3%        47.38  lkp-nex04/RAID5-12HDD-thresh=100M/ext2-100dd-4-3.5.0
                   50.98       -15.2%        43.22  lkp-nex04/RAID5-12HDD-thresh=8G/ext2-100dd-1-3.5.0
                   49.52       -14.8%        42.18  lkp-nex04/RAID5-12HDD-thresh=8G/ext2-100dd-2-3.5.0
                   48.35       -17.2%        40.04  lkp-nex04/RAID5-12HDD-thresh=8G/ext2-100dd-3-3.5.0
                   49.14       -14.8%        41.88  lkp-nex04/RAID5-12HDD-thresh=8G/ext2-100dd-4-3.5.0
                  693.96       -10.5%       620.90  TOTAL write_bw

RAID5 ext2 10dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                   46.88        -0.5%        46.67  lkp-nex04/RAID5-12HDD-thresh=1000M/ext2-10dd-1-3.5.0
                   49.98        -8.8%        45.59  lkp-nex04/RAID5-12HDD-thresh=1000M/ext2-10dd-2-3.5.0
                   45.01        +0.7%        45.32  lkp-nex04/RAID5-12HDD-thresh=100M/ext2-10dd-1-3.5.0
                   84.88       -25.5%        63.27  lkp-nex04/RAID5-12HDD-thresh=100M/ext2-10dd-2-3.5.0
                   44.49       +15.9%        51.56  lkp-nex04/RAID5-12HDD-thresh=8G/ext2-10dd-1-3.5.0
                   43.73        +5.6%        46.19  lkp-nex04/RAID5-12HDD-thresh=8G/ext2-10dd-2-3.5.0
                  314.97        -5.2%       298.60  TOTAL write_bw

RAID5 ext2 1dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  234.85        +7.6%       252.80  lkp-nex04/RAID5-12HDD-thresh=1000M/ext2-1dd-1-3.5.0
                  250.77       +17.9%       295.65  lkp-nex04/RAID5-12HDD-thresh=1000M/ext2-1dd-2-3.5.0
                  205.84        +4.9%       215.93  lkp-nex04/RAID5-12HDD-thresh=100M/ext2-1dd-1-3.5.0
                  213.89        +7.2%       229.37  lkp-nex04/RAID5-12HDD-thresh=100M/ext2-1dd-2-3.5.0
                  217.70       +13.1%       246.25  lkp-nex04/RAID5-12HDD-thresh=8G/ext2-1dd-1-3.5.0
                  241.22        +8.3%       261.19  lkp-nex04/RAID5-12HDD-thresh=8G/ext2-1dd-2-3.5.0
                 1364.27       +10.0%      1501.19  TOTAL write_bw

RAID0 ext4 100dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  675.08       -10.5%       604.29  lkp-nex04/RAID0-12HDD-thresh=1000M/ext4-100dd-1-3.5.0
                  640.40        -0.8%       635.21  lkp-nex04/RAID0-12HDD-thresh=1000M/ext4-100dd-2-3.5.0
                  370.03        +4.9%       388.06  lkp-nex04/RAID0-12HDD-thresh=1000M/ext4-100dd-3-3.5.0
                  376.90        +6.1%       399.96  lkp-nex04/RAID0-12HDD-thresh=1000M/ext4-100dd-4-3.5.0
                  709.76       -15.7%       598.44  lkp-nex04/RAID0-12HDD-thresh=100M/ext4-100dd-1-3.5.0
                  399.91       +52.7%       610.76  lkp-nex04/RAID0-12HDD-thresh=100M/ext4-100dd-2-3.5.0
                  342.58        +6.3%       364.24  lkp-nex04/RAID0-12HDD-thresh=100M/ext4-100dd-3-3.5.0
                  300.55       +24.6%       374.34  lkp-nex04/RAID0-12HDD-thresh=100M/ext4-100dd-4-3.5.0
                  699.77       -19.2%       565.54  lkp-nex04/RAID0-12HDD-thresh=8G/ext4-100dd-1-3.5.0
                  582.28        -1.5%       573.28  lkp-nex04/RAID0-12HDD-thresh=8G/ext4-100dd-2-3.5.0
                  491.00        +8.4%       532.13  lkp-nex04/RAID0-12HDD-thresh=8G/ext4-100dd-3-3.5.0
                  485.84        +9.5%       532.12  lkp-nex04/RAID0-12HDD-thresh=8G/ext4-100dd-4-3.5.0
                 6074.09        +1.7%      6178.38  TOTAL write_bw

RAID0 ext4 10dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  676.52        -2.7%       658.38  lkp-nex04/RAID0-12HDD-thresh=1000M/ext4-10dd-1-3.5.0
                  626.18        -3.2%       606.21  lkp-nex04/RAID0-12HDD-thresh=1000M/ext4-10dd-2-3.5.0
                  681.39        -2.1%       667.25  lkp-nex04/RAID0-12HDD-thresh=100M/ext4-10dd-1-3.5.0
                  630.30        +3.4%       651.81  lkp-nex04/RAID0-12HDD-thresh=100M/ext4-10dd-2-3.5.0
                  675.79        -1.9%       663.17  lkp-nex04/RAID0-12HDD-thresh=8G/ext4-10dd-1-3.5.0
                  665.04        +1.3%       673.54  lkp-nex04/RAID0-12HDD-thresh=8G/ext4-10dd-2-3.5.0
                 3955.21        -0.9%      3920.37  TOTAL write_bw

RAID0 ext4 1dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  512.70        +4.0%       533.22  lkp-nex04/RAID0-12HDD-thresh=1000M/ext4-1dd-1-3.5.0
                  524.61        -0.3%       522.90  lkp-nex04/RAID0-12HDD-thresh=1000M/ext4-1dd-2-3.5.0
                  524.16        +0.8%       528.25  lkp-nex04/RAID0-12HDD-thresh=100M/ext4-1dd-2-3.5.0
                  484.84        -7.4%       448.83  lkp-nex04/RAID0-12HDD-thresh=8G/ext4-1dd-1-3.5.0
                  470.40        -3.2%       455.31  lkp-nex04/RAID0-12HDD-thresh=8G/ext4-1dd-2-3.5.0
                 2516.71        -1.1%      2488.51  TOTAL write_bw

RAID0 ext3 100dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  500.94        -4.0%       481.11  lkp-nex04/RAID0-12HDD-thresh=1000M/ext3-100dd-1-3.5.0
                  494.13        -4.3%       473.13  lkp-nex04/RAID0-12HDD-thresh=1000M/ext3-100dd-2-3.5.0
                  513.57        -9.2%       466.07  lkp-nex04/RAID0-12HDD-thresh=1000M/ext3-100dd-3-3.5.0
                  490.19        -5.9%       461.42  lkp-nex04/RAID0-12HDD-thresh=1000M/ext3-100dd-4-3.5.0
                  511.08        -2.9%       496.04  lkp-nex04/RAID0-12HDD-thresh=100M/ext3-100dd-1-3.5.0
                  520.57        -7.6%       480.95  lkp-nex04/RAID0-12HDD-thresh=100M/ext3-100dd-2-3.5.0
                  523.62        -5.2%       496.52  lkp-nex04/RAID0-12HDD-thresh=100M/ext3-100dd-3-3.5.0
                  497.72        -0.1%       497.16  lkp-nex04/RAID0-12HDD-thresh=100M/ext3-100dd-4-3.5.0
                  470.99        -5.0%       447.64  lkp-nex04/RAID0-12HDD-thresh=8G/ext3-100dd-1-3.5.0
                  444.63        +2.0%       453.54  lkp-nex04/RAID0-12HDD-thresh=8G/ext3-100dd-2-3.5.0
                  448.25        -4.7%       427.18  lkp-nex04/RAID0-12HDD-thresh=8G/ext3-100dd-3-3.5.0
                  475.57        -3.1%       460.84  lkp-nex04/RAID0-12HDD-thresh=8G/ext3-100dd-4-3.5.0
                 5891.26        -4.2%      5641.62  TOTAL write_bw

RAID0 ext3 10dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  560.26        +2.8%       576.15  lkp-nex04/RAID0-12HDD-thresh=1000M/ext3-10dd-1-3.5.0
                  583.44        +0.5%       586.08  lkp-nex04/RAID0-12HDD-thresh=1000M/ext3-10dd-2-3.5.0
                  566.37        -3.2%       548.19  lkp-nex04/RAID0-12HDD-thresh=100M/ext3-10dd-1-3.5.0
                  579.37        -2.1%       567.13  lkp-nex04/RAID0-12HDD-thresh=100M/ext3-10dd-2-3.5.0
                  623.24        +0.2%       624.71  lkp-nex04/RAID0-12HDD-thresh=8G/ext3-10dd-1-3.5.0
                  624.26        +0.7%       628.74  lkp-nex04/RAID0-12HDD-thresh=8G/ext3-10dd-2-3.5.0
                 3536.93        -0.2%      3531.00  TOTAL write_bw

RAID0 ext3 1dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  351.69        -2.3%       343.73  lkp-nex04/RAID0-12HDD-thresh=1000M/ext3-1dd-1-3.5.0
                  355.50        -4.1%       340.77  lkp-nex04/RAID0-12HDD-thresh=1000M/ext3-1dd-2-3.5.0
                  383.34        +0.9%       386.96  lkp-nex04/RAID0-12HDD-thresh=100M/ext3-1dd-1-3.5.0
                  385.74        +1.3%       390.69  lkp-nex04/RAID0-12HDD-thresh=100M/ext3-1dd-2-3.5.0
                  315.53        -0.2%       314.81  lkp-nex04/RAID0-12HDD-thresh=8G/ext3-1dd-1-3.5.0
                  319.52        -1.9%       313.36  lkp-nex04/RAID0-12HDD-thresh=8G/ext3-1dd-2-3.5.0
                 2111.31        -1.0%      2090.32  TOTAL write_bw

RAID0 ext2 100dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  694.06        +0.0%       694.22  lkp-nex04/RAID0-12HDD-thresh=1000M/ext2-100dd-1-3.5.0
                  693.19        -0.1%       692.38  lkp-nex04/RAID0-12HDD-thresh=1000M/ext2-100dd-2-3.5.0
                  686.16        +1.2%       694.35  lkp-nex04/RAID0-12HDD-thresh=1000M/ext2-100dd-3-3.5.0
                  691.17        -0.2%       690.13  lkp-nex04/RAID0-12HDD-thresh=1000M/ext2-100dd-4-3.5.0
                  668.16        +1.3%       677.07  lkp-nex04/RAID0-12HDD-thresh=100M/ext2-100dd-1-3.5.0
                  404.60       +62.9%       658.90  lkp-nex04/RAID0-12HDD-thresh=100M/ext2-100dd-2-3.5.0
                  346.48       +81.1%       627.62  lkp-nex04/RAID0-12HDD-thresh=100M/ext2-100dd-3-3.5.0
                  373.48       +71.3%       639.85  lkp-nex04/RAID0-12HDD-thresh=100M/ext2-100dd-4-3.5.0
                  691.96        +0.2%       693.29  lkp-nex04/RAID0-12HDD-thresh=8G/ext2-100dd-1-3.5.0
                  690.73        +0.5%       694.40  lkp-nex04/RAID0-12HDD-thresh=8G/ext2-100dd-2-3.5.0
                  692.65        +0.1%       693.27  lkp-nex04/RAID0-12HDD-thresh=8G/ext2-100dd-3-3.5.0
                  690.10        +0.2%       691.71  lkp-nex04/RAID0-12HDD-thresh=8G/ext2-100dd-4-3.5.0
                 7322.74       +11.3%      8147.20  TOTAL write_bw

RAID0 ext2 10dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  247.29       +23.2%       304.58  lkp-nex04/RAID0-12HDD-thresh=1000M/ext2-10dd-1-3.5.0
                  697.35        +0.4%       700.38  lkp-nex04/RAID0-12HDD-thresh=1000M/ext2-10dd-2-3.5.0
                  662.14        +1.8%       673.83  lkp-nex04/RAID0-12HDD-thresh=100M/ext2-10dd-1-3.5.0
                  613.81       +10.0%       675.44  lkp-nex04/RAID0-12HDD-thresh=100M/ext2-10dd-2-3.5.0
                  337.37        +5.5%       355.95  lkp-nex04/RAID0-12HDD-thresh=8G/ext2-10dd-1-3.5.0
                  682.57        +0.0%       682.90  lkp-nex04/RAID0-12HDD-thresh=8G/ext2-10dd-2-3.5.0
                 3240.53        +4.7%      3393.07  TOTAL write_bw

RAID0 ext2 1dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  526.72        -4.1%       505.29  lkp-nex04/RAID0-12HDD-thresh=1000M/ext2-1dd-1-3.5.0
                  516.77        -0.6%       513.81  lkp-nex04/RAID0-12HDD-thresh=1000M/ext2-1dd-2-3.5.0
                  617.83        +0.3%       619.45  lkp-nex04/RAID0-12HDD-thresh=100M/ext2-1dd-1-3.5.0
                  617.49        +0.6%       621.09  lkp-nex04/RAID0-12HDD-thresh=100M/ext2-1dd-2-3.5.0
                  502.60        -1.0%       497.39  lkp-nex04/RAID0-12HDD-thresh=8G/ext2-1dd-1-3.5.0
                  504.82        -5.7%       475.86  lkp-nex04/RAID0-12HDD-thresh=8G/ext2-1dd-2-3.5.0
                 3286.22        -1.6%      3232.89  TOTAL write_bw

JBOD ext4 100dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  720.62        -1.5%       710.16  lkp-nex04/JBOD-12HDD-thresh=1000M/ext4-100dd-1-3.5.0
                  469.82       +14.3%       536.78  lkp-nex04/JBOD-12HDD-thresh=1000M/ext4-100dd-2-3.5.0
                  666.90        -2.6%       649.61  lkp-nex04/JBOD-12HDD-thresh=1000M/ext4-100dd-3-3.5.0
                  343.93       +24.1%       426.86  lkp-nex04/JBOD-12HDD-thresh=1000M/ext4-100dd-4-3.5.0
                  779.52        +6.5%       830.11  lkp-nex04/JBOD-12HDD-thresh=100M/ext4-100dd-1-3.5.0
                  457.65        -1.4%       451.18  lkp-nex04/JBOD-12HDD-thresh=100M/ext4-100dd-2-3.5.0
                  739.08        +5.7%       781.16  lkp-nex04/JBOD-12HDD-thresh=100M/ext4-100dd-3-3.5.0
                  332.98        -9.6%       301.13  lkp-nex04/JBOD-12HDD-thresh=100M/ext4-100dd-4-3.5.0
                  705.26        -1.2%       696.61  lkp-nex04/JBOD-12HDD-thresh=8G/ext4-100dd-1-3.5.0
                  565.73       +16.8%       660.76  lkp-nex04/JBOD-12HDD-thresh=8G/ext4-100dd-2-3.5.0
                  647.47        +5.3%       681.63  lkp-nex04/JBOD-12HDD-thresh=8G/ext4-100dd-3-3.5.0
                  416.22       +25.5%       522.50  lkp-nex04/JBOD-12HDD-thresh=8G/ext4-100dd-4-3.5.0
                 6845.19        +5.9%      7248.49  TOTAL write_bw

JBOD ext4 10dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  706.04        -0.0%       705.86  lkp-nex04/JBOD-12HDD-thresh=1000M/ext4-10dd-1-3.5.0
                  525.34       +12.1%       589.06  lkp-nex04/JBOD-12HDD-thresh=1000M/ext4-10dd-2-3.5.0
                  646.70        +4.9%       678.59  lkp-nex04/JBOD-12HDD-thresh=100M/ext4-10dd-1-3.5.0
                  335.12       +25.1%       419.10  lkp-nex04/JBOD-12HDD-thresh=100M/ext4-10dd-2-3.5.0
                  703.37        +0.1%       703.76  lkp-nex04/JBOD-12HDD-thresh=8G/ext4-10dd-1-3.5.0
                  665.60        +5.4%       701.85  lkp-nex04/JBOD-12HDD-thresh=8G/ext4-10dd-2-3.5.0
                 3582.17        +6.0%      3798.23  TOTAL write_bw

JBOD ext4 1dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  702.86        -0.2%       701.74  lkp-nex04/JBOD-12HDD-thresh=1000M/ext4-1dd-1-3.5.0
                  702.41        -0.0%       702.06  lkp-nex04/JBOD-12HDD-thresh=1000M/ext4-1dd-2-3.5.0
                  704.49        +2.6%       723.00  lkp-nex04/JBOD-12HDD-thresh=100M/ext4-1dd-1-3.5.0
                  704.21        +1.2%       712.47  lkp-nex04/JBOD-12HDD-thresh=100M/ext4-1dd-2-3.5.0
                  701.66        -0.1%       700.83  lkp-nex04/JBOD-12HDD-thresh=8G/ext4-1dd-1-3.5.0
                  701.17        +0.0%       701.36  lkp-nex04/JBOD-12HDD-thresh=8G/ext4-1dd-2-3.5.0
                 4216.81        +0.6%      4241.46  TOTAL write_bw

JBOD ext3 100dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  683.15        -3.8%       657.31  lkp-nex04/JBOD-12HDD-thresh=1000M/ext3-100dd-1-3.5.0
                  711.48        -0.1%       710.83  lkp-nex04/JBOD-12HDD-thresh=1000M/ext3-100dd-2-3.5.0
                  677.50        +0.0%       677.62  lkp-nex04/JBOD-12HDD-thresh=1000M/ext3-100dd-3-3.5.0
                  713.31        -0.5%       709.88  lkp-nex04/JBOD-12HDD-thresh=1000M/ext3-100dd-4-3.5.0
                  648.70       +16.1%       753.15  lkp-nex04/JBOD-12HDD-thresh=100M/ext3-100dd-1-3.5.0
                  633.24       +26.5%       801.02  lkp-nex04/JBOD-12HDD-thresh=100M/ext3-100dd-2-3.5.0
                  568.48       +23.8%       703.49  lkp-nex04/JBOD-12HDD-thresh=100M/ext3-100dd-3-3.5.0
                  680.59       +21.6%       827.77  lkp-nex04/JBOD-12HDD-thresh=100M/ext3-100dd-4-3.5.0
                  656.73        -0.9%       651.09  lkp-nex04/JBOD-12HDD-thresh=8G/ext3-100dd-1-3.5.0
                  697.29        -0.3%       695.49  lkp-nex04/JBOD-12HDD-thresh=8G/ext3-100dd-2-3.5.0
                  669.99        -1.9%       657.24  lkp-nex04/JBOD-12HDD-thresh=8G/ext3-100dd-3-3.5.0
                  697.73        -2.1%       683.17  lkp-nex04/JBOD-12HDD-thresh=8G/ext3-100dd-4-3.5.0
                 8038.18        +6.1%      8528.06  TOTAL write_bw

JBOD ext3 10dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  669.69        -1.0%       663.26  lkp-nex04/JBOD-12HDD-thresh=1000M/ext3-10dd-1-3.5.0
                  704.60        +0.3%       707.03  lkp-nex04/JBOD-12HDD-thresh=1000M/ext3-10dd-2-3.5.0
                  629.95        +3.0%       648.55  lkp-nex04/JBOD-12HDD-thresh=100M/ext3-10dd-1-3.5.0
                  616.65        +9.6%       676.08  lkp-nex04/JBOD-12HDD-thresh=100M/ext3-10dd-2-3.5.0
                  691.77        +0.6%       695.88  lkp-nex04/JBOD-12HDD-thresh=8G/ext3-10dd-1-3.5.0
                  706.05        -0.2%       704.95  lkp-nex04/JBOD-12HDD-thresh=8G/ext3-10dd-2-3.5.0
                 4018.71        +1.9%      4095.75  TOTAL write_bw

JBOD ext3 1dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  700.88        +0.1%       701.30  lkp-nex04/JBOD-12HDD-thresh=1000M/ext3-1dd-1-3.5.0
                  699.78        +0.1%       700.27  lkp-nex04/JBOD-12HDD-thresh=1000M/ext3-1dd-2-3.5.0
                  700.07        -0.0%       699.98  lkp-nex04/JBOD-12HDD-thresh=100M/ext3-1dd-1-3.5.0
                  598.09       +11.7%       668.09  lkp-nex04/JBOD-12HDD-thresh=100M/ext3-1dd-2-3.5.0
                  700.53        -0.0%       700.47  lkp-nex04/JBOD-12HDD-thresh=8G/ext3-1dd-1-3.5.0
                  700.65        +0.1%       701.43  lkp-nex04/JBOD-12HDD-thresh=8G/ext3-1dd-2-3.5.0
                 4100.00        +1.7%      4171.54  TOTAL write_bw

JBOD ext2 100dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  644.32        +6.1%       683.56  lkp-nex04/JBOD-12HDD-thresh=1000M/ext2-100dd-1-3.5.0
                  558.44       +16.9%       652.63  lkp-nex04/JBOD-12HDD-thresh=1000M/ext2-100dd-2-3.5.0
                  443.68       +30.1%       577.18  lkp-nex04/JBOD-12HDD-thresh=1000M/ext2-100dd-3-3.5.0
                  449.28       +36.8%       614.49  lkp-nex04/JBOD-12HDD-thresh=1000M/ext2-100dd-4-3.5.0
                  526.02       +10.2%       579.52  lkp-nex04/JBOD-12HDD-thresh=100M/ext2-100dd-1-3.5.0
                  442.03       +10.6%       488.71  lkp-nex04/JBOD-12HDD-thresh=100M/ext2-100dd-2-3.5.0
                  375.04        -5.5%       354.36  lkp-nex04/JBOD-12HDD-thresh=100M/ext2-100dd-3-3.5.0
                  365.83        +3.9%       379.96  lkp-nex04/JBOD-12HDD-thresh=100M/ext2-100dd-4-3.5.0
                  693.56        +0.8%       699.06  lkp-nex04/JBOD-12HDD-thresh=8G/ext2-100dd-1-3.5.0
                  661.00        +3.3%       682.82  lkp-nex04/JBOD-12HDD-thresh=8G/ext2-100dd-2-3.5.0
                  584.28        +9.1%       637.22  lkp-nex04/JBOD-12HDD-thresh=8G/ext2-100dd-3-3.5.0
                  657.01        +4.2%       684.28  lkp-nex04/JBOD-12HDD-thresh=8G/ext2-100dd-4-3.5.0
                 6400.48        +9.9%      7033.79  TOTAL write_bw

JBOD ext2 10dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  662.51        +3.4%       685.05  lkp-nex04/JBOD-12HDD-thresh=1000M/ext2-10dd-1-3.5.0
                  665.07        +3.2%       686.05  lkp-nex04/JBOD-12HDD-thresh=1000M/ext2-10dd-2-3.5.0
                  431.26       +26.9%       547.16  lkp-nex04/JBOD-12HDD-thresh=100M/ext2-10dd-1-3.5.0
                  397.42       +39.4%       553.83  lkp-nex04/JBOD-12HDD-thresh=100M/ext2-10dd-2-3.5.0
                  685.99        +0.9%       691.90  lkp-nex04/JBOD-12HDD-thresh=8G/ext2-10dd-1-3.5.0
                  685.68        +1.2%       693.94  lkp-nex04/JBOD-12HDD-thresh=8G/ext2-10dd-2-3.5.0
                 3527.93        +9.4%      3857.93  TOTAL write_bw

JBOD ext2 1dd
                   3.5.0                3.6.0-rc1+
------------------------  ------------------------
                  718.45        -0.1%       717.89  lkp-nex04/JBOD-12HDD-thresh=1000M/ext2-1dd-1-3.5.0
                  717.25        +0.2%       718.89  lkp-nex04/JBOD-12HDD-thresh=1000M/ext2-1dd-2-3.5.0
                  686.97        +1.0%       693.82  lkp-nex04/JBOD-12HDD-thresh=100M/ext2-1dd-1-3.5.0
                  683.79        +1.5%       694.03  lkp-nex04/JBOD-12HDD-thresh=100M/ext2-1dd-2-3.5.0
                  699.79        +0.1%       700.41  lkp-nex04/JBOD-12HDD-thresh=8G/ext2-1dd-1-3.5.0
                  700.22        +0.1%       701.15  lkp-nex04/JBOD-12HDD-thresh=8G/ext2-1dd-2-3.5.0
                 4206.46        +0.5%      4226.19  TOTAL write_bw
