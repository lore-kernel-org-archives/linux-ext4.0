From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 2/3] jbd2: Add extra parameter in
 start_this_handle() to control allocation flags.
Date: Tue, 31 May 2011 18:27:20 -0400
Message-ID: <20110531222720.GA3867@thunk.org>
References: <1306563416-4286-1-git-send-email-mkatiyar@gmail.com>
 <1306563657-4334-1-git-send-email-mkatiyar@gmail.com>
 <20110531112253.GD5614@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Manish Katiyar <mkatiyar@gmail.com>, linux-ext4@vger.kernel.org,
	mfasheh@suse.com, jlbec@evilplan.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36921 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161008Ab1FACW3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 May 2011 22:22:29 -0400
Content-Disposition: inline
In-Reply-To: <20110531112253.GD5614@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 31, 2011 at 01:22:53PM +0200, Jan Kara wrote:
> 
> The problem is that with ext4, we need i_mutex in io completion path to
> end page writeback. So we cannot do GFP_KERNEL allocation whenever we hold
> i_mutex because mm might wait in direct reclaim for IO to complete and that
> cannot happen until we release i_mutex. 

OK, maybe I'm being dense, but I'm not seeing it.  I see where we need
i_mutex on the ext4_da_writepages() codepath, but that's never used
for direct reclaim.  Direct reclaim only calls ext4_writepage(), and
that doesn't seem to try to grab i_mutex as near as I can tell.  Am I
missing something?

						- Ted
