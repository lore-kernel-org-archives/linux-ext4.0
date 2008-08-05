From: Theodore Tso <tytso@mit.edu>
Subject: Re: Problem with delayed allocation
Date: Tue, 5 Aug 2008 11:16:02 -0400
Message-ID: <20080805151602.GC12544@mit.edu>
References: <E1KPNNn-0003IN-0B@closure.thunk.org> <20080804163505.GE9397@skywalker> <20080805064428.GB8569@mit.edu> <20080805065217.GF9397@skywalker> <20080805132133.GA15568@skywalker> <20080805134722.GA12544@mit.edu> <20080805142403.GA16529@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:40934 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756463AbYHEPQH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Aug 2008 11:16:07 -0400
Content-Disposition: inline
In-Reply-To: <20080805142403.GA16529@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 05, 2008 at 07:54:03PM +0530, Aneesh Kumar K.V wrote:
> But we would still can have pages skipped in the second call to
> ext4_da_writepages(). But this make me wonder how xfs is doing
> delalloc. 

I just checked XFS, and it does the right thing.  See below for my
tests.  The two interesting things of note is that XFS takes a lot
longer (5 seconds vs 0.293 seconds) to do the unmount, so they are
definitely doing something right to wait for the dellayed allocations
to get mapped and written to disk.  The second thing of note is that
ext4 is currently beating XFS at the totally meaningless reiser4
benchmark (aka untar a kernel source tree :-), which we can do in 28
seconds versus XFS's 31 seconds.

So for this test, we're 12% faster (20% faster if we include the time
taken by the remount read-only step), but we're losing 9% of the data.  :-/

		  	     	   	     - Ted


<tytso.root@closure> {/}, level 2  
270# /sbin/mkfs.xfs -f /dev/thunk/testbench; mount /dev/thunk/testbench /mnt; cd /mnt; time tar xjf /usr/projects/linux/linux-2.6.26-3495-gf303489.tar.bz2 ; time mount -o remount,ro /mnt; cd ..; du -s /mnt; umount /mnt; mount /dev/thunk/testbench /mnt; du -s /mnt; umount /mnt
meta-data=/dev/thunk/testbench   isize=256    agcount=8, agsize=163840 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=1310720, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096  
log      =internal log           bsize=4096   blocks=2560, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

real	 0m31.060s
user	 0m19.965s
sys	 0m8.323s

real	 0m5.263s
user	 0m0.000s
sys	 0m0.847s
320872	 /mnt
320872	 /mnt
<tytso.root@closure> {/}, level 2  
271# /sbin/mkfs.ext4dev  /dev/thunk/testbench; mount /dev/thunk/testbench /mnt; cd /mnt; time tar xjf /usr/projects/linux/linux-2.6.26-3495-gf303489.tar.bz2 ; time mount -o remount,ro /mnt; cd ..; du -s /mnt; umount /mnt; mount /dev/thunk/testbench /mnt; du -s /mnt; umount /mnt
mke2fs 1.41.0 (10-Jul-2008)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
327680 inodes, 1310720 blocks
65536 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=1342177280
40 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
	   32768, 98304, 163840, 229376, 294912, 819200, 884736

Writing inode tables: done                            
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 32 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.

real	  0m28.125s
user	  0m18.545s
sys	  0m8.983s

real	  0m0.293s
user	  0m0.000s
sys	  0m0.093s
323736	  /mnt
284332	  /mnt
