From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [BUG] aborted ext4 leads to inifinity loop in balance_dirty_pages
Date: Tue, 25 Oct 2011 21:04:53 +0900
Message-ID: <4EA6A5E5.2050604@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:47089 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188Ab1JYMFf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Oct 2011 08:05:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Write systemcall calls balance_dirty_pages() for direct reclaim.
However, if ext4 is aborted because of the journal abort, ext4_da_writepages()
cannot reduce the number of dirty pages because EXT4_MF_FS_ABORTED is set to
s_mount_flag. banalce_dirty_pages() has a busy loop, and we can pass this loop
only if the number of dirty pages is less than the threshold. So this function
loops infinity.

When write systemcall and kjournald ran at the same time and the disk
corruption happened, the problem occurred. The kernel version was 3.1-rc9.
I corrupted the disk on purpose by using dmsetup command.


process1 (write)                  process2 (kjournald)

generic_perform_write
  ext4_da_write_begin
  ext4_da_write_end

-------------- detect disk corruption --------------

                                  jbd2_journal_commit_transaction
                                     journal_submit_data_buffers
                                     jbd2_journal_abort

  balance_dirty_pages
    writeback_inodes_wb
      ...
        ext4_da_writepages           <- do nothing if EXT4_MF_FS_ABORTED is set
          ext4_journal_start
            ext4_journal_start_sb    <- detect journal abort
              ext4_abort             <- set EXT4_MF_FS_ABORTED


One possible idea to fix this problem is that ext4_da_writepages()
invalidates the dirty pages if the filesystem has been aborted.
Do you have any ideas?

Regards,
Kazuya Mio
