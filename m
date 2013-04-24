From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: page eviction from the buddy cache
Date: Wed, 24 Apr 2013 14:41:30 -0700
Message-ID: <20130424144130.0d28b94b229b915d7f9c7840@linux-foundation.org>
References: <alpine.LNX.2.00.1303271135420.29687@eggly.anvils>
	<3C8EEEF8-C1EB-4E3D-8DE6-198AB1BEA8C0@gmail.com>
	<515CD665.9000300@gmail.com>
	<239AD30A-2A31-4346-A4C7-8A6EB8247990@gmail.com>
	<51730619.3030204@fastmail.fm>
	<20130420235718.GA28789@thunk.org>
	<5176785D.5030707@fastmail.fm>
	<20130423122708.GA31170@thunk.org>
	<alpine.LNX.2.00.1304231230340.12850@eggly.anvils>
	<20130423150008.046ee9351da4681128db0bf3@linux-foundation.org>
	<20130424142650.GA29097@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Hugh Dickins <hughd@google.com>,
	Bernd Schubert <bernd.schubert@fastmail.fm>,
	Alexey Lyahkov <alexey.lyashkov@gmail.com>,
	Will Huck <will.huckk@gmail.com>,
	Andrew Perepechko <anserper@ya.ru>, linux-ext4@vger.kernel.org,
	linux-mm@kvack.org, mgorman@suse.de
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758268Ab3DXVlc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Apr 2013 17:41:32 -0400
In-Reply-To: <20130424142650.GA29097@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 24 Apr 2013 10:26:50 -0400 "Theodore Ts'o" <tytso@mit.edu> wrote:

> On Tue, Apr 23, 2013 at 03:00:08PM -0700, Andrew Morton wrote:
> > That should fix things for now.  Although it might be better to just do
> > 
> >  	mark_page_accessed(page);	/* to SetPageReferenced */
> >  	lru_add_drain();		/* to SetPageLRU */
> > 
> > Because a) this was too early to decide that the page is
> > super-important and b) the second touch of this page should have a
> > mark_page_accessed() in it already.
> 
> The question is do we really want to put lru_add_drain() into the ext4
> file system code?  That seems to pushing some fairly mm-specific
> knowledge into file system code.  I'll do this if I have to do, but
> wouldn't be better if this was pushed into mark_page_accessed(), or
> some other new API was exported by the mm subsystem?

Sure, that would be daft.  We'd add a new
mark_page_accessed_right_now_dont_use_this() to mm/swap.c

