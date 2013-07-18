From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: Prevent massive fs corruption if verifying the
 block bitmap fails
Date: Wed, 17 Jul 2013 17:13:07 -0700
Message-ID: <20130718001307.GC5790@blackbox.djwong.org>
References: <20130717020209.GB5785@blackbox.djwong.org>
 <20130717030832.GB12908@thunk.org>
 <20130717070900.GA5790@blackbox.djwong.org>
 <20130717131951.GC12908@thunk.org>
 <20130717194356.GB5790@blackbox.djwong.org>
 <20130717195503.GC26859@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38040 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab3GRANN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Jul 2013 20:13:13 -0400
Content-Disposition: inline
In-Reply-To: <20130717195503.GC26859@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 17, 2013 at 03:55:03PM -0400, Theodore Ts'o wrote:
> On Wed, Jul 17, 2013 at 12:43:56PM -0700, Darrick J. Wong wrote:
> > I also wrote a script that fills a fs, maliciously marks all the fs metadata
> > blocks as free, and writes more files to the fs, with the result that you
> > corrupt the metadata.  I wonder if it's feasible to modify mballoc to check
> > that it's not handing out well known metadata locations to files?
> 
> We have that --- it's the block_validity mount option.  I use it
> regularly for testing.  It's off by default because it does take a bit

Aha, I thought so. :)

> more CPU time for every single block allocation and deallocation.  It
> would be useful if someone who had access to fast PCIe-attached flash
> tried to measure the CPU utilization of a metadata-intensive workload
> (such as fs_mark) with and without block_validity.  If the overhead is
> negligible, we could enable this by default, and remove the mount
> option.

Well, I don't have a fancy PCIe SSD, but I do have some RAM.  I wrote a program
that simulates the allocation behavior of unpacking a kernel tarball 14 times
via fallocate, and ran it 16 times.  The columns are test-name, elapsed time,
user time, and system time, all in seconds.  Kernel is 3.10, e2fsprogs is
1.43-WIP from last week.

tmpfs file losetup'd:

block_validity,tar:    9.52 0.56 8.31
no_block_validity,tar: 9.47 0.56 8.26

block_validity,del:    7.57 0.30 6.96
no_block_validity,del: 7.56 0.31 6.95

Boring laptop mSATA SSD:

block_validity,tar:    15.24 0.64 8.37
no_block_validity,tar: 14.85 0.63 8.30

block_validity,del:     9.00 0.29 7.06
no_block_validity,del:  9.09 0.30 7.12

Encrypted external USB2 HDD:

block_validity,tar:    59.23 0.62 8.55
no_block_validity,tar: 59.51 0.67 8.51

block_validity,del:    21.05 0.33 7.46
no_block_validity,del: 21.37 0.32 7.71

The allocation test spent 0.6%, 0.8%, and 0.5% more kernel time.  I'm not sure
why the delete test speeds up that much, though.

I can go run mailserver or fsmark or something too if you want.

--D
