From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: A question about freeing a free block
Date: Mon, 18 Jun 2007 01:51:53 -0600
Message-ID: <20070618075153.GA6927@mail.clusterfs.com>
References: <200706110400.l5B405lF003853@nrchpc.ac.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: guomingyang <guomingyang@nrchpc.ac.cn>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:50674 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbXFRHvy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jun 2007 03:51:54 -0400
Content-Disposition: inline
In-Reply-To: <200706110400.l5B405lF003853@nrchpc.ac.cn>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This was posted to linux-fsdevel, but the correct audience is linux-ext4.

On Jun 11, 2007  12:00 +0800, guomingyang wrote:
> I have a question about freeing a free block, in ext3_free_branches
> (ext3/inode.c). When ext3 want to free the top of a subtree, it first
> forget it, then extend the handle to make sure clearing the address of
> the top to be atomic in the journal  with the updating of the bitmap
> block which owns it.  If extend_transaction() fails, freeing the top
> will be another transaction,

There is presumably a crash at this point, and next transaction is not
committed to disk?

> then the blocks pointed by this top are probably re-released by
> ext3_orphan_cleanup().

Hmm... the indirect block should be zeroed out by this point, so
re-releasing the blocks it holds would be a no-op.  However, the call
to ext3_forget() might have removed it from the transaction and caused
the zeroed-out indirect blocks to be lost.

> But when freeing a free block happens, a ext3_error() will be called
> and ext3_handle_error() will mark a error on super block. Isn't it too
> strict?

No, double-free of blocks is ALWAYS a sign of corruption.  The error here
_seems_ to be that the ext3_forget() should happen after the transaction
is extended.  In the normal case, the transaction will be extended and the
forget will work, but if the transaction was closed and the truncate moved
to a new transaction the ext3_forget() would result in a revoke record in
the new transaction.


What would be interesting here is a test case (probably involving a patch
to the ext3 code) that forces the transaction to be closed and a new one
started at this point (sleeping 6s before try_to_extend_transaction() may
be enough), and then causing the journal to be aborted once the previous
transaction is committed.  Doing kernel recovery of this filesystem should
hit the bug if your theory is right.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
