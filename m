From: Lukas Czerner <lczerner@redhat.com>
Subject: Punch hole problem on PAGE_SIZE > blocksize
Date: Fri, 10 Feb 2012 20:10:38 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1202101959490.27190@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759903Ab2BJTKn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Feb 2012 14:10:43 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Allison,

I found quite disturbing problem when testing loop discard support on
file systems where PAGE_SIZE > blocksize. The result is that the file
system image is completely destroyed, but the underlying file system
seems ok. I have seen this messages in the logs:

EXT4-fs error (device sdb): ext4_ext_search_left:1221: inode #12: comm
flush-8:16: ix (2248761) != EXT_FIRST_INDEX (0) (depth 1)!
EXT4-fs (sdb): delayed block allocation failed for inode 12 at logical
offset 2258177 with max blocks 64 with error -5
EXT4-fs (sdb): This should not happen!! Data will be lost

and

EXT4-fs error (device sdd2): ext4_ext_get_blocks: inode #12: (comm
loop0) bad extent address iblock: 34479, depth: 3 pblock 0

Steps to reproduce

mkfs.ext4 -b1024 /dev/sdb
mount /dev/sdb /mnt/test2
dd if=/dev/zero of=/mnt/test2/file bs=1M count=4096
losetup /dev/loop0 /mnt/test2/file

cd xfstests

export TEST_DIR=/mnt/test
export TEST_DEV=/dev/sda
export SCRATCH_DEV=/dev/loop0
export SCRATCH_MNT=/mnt/test1
export MKFS_OPTIONS="-F -b1024"
export MOUNT_OPTIONS="-o discard"
export FSTYP="ext4"

while ./check 251; do echo "OK"; done

..and just wait and watch the logs.

Do you have any idea what might be the problem ?

Thanks!
-Lukas
