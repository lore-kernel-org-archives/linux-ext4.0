From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] ext4: Fix data exposure after a crash
Date: Sat, 23 Apr 2016 23:48:13 -0400
Message-ID: <20160424034813.GG20980@thunk.org>
References: <1459354767-8693-1-git-send-email-jack@suse.cz>
 <1459354767-8693-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Weller.Huang@cn.bosch.com,
	stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:32788 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbcDXDsU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Apr 2016 23:48:20 -0400
Content-Disposition: inline
In-Reply-To: <1459354767-8693-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 30, 2016 at 06:19:24PM +0200, Jan Kara wrote:
> Huang has reported that in his powerfail testing he is seeing stale
> block contents in some of recently allocated blocks although he mounts
> ext4 in data=ordered mode. After some investigation I have found out
> that indeed when delayed allocation is used, we don't add inode to
> transaction's list of inodes needing flushing before commit. Originally
> we were doing that but commit f3b59291a69d removed the logic with a
> flawed argument that it is not needed.
> 
> The problem is that although for delayed allocated blocks we write their
> contents immediately after allocating them, there is no guarantee that
> the IO scheduler or device doesn't reorder things and thus transaction
> allocating blocks and attaching them to inode can reach stable storage
> before actual block contents. Actually whenever we attach freshly
> allocated blocks to inode using a written extent, we should add inode to
> transaction's ordered inode list to make sure we properly wait for block
> contents to be written before committing the transaction. So that is
> what we do in this patch. This also handles other cases where stale data
> exposure was possible - like filling hole via mmap in
> data=ordered,nodelalloc mode.
> 
> The only exception to the above rule are extending direct IO writes where
> blkdev_direct_IO() waits for IO to complete before increasing i_size and
> thus stale data exposure is not possible. For now we don't complicate
> the code with optimizing this special case since the overhead is pretty
> low. In case this is observed to be a performance problem we can always
> handle it using a special flag to ext4_map_blocks().
> 
> CC: stable@vger.kernel.org
> Fixes: f3b59291a69d0b734be1fc8be489fef2dd846d3d
> Reported-by: "HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
> Tested-by: "HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

						- Ted
