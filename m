From: Jacek Luczak <difrost.kernel@gmail.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Fri, 2 Mar 2012 10:51:55 +0100
Message-ID: <CADDYkjRXP8jQXEGoDcfghRgtC-XvS40EZ6U4H1z67fCapz54MA@mail.gmail.com>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
	<CADDYkjRni4i3QvWo+hOn-Ct4mFoTpL1-ydmE7fbzYJmHFhS3_Q@mail.gmail.com>
	<CADDYkjRYrKaBvTQ4Pe6bfemL7r5W=AU468uy0krFAEJD45syow@mail.gmail.com>
	<20120229144244.GF5054@shiny>
	<CADDYkjSEcktUYS+FzoEQ-FH1yMCvq4as5S2LoJyQBPM9=+CoTw@mail.gmail.com>
	<CADDYkjQ-N2+2sJMb9=DZt1vr1=nWkCCdXB2xJAPgkhAuguEPyg@mail.gmail.com>
	<CAJd=RBAs3KGVO8hdUY3peoG1JuxU7_SZ4Z=H0Uy43wLpUFkh7g@mail.gmail.com>
	<CADDYkjR+d+pFYN-mQ91ZP4KcU4zzwC5jmxj1xxMDrp+X+Z8c6g@mail.gmail.com>
	<20120301141823.GV5054@shiny>
	<CADDYkjRs934T2D7DPCk_dcrazptWtLu70=A61R32p22Ee1iXsw@mail.gmail.com>
	<20120301184248.GC32588@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "Ted Ts'o" <tytso@mit.edu>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Hillf Danton <dhillf@gmail.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org,
	lczerner@redhat.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120301184248.GC32588@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2012/3/1 Ted Ts'o <tytso@mit.edu>:
> On Thu, Mar 01, 2012 at 03:43:41PM +0100, Jacek Luczak wrote:
>>
>> Yep, ext4 is close to my wife's closet.
>>
>
> Were all of the file systems freshly laid down, or was this an aged
> ext4 file system?

Always fresh, recreated for each tests - that's why it takes quite
much time as I had to copy the test dir back in places. Env is kept in
all tests as much consistent as possible thus the values should have
credibility.

> Also you should beware that if you have a workload which is heavy
> parallel I/O, with lots of random, read/write accesses to small files,
> a benchmark using tar might not be representative of what you will see
> in production --- different file systems have different strengths and
> weaknesses --- and the fact that ext3/ext4's readdir() returns inodes
> in a non-optimal order for stat(2) or unlink(2) or file copy in the
> cold cache case may not matter as much as you think in a build server.
> (i.e., the directories that do need to be searched will probably be
> serviced out of the dentry cache, etc.)

The set of tests were chosen as is not to find best fs for build purposes.

For a pure builds ext4 is as of now the best and most of the points
you've put above are valid here. We've performed a real tests in a
clone of production environment. Results are not that surprising as
one can find same from e.g. Phoronix test. We've done test in XFS vs
ext[34] and ext4 vs btrfs. Here if we are taking into account only a
software compilation ext4 rocks. Btrfs is only few seconds slower (max
5 in average). The choice then was to use ext4 due to more mature
foundations and support in RHEL. Why we're looking for new one? Well,
the build environment is not only based on software building. There
are e.g. some strange tests running in parallel, code analysis, etc.
Users are doing damn odd things there ... are using Java, you can
imagine how bad bad bad bad zombie java can be. We've failed here and
are not able to isolate each use cases and create profiled
environment. Thus we need to find sth that will provide common sense
for all use cases.

The previous tests shown that ext[34] rocks on compilation timing, but
all around not really. Also one need to remember that fs content
changes often. The ext3 was ageing in 4-6 months of use. XFS on the
other hand was great all around while not in compilation timings.
Roughly 10% is not that much but if hosts is doing builds 24h/7 then
after a few days we've been much behind ext[34] clone env. Btrfs was
only tested against compilation timings, not in general use.

We've created a simple test case for compilation. It's quite not same
as what we got in real env but is good baseline (kernel build system
is too perfect). Simply parallel kernel builds with randomly
allyesconfig or allmodconfig. Below are the seekwatcher graphs of
around 1h of tests running. There were 10 builds (kernels
2.6.20-2.6.29) running with three parallel threads:
1) ext4: http://91.234.146.107/~difrost/seekwatcher/kt_ext4.png
2) btrfs: http://91.234.146.107/~difrost/seekwatcher/kt_btrfs.png
3) both: http://91.234.146.107/~difrost/seekwatcher/kt_btrfs_ext4.png

Above graphs prove that ext4 is ahead in this ,,competition''. I will
try to setup there a real build env to see how those two compare.

-Jacek
