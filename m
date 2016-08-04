From: Jan Kara <jack@suse.cz>
Subject: Re: Sleeping function called in invalid context
Date: Thu, 4 Aug 2016 18:05:50 +0200
Message-ID: <20160804160550.GA12861@quack2.suse.cz>
References: <57A19B9B.60005@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Nikolay Borisov <kernel@kyup.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40799 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964981AbcHDQF6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Aug 2016 12:05:58 -0400
Content-Disposition: inline
In-Reply-To: <57A19B9B.60005@kyup.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 03-08-16 10:22:03, Nikolay Borisov wrote:
> While doing some testing on today's checkout of Linus' master branch I
> got the following: 

> 
> [    9.302725] BUG: sleeping function called from invalid context at ./include/linux/buffer_head.h:358
> [    9.304403] in_atomic(): 1, irqs_disabled(): 0, pid: 1718, name: mount
> [    9.305633] 8 locks held by mount/1718:

Yeah, this looks like a regression cause by commit 4743f83990614af "ext4:
Fix WARN_ON_ONCE in ext4_commit_super()". Arguably that cure is worse than
the disease but OTOH calling ext4_commit_super() from an atomic context
(like __ext4_grp_locked_error() does) sucks as well.

I'm not sure what the right fix is here. The cleanest would probably be to
always drop group lock in __ext4_grp_locked_error() and make sure we always
properly bail out of mballoc code on such error. But that's a non-trivial
amount of work. Not sure if other ext4 people have opinion on this?

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
