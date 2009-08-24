From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e4defrag: fix ppc build
Date: Mon, 24 Aug 2009 15:38:02 -0400
Message-ID: <20090824193802.GA17684@mit.edu>
References: <4A9220A6.7020000@redhat.com> <87f94c370908240640n75bef581k5abe45d4f18c2f68@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Kyle McMartin <kyle@mcmartin.ca>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48399 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbZHXTiO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Aug 2009 15:38:14 -0400
Content-Disposition: inline
In-Reply-To: <87f94c370908240640n75bef581k5abe45d4f18c2f68@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 24, 2009 at 09:40:51AM -0400, Greg Freemyer wrote:
> On Mon, Aug 24, 2009 at 1:09 AM, Eric Sandeen<sandeen@redhat.com> wrote:
> > From: Kyle McMartin <kyle@mcmartin.ca>
> >
> > ppc glibc seems to be missing sync_file_range, so we fell back
> > to the local define, and there ppc differs as well, so the
> > build was failing.
> >
> > Thanks to Kyle for the patch w/ the tidy solution.
> >
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> >
> > diff --git a/misc/e4defrag.c b/misc/e4defrag.c
> 
> Eric,
> 
> Which git repository holds e4defrag.c?  I assume it is public.
> 

e4defrag can be found in the 'master', 'next', and 'pu' branches of
the e2fsprogs repository.  It's not in the 'maint' branch, so it's not
in any of the e2fsprogs 1.41.x releases.  The 'master' branch contains
the in-development work that will be showing up in e2fsprogs 1.42; so
far the big things that there is the on-going merge 64-bit block
number support, and e4defrag.

							- Ted
