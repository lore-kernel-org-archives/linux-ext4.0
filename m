From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [RFC PATCH 1/1] Allow ext4 to run without a journal.
Date: Tue, 04 Nov 2008 13:21:41 -0800
Message-ID: <1225833701.7133.17.camel@bobble.smo.corp.google.com>
References: <1225397281.19114.13.camel@bobble.smo.corp.google.com>
	 <20081030234037.GU3184@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Michael Rubin <mrubin@google.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:33749 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbYKDVVu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Nov 2008 16:21:50 -0500
In-Reply-To: <20081030234037.GU3184@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-10-30 at 17:40 -0600, Andreas Dilger wrote:
> >  void ext4_dirty_inode(struct inode *inode)
> >  {
> > +	handle_t *current_handle = ext4_journal_current_handle(inode->i_sb);
> > +	if (!current_handle) {
> > +	handle_t *current_handle = ext4_journal_current_handle(inode->i_sb);
> 
> Wouldn't ext4_journal_current_handle() just return NULL always for an
> unjournalled ext4 filesystem?  Unfortunately, I can't see what "sb" is
> used for because your patch doesn't include the ext4_journal_current_handle()
> code.

Sorry about that, I'm doing the work in a p4 repository and somehow that
file didn't get p4 opened so it didn't generate the diff.  The short
version is that it was checking the COMPAT_HAS_JOURNAL flag.

> One option is to start with a wrapper like "ext4_handle_valid(handle)"
> instead of checking "handle == NULL" everywhere.  Then, we could put
> a magic value into "handle" and current->journal_info (maybe the
> the ext3_sb_info pointer).  Put a magic value at the start of ext4_sb_info
> that can be validated as never belonging to a journal handle, and then you
> don't need to pass "sb" everywhere.  It also allows you to distinguish
> between the "no handle was ever started" case and "running unjournalled".

Okay, yeah, this sounds like the way to go.  I had seen the previous
handle==NULL case but had put it aside to get a proof-of-concept
implementation going as quickly as possible.  Your explanation here
clears things up.

My suggestion is, for the non-journalling flag, set the first field
(which in the handle is a pointer to the transaction) to NULL to
distinguish it from a real handle.  As far as I can tell from browsing
the code the h_transaction pointer in a real handle should never be
NULL.  Please let me know if this is not the case.  And maybe offer
another suggestion...?

(As an aside, this particular situation is one of the reasons a friend
of mine, Tom Van Vleck, strongly insists on putting magic numbers and
versions into structures.  I'm not as insistent about it as he is but it
certainly would have helped here.)

> In any case, I'm not sure if this code is completely correct, since the
> previous code allowed calling ext4_dirty_inode() without first starting
> a journal handle, and now it would just silently do nothing and cause
> filesystem corruption for the journalled case.

So now handle==NULL will only refer to this case, correct?  And I infer
from your comment that handle != NULL refers to a started handle, that
is, a handle that has a non-NULL h_transaction pointer (for my
purposes).
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

