From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH 0/2] ext3: Reduce calling ext3_mark_inode_dirty() for speedup
Date: Mon, 30 Jan 2012 17:41:17 +0900
Message-ID: <4F2657AD.9060901@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:40992 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab2A3IoT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Jan 2012 03:44:19 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext3 has a performance problem that parallel write is too slow.
I looked into this and found out that ext3 calls ext3_mark_inode_dirty()
unnecessarily.

The following result is the time of writing 16 files whose size are 3GB
by 16 threads. This measurement was performed in linux3.3-rc1 with
4-way server, 512GB memory.

    filesystem        time(sec)  call ext3_mark_inode_dirty(times)
    ---
    ext3              220.5      50,338,104
    ext3 (patched)    196.3      25,169,658
    ext4 (*1)         190.3      28,465,799

    *1 disable ext4-specific option (delalloc, extent, and so on)

ext3 in RHEL5.5 clearly shows the difference in performance.
Writing by the same method takes 533 seconds, though writing by one thread
takes 191 seconds.

Every time we write one page, ext3 calls ext3_mark_inode_dirty() four times.
Two of these are unnecessary in many case, so I add the conditions to call
the function only when it is necessary.

      sys_write
        ...
          __generic_file_aio_write
            file_update_time
              mark_inode_dirty_sync
            generic_file_buffered_write
              ...
                ext3_get_blocks_handle
                  ext3_write_begin
                    ...
                      ext3_new_blocks
                        vfs_dq_alloc_block
    1)                    mark_inode_dirty
                        vfs_dq_free_block
    2)                    mark_inode_dirty      <-- patch 1/2
                    ext3_splice_branch
    3)                ext3_mark_inode_dirty     <-- patch 2/2
                  ext3_ordered_write_end
                    update_file_sizes
    4)                mark_inode_dirty

Regards,
Kazuya Mio
