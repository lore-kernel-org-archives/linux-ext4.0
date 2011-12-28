From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/5] jbd2: clear revoked flag on buffers before a new
 transaction started
Date: Wed, 28 Dec 2011 18:25:50 -0500
Message-ID: <20111228232550.GE12370@thunk.org>
References: <1321344474-14707-1-git-send-email-xiaoqiangnk@gmail.com>
 <1321344474-14707-5-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34563 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab1L1XZ4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Dec 2011 18:25:56 -0500
Content-Disposition: inline
In-Reply-To: <1321344474-14707-5-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 15, 2011 at 04:07:54PM +0800, Yongqiang Yang wrote:
> A revoked block in a transaction means the block is deleted by filesystem
> in the transaction.  If the block is reused in the same transaction, we
> need to cancel revoke status of the block.  We also should prohibit a block
> from being revoked more than once in a transaction.  So we need to look up
> the revoke table to check if a given block is revoked, to acceletate the
> looking up, jbd/jbd2 use revoked flag to cache status of a block.
> 
> Ok, we should clear revoked flag once the transaction is not running. Because
> the revoking and cancelling revoke operate on a running transaction. Once
> a transaction is non-running, revoked flag is useless.
> 
> Without this patch, the following case triggers a false journal error.
> Given that a block is used as a meta block and is deleted(revoked) in ordered
> mode, then the block is allocated as a data block to a file.  Up to now,
> user changes the file's journal mode from ordered to journaled, then truncates
> the file.  The block will be considered re-revoked by journal because it
> has revoked flag in last transaction.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Applied, thanks.

						- Ted
