From: Dexuan Cui <decui@microsoft.com>
Subject: RE: ext4: performance regression introduced by the cgroup writeback
 support
Date: Thu, 24 Sep 2015 00:12:30 +0000
Message-ID: <d9d2300ea9fd4dd29a2e02c66e68a2ec@SIXPR30MB031.064d.mgd.msft.net>
References: <f30d4a6aa8a546ff88f73021d026a453@SIXPR30MB031.064d.mgd.msft.net>
 <20150923161359.GB25218@ret.masoncoding.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Tejun Heo <tj@kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Chris Mason <clm@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150923161359.GB25218@ret.masoncoding.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> -----Original Message-----
> From: Chris Mason [mailto:clm@fb.com]
> Sent: Thursday, September 24, 2015 0:14
> To: Dexuan Cui <decui@microsoft.com>
> Cc: Theodore Ts'o <tytso@mit.edu>; Andreas Dilger <adilger.kernel@dilger.ca>;
> Tejun Heo <tj@kernel.org>; linux-ext4@vger.kernel.org; linux-
> fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: ext4: performance regression introduced by the cgroup writeback
> support
> 
> On Wed, Sep 23, 2015 at 01:49:31PM +0000, Dexuan Cui wrote:
> > Hi all,
> > Since some point between July and Sep, I have been suffered from a strange
> "very slow write" issue and on Sep 9 I reported it to LKML (but got no reply):
> https://na01.safelinks.protection.outlook.com/?url=https%3a%2f%2flkml.org%
> 2flkml%2f2015%2f9%2f9%2f290&data=01%7c01%7cdecui%40064d.mgd.micros
> oft.com%7c8001aa10249f41a0363608d2c432042d%7c72f988bf86f141af91ab2
> d7cd011db47%7c1&sdata=oJBsP55jdg86TNt2X71s0gfPlwbMTzaJN9QIcsXsSmA%
> 3d
> >
> > The issue is: under high CPU and disk I/O pressure, *some* processes can
> suffer from a very slow write speed (e.g., <1MB/s or even only 20KB/s), while
> the normal write speed should be at least dozens of MB/s.
> >
> > I think I identified the commit which introduced the regression:
> > ext4: implement cgroup writeback support
> (https://na01.safelinks.protection.outlook.com/?url=https%3a%2f%2fgit.kernel.
> org%2fcgit%2flinux%2fkernel%2fgit%2fnext%2flinux-
> next.git%2fcommit%2f%3fid%3d001e4a8775f6e8ad52a89e0072f09aee47d5d25
> 2&data=01%7c01%7cdecui%40064d.mgd.microsoft.com%7c8001aa10249f41a0
> 363608d2c432042d%7c72f988bf86f141af91ab2d7cd011db47%7c1&sdata=QIcX
> R%2flZMqkK2afIxV%2fYxZDug26vj5yx%2bkoh6ugJB2A%3d)
> >
> > This commit is already in the mainline tree, so I can reproduce the issue there
> too:
> > With the latest mainline,  I can reproduce the issue; after I revert the patch, I
> can't reproduce the issue.
> >
> > When the issue happens:
> > 1. the read speed is pretty normal, e.g.. it's still >100MB/s.
> > 2. 'top' shows both the 'user' and 'sys' utilization is about 0%, but the IO-wait is
> always about 100%.
> > 3. 'iotop' shows the read speed is 0 (this is correct because there is indeed no
> read request)  and the write speed is pretty slow (the average is <1MB/s or even
> 20KB/s).
> > 4. when the issue happens, sometimes any new process suffers from the slow
> write issue, but sometimes it looks not all the new processes suffers from the
> issue.
> > 5. The " WARNING: CPU: 7 PID: 6782 at fs/inode.c:390 ihold+0x30/0x40() " in
> my Sep-9 mail may be another different issue.
> > 6. To reproduce the issue, I need to run my workload for enough long time
> (see the below).
> >
> > My workload is simple: I just repeatedly build the kernel source ("make clean;
> make -j16"). My kernel config is attached FYI.
> >
> > I can reproduce the issue on a physical machine: e.g., in my kernel building test
> with my .config, it took only ~5 minutes in the first 176 runs, but since the 177th
> run, it could take from 10 hours to 5 minutes - very unstable.
> >
> > It looks it's easier to reproduce the issue in a Hyper-V VM: usually I can
> reproduce the issue within the first 10 or 20 runs.
> >
> > Any idea?
> 
> Are you using cgroups?  That patch really shouldn't impact load unless
> there are actual IO controls in place.
> 
> -chris

I'm not using cgroups here.

Tejun just now found the root cause: "Separate wb domains
shouldn't have been enabled on traditional hierarchies " and supplied a fix.

Thanks,
-- Dexuan
