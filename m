From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] Fix possible NULL pointer dereference in JBD2
Date: Mon, 9 Feb 2009 18:34:41 +0100
Message-ID: <20090209173441.GA3824@duck.suse.cz>
References: <1233845582-954-1-git-send-email-jack@suse.cz> <20090205213744.GA9814@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, mfasheh@suse.com
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:38403 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754780AbZBIReo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Feb 2009 12:34:44 -0500
Content-Disposition: inline
In-Reply-To: <20090205213744.GA9814@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 05-02-09 16:37:44, Theodore Tso wrote:
> On Thu, Feb 05, 2009 at 03:52:59PM +0100, Jan Kara wrote:
> > 
> 
> >   the three patches below fix a bug in
> > jbd2_journal_begin_ordered_truncate() that could possibly lead to
> > NULL pointer dereference. The question is how to merge the fix as it
> > changes the prototype of the function and both ext4 and ocfs2 use
> > it.  Mark, Mingming, any suggestions?
> 
> Jan, how how easy is it to hit this?  Do you believe we should try to
> get this in for 2.6.29?  I got some final things to push to Linus so
> I can also push it via the ext4 tree.  I doubt it will conflict with
> > anything in my tree, either.
  The possibility of hitting this is quite small. We check
inode->i_transaction for NULL just before dereferencing it so the commit
would have to set it to NULL just between those two instructions.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
