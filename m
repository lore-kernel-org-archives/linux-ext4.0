From: Theodore Tso <tytso@mit.edu>
Subject: Re: async commit & write barrier code
Date: Tue, 23 Sep 2008 18:35:05 -0400
Message-ID: <20080923223505.GA11346@mit.edu>
References: <48D7D3DF.70505@redhat.com> <48D9545E.8040302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:37957 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751538AbYIWWfI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Sep 2008 18:35:08 -0400
Content-Disposition: inline
In-Reply-To: <48D9545E.8040302@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 23, 2008 at 03:41:02PM -0500, Eric Sandeen wrote:
> 
> I agree; with async commit, ext4/jbd2 is running with *no* barrier
> writes in jbd code. (FWIW, on the fsync front, fsync calls
> blkdev_issue_flush in ext4 so that part may actually be ok in the end).
> 
> But at a minimum, I think that for data=ordered, there is now *no*
> guarantee that the associated file data actually hits disk before the
> size updates, is there?

I think the theory behind this was that the journal checksums would
protect us against misordered writes.  But yes, this means that we
would effectively have data=writeback, and not data=ordered.  More
seriously, when I started using my root filesystem with async commit,
when the system crashed after suspend/resumes, I was seeing filesystem
corruptions which caused data loss and which required e2fsck to fix.
I've commented the patch out of the series file for now, until we can
do some more testing of async commit.

							- Ted
