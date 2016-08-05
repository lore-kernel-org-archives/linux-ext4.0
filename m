From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Sleeping function called in invalid context
Date: Fri, 5 Aug 2016 10:56:04 -0400
Message-ID: <20160805145604.GA9105@thunk.org>
References: <57A19B9B.60005@kyup.com>
 <20160804160550.GA12861@quack2.suse.cz>
 <20160804205845.GC10933@thunk.org>
 <57A43267.7030608@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Nikolay Borisov <kernel@kyup.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53774 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422688AbcHEO4S (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Aug 2016 10:56:18 -0400
Content-Disposition: inline
In-Reply-To: <57A43267.7030608@kyup.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 05, 2016 at 09:29:59AM +0300, Nikolay Borisov wrote:
> > The easist way to fix this is defer the ext4_commit_super() to a
> > workqueue.  We only need this in the errors=continue case, and in that
> > scenario we're not in a hurry when the superblock gets written out.
> 
> Is errors=continue the default option if nothing specifically is
> specified at mount time, since I don't have this set explicitly:
> 
> /dev/vda / ext4 rw,relatime,data=ordered 0 0

Yes, it's the default.  I keep wondering whether we should change the
default to remount-ro or even panic, since people sometimes don't
notice that the "file system has been corrupted" messages, and then
they can end up losing a lot more detail if we forced them to address
the issue right away.

						- Ted
