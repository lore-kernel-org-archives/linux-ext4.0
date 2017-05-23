From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: e2fsck bug? - Sparse files corrupt after "e2fsck -E bmap2extent".
Date: Tue, 23 May 2017 09:25:21 -0700
Message-ID: <20170523162521.GD4510@birch.djwong.org>
References: <a7a4fc1f-c1d9-bd69-cc2a-1a8094931e6d@dragonfly.plus.com>
 <20170523154152.glfcx7aryt5x4otj@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marc Thomas <marc@dragonfly.plus.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17542 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757612AbdEWQZb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 23 May 2017 12:25:31 -0400
Content-Disposition: inline
In-Reply-To: <20170523154152.glfcx7aryt5x4otj@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 23, 2017 at 11:41:52AM -0400, Theodore Ts'o wrote:
> On Tue, May 23, 2017 at 12:20:59AM +0100, Marc Thomas wrote:
> > Hi All,
> > 
> > Would you agree this is a bug? As I understand it, reading from an
> > "unpopulated" region of a sparse file should return all zeros - so the
> > md5sum should be the same before and after migration.
> 
> I agree that sparse files should be properly handled after bmap2extent
> conversion.  This code hasn't received that much use or testing, but
> I've tried to replicate the problem and I haven't succeeded.  This
> script works for me:
> 
> ----- cut here -----
> #!/bin/bash
> 
> rm -f /tmp/foo.img
> mke2fs -t ext3 -Fq /tmp/foo.img 65536
> mount -o loop /tmp/foo.img /mnt
> dd if=/etc/motd of=/mnt/test bs=4k >& /dev/null
> dd if=/etc/motd of=/mnt/test conv=notrunc seek=32 bs=4k >& /dev/null
> dd if=/etc/motd of=/mnt/test2 bs=4k >& /dev/null
> dd if=/etc/motd of=/mnt/test2 conv=notrunc seek=1024 bs=4k >& /dev/null
> lsattr /mnt/test*
> md5sum /mnt/test* > /mnt/MD5SUMS
> umount /mnt
> e2fsck -fy -E bmap2extent /tmp/foo.img
> mount -o loop /tmp/foo.img /mnt
> md5sum -c /mnt/MD5SUMS
> lsattr /mnt/test*
> umount /mnt
> ----- cut here -----
> 
> Maybe you can come up with a simple repro case that fails for you?

Or take an e2image of one of the affected filesystems so that the
developers can directly reproduce your error case. :)

e2image -Q /dev/sda1 /some/qcow/dump/file

(Preferably xz the dumpfile before uploading...)

--D

> 
> Thanks,
> 
> 						- Ted
> 						
