From: Nathan Roberts <nroberts@yahoo-inc.com>
Subject: Re: Storing inodes in a separate block device?
Date: Thu, 22 May 2008 11:58:41 -0500
Message-ID: <4835A641.20909@yahoo-inc.com>
References: <48358907.3010103@yahoo-inc.com> <48358F95.4070900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mrout3.yahoo.com ([216.145.54.173]:39780 "EHLO mrout3.yahoo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378AbYEVQ65 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 May 2008 12:58:57 -0400
In-Reply-To: <48358F95.4070900@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


>> I've ran some basic tests using ext4 on a SATA array plus a USB thumb 
>> drive for the inodes. Even with the slowness of a thumb drive, I was 
>> able to see encouraging results ( >50% read throughput improvement for a 
>> mixture of 4K-8K files).
> 
> How'd you test this, do you have a patch?  Sounds interesting.

Right now I have only changed enough code to be able to test the theory. 
It's in no way a presentable patch at this point. With some simplifying 
assumptions, the code changes were pretty easy:
- parse a new "idev=" mount option
- Store bdev information for the inode block device in sb_info struct
- Change __ext4_get_inode_loc() to recalculate the block offset in the 
case of a separate device and issue __getblk() to the alternate device.

- A simple utility which copies inodes from one block device to another 
is the only other thing that's needed. (This was simpler than modifying 
the tools. It also allowed me to easily perform BEFORE/AFTER comparisons 
with the only real variable being where the inodes are located.)

So, to get a file system going:
- mke2fs as usual
- copy inodes from original blkdev to inode_blkdev (yes, there are 2 
copies of the inodes, space conservation was not my objective.)
- mount using idev=<inode block device> option


To run the test:
- mkfs
- mount WITHOUT idev= option
- Create 10 million files
- copy inodes to inode_blkdev

SEQ1
-----
- umount, mount readonly, WITHOUT idev
- echo 3 > /proc/sys/vm/drop_caches
- Read 5000 random files using 500 threads, record average read time

SEQ2
-----
- umount, mount readonly, WITH idev,
- drop_caches
- Read 5000 random files using 500 threads, record average read time

- Repeat SEQ1 and then SEQ2 to verify no unexpected caching is going on 
(should see same results as original run).

--

The filesystem features reported by dumpe2fs were:
Filesystem features:      has_journal ext_attr resize_inode dir_index 
filetype needs_recovery extents sparse_super large_file


Thanks,
Nathan
