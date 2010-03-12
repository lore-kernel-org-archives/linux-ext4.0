From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: bug in ext3 code causing OOM error on systems with small memory
Date: Fri, 12 Mar 2010 13:57:36 -0800
Message-ID: <20100312135736.2f3f5b91.akpm@linux-foundation.org>
References: <84493E34003342289DF1705263D087AC@FransW7>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Mingming Cao <cmm@us.ibm.com>, Jan Kara <jack@suse.cz>
To: "Frans van de Wiel" <fvdw@fvdw.eu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753938Ab0CLV56 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Mar 2010 16:57:58 -0500
In-Reply-To: <84493E34003342289DF1705263D087AC@FransW7>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(cc's added)

On Sat, 6 Mar 2010 10:31:07 +0100
"Frans van de Wiel" <fvdw@fvdw.eu> wrote:

> Dear sirs
> 
> Recently I compiled the linux-2.6.33 kernel for my arm9  based NAS using the orion5x mach.
> The kernel runs but when creating a sub directory outside the root in a big disk ext3 partition (in my case 5000 GB) it caused an OOM error.
> 
> journal_get_undo_access: No memory for committed data
> ext3_try_to_allocate_with_rsv: aborting transaction: Out of memory in __ext3_journal_get_undo_access
> 
> Now my NAS has a tiny system memory only 16 MB  but it worked fine on older kernels like 2.6.12.
> I am not an experienced C programmer but I investigated the problem and think I found the reason and that it might be a good idea to share this with you as it might be useful for others with the same problem and I think it will speed up sub directory creation on big partitions.
> The problem is also present in etx2 driver but it does not cause an OOM as there is no journaling, however it causes a significant delay in directory creation.
> Creating a sub directory took in my case 25 seconds on a 500 GB disk. Thats not acceptable. 
> 
>  It took me a while to figure it out why, but it appeared that when trying to create a sub directory the driver starts to look for free blocks with a block group number that was not suitable (too high). Then the routine starts to check all groups one by one to find a suitable group. As there are almost 4000 groups on a 500 GB partition that takes time and in case of using ext3 the journaling of that action caused an out of memory situation. On ext2 it just took a long time to make a sub directory (up to 20 seconds or so).  
> 
> The error was in the balloc.c file  where there is a routine to allocate new blocks. 
> 
> By adding printk lines I finally found the place where the problem was. After comparing this file with the linux-2.6.12.6 version it appeared that in the newer version they deleted a check that caused the loop to continue without trying to allocate in cause the group was not suitable, so skipping the time and memory intensive part of the loop for that group.
> I added that again and voila problem solved. Think on more powerful system with more memory you will never notice the problem but on the NAS with its limited hardware it caused an issue.
> 
> I attached a file showing the part of the balloc.c file with the problem and the correction made (the correction is in line 117-120 of the attached file in between the lines markes /* fvdw */). I am not a C expert and just copied the check from the old version (of course adapting variables names to match with the new version). But it seems to fix the problem. I checked with printk statements, the adapted routine allocates to the same block as without this correction, it only skips unnecessary work. maybe you can have a look at it if it its ok and will not cause other problems.
> The function at line 137 was causing the OOM error when called too many times after each other in ext3  and in ext causing the delay of creating the directory.
> 
> Hope this information is useful to you. I am not a n experienced C progrommar so my bug rapport may be different from your standards sorry for this 
> 

Thanks.  Here's Frans's patch:

--- a/fs/ext3/balloc.c~a
+++ a/fs/ext3/balloc.c
@@ -1581,6 +1581,8 @@ retry_alloc:
 		gdp = ext3_get_group_desc(sb, group_no, &gdp_bh);
 		if (!gdp)
 			goto io_error;
+		if (!gdp->bg_free_blocks_count)
+			continue;
 		free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
 		/*
 		 * skip this group if the number of
_

and afaict this is a regression added by

: commit 46d01a225e694f1a4343beea44f1e85105aedd7e
: Author:     Mingming Cao <cmm@us.ibm.com>
: AuthorDate: Sat Oct 18 20:27:56 2008 -0700
: Commit:     Linus Torvalds <torvalds@linux-foundation.org>
: CommitDate: Mon Oct 20 08:52:37 2008 -0700
: 
:     ext3: fix ext3 block reservation early ENOSPC issue
:     
:     We could run into ENOSPC error on ext3, even when there is free blocks on
:     the filesystem.
:     
:     The problem is triggered in the case the goal block group has 0 free
:     blocks , and the rest block groups are skipped due to the check of
:     "free_blocks < windowsz/2".  Current code could fall back to non
:     reservation allocation to prevent early ENOSPC after examing all the block
:     groups with reservation on , but this code was bypassed if the reservation
:     window is turned off already, which is true in this case.
:     
:     This patch fixed two issues:
:     1) We don't need to turn off block reservation if the goal block group has
:     0 free blocks left and continue search for the rest of block groups.
:     
:     Current code the intention is to turn off the block reservation if the
:     goal allocation group has a few (some) free blocks left (not enough for
:     make the desired reservation window),to try to allocation in the goal
:     block group, to get better locality.  But if the goal blocks have 0 free
:     blocks, it should leave the block reservation on, and continues search for
:     the next block groups,rather than turn off block reservation completely.
:     
:     2) we don't need to check the window size if the block reservation is off.
:     
:     The problem was originally found and fixed in ext4.
:     
:     Signed-off-by: Mingming Cao <cmm@us.ibm.com>
:     Cc: Theodore Ts'o <tytso@mit.edu>
:     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
:     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
: 
: diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
: index 92fd033..f5b57a2 100644
: --- a/fs/ext3/balloc.c
: +++ b/fs/ext3/balloc.c
: @@ -1547,6 +1547,7 @@ retry_alloc:
:  	 * turn off reservation for this allocation
:  	 */
:  	if (my_rsv && (free_blocks < windowsz)
: +		&& (free_blocks > 0)
:  		&& (rsv_is_empty(&my_rsv->rsv_window)))
:  		my_rsv = NULL;
:  
: @@ -1585,7 +1586,7 @@ retry_alloc:
:  		 * free blocks is less than half of the reservation
:  		 * window size.
:  		 */
: -		if (free_blocks <= (windowsz/2))
: +		if (my_rsv && (free_blocks <= (windowsz/2)))
:  			continue;
:  
:  		brelse(bitmap_bh);

where

	free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);

so this is zero.  We set my_rsv to NULL and then fail to do the
`free_blocks <= (windowsz/2)' check, which would have caused the
bailout.


Is anyone interested in taking a look?
