From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC PATCH 1/1] Allow ext4 to run without a journal.
Date: Tue, 04 Nov 2008 16:38:54 -0700
Message-ID: <20081104233854.GA3184@webber.adilger.int>
References: <1225397281.19114.13.camel@bobble.smo.corp.google.com>
 <20081030234037.GU3184@webber.adilger.int>
 <1225833701.7133.17.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Michael Rubin <mrubin@google.com>
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42920 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107AbYKDXjT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Nov 2008 18:39:19 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mA4NdIJo000677
	for <linux-ext4@vger.kernel.org>; Tue, 4 Nov 2008 15:39:18 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K9U001011NQ0100@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 04 Nov 2008 15:39:18 -0800 (PST)
In-reply-to: <1225833701.7133.17.camel@bobble.smo.corp.google.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 04, 2008  13:21 -0800, Frank Mayhar wrote:
> On Thu, 2008-10-30 at 17:40 -0600, Andreas Dilger wrote:
> > One option is to start with a wrapper like "ext4_handle_valid(handle)"
> > instead of checking "handle == NULL" everywhere.  Then, we could put
> > a magic value into "handle" and current->journal_info (maybe the
> > the ext3_sb_info pointer).  Put a magic value at the start of ext4_sb_info
> > that can be validated as never belonging to a journal handle, and then you
> > don't need to pass "sb" everywhere.  It also allows you to distinguish
> > between the "no handle was ever started" case and "running unjournalled".
> 
> Okay, yeah, this sounds like the way to go.  I had seen the previous
> handle==NULL case but had put it aside to get a proof-of-concept
> implementation going as quickly as possible.  Your explanation here
> clears things up.

True - my inspection was from the "what is needed to make this acceptable
for inclusion".  The code definitely looks reasonable for performance
testing under different loads.

> My suggestion is, for the non-journalling flag, set the first field
> (which in the handle is a pointer to the transaction) to NULL to
> distinguish it from a real handle.  As far as I can tell from browsing
> the code the h_transaction pointer in a real handle should never be
> NULL.  Please let me know if this is not the case.  And maybe offer
> another suggestion...?

I'm not dead set on a "magic number" solution either, just something
I thought of while looking through the patch.  It would definitely
help find places where the code is not doing matching start/stop of
the handle.  That isn't important if you are doing a lot of testing
with journals enabled, but it 

> (As an aside, this particular situation is one of the reasons a friend
> of mine, Tom Van Vleck, strongly insists on putting magic numbers and
> versions into structures.  I'm not as insistent about it as he is but it
> certainly would have helped here.)
> 
> > In any case, I'm not sure if this code is completely correct, since the
> > previous code allowed calling ext4_dirty_inode() without first starting
> > a journal handle, and now it would just silently do nothing and cause
> > filesystem corruption for the journalled case.
> 
> So now handle==NULL will only refer to this case, correct?  And I infer
> from your comment that handle != NULL refers to a started handle, that
> is, a handle that has a non-NULL h_transaction pointer (for my
> purposes).

Right.  It might even be worthwhile to add in some debugging to see
if ext4_dirty_inode() is EVER called with handle != NULL, or if this
conditional behaviour is just a residual from days of yore.  It seems
the only callsite is from the VFS and there may never be a transaction
started at that point, I'm not sure.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

