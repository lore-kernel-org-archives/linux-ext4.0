From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: NULL pointer dereference in ext4_ext_remove_space on 3.5.1
Date: Fri, 17 Aug 2012 21:22:37 +0800
Message-ID: <20120817132237.GA311@localhost>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
 <20120816024654.GB3781@thunk.org>
 <20120816111051.GA16036@localhost>
 <20120816152513.GA31346@thunk.org>
 <20120817060110.GA28786@localhost>
 <20120817131558.GA11439@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Marti Raudsepp <marti@juffo.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:4610 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294Ab2HQNWq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Aug 2012 09:22:46 -0400
Content-Disposition: inline
In-Reply-To: <20120817131558.GA11439@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Fri, Aug 17, 2012 at 09:15:58AM -0400, Theodore Ts'o wrote:
> Thanks Fengguang:
> 
> For the record, I was able to find my own easy repro, last night using
> only a 220 meg partition:
> 
> # mke2fs -t ext4 -b 1024 -J size=1 /dev/vdc
> # mount -t ext2 /dev/vdc /vdc
> # mkdir /vdc/a
> # cd /vdc/a
> # seq 1 210000  | xargs -n 1 fallocate -l 1m
> # seq 1 2 210000  | xargs /bin/rm
> # mkdir /vdc/b
> # cd /vdc/b
> # seq 1 103 | xargs -n 1 fallocate -l 1g
> # cd /
> # umount /vdc
> # mount -t ext4 -o commit=10000 /dev/vdc /vdc
> # rm -rf /vdc/b

It makes a nice and simple test script, I'd very like to add it to my
0day test system :-)

> For future reference, there are a couple of things that are of
> interest to ext4 developers when trying to create repro's:
> 
> 1)  The use of mounting with ext2 to speed up the setup.
> 
> 2)  The first two "seq ... | xargs ..." commands to create a very
> fragmented file system.
> 
> 3) Using a 1k block size file system to stress the extent tree code
> and htree directory (since its easier to make larger tree structure).
> 
> 4)  The use of the mount option commit=10000 to test what happens when
> the journal is full (without using a nice, fast device such as RAID array
> or without burning write cycles on an expensive flash device.)

Thanks for the directions! I'll make that a big comment.

Thanks,
Fengguang
