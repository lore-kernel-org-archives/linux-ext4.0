From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [RFC] BIG_BG vs extended META_BG in ext4
Date: Sat, 30 Jun 2007 23:39:08 -0500
Message-ID: <20070630233908.115ec78e@gara>
References: <20070629170958.13b7700c@gara>
 <20070630055125.GC5535@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45490 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbXGAEkZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Jul 2007 00:40:25 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l614fYpa002331
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jul 2007 00:41:34 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l614eOrc490410
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jul 2007 00:40:24 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l614eO1d019496
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jul 2007 00:40:24 -0400
In-Reply-To: <20070630055125.GC5535@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 30 Jun 2007 01:51:25 -0400
Andreas Dilger <adilger@clusterfs.com> wrote:
> I don't think there is actually any fundamental difference between these
> proposals.  The reality is that we cannot change the semantics of the
> META_BG flag at this point, since both e2fsprogs and ext3/ext4 in the
> kernel understand META_BG to mean only "group descriptor backups are
> in groups {0, 1, last} of the metagroup" and nothing else.

Agree.  I call it extended META_BG for lack of a better name, but a new
feature flag will be required.

> If we want to allow the bitmaps and inode table outside the group they
> represent then this needs to be a separate feature flag, and we may as
> well include the additional improvement of the BIG_BG feature at the
> same time.  I don't think this really any reason to claim there is "no
> need to have a concept of block groups".

Well when I think about block groups, it seems to me that its basically
a range of blocks with some blocks dedicated for holding important meta
data.  If you remove the meta data, then all that is left is a range of
blocks with some backup data scatter around specific locations on the
disk.  Of course, my definition of what a block group is could just be
wrong. :)

We could blur the difference between these two features though.

> Also note that e2fsprogs already reserves the bg_free_*_bg fields for
> BIG_BG in the expanded group descriptors, though there is no official
> definition for BIG_BG:
> 
> struct ext4_group_desc
> {
>         [ ext3_group_desc ]
>         __u32   bg_block_bitmap_hi;     /* Blocks bitmap block MSB */
>         __u32   bg_inode_bitmap_hi;     /* Inodes bitmap block MSB */
>         __u32   bg_inode_table_hi;      /* Inodes table block MSB */
>         __u16   bg_free_blocks_count_hi;/* Free blocks count MSB */
>         __u16   bg_free_inodes_count_hi;/* Free inodes count MSB */
>         __u16   bg_used_dirs_count_hi;  /* Directories count MSB */
>         __u16   bg_pad;
>         __u32   bg_reserved2[3];
> };
> 
> 
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
> 

Thanks for the pointer.

-JRS
