From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] resolve duplicate flag no for PG_lazyfree
Date: Mon, 14 May 2007 13:46:06 -0700
Message-ID: <20070514134606.695f087a.akpm@linux-foundation.org>
References: <379110250.28666@ustc.edu.cn>
	<20070513224630.3cd0cb54.akpm@linux-foundation.org>
	<20070514180618.GB9399@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Fengguang Wu <fengguang.wu@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Rik van Riel <riel@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Nick Piggin <nickpiggin@yahoo.com.au>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756673AbXENUqa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 May 2007 16:46:30 -0400
In-Reply-To: <20070514180618.GB9399@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 14 May 2007 14:06:19 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Sun, May 13, 2007 at 10:46:30PM -0700, Andrew Morton wrote:
> > otoh, the intersection between pages which are PageBooked() and pages which
> > are PageLazyFree() should be zreo, so it'd be good to actually formalise
> > this reuse within the ext4 patches.
> > 
> > otoh2, PageLazyFree() could have reused PG_owner_priv_1.
> > 
> > Rik, Ted: any thoughts?  We do need to scrimp on page flags: when we
> > finally run out, we're screwed.
> 
> It makes sense to me.  PG_lazyfree is currently only in -mm, right?

Ah, yes, I got confused, sorry.

>  I
> don't see it in my git tree.  It would probably would be a good idea
> to make sure that we check to add some sanity checking code if it
> isn't there already that PG_lazyfree isn't already set when try to set
> PG_lazyfree (just in case there is a bug in the future which causes
> the should-never-happen case of trying lazy free a PageBooked page).
> 

Actually, I think the current status of
lazy-freeing-of-memory-through-madv_free.patch is "might not be needed".  I
_think_ we've determined that 0a27a14a62921b438bb6f33772690d345a089be6
sufficiently fixed the perfomance problems we had in there?
