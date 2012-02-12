From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: Punch hole problem on PAGE_SIZE > blocksize
Date: Sun, 12 Feb 2012 20:09:57 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1202122004490.14664@dhcp-27-109.brq.redhat.com>
References: <alpine.LFD.2.00.1202101959490.27190@dhcp-27-109.brq.redhat.com> <4F378749.7060206@linux.vnet.ibm.com> <alpine.LFD.2.00.1202121128450.6967@dhcp-27-109.brq.redhat.com> <4F37EC04.2020308@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056Ab2BLTKC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Feb 2012 14:10:02 -0500
In-Reply-To: <4F37EC04.2020308@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 12 Feb 2012, Allison Henderson wrote:

> On 02/12/2012 03:31 AM, Lukas Czerner wrote:
> > On Sun, 12 Feb 2012, Allison Henderson wrote:
> > 
> > > On 02/10/2012 12:10 PM, Lukas Czerner wrote:
> > > > Hi Allison,
> > > > 
> > > > I found quite disturbing problem when testing loop discard support on
> > > > file systems where PAGE_SIZE>   blocksize. The result is that the file
> > > > system image is completely destroyed, but the underlying file system
> > > > seems ok. I have seen this messages in the logs:
> > > > 
> > > > EXT4-fs error (device sdb): ext4_ext_search_left:1221: inode #12: comm
> > > > flush-8:16: ix (2248761) != EXT_FIRST_INDEX (0) (depth 1)!
> > > > EXT4-fs (sdb): delayed block allocation failed for inode 12 at logical
> > > > offset 2258177 with max blocks 64 with error -5
> > > > EXT4-fs (sdb): This should not happen!! Data will be lost
> > > > 
> > > > and
> > > > 
> > > > EXT4-fs error (device sdd2): ext4_ext_get_blocks: inode #12: (comm
> > > > loop0) bad extent address iblock: 34479, depth: 3 pblock 0
> > > > 
> > > > Steps to reproduce
> > > > 
> > > > mkfs.ext4 -b1024 /dev/sdb
> > > > mount /dev/sdb /mnt/test2
> > > > dd if=/dev/zero of=/mnt/test2/file bs=1M count=4096
> > > > losetup /dev/loop0 /mnt/test2/file
> > > > 
> > > > cd xfstests
> > > > 
> > > > export TEST_DIR=/mnt/test
> > > > export TEST_DEV=/dev/sda
> > > > export SCRATCH_DEV=/dev/loop0
> > > > export SCRATCH_MNT=/mnt/test1
> > > > export MKFS_OPTIONS="-F -b1024"
> > > > export MOUNT_OPTIONS="-o discard"
> > > > export FSTYP="ext4"
> > > > 
> > > > while ./check 251; do echo "OK"; done
> > > > 
> > > > ..and just wait and watch the logs.
> > > > 
> > > > Do you have any idea what might be the problem ?
> > > > 
> > > > Thanks!
> > > > -Lukas
> > > > 
> > > 
> > > Hi Lukas,
> > > 
> > > Im having some trouble getting the bug to reproduce for me.  I have the
> > > dm-crypt module, but when I get to the test loop, i get "mount: unknown
> > > filesystem type 'crypto_LUKS'". Is there something else I need to do or
> > > install? With out being able to dig into it, I cant think of why it would
> > > do
> > > that, I have not seen it produce that error before.  :(   Thx!
> > > 
> > > Allison Henderson
> > 
> > Hi Allison,
> > 
> > I do not understand it either, there is no dm-crypt involved in this
> > scenario. One think that comes to my mind is that TEST_DEV (in my case
> > /dev/sda) needs to contain valid file system, but that is just how
> > xfstests works. Please, let me know if you still have problems
> > reproducing it.
> > 
> > Thanks!
> > -Lukas
> > 
> Ok, I got it, it was my fault I had forgotten that I had used the scratch
> partition for an encryption test a while back.  Sorry!  I am getting a "[not
> run] FSTRIM is not supported" though, I think I need a device that supports
> discard.  I will poke around Monday and see if I can borrow one from somebody.
> 
> Allison Henderson

Well, you'll have to try that on the recent upstream kernel, or at least
the one which has my loop discard support patch
dfaa2ef68e80c378e610e3c8c536f1c239e8d3ef
so we convert the discard command in the loop driver into punch hole to
the backing file. But I have been able to reproduce it just with dd and
fallocate - just create a file with some extents and then puch a hole in
the size of the file and you'll get the error. I believe that there is
some kind of off-by-one error (probabaly blocks count vs. block
number:)). I have not had time to investigate this issue, but I'll look
into it soon.

Thanks!
-Lukas
