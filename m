From: Eric Sesterhenn <snakebyte@gmx.de>
Subject: Re: BUG_ON at mballoc.c:3752
Date: Mon, 4 Feb 2008 09:29:36 +0100
Message-ID: <20080204082936.GB5284@alice>
References: <20080131140137.GA20780@alice> <20080131154207.GA22201@alice> <20080204060055.GC7494@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56133 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753757AbYBDI3j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Feb 2008 03:29:39 -0500
Content-Disposition: inline
In-Reply-To: <20080204060055.GC7494@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Aneesh Kumar K.V (aneesh.kumar@linux.vnet.ibm.com) wrote:
> On Thu, Jan 31, 2008 at 04:42:07PM +0100, Eric Sesterhenn wrote:
> > * Eric Sesterhenn (snakebyte@gmx.de) wrote:
> > > hi,
> > > 
> > > while running a modified version of fsfuzzer i triggered the BUG() in
> > > ext4_mb_release_inode_pa(). Sadly I am not able to reproduce this using
> > > the generated image, but running the fuzzer will usually trigger this in
> > > less than 40 attempts. Increasing the JBD2 Debug level didnt give more
> > > information. The kernel is current git with
> > > ext4-fix-null-pointer-deref-in-journal_wait_on_commit_record.patch
> > > applied. 
> > 
> > I am now able to reproduce this using this image:
> > http://www.cccmz.de/~snakebyte/ext4.24.img.bz2
> > 
> > the following commands will trigger the oops for me
> > 
> > mount cfs/ext4.24.img /media/test -t ext4dev -o extents -o loop
> > mkdir /media/test/stress
> > chown snakebyte:snakebyte /media/test/stress && sudo -u snakebyte fstest -n 10 -l 10 -f 5 -s 40000 -p /media/test/stress/
> > 
> 
> The file system is corrupted. The BUG_ON indicate that the free spcae
> marked in the prealloc space and found by looking at the bitmap are not
> same. Do you have a set of steps that i can follow to reproduce this ?

just compile the mangle.c and run the modified fuzzer for a while (link
below) or use the steps above

> on a clean file system ?

had no luck on a clean fs with this

> Where do i find the fsfuzzer that you are using ?

http://www.cccmz.de/~snakebyte/fsfuzzer-0.6-lmh-eric.tar.bz2
http://www.cccmz.de/~snakebyte/fsfuzz.diff

needs user/group nobody:nobody and stuff like fstest, fsx, iozone,
fsstress

The changes i made are basically changing the fuzzing ratio, adding udf,
hfsplus and ext4, reducing the number of runs to 100 (not unlimited),
saving a backup of the image before mounting and running the tests, and
mounting ext3 with -o debug

Greetings, Eric
