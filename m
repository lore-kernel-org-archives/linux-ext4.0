From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: Punch hole problem on PAGE_SIZE > blocksize
Date: Sun, 12 Feb 2012 02:32:57 -0700
Message-ID: <4F378749.7060206@linux.vnet.ibm.com>
References: <alpine.LFD.2.00.1202101959490.27190@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:44504 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab2BLJdR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 12 Feb 2012 04:33:17 -0500
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Sun, 12 Feb 2012 02:33:17 -0700
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 78488C9004D
	for <linux-ext4@vger.kernel.org>; Sun, 12 Feb 2012 04:32:59 -0500 (EST)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q1C9WxUB246420
	for <linux-ext4@vger.kernel.org>; Sun, 12 Feb 2012 04:32:59 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q1C9WwV9027469
	for <linux-ext4@vger.kernel.org>; Sun, 12 Feb 2012 07:32:59 -0200
In-Reply-To: <alpine.LFD.2.00.1202101959490.27190@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/10/2012 12:10 PM, Lukas Czerner wrote:
> Hi Allison,
>
> I found quite disturbing problem when testing loop discard support on
> file systems where PAGE_SIZE>  blocksize. The result is that the file
> system image is completely destroyed, but the underlying file system
> seems ok. I have seen this messages in the logs:
>
> EXT4-fs error (device sdb): ext4_ext_search_left:1221: inode #12: comm
> flush-8:16: ix (2248761) != EXT_FIRST_INDEX (0) (depth 1)!
> EXT4-fs (sdb): delayed block allocation failed for inode 12 at logical
> offset 2258177 with max blocks 64 with error -5
> EXT4-fs (sdb): This should not happen!! Data will be lost
>
> and
>
> EXT4-fs error (device sdd2): ext4_ext_get_blocks: inode #12: (comm
> loop0) bad extent address iblock: 34479, depth: 3 pblock 0
>
> Steps to reproduce
>
> mkfs.ext4 -b1024 /dev/sdb
> mount /dev/sdb /mnt/test2
> dd if=/dev/zero of=/mnt/test2/file bs=1M count=4096
> losetup /dev/loop0 /mnt/test2/file
>
> cd xfstests
>
> export TEST_DIR=/mnt/test
> export TEST_DEV=/dev/sda
> export SCRATCH_DEV=/dev/loop0
> export SCRATCH_MNT=/mnt/test1
> export MKFS_OPTIONS="-F -b1024"
> export MOUNT_OPTIONS="-o discard"
> export FSTYP="ext4"
>
> while ./check 251; do echo "OK"; done
>
> ..and just wait and watch the logs.
>
> Do you have any idea what might be the problem ?
>
> Thanks!
> -Lukas
>

Hi Lukas,

Im having some trouble getting the bug to reproduce for me.  I have the 
dm-crypt module, but when I get to the test loop, i get "mount: unknown 
filesystem type 'crypto_LUKS'". Is there something else I need to do or 
install? With out being able to dig into it, I cant think of why it 
would do that, I have not seen it produce that error before.  :(   Thx!

Allison Henderson

