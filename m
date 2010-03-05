From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PULL REQUEST] Quota cleanups & fixes and ext3 fixes for
 2.6.34-rc1
Date: Fri, 5 Mar 2010 23:01:17 +0000
Message-ID: <20100305230117.GZ30031@ZenIV.linux.org.uk>
References: <20100305003304.GE4887@quack.suse.cz>
 <alpine.LFD.2.00.1003051314330.3906@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, dushistov@mail.ru,
	joel.becker@oracle.com, shaggy@linux.vnet.ibm.com,
	linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:56666 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358Ab0CEXB1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Mar 2010 18:01:27 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003051314330.3906@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 05, 2010 at 01:24:35PM -0800, Linus Torvalds wrote:
> 
> 
> On Fri, 5 Mar 2010, Jan Kara wrote:
> > 
> >   could you please pull from
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus
> > 
> >   You'll get lots of quota cleanups from Christoph which touch filesystems
> > all over the place but it's just function renaming and moving quota calls
> > from VFS into filesystems themselves.
> 
> Gaah. This interacted with the VFS stuff (the do_filp_open() cleanip in 
> particular) I merged from Al earlier today. 
> 
> It really looked very trivial, so I fixed it up. Al had split up 
> do_filp_open() into several helper functions, and one of your changes was 
> to the old pre-split one. I felt confident enough about it that I just did 
> the obvious merge resolution, but you guys should check it out to be sure.

It's OK as merge resolution, but I really wonder if that patch (taking
quota initialization to filesystems) is a good idea.  It adds boilerplate
code that is easy to miss.  And looking at what's done in e.g. ext2,
I'd say that places where it's added are lousy - if we want to do that
on directory modifications, we ought to take it into places that actually
create directory entries.  Not to mention that we never shrink directories
there, so it should be just one call in ext2_add_link() instead of all
that pile.

Looks like a good case for a followup series, if nothing else.
