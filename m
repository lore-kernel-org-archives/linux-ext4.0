From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] quota: Remove unnecessary definitions
Date: Tue, 24 Jan 2012 14:56:29 +0100
Message-ID: <20120124135629.GB18136@quack.suse.cz>
References: <1327004329-6909-1-git-send-email-jack@suse.cz>
 <20120123210922.GA17974@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Aditya Kali <adityakali@google.com>,
	linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52411 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513Ab2AXN4b (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jan 2012 08:56:31 -0500
Content-Disposition: inline
In-Reply-To: <20120123210922.GA17974@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 23-01-12 16:09:22, Ted Tso wrote:
> On Thu, Jan 19, 2012 at 09:18:49PM +0100, Jan Kara wrote:
> > 
> >  Ted, after applying this patch, you'll need to run 'make depend' to fixup
> > dependencies in makefiles. I didn't include that in the patch because on my
> > system the dependencies are different and so diff is 1500+ lines.
> > 
> > Also I've talked with Aditya and there's no real reason for libquota to be a
> > separate library. So I think it would be best to just make it part of
> > libext2fs. Do you agree?
> 
> My current thinking is to rename it to libinternal, and only build it
> statically.  It has all sorts of namespace leakage issues, and it's
> not clear any programs outside of e2fsprogs would need it any way.
> What do folks think?
  Well, I could see someone interested in modifying quota information on
unmounted fs image. So I believe there is some use in exporting at least
some quota functions. But it's better to export less in the beginning and
add what's needed later than having to maintain crappy API. So I'm OK with
your plan.

BTW one more question: So far I've kept quota format abstractions (taken
from quota-tools) in the quota code in e2fsprogs. But it's not really
needed and it's one of reasons why quota code I wrote for ocfs2-tools
achieves the same functionality in about half amount of lines (and that's
after reductions I already made). But the abstraction could become handy if
you decided to change quota file format. So should I keep the abstraction or
rip it out?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
