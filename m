From: Eric Sandeen <sandeen@redhat.com>
Subject: ext4 stack usage
Date: Mon, 05 Nov 2007 11:50:57 -0600
Message-ID: <472F5801.6050104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbXKERvF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Nov 2007 12:51:05 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id lA5Hp1UO005143
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 12:51:01 -0500
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lA5Hp14p010451
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 12:51:01 -0500
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id lA5How7j029389
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 12:50:59 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Just FYI; there are some fairly large stack users in ext4dev.  On my
x86_64 box with gcc 4.1.1, and the git patch series applied:

0x00019ac5 ext4_mb_new_blocks [ext4dev]:                424
0x0001c221 ext4_mb_free_blocks [ext4dev]:               408
0x00011390 ext4_group_add [ext4dev]:                    392
0x000050cb ext4_get_blocks_handle [ext4dev]:            328
0x0001853f ext4_mb_discard_preallocations [ext4dev]:    328
0x0000a3a2 ext4_find_entry [ext4dev]:                   312
0x0000b4de ext4_get_parent [ext4dev]:                   264
0x00013fb3 ext4_ext_get_blocks [ext4dev]:               264
0x00014969 ext4_fallocate [ext4dev]:                    264
0x0001b20a ext4_mb_seq_groups_show [ext4dev]:           264
0x00006543 ext4_truncate [ext4dev]:                     232
0x00009b3d ext4_add_entry [ext4dev]:                    216
0x0000d575 ext4_error [ext4dev]:                        216
0x0000e8f5 ext4_fill_super [ext4dev]:                   216
0x00017127 ext4_mb_release_inode_pa [ext4dev]:          216
0x000172cb ext4_mb_init_cache [ext4dev]:                216
0x0001dcad ext4_xattr_set_handle [ext4dev]:             216
0x0000d145 ext4_warning [ext4dev]:                      208
0x0000d794 ext4_abort [ext4dev]:                        208
0x000022f6 ext4_readdir [ext4dev]:                      200
0x00003292 ext4_new_inode [ext4dev]:                    200
0x0001e601 ext4_expand_extra_isize_ea [ext4dev]:        184
0x0000e07d ext4_quota_on [ext4dev]:                     168
0x00014dca ext4_ext_truncate [ext4dev]:                 168
0x00018f6f ext4_mb_write_prealloc_table [ext4dev]:      168
0x0001935a ext4_mb_seq_history_show [ext4dev]:          160
0x00005953 ext4_getblk [ext4dev]:                       152
0x00009283 do_split [ext4dev]:                          152
0x0000bf3b ext4_rename [ext4dev]:                       152
0x000132b9 ext4_ext_insert_extent [ext4dev]:            152
0x000011c9 ext4_new_blocks_old [ext4dev]:               136
0x0000831e ext4_ioctl [ext4dev]:                        136
0x00010cc9 add_new_gdb [ext4dev]:                       136
0x0001b565 ext4_mb_init [ext4dev]:                      136
0x0000ad20 ext4_htree_fill_tree [ext4dev]:              120
0x0000e225 ext4_remount [ext4dev]:                      120
0x00015c5e ext4_ext_migrate [ext4dev]:                  120
0x000008b3 ext4_try_to_allocate_with_rsv [ext4dev]:     104
0x00001e14 ext4_new_blocks [ext4dev]:                   104
0x0000b920 ext4_orphan_del [ext4dev]:                   104
0x0000c90a parse_options [ext4dev]:                     104
0x0001bf3f ext4_mb_discard_inode_preallocations [ext4dev]:104

with the push for 4k stacks, some of these might start to be an issue.

struct ext4_allocation_context might be one big hitter, at 168 bytes
when placed on the stack.

(for comparison, a few of xfs's top stack users are:)

0x0001a1b4 xfs_bmapi [xfs]:                             360
0x00045a73 _xfs_trans_commit [xfs]:                     312
0x000384d6 xfs_bulkstat [xfs]:                          296
0x0004d0b8 xfs_symlink [xfs]:                           296
0x0003798f xfs_iomap_write_delay [xfs]:                 280
0x00056254 xfs_cleanup_inode [xfs]:                     264
<big snip - xfs has many more >100byte functions than ext4>

of course callchain details matter, too, but this is worth keeping an
eye on.

-Eric
