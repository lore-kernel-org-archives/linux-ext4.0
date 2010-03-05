From: tytso@mit.edu
Subject: Re: possible ext4 related deadlock
Date: Fri, 5 Mar 2010 10:45:52 -0500
Message-ID: <20100305154552.GA6000@thunk.org>
References: <4B754E5E.603@ge.com>
 <4B910D8C.30301@ge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Enrik Berkhan <Enrik.Berkhan@ge.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:53454 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472Ab0CEPp4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Mar 2010 10:45:56 -0500
Content-Disposition: inline
In-Reply-To: <4B910D8C.30301@ge.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 05, 2010 at 02:56:28PM +0100, Enrik Berkhan wrote:
> 
> Meanwhile, I have found out that thread 2 actually isn't completely
> blocked but loops in __alloc_pages_internal:
> 
> get_page_from_freelist() doesn't return a page;
> try_to_free_pages() returns did_some_progress == 0;
> later, do_retry == 1 and the loop restarts with goto rebalance;
>
> 
> Can anybody explain this behaviour and maybe direct me to the root cause?
> 
> Of course, this now looks more like a page allocation problem than
> an ext4 one.

Yep, I'd have to agree with you.  We're only trying to allocate a
single page here, and you have plenty of pages available.  Just
checking....  you don't have CONFIG_NUMA enabled and doing something
crazy with NUMA nodes, are you?

The reason why there is no retry logic in this piece of code is this
is not something that we've *ever* anticipated would fail --- and if
it fails, the system is so badly in the weeds that we're probably
better off just returning ENOMEM and return an error to userspace; if
you can't even allocate a single page, the OOM killer should have been
killing off random processes for a while anyway, so a ENOMEM return to
a write(2) system call means the process has gotten off lightly; it's
lucky to still be alive, after all, with the OOM killer surely going
postal if things are so bad that a 4k page allocation isn't
succeeding.  :-)

So I would definitely say this is a problem with the page allocation
mechanism; you say it's been modified a bit for NOMMU for the Blackfin
architecture?  I imagine the fact that you don't have any kind of VM
means that the allocator must be playing all sorts of tricks to make
sure that a process can allocate memory contiguously in its data
segment, for example.  I assume that there are regions of memory which
are reserved for page cache?  I'm guessing you have to change how much
room is reserved for the page cache, or some such.  This sounds like
it's a Blackfin-specific issue.

My recommendation would be that you don't put the retry loop in the
ext4 code, since I suspect this is not going to be the only place
where the Blackfin is going to randomly fail to give you a 4k page,
even though there's plenty of memory somewhere else.  The lack of an
MMU pretty much guarantees this sort of thing can happen.  So putting
the retry loop in the page allocator, with a WARN_ON(1) when it
happens, so the developers can appropriately tune the manual memory
partition settings, seems like the better approach.

Regards,

					- Ted
