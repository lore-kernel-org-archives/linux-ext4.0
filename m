From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/1] Allow ext4 to run without a journal.
Date: Mon, 15 Dec 2008 23:00:11 -0500
Message-ID: <20081216040011.GF11502@mit.edu>
References: <1228953270.14314.15.camel@bobble.smo.corp.google.com> <1229362555.19828.2.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:36420 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750958AbYLPEAO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Dec 2008 23:00:14 -0500
Content-Disposition: inline
In-Reply-To: <1229362555.19828.2.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 15, 2008 at 09:35:55AM -0800, Frank Mayhar wrote:
> On Wed, 2008-12-10 at 15:54 -0800, Frank Mayhar wrote:
> > A few weeks ago I posted a patch for discussion that allowed ext4 to run
> > without a journal.  Since that time I've integrated the excellent
> > comments from Andreas and fixed several serious bugs.  We're currently
> > running with this patch and generating some performance numbers against
> > both ext2 (with backported reservations code) and ext4 with and without
> > a journal.  It just so happens that running without a journal is
> > slightly faster for most everything.
> 
> Has anyone had a chance to take a look at this?  Andreas?  Ted?  Anyone?

For some reason it didn't show up in my mailbox; maybe an errant SPAM
checker grabbed it?  (For some reason Herbert Xu's mail server
recently blacklisted my mail server, so he can't get any e-mails from
me, whether it's a reply to LKML or an invite to the kernel summit.
More recently Baracuda Networks, which handles mit.edu's spam
filtering, blacklisted the mail server for the vendor-sec mailing
list.  Go figure.)  

Fortunately your patch did show up in patchwork:

	http://patchwork.ozlabs.org/project/linux-ext4/

I've been travelling, so I haven't had a chance to look at it,
although I did note that it had showed up over the weekend when I was
going over the patch queue and reconciling it with Patchwork, and
wondered why I hadn't seen earlier...

I will try to get it shortly.

Regards,

						- Ted
