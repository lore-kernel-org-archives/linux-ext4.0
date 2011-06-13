From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: Fix oops in jbd2_journal_remove_journal_head()
Date: Mon, 13 Jun 2011 16:10:14 +0200
Message-ID: <20110613141014.GE4907@quack.suse.cz>
References: <1306768378-27748-1-git-send-email-jack@suse.cz>
 <20110606141630.GK7180@thunk.org>
 <20110608193142.GH5361@quack.suse.cz>
 <20110612214113.GD2662@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59381 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab1FMOKP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jun 2011 10:10:15 -0400
Content-Disposition: inline
In-Reply-To: <20110612214113.GD2662@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 12-06-11 17:41:13, Ted Tso wrote:
> On Wed, Jun 08, 2011 at 09:31:42PM +0200, Jan Kara wrote:
> > On Mon 06-06-11 10:16:30, Ted Tso wrote:
> > > On Mon, May 30, 2011 at 05:12:58PM +0200, Jan Kara wrote:
> > > >  /*
> > > > - * For the unlocked version of this call, also make sure that any
> > > > - * hanging journal_head is cleaned up if necessary.
> > > > + * For the unlocked version of this call, also drop buffer_head reference.
> > > >   *
> > > >   * __jbd2_journal_refile_buffer is usually called as part of a single locked
> > >      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > 
> > > Doesn't this paragraph refer to jbd2_journal_refile_buffer(), not
> > > __jbd2_journal_refile_buffer()?  Or am I missing something?
> >   Hmm, the comment seems to be wrong. The comment about buffer_head
> > reference does not apply anymore. I'll fix that.
> 
> Are you going to be sending me a new version of this patch with this
> comment fixed?  Or should I just remove it?
  I've replaced a comment with a better one, also fixed one more wrong
comment I've found and resent the patch now. Thanks for reminding me.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
