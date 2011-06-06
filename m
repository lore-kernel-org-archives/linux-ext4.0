From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 2/3] jbd2: Add extra parameter in
 start_this_handle() to control allocation flags.
Date: Sun, 5 Jun 2011 23:21:13 -0400
Message-ID: <20110606032113.GC7180@thunk.org>
References: <1306563416-4286-1-git-send-email-mkatiyar@gmail.com>
 <1306563657-4334-1-git-send-email-mkatiyar@gmail.com>
 <20110531112253.GD5614@quack.suse.cz>
 <20110531222720.GA3867@thunk.org>
 <20110602095424.GA5718@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Manish Katiyar <mkatiyar@gmail.com>, linux-ext4@vger.kernel.org,
	mfasheh@suse.com, jlbec@evilplan.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35228 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755370Ab1FFDVT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Jun 2011 23:21:19 -0400
Content-Disposition: inline
In-Reply-To: <20110602095424.GA5718@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 02, 2011 at 11:54:24AM +0200, Jan Kara wrote:
>   What happens is that direct reclaim sometimes does
> wait_on_page_writeback() (e.g. shrink_page_list()) or it explicitely waits
> for NR_WRITEBACK statistics to go below some threshold
> (throttle_vm_writeout()). And that is deadlockable if we hold i_mutex while
> doing this because we may need i_mutex to actually move the page from
> PageWriteback state...

We don't actully call set_page_writeback() until right before we
submit the page for writeback.  And we convert the unwritten extents
in a workqueue, which gets submitted after we call
end_page_writeback().  So I'm still not seeing a problem; sorry if I'm
being dense!

			    	      	  - Ted

> As I'm saying this, I've realized ext4 has this problem also with
> stable-pages patches because there we can wait for PageWriteback in
> grab_cache_page_write_begin() when we also hold i_mutex. So I think we'll
> have to come up with a way to convert unwritten extents without having to
> hold i_mutex. That's going to be interesting.
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
