From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: make sure to revoke all the freeable blocks in
 ext4_free_blocks
Date: Sun, 21 Feb 2016 18:35:21 -0500
Message-ID: <20160221233521.GA23122@thunk.org>
References: <1450316940-10774-1-git-send-email-daeho.jeong@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33596 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbcBUXf1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Feb 2016 18:35:27 -0500
Content-Disposition: inline
In-Reply-To: <1450316940-10774-1-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 17, 2015 at 10:49:00AM +0900, Daeho Jeong wrote:
> Now, ext4_free_blocks() doesn't revoke data blocks of per-file data
> journalled inode and it can cause file data inconsistency problems.
> Even though data blocks of per-file data journalled inode are already
> forgotten by jbd2_journal_invalidatepage() in advance of invoking
> ext4_free_blocks(), we still need to revoke the data blocks here.
> Moreover some of the metadata blocks, which are not found by
> sb_find_get_block(), are still needed to be revoked, but this is also
> missing here.
> 
> Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

Apologies for the delay.

						- Ted
