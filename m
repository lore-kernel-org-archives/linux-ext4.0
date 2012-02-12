From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: Punch hole problem on PAGE_SIZE > blocksize
Date: Sun, 12 Feb 2012 11:31:43 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1202121128450.6967@dhcp-27-109.brq.redhat.com>
References: <alpine.LFD.2.00.1202101959490.27190@dhcp-27-109.brq.redhat.com> <4F378749.7060206@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab2BLKbs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Feb 2012 05:31:48 -0500
In-Reply-To: <4F378749.7060206@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 12 Feb 2012, Allison Henderson wrote:

> On 02/10/2012 12:10 PM, Lukas Czerner wrote:
> > Hi Allison,
> > 
> > I found quite disturbing problem when testing loop discard support on
> > file systems where PAGE_SIZE>  blocksize. The result is that the file
> > system image is completely destroyed, but the underlying file system
> > seems ok. I have seen this messages in the logs:
> > 
> > EXT4-fs error (device sdb): ext4_ext_search_left:1221: inode #12: comm
> > flush-8:16: ix (2248761) != EXT_FIRST_INDEX (0) (depth 1)!
> > EXT4-fs (sdb): delayed block allocation failed for inode 12 at logical
> > offset 2258177 with max blocks 64 with error -5
> > EXT4-fs (sdb): This should not happen!! Data will be lost
> > 
> > and
> > 
> > EXT4-fs error (device sdd2): ext4_ext_get_blocks: inode #12: (comm
> > loop0) bad extent address iblock: 34479, depth: 3 pblock 0
> > 
> > Steps to reproduce
> > 
> > mkfs.ext4 -b1024 /dev/sdb
> > mount /dev/sdb /mnt/test2
> > dd if=/dev/zero of=/mnt/test2/file bs=1M count=4096
> > losetup /dev/loop0 /mnt/test2/file
> > 
> > cd xfstests
> > 
> > export TEST_DIR=/mnt/test
> > export TEST_DEV=/dev/sda
> > export SCRATCH_DEV=/dev/loop0
> > export SCRATCH_MNT=/mnt/test1
> > export MKFS_OPTIONS="-F -b1024"
> > export MOUNT_OPTIONS="-o discard"
> > export FSTYP="ext4"
> > 
> > while ./check 251; do echo "OK"; done
> > 
> > ..and just wait and watch the logs.
> > 
> > Do you have any idea what might be the problem ?
> > 
> > Thanks!
> > -Lukas
> > 
> 
> Hi Lukas,
> 
> Im having some trouble getting the bug to reproduce for me.  I have the
> dm-crypt module, but when I get to the test loop, i get "mount: unknown
> filesystem type 'crypto_LUKS'". Is there something else I need to do or
> install? With out being able to dig into it, I cant think of why it would do
> that, I have not seen it produce that error before.  :(   Thx!
> 
> Allison Henderson

Hi Allison,

I do not understand it either, there is no dm-crypt involved in this
scenario. One think that comes to my mind is that TEST_DEV (in my case
/dev/sda) needs to contain valid file system, but that is just how
xfstests works. Please, let me know if you still have problems
reproducing it.

Thanks!
-Lukas
