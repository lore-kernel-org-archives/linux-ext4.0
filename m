From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 05/12] ext4: pass context information to
 jbd2__journal_start()
Date: Mon, 11 Feb 2013 20:58:55 +0100
Message-ID: <20130211195855.GB14172@quack.suse.cz>
References: <1360446832-12724-1-git-send-email-tytso@mit.edu>
 <1360446832-12724-6-git-send-email-tytso@mit.edu>
 <20130211161634.GI5318@quack.suse.cz>
 <20130211181335.GA8724@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47961 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759958Ab3BKT65 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Feb 2013 14:58:57 -0500
Content-Disposition: inline
In-Reply-To: <20130211181335.GA8724@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 11-02-13 13:13:35, Ted Tso wrote:
> On Mon, Feb 11, 2013 at 05:16:34PM +0100, Jan Kara wrote:
> > > postmark-2917  [000] ....   196.435786: jbd2_handle_stats: dev 254,32
> > >    tid 570 type 2 line_no 2541 interval 311 sync 0 requested_blocks 1
> > >    dirtied_blocks 0
> >   Nice! I'm just wondering - won't it be easier if we just stored a pointer
> > to __FILE__ in the handle? We wouldn't have to define those transaction
> > types and think which one to use when coding. Also checking the trace point
> > output would be simpler. I guess using __FILE__ will increase kernel size
> > due to additional string constants as gcc isn't clever enough to merge
> > identical strings. But we could workaround that defining in every ext4
> > file:
> 
> One of the reasons why I originally started with using an integer type
> was that I was originally thinking about calculating handle-level
> statistics (max hold time, average hold time, etc., and keeping those
> statistics on a per-class basis).  So having an integer type number
> was useful for that purpose.
> 
> Once I figured out that you could do things specify constraints such
> as "interval > 5", the desire to do kernel-level statistics became
> less urgent for me, since it's really finding the "long pole" handle
> hold times which are most interesting.  I still might want to some
> kernel-level statistics which are broken down by type, since once we
> eliminate the long pole, knowing what the average handle hold times
> are could still be useful/interesting.
  Agreed. Although for debugging purposes one can compute this info from
stats output by tracepoints. But if you want to ask users to give you
stats, computing them in kernel is superior (less overhead than full
tracing). We could still compute per call site stats with __FILE__, lineno
pair but it would require some hashing and is probably an overkill.

> Another downside of using a pointer to __FILE__, or some static
> character pointer, is that it doesn't work for the applications such
> as perf (and I think ftrace, although I'm not certain about the ftrace
> tool, since I never use it) can't handle printing the char *, since
> they use the ring buffer syscall directly instead of using the
> TP_printk statement.  So all they get is a kernel address, and
> something which is useful to decode.
  One can overcome this relatively easily by defining the trace
event to have __array(char, file, 32) and then strcpy() the name to is in
TP_fast_assign(). We do this in lot of other trace points as well (with
device names etc.).

> But for users who are using the /sys/kernel/debug/tracing interface
> via echo and cat, I do agree that using a static char *JBD_FILE so
> that /sys/kernel/debug/trace has real file names would be a bit more
> convenient for them.
  Convenience of use is one thing, having programmer properly assign new
handle types (or use old ones) is another. And you also have questions like
- there are three call sites with this handle type but I cannot figure out
which of them is causing problems.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
