From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: kerneloops.org: 2.6.26-rc possible regression in ext3
Date: Wed, 18 Jun 2008 23:14:12 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0806182302340.2907@woody.linux-foundation.org>
References: <4859EFE2.2090202@linux.intel.com> <alpine.LFD.1.10.0806182242390.2907@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>
To: Arjan van de Ven <arjan@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59950 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754102AbYFSGOP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jun 2008 02:14:15 -0400
In-Reply-To: <alpine.LFD.1.10.0806182242390.2907@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Wed, 18 Jun 2008, Linus Torvalds wrote:
> 
> One thing I note is that all the oopses seem to be i686 - are there that 
> few x86-64 fc10 users (I'd have assumed that 64-bit is starting to be the 
> norm for people who live on the edge, but perhaps I'm just out of touch)? 
> 
> Or could this perhaps be an indication that it is specific to i686 some 
> way (eg a compiler issue?)

The oops code is odd:

  27:	8d 4c 18 fe          	lea    0xfffffffe(%eax,%ebx,1),%ecx
  2b:*	8b 19                	mov    (%ecx),%ebx     <-- trapping instruction
  2d:	83 e9 08             	sub    $0x8,%ecx
  30:	89 d8                	mov    %ebx,%eax
  32:	66 d1 e8             	shr    %ax
  35:	0f b7 c0             	movzwl %ax,%eax

and that "lea" is doing an address computation of "eax+2*ebx-2". Which 
does *not* look like an address to a 32-bit entity, but to a 16-bit one. 
Yeah, it's not conclusive, but it is suggestive.

And the 16-bit "shr+movzwl" further strengthens the case that it is 
actually working on a 16-bit entity. The trapping instruction _should_ 
possibly have been a "movzwl (%ecx),%ebx" to begin with.

But it did a 32-bit load, and in this case it looks as if the 16-bit load 
would have been correct! The value of ECX in this example was

	ECX: dc384ffe

ie it was indeed a two-byte aligned thing at the end of the page, and if 
the load had been a 16-bit load (like the data seems to be), it would 
never have oopsed! The page fault seems to be due to DEBUG_PAGEALLOC and 
the next page being unmapped because it's not allocated.

I only looked closer at one particular oops (25906, in case anybody 
cares), but at least judging from that particular one I would indeed 
suspect a compiler bug.

Of course, the main reason I say that is that none of the ext3 or VFS 
changes look even _remotely_ relevant to any of this. They really don't 
look like they could possibly matter for "do_split()" unless there is 
something really odd going on.

			Linus
