From: "Mark Knibbs" <markk@clara.co.uk>
Subject: Re: Possible ext2 bug with large sparse files?
Date: Wed, 06 Jun 2007 14:18:11 +0100
Message-ID: <E1HvvOu-000Ok2-Fh@oceanus.uk.clara.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: markk@clara.co.uk
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oceanus.uk.clara.net ([80.168.70.150]:2909 "EHLO
	oceanus.uk.clara.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761838AbXFFNSO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jun 2007 09:18:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi, 

This is a follow-up to my previous message. The bug is also present in ext3, 
and applies to partitions with 2K blocks and (at least in part) to those 
with 4K blocks. There is also another issue, which may well be a bug in 
e2fsck. 

For partitions with 2K blocks the maximum file size is 275,415,851,008 
bytes; changing the seek= argument in the dd examples to 275415851007 & 
275415851008 gives similar results. 

The maximum file size on partitions with 4K blocks is 2,196,875,759,616 
bytes, so I tested using dd with seek=2196875759615 & 2196875759616. With 4K 
blocks there don't seem to be any problems with warnings in dmesg output, or 
fsck. The only bug (or what I think is a bug) is that
 dd if=/dev/zero of=test.bin bs=1 count=1 seek=2196875759616
causes the file size to show as 2196875759616, but it shouldn't since no 
actual write took place. 


As before, on an ext3 partition with 1K block size, doing
 dd if=/dev/zero of=test.bin bs=1 count=1 seek=17247252480
(which causes the file size to show as 17247252480, but it shouldn't since 
no actual write took place) gives a "File size limit exceeded" message and 
this warning in dmesg output:
 "EXT3-fs warning (device sde): ext3_block_to_path: block > big" 

Unlike the ext2 case however, if you run fsck.ext3 -f it doesn't ask a 
question like
 "i_size is 17247252480, should be 0.  Fix<y>?"
but seems to silently do that; on mounting after running fsck -f, test.bin 
shows as 0 bytes long. 


If instead you do
 dd if=/dev/zero of=test.bin bs=1 count=1 seek=17247252479
(which should work okay, since the maximum file size is 17247252480) then 
fsck -f gives a strange message:
 "Inode 6073, i_size is 17247252480, should be 17247252480.  Fix<y>?"
Even if you say yes to "fix" it, repeatedly running fsck always asks that 
question. 

This happens:
# cd /mnt/sde_removable
# dd if=/dev/zero of=test.bin bs=1 count=1 seek=17247252479
1+0 records in
1+0 records out
1 byte (1 B) copied, 0.132501 seconds, 0.0 kB/s
# ls -l
total 16
drwx------ 2 root root       12288 Jun  6 13:04 lost+found/
 -rw-r--r-- 1 root root 17247252480 Jun  6 13:09 test.bin
# cd ~
# umount /mnt/sde_removable
# fsck.ext3 -f /dev/sde
e2fsck 1.38 (30-Jun-2005)
Pass 1: Checking inodes, blocks, and sizes
Inode 6073, i_size is 17247252480, should be 17247252480.  Fix<y>? yes 

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information 

Ext3_test: ***** FILE SYSTEM WAS MODIFIED *****
Ext3_test: 12/125488 files (0.0% non-contiguous), 24081/501760 blocks
# mount -t ext3 -o noatime /dev/sde /mnt/sde_removable
# ls -l /mnt/sde_removable
total 16
drwx------ 2 root root       12288 Jun  6 13:04 lost+found/
 -rw-r--r-- 1 root root 17247252480 Jun  6 13:09 test.bin
# umount /mnt/sde_removable
# fsck.ext3 -f /dev/sde
e2fsck 1.38 (30-Jun-2005)
Pass 1: Checking inodes, blocks, and sizes
Inode 6073, i_size is 17247252480, should be 17247252480.  Fix<y>? yes 

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information 

Ext3_test: ***** FILE SYSTEM WAS MODIFIED *****
Ext3_test: 12/125488 files (0.0% non-contiguous), 24081/501760 blocks 


Regards,
 -- Mark 
