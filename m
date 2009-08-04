From: Theodore Tso <tytso@mit.edu>
Subject: Re: spatch for 64-bit e2fsprogs (was Re: Fix device too big bug in
	mainline?)
Date: Tue, 4 Aug 2009 10:48:46 -0400
Message-ID: <20090804144846.GE28678@mit.edu>
References: <20090730215302.GA31141@shell> <20090802002833.GB8680@mit.edu> <20090802022209.GC8680@mit.edu> <20090803202740.GE10853@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Julia Lawall <julia@diku.dk>, linux-ext4@vger.kernel.org,
	Eric Sandeen <sandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41535 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427AbZHDOtB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Aug 2009 10:49:01 -0400
Content-Disposition: inline
In-Reply-To: <20090803202740.GE10853@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 03, 2009 at 04:27:40PM -0400, Valerie Aurora wrote:
> I'm curious what you think of this proposal: Redo all the foo() ->
> foo2() patches in the entire 64-bit series as a semantic patches.

Well, certainly assembling all of the 64-bit changes into a single
patch is a good thing; I'm currently doing it by hand, by rearranging
patches and transplanting patch hunks around.  The reason why I
hesitate about automating things is that when then have to follow up
the patch with one that fixes up the types of various variables, and
also printf format statements, etc.

In addition, one challenge that has to be taken into account is that
once we start making wholesale changes, we start breaking the rest of
the patches in the patch queue.  So there are probably some changes
that we probably want to do by hand, and merge them into the tree
first.  This includes the bitmap changes (which I've simplified to the
point where we don't need make the *_bitmap -> *_bitmap64 type changes
any more), the filesystem swap code (which I think has an ABI change
and I want to fix slightly differently), the 64-bit dblist code (which
I want to look at more closely) and the progress meter code (which
again I want to clean up their API first).

So we probably need to merge some patches by hand before we get to the
changes that can be done via spatch.  Otherwise, if we start making
redoing thesemantic patch changes right away, the concern is that
we'll miss some of the more subtle changes that are contained within
the patch series.

If you want to start preparing for the semantic patches by preparing
and testing the receipes, and then helping to flag those patches that
contain some changes that contain some changes that can't be applied
via spatch, that would be helpful.

Does that sound like a plan?

						-Ted
