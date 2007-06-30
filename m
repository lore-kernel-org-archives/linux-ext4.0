From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] BIG_BG vs extended META_BG in ext4
Date: Sat, 30 Jun 2007 01:51:25 -0400
Message-ID: <20070630055125.GC5535@schatzie.adilger.int>
References: <20070629170958.13b7700c@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:40694 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbXF3Fv1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jun 2007 01:51:27 -0400
Content-Disposition: inline
In-Reply-To: <20070629170958.13b7700c@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 29, 2007  17:09 -0500, Jose R. Santos wrote:
> I think the BIG_BG feature is better suited to the design philosophy of
> ext2/3.  Since all the important meta-data is easily accessible thanks
> to the static filesystem  layout, I would expect for easier fsck
> recovery.  This should also provide with some performance improvements
> for both extents (allowing each extent to be larger than 128M) as well
> as fsck since bitmaps would be place closer together.
> 
> An extended version of metadata block group could provide better
> performance improvements during fsck time since we could pack all of
> the filesystem bitmaps together.  Having the inode tables separated
> from the block groups could mean that we could implement dynamic inodes
> in the future as well.  This feature seems like it would be more
> invasive for e2fspros at first glance (at least for fsck).  Also, with
> no metadata in the block groups, there is essentially no need to have a
> concept of block groups anymore which would mean that this is a
> completely different filesystem layout compared to ext2/3.
> 
> Since I have not much experience with ext4 development, I was wondering
> if anybody had any opinion as to which of these two methods would
> better serve the need of the intended users and see which one would be
> worth to prototype first.

I don't think there is actually any fundamental difference between these
proposals.  The reality is that we cannot change the semantics of the
META_BG flag at this point, since both e2fsprogs and ext3/ext4 in the
kernel understand META_BG to mean only "group descriptor backups are
in groups {0, 1, last} of the metagroup" and nothing else.

If we want to allow the bitmaps and inode table outside the group they
represent then this needs to be a separate feature flag, and we may as
well include the additional improvement of the BIG_BG feature at the
same time.  I don't think this really any reason to claim there is "no
need to have a concept of block groups".

Also note that e2fsprogs already reserves the bg_free_*_bg fields for
BIG_BG in the expanded group descriptors, though there is no official
definition for BIG_BG:

struct ext4_group_desc
{
        [ ext3_group_desc ]
        __u32   bg_block_bitmap_hi;     /* Blocks bitmap block MSB */
        __u32   bg_inode_bitmap_hi;     /* Inodes bitmap block MSB */
        __u32   bg_inode_table_hi;      /* Inodes table block MSB */
        __u16   bg_free_blocks_count_hi;/* Free blocks count MSB */
        __u16   bg_free_inodes_count_hi;/* Free inodes count MSB */
        __u16   bg_used_dirs_count_hi;  /* Directories count MSB */
        __u16   bg_pad;
        __u32   bg_reserved2[3];
};



Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
