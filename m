From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Rewrite ext4_page_mkwrite() to return locked page
Date: Sun, 5 Jun 2011 22:17:54 -0400
Message-ID: <20110606021754.GA7180@thunk.org>
References: <1306767829-27580-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41450 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862Ab1FFCR6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Jun 2011 22:17:58 -0400
Content-Disposition: inline
In-Reply-To: <1306767829-27580-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 30, 2011 at 05:03:49PM +0200, Jan Kara wrote:
> ext4_page_mkwrite() does not return page locked. This makes it hard
> to avoid races with filesystem freezing code (so that we don't leave
> writeable page on a frozen fs) or writeback code (so that we allow page
> to be stable during writeback).
> 
> Also the current code uses i_alloc_sem to avoid races with truncate but that
> seems to be the wrong locking order according to lock ordering documented in
> mm/rmap.c.
> 
> Also add a check for frozen filesystem so that we don't busyloop in page fault
> when the filesystem is frozen.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

I'm not sure this commit description is accurate --- or I'm horribly
confused.

The old code was in fact returning the page locked --- I assume you're
referring to lock_page(page) (which is called right before the normal
path return).  So what am I missing?

							- Ted
