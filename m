From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: >2TB file issue with e2fsck
Date: Thu, 18 Mar 2010 16:38:30 -0500
Message-ID: <4BA29D56.4040607@redhat.com>
References: <150c16851003181425s3cea7067o1505279f9d01b0a9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929Ab0CRVid (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Mar 2010 17:38:33 -0400
In-Reply-To: <150c16851003181425s3cea7067o1505279f9d01b0a9@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/18/2010 04:25 PM, Justin Maggard wrote:
> Ran into an interesting issue, and thought I'd report it.  I created a
> 4TB file using posix_fallocate() on a freshly-created ext4 filesystem,
> unmounted, and then ran e2fsck -f on it.  Using e2fsprogs 1.41.9,
> e2fsck ran through with no issues.  Versions 1.41.10 and 1.41.11,
> however, reported finding an error.  Output was the same for both
> 1.41.10 and 1.41.11:
> 
> e2fsck 1.41.10 (10-Feb-2009)
> Pass 1: Checking inodes, blocks, and sizes
> Inode 12, i_blocks is 8589935432, should be 840.  Fix? yes

# bc
obase=16
8589935432
200000348
840
348

oops, so looks like another 32-bit overflow.

we go there if:

        if ((pb.num_blocks != ext2fs_inode_i_blocks(fs, inode)) || ...

but:

struct process_block_struct {
        ext2_ino_t      ino;
        unsigned        is_dir:1, is_reg:1, clear:1, suppress:1,
                                fragmented:1, compressed:1, bbcheck:1;
        blk_t           num_blocks;

and:

typedef __u32           blk_t;

we can't fit 8589935432 into a u32; looks like this one needs a blk64_t
overhaul as well.

commmit 8a8f36540bbf5d4397cf476e216e9a720b5c1d8e added handling of
the high i_blocks number, but did not enlarge the container it
went into:

-       if ((pb.num_blocks != inode->i_blocks) ||
+       if ((pb.num_blocks != ext2fs_inode_i_blocks(fs, inode)) ||

-Eric



> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> 
> c: ***** FILE SYSTEM WAS MODIFIED *****
> c: 12/90523648 files (0.0% non-contiguous), 1079543383/1448361984 blocks
> 
> I'm in the process of trying it again using dd to create the large
> file instead of posix_fallocate(), but I suspect the results will be
> the same.  Writing out such a huge file using dd takes a lot longer,
> since as was discussed on this list a couple weeks ago, large
> sequential writes on ext4 max out around 350MB/s. :)
> 
> -Justin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

