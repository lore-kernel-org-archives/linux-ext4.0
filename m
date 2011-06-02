From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 2/3] jbd2: Add extra parameter in
 start_this_handle() to control allocation flags.
Date: Thu, 2 Jun 2011 11:54:24 +0200
Message-ID: <20110602095424.GA5718@quack.suse.cz>
References: <1306563416-4286-1-git-send-email-mkatiyar@gmail.com>
 <1306563657-4334-1-git-send-email-mkatiyar@gmail.com>
 <20110531112253.GD5614@quack.suse.cz>
 <20110531222720.GA3867@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Manish Katiyar <mkatiyar@gmail.com>,
	linux-ext4@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57595 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932565Ab1FBJy0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Jun 2011 05:54:26 -0400
Content-Disposition: inline
In-Reply-To: <20110531222720.GA3867@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 31-05-11 18:27:20, Ted Tso wrote:
> On Tue, May 31, 2011 at 01:22:53PM +0200, Jan Kara wrote:
> > 
> > The problem is that with ext4, we need i_mutex in io completion path to
> > end page writeback. So we cannot do GFP_KERNEL allocation whenever we hold
> > i_mutex because mm might wait in direct reclaim for IO to complete and that
> > cannot happen until we release i_mutex. 
> 
> OK, maybe I'm being dense, but I'm not seeing it.  I see where we need
> i_mutex on the ext4_da_writepages() codepath, but that's never used
> for direct reclaim.  Direct reclaim only calls ext4_writepage(), and
> that doesn't seem to try to grab i_mutex as near as I can tell.  Am I
> missing something?
  What happens is that direct reclaim sometimes does
wait_on_page_writeback() (e.g. shrink_page_list()) or it explicitely waits
for NR_WRITEBACK statistics to go below some threshold
(throttle_vm_writeout()). And that is deadlockable if we hold i_mutex while
doing this because we may need i_mutex to actually move the page from
PageWriteback state...

As I'm saying this, I've realized ext4 has this problem also with
stable-pages patches because there we can wait for PageWriteback in
grab_cache_page_write_begin() when we also hold i_mutex. So I think we'll
have to come up with a way to convert unwritten extents without having to
hold i_mutex. That's going to be interesting.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
