From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: ext4 write performance regression in 3.6-rc1 on RAID0/5
Date: Tue, 21 Aug 2012 20:07:11 +0800
Message-ID: <20120821120711.GA21736@localhost>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
 <20120816024654.GB3781@thunk.org>
 <20120816111051.GA16036@localhost>
 <20120816152513.GA31346@thunk.org>
 <20120817060915.GB28786@localhost>
 <20120817134039.GB11439@thunk.org>
 <20120817142526.GA1059@localhost>
 <20120818064457.7e94d266@notabene.brown>
 <20120821094221.GA18919@localhost>
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
In-Reply-To: <20120821094221.GA18919@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Aug 21, 2012 at 05:42:21PM +0800, Fengguang Wu wrote:
> On Sat, Aug 18, 2012 at 06:44:57AM +1000, NeilBrown wrote:
> > On Fri, 17 Aug 2012 22:25:26 +0800 Fengguang Wu <fengguang.wu@intel.com>
> > wrote:
> > 
> > > [CC md list]
> > > 
> > > On Fri, Aug 17, 2012 at 09:40:39AM -0400, Theodore Ts'o wrote:
> > > > On Fri, Aug 17, 2012 at 02:09:15PM +0800, Fengguang Wu wrote:
> > > > > Ted,
> > > > > 
> > > > > I find ext4 write performance dropped by 3.3% on average in the
> > > > > 3.6-rc1 merge window. xfs and btrfs are fine.
> > > > > 
> > > > > Two machines are tested. The performance regression happens in the
> > > > > lkp-nex04 machine, which is equipped with 12 SSD drives. lkp-st02 does
> > > > > not see regression, which is equipped with HDD drives. I'll continue
> > > > > to repeat the tests and report variations.
> > > > 
> > > > Hmm... I've checked out the commits in "git log v3.5..v3.6-rc1 --
> > > > fs/ext4 fs/jbd2" and I don't see anything that I would expect would
> > > > cause that.  The are the lock elimination changes for Direct I/O
> > > > overwrites, but that shouldn't matter for your tests which are
> > > > measuring buffered writes, correct?
> > > > 
> > > > Is there any chance you could do me a favor and do a git bisect
> > > > restricted to commits involving fs/ext4 and fs/jbd2?
> > > 
> > > I noticed that the regressions all happen in the RAID0/RAID5 cases.
> > > So it may be some interactions between the RAID/ext4 code?
> > 
> > I'm aware of some performance regression in RAID5 which I will be drilling
> > down into next week.  Some things are faster, but some are slower :-(
> > 
> > RAID0 should be unchanged though - I don't think I've changed anything there.
> > 
> > Looking at your numbers, JBOD ranges from  +6.5% to -1.5%
> >                         RAID0 ranges from  +4.0% to -19.2%
> >                         RAID5 ranges from +20.7% to -39.7%
> > 
> > I'm guessing + is good and - is bad?
> 
> Yes.
> 
> > The RAID5 numbers don't surprise me.  The RAID0 do.
> 
> You are right. I did more tests and it's now obvious that RAID0 is
> mostly fine. The major regressions are in the RAID5 10/100dd cases.
> JBOD is performing better in 3.6.0-rc1 :-)
> 
> > > 
> > > I'll try to get some ext2/3 numbers, which should have less changes on the fs side.
> > 
> > Thanks.  That will be useful.
> 
> Here are the more complete results.
> 
>    RAID5     ext4    100dd    -7.3%
>    RAID5     ext4     10dd    -2.2%
>    RAID5     ext4      1dd   +12.1%
>    RAID5     ext3    100dd    -3.1%
>    RAID5     ext3     10dd   -11.5%
>    RAID5     ext3      1dd    +8.9%
>    RAID5     ext2    100dd   -10.5%
>    RAID5     ext2     10dd    -5.2%
>    RAID5     ext2      1dd   +10.0%
>    RAID0     ext4    100dd    +1.7%
>    RAID0     ext4     10dd    -0.9%
>    RAID0     ext4      1dd    -1.1%
>    RAID0     ext3    100dd    -4.2%
>    RAID0     ext3     10dd    -0.2%
>    RAID0     ext3      1dd    -1.0%
>    RAID0     ext2    100dd   +11.3%
>    RAID0     ext2     10dd    +4.7%
>    RAID0     ext2      1dd    -1.6%
>     JBOD     ext4    100dd    +5.9%
>     JBOD     ext4     10dd    +6.0%
>     JBOD     ext4      1dd    +0.6%
>     JBOD     ext3    100dd    +6.1%
>     JBOD     ext3     10dd    +1.9%
>     JBOD     ext3      1dd    +1.7%
>     JBOD     ext2    100dd    +9.9%
>     JBOD     ext2     10dd    +9.4%
>     JBOD     ext2      1dd    +0.5%

And here are the xfs/btrfs results. Very impressive RAID5 improvements!

   RAID5    btrfs    100dd   +25.8%
   RAID5    btrfs     10dd   +21.3%
   RAID5    btrfs      1dd   +14.3%
   RAID5      xfs    100dd   +32.8%
   RAID5      xfs     10dd   +21.5%
   RAID5      xfs      1dd   +25.2%
   RAID0    btrfs    100dd    -7.4%
   RAID0    btrfs     10dd    -0.2%
   RAID0    btrfs      1dd    -2.8%
   RAID0      xfs    100dd   +18.8%
   RAID0      xfs     10dd    +0.0%
   RAID0      xfs      1dd    +3.8%
    JBOD    btrfs    100dd    -0.0%
    JBOD    btrfs     10dd    +2.3%
    JBOD    btrfs      1dd    -0.1%
    JBOD      xfs    100dd    +8.3%
    JBOD      xfs     10dd    +4.1%
    JBOD      xfs      1dd    +0.1%

Thanks,
Fengguang
