From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/12] ext4: pass context information to
 jbd2__journal_start()
Date: Mon, 11 Feb 2013 15:14:41 -0500
Message-ID: <20130211201441.GA14005@thunk.org>
References: <1360446832-12724-1-git-send-email-tytso@mit.edu>
 <1360446832-12724-6-git-send-email-tytso@mit.edu>
 <20130211161634.GI5318@quack.suse.cz>
 <20130211181335.GA8724@thunk.org>
 <20130211195855.GB14172@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47909 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758792Ab3BKUOo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Feb 2013 15:14:44 -0500
Content-Disposition: inline
In-Reply-To: <20130211195855.GB14172@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 11, 2013 at 08:58:55PM +0100, Jan Kara wrote:
> > Another downside of using a pointer to __FILE__, or some static
> > character pointer, is that it doesn't work for the applications such
> > as perf (and I think ftrace, although I'm not certain about the ftrace
> > tool, since I never use it) can't handle printing the char *, since
> > they use the ring buffer syscall directly instead of using the
> > TP_printk statement.  So all they get is a kernel address, and
> > something which is useful to decode.
>
>   One can overcome this relatively easily by defining the trace
> event to have __array(char, file, 32) and then strcpy() the name to is in
> TP_fast_assign(). We do this in lot of other trace points as well (with
> device names etc.).

True, but then the tradeoff is that we've bloated the size of the
tracepoint in the ring buffer.  Given how many handles can be created
and closed per second, keeping the tracepoint size small is also
desireable.  Of course one thing we could do is use a small integer,
and then have a sysfs interface which maps the integer to the file
name.   That may be overkill, though.

> 
> > But for users who are using the /sys/kernel/debug/tracing interface
> > via echo and cat, I do agree that using a static char *JBD_FILE so
> > that /sys/kernel/debug/trace has real file names would be a bit more
> > convenient for them.
>   Convenience of use is one thing, having programmer properly assign new
> handle types (or use old ones) is another. And you also have questions like
> - there are three call sites with this handle type but I cannot figure out
> which of them is causing problems.

Well, that's what the line number is for (so you can distinguish the
call site).  The other reason why using a type separate from the file
name is sometimes the best way to classify different types of handle
operations isn't necessarily by file name.  As far as the effort of
programmers to assign new handle types, I don't really anticipate that
this will be a common thing; it's pretty rare that we introduce code
which requires new calls to ext4_journal_start/ext4_journal_stop.  And
when programmers do need to do this, the question of which handle type
to use or whether to create a new handle type is a pretty minor issue.
The much greater difficulty is figuring out how many journal credits
to reserve.  :-)

						- Ted
