From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC PATCH] mark buffer_head mapping preallocate area as new
 during write_begin with delayed allocation
Date: Mon, 27 Apr 2009 14:30:10 -0500
Message-ID: <49F607C2.6060106@redhat.com>
References: <1240859143-31122-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49049 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbZD0TaQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Apr 2009 15:30:16 -0400
In-Reply-To: <1240859143-31122-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> We need to mark the  buffer_head mapping prealloc space
> as new during write_begin. Otherwise we don't zero out the
> page cache content properly for a partial write. This will
> cause file corruption with preallocation.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> ---
>  fs/ext4/inode.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c6bd6ce..c7251ec 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2323,6 +2323,8 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
>  		set_buffer_delay(bh_result);
>  	} else if (ret > 0) {
>  		bh_result->b_size = (ret << inode->i_blkbits);
> +		if (buffer_unwritten(bh_result))
> +			set_buffer_new(bh_result);
>  		ret = 0;
>  	}
>  

Hm, yep, that sure does break things.  For some future regression test:

[root@inode tmp]# /root/fallocate -l 8k testfile
[root@inode tmp]# dd if=/dev/zero of=testfile bs=1 count=10 conv=notrunc
10+0 records in
10+0 records out
10 bytes (10 B) copied, 5.1491e-05 s, 194 kB/s
[root@inode tmp]# hexdump -C testfile

<much garbage ensues>

This looks pretty reasonable; Aneesh & I talked online and found that
xfs has a somewhat similar fix:

commit 549054afadae44889c0b40d4c3bfb0207b98d5a0
Author: David Chinner <dgc@sgi.com>
Date:   Sat Feb 10 18:36:35 2007 +1100

    [XFS] Fix sub-block zeroing for buffered writes into unwritten extents.

    When writing less than a filesystem block of data into an unwritten
extent
    via buffered I/O, __xfs_get_blocks fails to set the buffer new flag.
As a
    result, the generic code will not zero either edge of the block
resulting
    in garbage being written to disk either side of the real data. Set the
    buffer new state on bufferd writes to unwritten extents to ensure that
    zeroing occurs.

-Eric
