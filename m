From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix oops when loading block bitmap failed
Date: Tue, 28 Oct 2014 20:33:33 -0400
Message-ID: <20141029003333.GA23469@thunk.org>
References: <1414069527-29803-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49695 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbaJ2Adj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Oct 2014 20:33:39 -0400
Content-Disposition: inline
In-Reply-To: <1414069527-29803-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 23, 2014 at 03:05:27PM +0200, Jan Kara wrote:
> When we fail to load block bitmap in __ext4_new_inode() we will
> dereference NULL pointer in ext4_journal_get_write_access(). So check
> for error from ext4_read_block_bitmap().
> 
> Coverity-id: 989065
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
