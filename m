From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Oops with ext(3|4) and audit and Xen
Date: Mon, 8 Oct 2012 17:39:07 -0400
Message-ID: <20121008213907.GE22980@thunk.org>
References: <CALnj_=5eQ5vCmv8x3u-rJPzofqJr+WDJuYzkpZo8sLe0+B2AAw@mail.gmail.com>
 <50732492.4040705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Moody <pmoody@google.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54478 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab2JHVjL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Oct 2012 17:39:11 -0400
Content-Disposition: inline
In-Reply-To: <50732492.4040705@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 08, 2012 at 02:08:02PM -0500, Eric Sandeen wrote:
> I had suggested this on the other list, but will put it here too, though it
> might be a long shot.  If threadinfo gets corrupted, the irqs_enabled()
> test might give the wrong answer.
> 
> Peter also mentioned that he had tried putting WARN_ON(irqs_disabled()) at
> various places along the stack above and never got it to trip; until after
> the BUG_ON() had fired; this makes me think corruption might be a possibility
> after all.

Well, there is absolutely no place where we disable interrupts in
ext3.  In ext4 we do have some spinlock_irqsave/irqresture() calls,
but they are tightly bracketed --- and since you can reproduce this
with ext3, I think that pretty much exonerates ext4.

Hmm.... one possibility might be that it's some XEN-specific paravirt
call that happens to be called by ext3/ext4 and which is leaving
interrupts disabled on its return due to a missing irqrestore() call?

Can you reproduce the problem if you disable XEN and run this on a
native system?  What if you run a kernel w/o auditing but under Xen?
Maybe that will allow you to figure out what the critical variable
might be?

I'll note that if ext3 or ext4 was playing with interrupts and leaving
them disabled, we'd have a huge number of people complaining.  So the
question is whether it's something unique to audit, or unique to Xen,
or perhaps the combination of the two....

					- Ted
