From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [RFC] mballoc: Add ioctls for new block allocation policy
Date: Wed, 04 Mar 2009 16:34:54 +0900
Message-ID: <49AE2F1E.205@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:55064 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbZCDHf0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Mar 2009 02:35:26 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

We will reconsider the implementation of force defragmentation mode (-f mode)
and relevant file defragmentation mode (-r mode), as you suggested in the
mail in December 2008:
 http://marc.info/?l=linux-ext4&m=122880166227883&w=2

These modes need to add the two following functions into the ext4 multiblock
allocation.
We'd like to decide the interface for the functions, so any comments are
welcome.

  a. Block allocation restriction
     This is the ioctl interface which allows a privileged program to specify
     one or more range of blocks which the filesystem's block allocator
     must not allocate from.
     This allows the ext4 online defrag to solve free space fragmentation;
     it has to do with force defragmentation mode.
     This feature may be useful for online shrink; at first, we restrict the
     allocation from the tail of a filesystem, then move data away from there,
     and shorten the size of it.

  b. Preferred blocks allocation
     This is ioctl interface which associates an inode with preferred range of
     blocks which the block allocator will try using first.
     It gives the two following features to ext4 online defrag.
      1. Defragment files and re-allocate them closely each other
         (Relevant file defragmentation mode needs this one).
      2. After solving free space fragmentation, re-allocate a file to the
         contiguous free space (Force defragmentation mode needs this one).
     It is also possible to allocate particular blocks to a file with
     fallocate in advance.

The followings are the implementation approaches of above two functions.

  a. Block allocation restriction (balloc restriction)
     For balloc restriction, we need to add ioctls, structures, and a member
     to an existing structure.

     Ioctls:
       EXT4_IOC_ADD_GLOBAL_ALLOC_RULE
				_IOW('f', 16, struct ext4_alloc_rule);

       This ioctl forbids block allocation from the blocks range where
       pointed by the ext4_alloc_rule. struct ext4_alloc_rule is set to
       ext4_sb_info->s_bg_list (described later).
       When we set it, the filesystem relative blocks range is converted into
       the block group relative one.
       The set ext4_alloc_rule is removed by the following ioctl or
       unmounting filesystem.

       EXT4_IOC_CLR_GLOBAL_ALLOC_RULE
				_IOW('f', 17, struct ext4_alloc_rule);

       This ioctl permits block allocator to allocate the range of blocks
       pointed by ext4_alloc_rule.
       It modifies s_bg_list->range_list to make the range allocatable.

     Structures:
       * ext4_alloc_rule (describes the range of balloc restriction)
         struct ext4_alloc_rule {
		__u64 start;	  /* physical start offset in block */
		__u64 len;	  /* the length of the blocks range */
		__u32 alloc_flag; /* mandatory...0(default) advisory...1 */
         };

         "alloc_flag" defines the behavior when the block allocator can not
         get blocks in the range of balloc restriction.
         In "mandatory" case, we never get the blocks from "start" to
         "start + len". If block allocation fail by the restriction, we get
         error (ENOSPC).
         On the other hand, we may get the blocks from the restricted range in
         "advisory" case.

       * ext4_bg_list (the list of the bg relative range of balloc restriction)
         struct ext4_bg_list {
		struct list_head bg_list;     /* next ext4_bg_list */
		ext4_group_t	 bg_num;      /* bg num */
		ext4_grpblk_t	 used_blocks; /* forbidden blocks by the
						 restriction */
		struct list_head range_list;  /* The list of bg relative balloc
						 restriction */
         };

         This list manages the bg relative range of balloc restrictions (struct
         ext4_bg_alloc_rule).

       * ext4_bg_alloc_rule (the bg relative range of balloc restriction)
         struct ext4_bg_alloc_rule {
		struct list_head range_list; /* next ext4_bg_alloc_rule */
		ext4_grpblk_t	 start;      /* physical start offset
						in block */
		ext4_grpblk_t	 end;        /* physical last offset
						in block */
		int		 alloc_flag; /* mandatory...0(default)
						advisory...1 */
         };

         This structure stores the bg relative range of balloc restriction.
         The range passed by ioctl is filesystem relative one, so it needs to
         be converted into it.

     A new member of the structure:
       We add the new member to the ext4_sb_info.
       struct ext4_sb_info {
		...
	+	struct list_head s_bg_list;
       }

     Behavior in mballoc:
       In the free blocks lookup (ext4_mb_{simple, complex}_scan_group,
       ext4_mb_scan_aligned, etc.), they compare the bg relative balloc
       restriction list to the range of free blocks we got. If the free blocks
       range overlaps with the restricted blocks one, we shorten the free
       blocks one or do lookup again.

  b. Preferred block allocation
     For preferred block allocation, we add ioctl, structures, and
     a member for an existing structure.

     Ioctl:
       EXT4_IOC_ADD_INODE_ALLOC_RULE	_IOW('f', 18, struct ext4_alloc_rule);
       This ioctl sets the preferred range of blocks (struct ext4_alloc_rule)
       to the inode. The range is cancelled by doing block allocation or
       closing fd.

     Structure:
       * ext4_alloc_rule (describes the range of balloc restriction)
         struct ext4_alloc_rule {
		__u64 start;	  /* physical start offset in block */
		__u64 len;	  /* the length of the blocks range */
		__u32 alloc_flag; /* mandatory...0(default) advisory...1 */
         };

         If we fail allocation to the blocks of purpose, "mandatory" case
         causes ENOSPC. Meanwhile, "advisory" case tries to allocate from the
         other place.

      * ext4_inode_alloc_rule (stores allocation rule and pid which set rule)
        struct ext4_inode_alloc_rule {
		struct *ext4_alloc_rule alloc_rule;
		pid_t alloc_pid;
        }

        alloc_rule: Stores the contents of ext4_alloc_rule from the ioctl.
        alloc_pid: The pid of the process which sets "alloc_rule"

     A new member of the structure:
       We add the new member to struct ext4_inode_info.
       struct ext4_inode_info {
		...
	+	struct ext4_inode_alloc_rule *i_alloc_rule;
		spinlock_t i_block_reservation_lock;
       }

     Behavior in mballoc:
       If current->pid differs from ext4_inode_info->i_alloc_rule->alloc_pid,
       the ordinary multiblock routine is executed. If not, block allocator
       does the following behavior:

       When doing multiblock allocation, it sets ext4_allocation_request->
       {goal, len, flags} with the contents of struct alloc_rule.
       Then, the purpose blocks are allocated via existing mballoc process.

Best regards,
Akira Fujita
