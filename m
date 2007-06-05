From: "Mark Knibbs" <markk@clara.co.uk>
Subject: Possible ext2 bug with large sparse files?
Date: Tue, 05 Jun 2007 13:25:29 +0100
Message-ID: <E1HvY6M-000Ai0-Ff@oceanus.uk.clara.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: markk@clara.co.uk
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oceanus.uk.clara.net ([80.168.70.150]:1206 "EHLO
	oceanus.uk.clara.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428AbXFEM40 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Jun 2007 08:56:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi, 

I have encountered a problem/issue relating to using ext2 filesystems with 
(very) large sparse files, where the file length is much larger than the 
filesystem size. 

I'm using an x86 PC, the same issue appears in kernel 2.6.14 & 2.6.20. Use 
dd 5.97 to replicate the problem. 

On a ~500MB ext2 volume with about 60MB free (a 512MB flash card in a USB 
reader), testing using dd like this:
 dd if=/dev/zero of=test.bin bs=1 count=1 seek=17247252479
works fine, but
 dd if=/dev/zero of=test.bin bs=1 count=1 seek=17247252480
gives a "File size limit exceeded" message and this warning appears in dmesg 
output:
 "EXT2-fs warning (device sdd): ext2_block_to_path: block > big" 

[For whatever reason, it seems the maximum file size for that
partition is 17,247,252,480 bytes. In itself that behaviour isn't 
necessarily a bug; but if you have any clue how the ext2 maximum file size 
is related (or not) to the amount of free space or the volume size, please 
let me know!] 

After doing
 dd if=/dev/zero of=test.bin bs=1 count=1 seek=17247252480
ls -l shows test.bin to be 17247252480 bytes long. 

I unmounted the partition and used e2fsck -f to check it:
 # e2fsck -f /dev/sdd
 e2fsck 1.38 (30-Jun-2005)
 Pass 1: Checking inodes, blocks, and sizes
 Inode 123466, i_size is 17247252480, should be 0.  Fix<y>? yes 

 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information 

 VolName: ***** FILE SYSTEM WAS MODIFIED *****
 VolName: 107/125488 files (2.8% non-contiguous), 428147/501760 blocks 


Regards,
 -- Mark 
