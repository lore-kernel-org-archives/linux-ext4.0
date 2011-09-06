From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: BUG: i_size and i_blocks corruption on ext4 with ^huge_file
Date: Tue, 06 Sep 2011 10:58:59 -0500
Message-ID: <4E664343.8020009@redhat.com>
References: <4E5AEF3B.8090207@wm.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Utako Kusaka <u-kusaka@wm.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598Ab1IFP7D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Sep 2011 11:59:03 -0400
In-Reply-To: <4E5AEF3B.8090207@wm.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/28/11 8:45 PM, Utako Kusaka wrote:
> Hi,
> 
> In ext4 with ^huge_file, s_maxbytes is 2199023251456. But when I create a file
> size of 2199023251456 bytes, i_size and i_blocks are corrupted.
> 
> If a file size of 2TB is created, i_blocks including metadata blocks will be
> over 32bit. 

For what sized filesystem block?  2T/4k is 2^29...

Oh right, i_blocks is 512 units in this case.  :(  Argh.

> So ext4_inode_blocks_set returns EFBIG, and i_size and i_blocks
> are not updated in ext4_do_update_inode.

Seems like this could get quite tricky.

What if there is a very badly fragmented file which requires a lot of metadata?
How could we calculate s_maxbytes to stop i_blocks from overflowing 32 bits?

In ext3 we could calculate metadata blocks for a given size, but not in this case...

I suppose we could refuse to add blocks if we would overflow, but then s_maxbytes
is misleading.

-Eric

> e.g. fallocate
> 
> ext4_fallocate
>     ext4_map_blocks
>     ext4_falloc_update_inode
>     ext4_mark_inode_dirty
>          ext4_do_update_inode
>               ext4_inode_blocks_set	<---- error
> 
> 
> # uname -a
> Linux mcds1 3.0.0 #2 SMP Mon Aug 8 17:58:28 JST 2011 x86_64 x86_64 x86_64 GNU/Linux
> # mkfs -t ext4 -O ^huge_file /dev/vg0/lv0
> # mount /dev/vg0/lv0 /mnt/mp1
> # fallocate -o 0 -l 2199023251456 /mnt/mp1/testfile
> # stat /mnt/mp1/testfile
>   File: `/mnt/mp1/testfile'
>   Size: 2199023251456	Blocks: 4294967688 IO Block: 4096   regular file
> Device: fd00h/64768d	Inode: 12          Links: 1
> Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 2011-08-09 10:20:31.008699267 +0900
> Modify: 2011-08-09 10:20:31.008699267 +0900
> Change: 2011-08-09 10:20:42.769699811 +0900
> 
> # umount /mnt/mp1
> # e2fsck -ttf /dev/vg0/lv0
> e2fsck 1.41.12 (17-May-2010)
> Pass 1: Checking inodes, blocks, and sizes
> Inode 12, i_size is 2198888873984, should be 2199023251456.  Fix<y>? yes
> 
> Inode 12, i_blocks is 4294705232, should be 4294967688.  Fix<y>? yes
> 
> :
> 
> --
> Utako Kusaka
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

