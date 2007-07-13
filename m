From: Andreas Dilger <adilger@clusterfs.com>
Subject: -ENOSPC return from xattr functions
Date: Fri, 13 Jul 2007 10:27:33 -0600
Message-ID: <20070713162733.GI5880@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Gruenbacher <agruen@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:38440 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbXGMQ1f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jul 2007 12:27:35 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello Andreas,
I noticed in ext3_xattr_block_set() that if i->value_len > sb->s_blocksize
it returns -ENOSPC.  However, in ext3_xattr_set_handle() it returns -ERANGE
when the name length is > 255.

It seems a bit misleading to return -ENOSPC when the filesystem isn't
actually out of space.  I think it would probably make more sense to
return -ERANGE or -EOVERFLOW in this case.


Also, I don't know if you noticed in "[EXT4 set 5][PATCH 1/1] expand inode
i_extra_isize to support features in larger inode" the discussion about
GFP_KERNEL allocations under xattr_sem.  It seems there is risk of deadlock
in this case because we are inside a journal handle and might get blocked
waiting on a new journal_start() trying to flush memory.

Should these allocations be GFP_NOFS instead?  They shouldn't be a big
source of memory contention because the buffer is freed immediately at
the end of the function.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
