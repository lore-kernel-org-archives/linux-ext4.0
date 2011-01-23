From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [PATCH 1/3] jbd2 : Make jbd2 transaction handle allocation to
 return errors and handle them gracefully.
Date: Sat, 22 Jan 2011 22:29:01 -0800
Message-ID: <20110123062900.GA7436@noexit>
References: <AANLkTi=o-rcsbY1gOExGyWdQ41m7KWpJ7=UzX4306m=t@mail.gmail.com>
 <20110123054049.GC3237@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Manish Katiyar <mkatiyar@gmail.com>, Jan Kara <jack@suse.cz>,
	ext4 <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:42648 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab1AWG3J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Jan 2011 01:29:09 -0500
Content-Disposition: inline
In-Reply-To: <20110123054049.GC3237@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 23, 2011 at 12:40:49AM -0500, Ted Ts'o wrote:
> On Sat, Jan 22, 2011 at 07:32:44PM -0800, Manish Katiyar wrote:
> >  Hi Jan,
> > 
> > This is the follow up from https://lkml.org/lkml/2011/1/17/154
> > Following patches make jbd2 to use GFP_KERNEL for transaction
> > allocation if the caller can handle the errors. Following is the list
> > of functions that I updated to pass the new flag. Also below is the
> > list of functions which still have the old behavior and pass the old
> > flags (either because they can't deal with errors, or I wasn't too
> > sure so I did conservatively). Appreciate your feedback. The other
> > callers of jbd2_journal_start() are from ocfs2, they still pass the
> > old flag.
> 
> Hmm, I wonder if it would be better to use
> 
> jbd2_journal_start(...)
> 
> and
> 
> jbd2_journal_start_nofail(...)

	This API is markedly better to read.  Btw, does _nofail() mean no
possible failures, or just no memory errors?  If it is no failures, I'd
love to see the function become void.

> The tradeoff is that long-term, the code is more readable (as opposed
> to having people look up what a random "true" or "false" value means).
> But short-term, while it will make the patch smaller, it also makes
> the patch harder audit, since we need to look at all of the places
> where we _haven't_ made a change to make sure those call sites can
> tolerate an error return.

	I think we should start with jbd2_journal_start_can_fail() or
something like it, and change it back to jbd2_journal_start() in the
next window.  It's a silly name, but it catches exactly what you are
worried about.

Joel

-- 

Life's Little Instruction Book #94

	"Make it a habit to do nice things for people who 
	 will never find out."

			http://www.jlbec.org/
			jlbec@evilplan.org
