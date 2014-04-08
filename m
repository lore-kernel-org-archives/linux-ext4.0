From: Pedro Fonseca <pfonseca@mpi-sws.org>
Subject: Data races in ext4
Date: Tue, 08 Apr 2014 22:58:46 +0200
Message-ID: <53446306.7020005@mpi-sws.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, adilger.kernel@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hera.mpi-klsb.mpg.de ([139.19.1.49]:57488 "EHLO
	hera.mpi-klsb.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639AbaDHVGH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Apr 2014 17:06:07 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I've encountered several data races while running custom test cases on 
ext4 (kernel 3.13.5), inside a QEMU based VM, but I'm not sure whether 
all of these data races are harmful.

Bellow I'm listing the data races summary, including the variable name, 
IP addresses, function names and source code files/line numbers. In 
addition, the pastbin links include snippets of the code at those 
locations and also include examples of racing pairs of instructions 
(which can be useful when there are more than two instructions racing). 
Several of the races reported affect either the function 
generic_fillattr() or the function ext4_do_update_inode(), so I'm 
grouping them bellow to simplify the analysis. Feel free to ask for more 
information in case it's needed.

I was hoping someone could have a look at these data races and let me 
know if they're going to be fixed.

Thanks,
Pedro


** Data races:
> Variable: mapping->nrpages Addresses: c107d9f3 c110c8d7
> c107d9f3 add_to_page_cache_locked /linux-3.13.5/mm/filemap.c:487
> c110c8d7 ext4_writepages /linux-3.13.5/fs/ext4/inode.c:2413
>
> Variable: raw_inode->i_size_lo  Addresses: c110abf0 c110abdb
> c110abf0 ext4_isize_set /linux-3.13.5/fs/ext4/ext4.h:2395
> c110abdb ext4_isize /linux-3.13.5/fs/ext4/ext4.h:2387
>
> Variable: mapping->writeback_index      Addresses: c108320f
> c108320f write_cache_pages /linux-3.13.5/mm/page-writeback.c:2012
>
> Variable: ei->i_datasync_tid    Addresses: c110adb3
> c110adb3 ext4_update_inode_fsync_trans 
> /linux-3.13.5/fs/ext4/ext4_jbd2.h:384
>
> Variable: ei->i_sync_tid        Addresses: c112ae80 c110ae6f
> c112ae80 ext4_update_inode_fsync_trans 
> /linux-3.13.5/fs/ext4/ext4_jbd2.h:382
> c110ae6f ext4_update_inode_fsync_trans 
> /linux-3.13.5/fs/ext4/ext4_jbd2.h:382
>
> Variable: kaddr/link    Addresses: c10ade1a c12d40eb
> c10ade1a 
> generic_readlinkat()->page_follow_link_light()->page_getlink()->nd_terminate_link 
> /linux-3.13.5/include/linux/namei.h:98
> c12d40eb generic_readlinkat()->vfs_readlink()->strlen 
> /linux-3.13.5/arch/x86/lib/string_32.c:168
>
> Variable: journal->j_running_transaction        Addresses: c1138ca1 
> c1136b02 c1136ca9
> c1136ca9 jbd2_get_transaction /linux-3.13.5/fs/jbd2/transaction.c:103
> c1138ca1 jbd2_journal_commit_transaction 
> /linux-3.13.5/fs/jbd2/commit.c:539
> c1136b02 start_this_handle /linux-3.13.5/fs/jbd2/transaction.c:280
>
> Variable: inode->i_state        Addresses: c10c035e c10c03cb c10c0352 
> c10c093a c10bffe2
> c10c0352 __writeback_single_inode /linux-3.13.5/fs/fs-writeback.c:473
> c10bffe2 inode_sync_complete /linux-3.13.5/fs/fs-writeback.c:217
> c10c035e __writeback_single_inode /linux-3.13.5/fs/fs-writeback.c:475
> c10c093a writeback_sb_inodes /linux-3.13.5/fs/fs-writeback.c:666
> c10c03cb __mark_inode_dirty /linux-3.13.5/fs/fs-writeback.c:1149
>
> Variable: raw_inode->i_size_high        Addresses: c110abf3 c110abde
> c110abde ext4_isize /linux-3.13.5/fs/ext4/ext4.h:2387
> c110abf3 ext4_isize_set /linux-3.13.5/fs/ext4/ext4.h:2396
http://pastebin.com/gSGUMC31


** Races involving/related to the function generic_fillattr():
> Variable: inode->i_blocks Addresses: c10aa04b c10aa891 c10a9f72
> c10a9f72 __inode_sub_bytes /linux-3.13.5/fs/stat.c:471
> c10aa891 __inode_add_bytes /linux-3.13.5/fs/stat.c:451
> c10aa04b generic_fillattr /linux-3.13.5/fs/stat.c:35
>
> Variable: inode->i_ctime        Addresses: c10aa032 c110b231
> c10aa032 generic_fillattr /linux-3.13.5/fs/stat.c:33
> c110b231 ext4_current_time /linux-3.13.5/fs/ext4/inode.c:3769
>
> Variable: inode->i_blocks       Addresses: c10a9f75 c110ab50 c10aa048 
> c10aa894
> c10a9f75 __inode_sub_bytes /linux-3.13.5/fs/stat.c:471
> c110ab50 ext4_inode_blocks_set /linux-3.13.5/fs/ext4/inode.c:4238
> c10aa048 generic_fillattr /linux-3.13.5/fs/stat.c:35
> c10aa894 __inode_add_bytes /linux-3.13.5/fs/stat.c:451
>
> Variable: inode->i_ctime        Addresses: c10b79e9 c110b22b c10aa02f
> c110b22b ext4_current_time /linux-3.13.5/fs/ext4/inode.c:3769
> c10b79e9 update_time /linux-3.13.5/fs/inode.c:1510
> c10aa02f generic_fillattr /linux-3.13.5/fs/stat.c:33
>
> Variable: inode->i_atime        Addresses: c10b7f62 c10b79a9 c10aa017 
> c10b7fcb
> c10b7f62 timespec_compare /linux-3.13.5/include/linux/time.h:35
> c10b7fcb timespec_equal /linux-3.13.5/include/linux/time.h:25
> c10aa017 generic_fillattr /linux-3.13.5/fs/stat.c:31
> c10b79a9 update_time /linux-3.13.5/fs/inode.c:1506
>
> Variable: inode->i_mtime        Addresses: c10b79f9 c10aa023 c110b237
> c110b237 ext4_truncate /linux-3.13.5/fs/ext4/inode.c:3769
> c10b79f9 update_time /linux-3.13.5/fs/inode.c:1512
> c10aa023 generic_fillattr /linux-3.13.5/fs/stat.c:32
http://pastebin.com/6cHQsZJk


** Races involving/related to the function ext4_do_update_inode():
> Variable: inode->i_ctime    Addresses: c110aac1 c10b79ec
> c110aac1 ext4_encode_extra_time /linux-3.13.5/fs/ext4/ext4.h:729
> c10b79ec update_time /linux-3.13.5/fs/inode.c:1510
>
> Variable: i_crtime  Addresses: c110ab4a
> c110ab4a ext4_encode_extra_time /linux-3.13.5/fs/ext4/ext4.h:729
>
> Variable: ei->i_disksize        Addresses: c110c813 c110ac06
> c110c813 ext4_wb_update_i_disksize /linux-3.13.5/fs/ext4/ext4.h:2476
> c110ac06 ext4_do_update_inode /linux-3.13.5/fs/ext4/inode.c:4342
>
> Variable: raw_inode->i_gid_high Addresses: c110aa6a
> c110aa6a ext4_do_update_inode /linux-3.13.5/fs/ext4/inode.c:4311
>
> Variable: raw_inode->i_dtime    Addresses: c110adf2
> c110adf2 ext4_do_update_inode /linux-3.13.5/fs/ext4/inode.c:4331
>
> Variable: i_mtime       Addresses: c110aac7
> c110aac7 ext4_encode_extra_time /linux-3.13.5/fs/ext4/ext4.h:729
>
> Variable: i_mtime       Addresses: c110aad0
> c110aad0 ext4_do_update_inode /linux-3.13.5/fs/ext4/inode.c:4325
>
> Variable: raw_inode->i_file_acl_high    Addresses: c110abbf
> c110abbf ext4_do_update_inode /linux-3.13.5/fs/ext4/inode.c:4336
>
> Variable: raw_inode->i_flags   Addresses: c110adf8
> c110adf8 ext4_do_update_inode /linux-3.13.5/fs/ext4/inode.c:4332
>
> Variable: raw_inode->i_file_acl_lo      Addresses: c110abc6
> c110abc6 ext4_do_update_inode /linux-3.13.5/fs/ext4/inode.c:4337
>
> Variable: raw_inode->i_blocks_lo        Addresses: c110ab5e
> c110ab5e ext4_inode_blocks_set /linux-3.13.5/fs/ext4/inode.c:4246
>
> Variable: raw_inode->i_links_count      Addresses: c110aaa6
> c110aaa6 ext4_do_update_inode /linux-3.13.5/fs/ext4/inode.c:4322
>
> Variable: raw_inode->i_mode     Addresses: c110aa52 c110aa3a c110abc9
> c110aa3a ext4_do_update_inode /linux-3.13.5/fs/ext4/inode.c:4297
> c110aa52 ext4_do_update_inode /linux-3.13.5/fs/ext4/inode.c:4301
> c110abc9 ext4_isize /linux-3.13.5/fs/ext4/ext4.h:2386
>
> Variable: EXT4_I(inode)->i_disksize     Addresses: c110c810 c110c147 
> c110abcb c110c7d2
> c110c810 ext4_wb_update_i_disksize /linux-3.13.5/fs/ext4/ext4.h:2476
> c110abcb ext4_do_update_inode /linux-3.13.5/fs/ext4/inode.c:4338
> c110c7d2 mpage_map_and_submit_extent /linux-3.13.5/fs/ext4/inode.c:2236
> c110c147 ext4_da_write_end /linux-3.13.5/fs/ext4/inode.c:2758
http://pastebin.com/Sqhf1b92




