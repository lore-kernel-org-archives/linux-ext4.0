From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 write performance regression in 3.6-rc1 on RAID0/5
Date: Fri, 17 Aug 2012 11:37:35 -0400
Message-ID: <20120817153735.GB31297@thunk.org>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
 <20120816024654.GB3781@thunk.org>
 <20120816111051.GA16036@localhost>
 <20120816152513.GA31346@thunk.org>
 <20120817060915.GB28786@localhost>
 <20120817134039.GB11439@thunk.org>
 <20120817142526.GA1059@localhost>
 <20120817151318.GA2341@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux RAID <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>,
	Li Shaohua <shli@fusionio.com>,
	Marti Raudsepp <marti@juffo.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com,
	"Shi, Alex" <alex.shi@intel.com>, linux-fsdevel@vger.kernel.org
To: Fengguang Wu <fengguang.wu@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120817151318.GA2341@localhost>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Aug 17, 2012 at 11:13:18PM +0800, Fengguang Wu wrote:
> 
> Obviously the major regressions happen to the 100dd over raid cases.
> Some 10dd cases are also impacted.
> 
> The attached graphs show that everything becomes more fluctuated in
> 3.6.0-rc1 for the lkp-nex04/RAID0-12HDD-thresh=8G/ext4-100dd-1 case.

Hmm... I'm not seeing any differences in the block allocation code, or
in ext4's buffered writeback code paths, which would be the most
likely cause of such problems.  Maybe a quick eyeball of the blktrace
to see if we're doing something pathalogically stupid?

You could also try running a filefrag -v on a few of the dd files to
see if there's any significant difference, although as I said, there
doesn't look like there was any significant changes in the block
allocation code between v3.5 and v3.6-rc1 --- although I suppose
changes in timeing could have have caused the block allocation
decisions to be different, so it's worth checking that out.

Thanks, regards,

						- Ted
