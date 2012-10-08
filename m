From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Oops with ext(3|4) and audit and Xen
Date: Mon, 08 Oct 2012 16:40:45 -0500
Message-ID: <5073485D.1080707@redhat.com>
References: <CALnj_=5eQ5vCmv8x3u-rJPzofqJr+WDJuYzkpZo8sLe0+B2AAw@mail.gmail.com> <50732492.4040705@redhat.com> <20121008213907.GE22980@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Peter Moody <pmoody@google.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab2JHVkw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Oct 2012 17:40:52 -0400
In-Reply-To: <20121008213907.GE22980@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/8/12 4:39 PM, Theodore Ts'o wrote:
> On Mon, Oct 08, 2012 at 02:08:02PM -0500, Eric Sandeen wrote:
>> I had suggested this on the other list, but will put it here too, though it
>> might be a long shot.  If threadinfo gets corrupted, the irqs_enabled()
>> test might give the wrong answer.
>>
>> Peter also mentioned that he had tried putting WARN_ON(irqs_disabled()) at
>> various places along the stack above and never got it to trip; until after
>> the BUG_ON() had fired; this makes me think corruption might be a possibility
>> after all.
> 
> Well, there is absolutely no place where we disable interrupts in
> ext3.  In ext4 we do have some spinlock_irqsave/irqresture() calls,
> but they are tightly bracketed --- and since you can reproduce this
> with ext3, I think that pretty much exonerates ext4.
> 
> Hmm.... one possibility might be that it's some XEN-specific paravirt
> call that happens to be called by ext3/ext4 and which is leaving
> interrupts disabled on its return due to a missing irqrestore() call?
> 
> Can you reproduce the problem if you disable XEN and run this on a
> native system?  What if you run a kernel w/o auditing but under Xen?
> Maybe that will allow you to figure out what the critical variable
> might be?
> 
> I'll note that if ext3 or ext4 was playing with interrupts and leaving
> them disabled, we'd have a huge number of people complaining.  So the
> question is whether it's something unique to audit, or unique to Xen,
> or perhaps the combination of the two....

and unique to running a 32-bit binary as well, right?

> 					- Ted


