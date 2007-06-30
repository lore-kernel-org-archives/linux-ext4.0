From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC] BIG_BG vs extended META_BG in ext4
Date: Sat, 30 Jun 2007 10:24:55 -0400
Message-ID: <1183213495.9505.21.camel@localhost.localdomain>
References: <20070629170958.13b7700c@gara>
	 <20070630055125.GC5535@schatzie.adilger.int>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Jose R. Santos" <jrs@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:38016 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231AbXF3OY5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jun 2007 10:24:57 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l5UEJoNV010538
	for <linux-ext4@vger.kernel.org>; Sat, 30 Jun 2007 10:19:50 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5UEOuUS202750
	for <linux-ext4@vger.kernel.org>; Sat, 30 Jun 2007 08:24:56 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5UEOu41005280
	for <linux-ext4@vger.kernel.org>; Sat, 30 Jun 2007 08:24:56 -0600
In-Reply-To: <20070630055125.GC5535@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 2007-06-30 at 01:51 -0400, Andreas Dilger wrote:
> On Jun 29, 2007  17:09 -0500, Jose R. Santos wrote:
> > I think the BIG_BG feature is better suited to the design philosophy of
> > ext2/3.  Since all the important meta-data is easily accessible thanks
> > to the static filesystem  layout, I would expect for easier fsck
> > recovery.  This should also provide with some performance improvements
> > for both extents (allowing each extent to be larger than 128M) as well
> > as fsck since bitmaps would be place closer together.
> > 
> > An extended version of metadata block group could provide better
> > performance improvements during fsck time since we could pack all of
> > the filesystem bitmaps together.  Having the inode tables separated
> > from the block groups could mean that we could implement dynamic inodes
> > in the future as well.  This feature seems like it would be more
> > invasive for e2fspros at first glance (at least for fsck).  Also, with
> > no metadata in the block groups, there is essentially no need to have a
> > concept of block groups anymore which would mean that this is a
> > completely different filesystem layout compared to ext2/3.
> > 
> > Since I have not much experience with ext4 development, I was wondering
> > if anybody had any opinion as to which of these two methods would
> > better serve the need of the intended users and see which one would be
> > worth to prototype first.
> 
> I don't think there is actually any fundamental difference between these
> proposals. 

I agree. The more I think about the extended META BG, the more I think
it's pretty much the BIG_BG. Only difference is,  with extended META BG,
it removed the restriction that all fs block descriptors has to store in
the first block group. Thus online resize volume size doesn't has to be
dependent on the block group size.


>  The reality is that we cannot change the semantics of the
> META_BG flag at this point, since both e2fsprogs and ext3/ext4 in the
> kernel understand META_BG to mean only "group descriptor backups are
> in groups {0, 1, last} of the metagroup" and nothing else.
> 
> If we want to allow the bitmaps and inode table outside the group they
> represent then this needs to be a separate feature flag, and we may as
> well include the additional improvement of the BIG_BG feature at the
> same time.  I don't think this really any reason to claim there is "no
> need to have a concept of block groups".
> 
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
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
