From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/8] jbd2: Issue cache flush after checkpointing even
 with internal journal
Date: Sun, 18 Mar 2012 23:45:07 -0400
Message-ID: <20120319034507.GE31682@thunk.org>
References: <1329330854-14237-1-git-send-email-jack@suse.cz>
 <1329330854-14237-4-git-send-email-jack@suse.cz>
 <20120314021745.GC15379@thunk.org>
 <20120315085935.GA32209@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55810 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101Ab2CSDpI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Mar 2012 23:45:08 -0400
Content-Disposition: inline
In-Reply-To: <20120315085935.GA32209@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 15, 2012 at 09:59:35AM +0100, Jan Kara wrote:
> On Tue 13-03-12 22:17:45, Ted Tso wrote:
> > I'm not sure why you pulled out the code for
> > jbd2_journal_get_log_tail(), since there's no other usage of the
> > function, but it did make this commit harder to review.  It's good for
> > code movement patches to be segregated to their own commit, just to
> > make it easier to review....
>   I pulled the code out because the last patch in the series uses it from
> commit code. So it was not a deliberate code movement. But I agree it might
> have been easier to review if the code movement was a separate patch.
> Should I do that or have you already coped with the patch as is?

No, it's fine as it is.  I've merged your patches into the ext4 tree
for the upcoming merge window.  Thanks!!

							 Ted
