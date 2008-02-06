From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: BUG_ON at mballoc.c:3752
Date: Wed, 06 Feb 2008 15:59:48 -0600
Message-ID: <1202335188.6886.15.camel@norville.austin.ibm.com>
References: <20080131140137.GA20780@alice> <20080131154207.GA22201@alice>
	 <20080204060055.GC7494@skywalker>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Eric Sesterhenn <snakebyte@gmx.de>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44024 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566AbYBFV7u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Feb 2008 16:59:50 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m16M1ida013342
	for <linux-ext4@vger.kernel.org>; Wed, 6 Feb 2008 17:01:44 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m16Lxo6n228842
	for <linux-ext4@vger.kernel.org>; Wed, 6 Feb 2008 16:59:50 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m16Lxnc5021759
	for <linux-ext4@vger.kernel.org>; Wed, 6 Feb 2008 16:59:49 -0500
In-Reply-To: <20080204060055.GC7494@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2008-02-04 at 11:30 +0530, Aneesh Kumar K.V wrote:
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
> The file system is corrupted.

That's what fsfuzzer does.

>  The BUG_ON indicate that the free spcae
> marked in the prealloc space and found by looking at the bitmap are not
> same.

File systems should not call BUG() due to a corrupt file system.
Instead the code should fail the operation, possibly marking the file
system read-only (or panicking) depending on the errors= mount option.

-- 
David Kleikamp
IBM Linux Technology Center
