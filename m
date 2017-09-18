From: Eryu Guan <eguan@redhat.com>
Subject: [4.14-rc1 bug] fstests generic/441 failure on ext2
Date: Mon, 18 Sep 2017 19:23:12 +0800
Message-ID: <20170918112312.GN8034@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40314 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755239AbdIRLXO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 18 Sep 2017 07:23:14 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

With ext2 driven by ext4 module (or ext4 without journal, I haven't
tested ext2 module, but I guess the result is the same), v4.14-rc1
kernel starts to fail fstests generic/441 as:

+First fsync after reopen of fd[0] failed: Input/output error

git bisect shows that this is uncovered by commit ffb959bbdf92 ("mm:
remove optimizations based on i_size in mapping writeback waits"), which
removed (i_size == 0) check in filemap_fdatawait().

I say "uncovered" because test fails with 4.13 kernel too if we re-open
the test file without O_TRUNC flag in src/fsync-err.c (so file size is
not zero, and fails the i_size == 0 check).

The EIO was returned by sync_inode_metadata() in __generic_file_fsync(),
the call trace is like:

do_fsync
 vfs_fsync_range
  ext4_sync_file
   __generic_file_fsync
    sync_inode_metadata
     writeback_single_inode
      __writeback_single_inode
       filemap_fdatawait  => EIO here

Thanks,
Eryu
