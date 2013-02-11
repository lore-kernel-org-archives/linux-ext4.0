From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/12] ext4: pass context information to
 jbd2__journal_start()
Date: Mon, 11 Feb 2013 13:13:35 -0500
Message-ID: <20130211181335.GA8724@thunk.org>
References: <1360446832-12724-1-git-send-email-tytso@mit.edu>
 <1360446832-12724-6-git-send-email-tytso@mit.edu>
 <20130211161634.GI5318@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47898 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758503Ab3BKSNj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Feb 2013 13:13:39 -0500
Content-Disposition: inline
In-Reply-To: <20130211161634.GI5318@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 11, 2013 at 05:16:34PM +0100, Jan Kara wrote:
> > postmark-2917  [000] ....   196.435786: jbd2_handle_stats: dev 254,32
> >    tid 570 type 2 line_no 2541 interval 311 sync 0 requested_blocks 1
> >    dirtied_blocks 0
>   Nice! I'm just wondering - won't it be easier if we just stored a pointer
> to __FILE__ in the handle? We wouldn't have to define those transaction
> types and think which one to use when coding. Also checking the trace point
> output would be simpler. I guess using __FILE__ will increase kernel size
> due to additional string constants as gcc isn't clever enough to merge
> identical strings. But we could workaround that defining in every ext4
> file:

One of the reasons why I originally started with using an integer type
was that I was originally thinking about calculating handle-level
statistics (max hold time, average hold time, etc., and keeping those
statistics on a per-class basis).  So having an integer type number
was useful for that purpose.

Once I figured out that you could do things specify constraints such
as "interval > 5", the desire to do kernel-level statistics became
less urgent for me, since it's really finding the "long pole" handle
hold times which are most interesting.  I still might want to some
kernel-level statistics which are broken down by type, since once we
eliminate the long pole, knowing what the average handle hold times
are could still be useful/interesting.

Another downside of using a pointer to __FILE__, or some static
character pointer, is that it doesn't work for the applications such
as perf (and I think ftrace, although I'm not certain about the ftrace
tool, since I never use it) can't handle printing the char *, since
they use the ring buffer syscall directly instead of using the
TP_printk statement.  So all they get is a kernel address, and
something which is useful to decode.

But for users who are using the /sys/kernel/debug/tracing interface
via echo and cat, I do agree that using a static char *JBD_FILE so
that /sys/kernel/debug/trace has real file names would be a bit more
convenient for them.

					- Ted
