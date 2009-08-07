From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [RFC][PATCH 1/7]ext4: Add EXT4_IOC_ADD_GLOBAL_ALLOC_RULE	restricts
 block allocation
Date: Fri, 07 Aug 2009 15:42:32 +0900
Message-ID: <4A7BCCD8.1070500@rs.jp.nec.com>
References: <4A409168.3020404@rs.jp.nec.com> <20090623231950.GN31668@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:64627 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbZHGGm5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Aug 2009 02:42:57 -0400
In-Reply-To: <20090623231950.GN31668@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,

Andreas Dilger wrote:
> On Jun 23, 2009  17:25 +0900, Akira Fujita wrote:
>> alloc_flag of ext4_alloc_rule structure is set as "mandatory" or "advisory".
>> Restricted blocks with "mandatory" are never used by block allocator.
>> But in "advisory" case, block allocator is allowed to use restricted blocks
>> when there are no free blocks on FS.
> 
> Would it make more sense to implement the range protections via the
> existing preallocation ranges (PA)?  An inode can have multiple
> PAs attached to it to have it prefer allocations from that range.
> 
> We could also attach PAs to the superblock to prevent other files from
> allocating out of those ranges.  This would work better with the existing
> allocation code instead of creating a second similar mechanism.

Thank you for comments.

I have considered about the block allocation control with preallocation (PA).
This is my new implementation idea.

a. Block allocation restriction (balloc restriction)
   Redesigned balloc restriction ioctl (EXT4_IOC_BALOC_CONTROL) can set
   and clear protected ranges with flag.
   And balloc restriction used a new type PA (MB_RESTRICT_PA),
   not inode PA (MB_INODE_PA) and group PA (MB_GROUP_PA).

   Previous my patch set has implemented two restriction types: mandatory
   (never used by block allocator) and advisory (used if there is
   no other free blocks to allocate).
   But, to make more simple, I implement only mandatory mode.

   With "SET_BALLOC_RESTRICTION" flag, this ioctl sets MB_RESTRIT_PA,
   and blocks in this PA covers are protected from other block allocator.
   If you want to use these ranges, call with "CLR_BALLOC_RESTRICTIOIN" flag.

   EXT4_IOC_BALLOC_CONTROL calls ext4_mb_new_blocks().  It tries to check
   whether specified range blocks are free or not with mballoc routine.
   If range blocks are free, ext4_mb_new_blocks() sets memory block bitmap
   used (same as ext4 PA), and then adds this information to restriction PA.
   But it does *not* set disk block bitmap used, because these blocks are part of PA.

   ext4_prealloc_space has a new list structure "pa_restrict_list" which holds
   restriction PA passed from user-space.
   ext4_group_info also has a new list structure "bb_restrict_request" which holds
   block group related restriction range.
   This list is used, when we calculate blocks count which are free
   but can not use because of restriction PA.


b. Preferred block allocation for inode (preferred balloc)
   EXT4_IOC_ADD_PREALLOC adds specified blocks to the inode PA.
   You can set arbitrary blocks ranges to inode PA,
   this is the different from fallocate.


   Ext4 inode PA is removed when file is closed, therefore it is not
   necessary to implement to clear inode PA.

Ioctl interfaces are as follows.

a. EXT4_IOC_BALLOC_CONTROL (Set or clear balloc restriction)

     EXT4_IOC_BALLOC_CONTROL
	_IOW('f', 16, struct ext4_balloc_control balloc_control)

     struct ext4_balloc_control {
       __u64 start; /* start physical block offset balloc rest */
       __u64 len;   /* block length */
       __u32 flags; /* set or clear */
     }

    "flags" can be set following 2 types.
    - SET_BALLOC_RESTRICTION
        Set blocks in range to the balloc restriction list.
    - CLR_BALLOC_RESTRICTION
        Clear blocks from the balloc restriction list.

b. EXT4_IOC_ADD_PREALLOC (Add inode preferred range)

     EXT4_IOC_ADD_PREALLOC _IOW('f', 18, struct ext4_balloc_control)

     struct ext4_balloc_control {
       __u64 start; /* start physical block offset */
       __u64 len;   /* block length */
       __u32 flags;  /* create and add mode for inode PA  */
     }

    "flags" must include one of the following create modes
    (MANDATORY or ADVISORY).  In addition, one of the control modes also must
    be set (REPLACER_INODE_PREALLOC or ADD_INODE_PREALLOC).
     Create modes:
     - MANDATORY
         Find free extent which satisfies "start" and "len" completely.
     - ADVISORY
         Try to find free extent from "start" and "len" blocks.
     Control modes:
     - REPLACE_INODE_PREALLOC
         Remove existed inode PA first, and then add specified range to
         the inode PA list newly.
     - ADD_INODE_PREALLOC
         Add specified range to the inode PA list.

     e.g.  flag = MANDATORY | ADD_INODE_PREALLOC
           Find free extent which fulfills the requirements completely,
           and if succeed, add this extent to the inode PA.

Regards,
Akira Fujita

