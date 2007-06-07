From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Possible ext2 bug with large sparse files?
Date: Thu, 7 Jun 2007 11:51:55 -0600
Message-ID: <20070607175154.GM5181@schatzie.adilger.int>
References: <E1HvvOu-000Ok2-Fh@oceanus.uk.clara.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mark Knibbs <markk@clara.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:55269 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933599AbXFGRv5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Jun 2007 13:51:57 -0400
Content-Disposition: inline
In-Reply-To: <E1HvvOu-000Ok2-Fh@oceanus.uk.clara.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 06, 2007  14:18 +0100, Mark Knibbs wrote:
> This is a follow-up to my previous message. The bug is also present in 
> ext3, and applies to partitions with 2K blocks and (at least in part) to 
> those with 4K blocks. There is also another issue, which may well be a bug 
> in e2fsck. 

Could you please clarify what the particular defect is that you are looking
at?  Presumably it is not just that there is an upper limit on the size of
a file?

> For partitions with 2K blocks the maximum file size is 275,415,851,008 
> bytes; changing the seek= argument in the dd examples to 275415851007 & 
> 275415851008 gives similar results. 
> 
> The maximum file size on partitions with 4K blocks is 2,196,875,759,616 
> bytes, so I tested using dd with seek=2196875759615 & 2196875759616. With 
> 4K blocks there don't seem to be any problems with warnings in dmesg 
> output, or fsck. The only bug (or what I think is a bug) is that
> dd if=/dev/zero of=test.bin bs=1 count=1 seek=2196875759616
> causes the file size to show as 2196875759616, but it shouldn't since no 
> actual write took place. 

The reason for this limitation is due to indirect block limits in the
ext2/3 file layout.  In ext4 it is theoretically possible to have files
up to 2^60 bytes in size, because the extent format handles 2^48-bit
block numbers, and the inode has an extra 16 bits to store the high part
of the block count.

> If instead you do
> dd if=/dev/zero of=test.bin bs=1 count=1 seek=17247252479
> (which should work okay, since the maximum file size is 17247252480) then 
> fsck -f gives a strange message:
> "Inode 6073, i_size is 17247252480, should be 17247252480.  Fix<y>?"
> Even if you say yes to "fix" it, repeatedly running fsck always asks that 
> question. 

This is definitely a bug...

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
