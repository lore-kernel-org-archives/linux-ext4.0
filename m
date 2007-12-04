From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [RFC] Flex_BG ialloc awareness.
Date: Tue, 4 Dec 2007 16:51:19 -0600
Message-ID: <20071204165119.38155a92@gara>
References: <20071203130539.52e096a0@gara>
	<20071203204247.GL3604@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53745 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbXLDWvU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Dec 2007 17:51:20 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id lB4MpIRO025907
	for <linux-ext4@vger.kernel.org>; Tue, 4 Dec 2007 17:51:18 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lB4MpImn466914
	for <linux-ext4@vger.kernel.org>; Tue, 4 Dec 2007 17:51:18 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lB4MpHU1000449
	for <linux-ext4@vger.kernel.org>; Tue, 4 Dec 2007 17:51:18 -0500
In-Reply-To: <20071203204247.GL3604@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 3 Dec 2007 13:42:47 -0700
Andreas Dilger <adilger@sun.com> wrote:

> On Dec 03, 2007  13:05 -0600, Jose R. Santos wrote:
> > @@ -600,6 +600,7 @@ void ext4_free_blocks_sb(handle_t *handle, struct super_block *sb,
> >  	ext4_grpblk_t group_freed;
> > +	ext4_group_t meta_group;
> 
> Please do not call these meta_groups.  This already means something very
> specific (i.e. desc_per_block groups) and using it for FLEX_BG is confusing.
> One possibly desirable relation is if the FLEX_BG count is some integer or
> power-of-two multiple of the metabg count.  That would allow the FLEX_BG
> code to share the same in-memory group struct as the mballoc code and save
> on some memory overhead.

Yes, need to clean the naming on some of these.  I also need to look
into the mballoc code to see if there is anything I can reuse.

> > +			meta_group = ext4_meta_group(sbi, block_group);
> > +			spin_lock(&sbi->s_meta_groups[meta_group].meta_group_lock);
> > +			sbi->s_meta_groups[meta_group].free_inodes++;
> > +			if (is_directory)
> > +				sbi->s_meta_groups[meta_group].num_dirs--;
> > +			spin_unlock(&sbi->s_meta_groups[meta_group].meta_group_lock);
> 
> This can be as many as hundreds or thousands of spin locks.  Why not use
> the same hashed locking code as the group descriptors themselves?
> 
> 		spin_lock(sb_bgl_lock(sbi, meta_group));
> 		spin_unlock(sb_bgl_lock(sbi, meta_group));
> 
> This scales with the number of CPUs and chance of contention is very low.

Excellent.  I was thinking that one spinlock per flex_bg was overkill
as well but I did not know the existence of blockgroup_lock.h.

> > +int find_group_meta(struct super_block *sb, struct inode *parent)
> > +{
> > +	ext4_group_t parent_mgroup = parent_group / sbi->s_groups_per_meta;
> 
> This could use ext4_meta_group(sbi, parent_group)?

Yes, thanks for catching.
 
> > +static inline ext4_group_t ext4_meta_group(struct ext4_sb_info *sbi,
> > +					     ext4_group_t block_group)
> > +{
> > +	return block_group/sbi->s_groups_per_meta;
> > +}
> 
> It would be preferable to limit s_groups_per_meta to be a power-of-two
> so that this can become a shift instead of a divide.

Seems like I always fall into the same trap.  I'll change this.

> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 

Thanks.

-JRS
