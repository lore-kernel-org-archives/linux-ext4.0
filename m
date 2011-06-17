From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: create com_err.h symlink in includedir
Date: Thu, 16 Jun 2011 22:31:49 -0400
Message-ID: <20110617023149.GD29725@thunk.org>
References: <4D5C1103.8060403@redhat.com>
 <20110220231015.GA4001@thunk.org>
 <4D84C5C9.1060507@redhat.com>
 <4DFA69EB.3060907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>, mitchb@mit.edu,
	Bruce Cassidy <bruce@whamcloud.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:32869 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab1FQCbw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jun 2011 22:31:52 -0400
Content-Disposition: inline
In-Reply-To: <4DFA69EB.3060907@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 16, 2011 at 03:39:07PM -0500, Eric Sandeen wrote:
> > Hm, now in a "make rpm" build which has source in one place and rpm build
> > area in another:
> > 
> > /bin/ln: creating hard link `/home/sandeen/rpmbuild/BUILDROOT/e2fsprogs-1.41.14-0.x86_64/usr/include/com_err.h' => `/usr/include/et/com_err.h': Invalid cross-device link
> > 
> > so I'm not quite sure how to work around this.
> > 
> > Maybe in the end it does have to be packaging-specific, with the
> > link created by the distro pkg scripts...?
> 
> Ted, your change broke any builds span 2 different filesystems.

I thought I fixed this with commit 1e082c62?

Which Makefile is breaking?  Is this the one in lib/et/Makefile.in?
It currently reads:

   $(Q) (cd $(DESTDIR)$(includedir) ;\
   	$(LN) $(LINK_INSTALL_FLAGS) et/com_err.h . )

and I don't see how that could have generated the error you've cited
above...

						- Ted


