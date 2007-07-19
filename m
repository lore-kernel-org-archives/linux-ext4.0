From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsprogs-1.39-tyt3 and ext4 question
Date: Thu, 19 Jul 2007 10:29:15 -0400
Message-ID: <20070719142915.GH28872@thunk.org>
References: <f7nfun$lcs$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Zephiris <zephiris@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:52839 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756905AbXGSO3Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jul 2007 10:29:24 -0400
Content-Disposition: inline
In-Reply-To: <f7nfun$lcs$1@sea.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 19, 2007 at 03:55:10AM -0700, Zephiris wrote:
> I've searched the lists and only saw a previous reference to possibly
> harmless 'make check' failures on this version, so I'll just ask.
> I've been trying to get ext4 running for some time,  but it appears to be
> working normally lately. e4defrag and mballoc patches also appear to be
> working fine (everything against 2.6.22.1). But that version of e2fsprogs
> (1.39-tyt3), even with the last round of patches against it, appears to
> generate many bogus errors when checking the filesystem with 'fsck -fn'.
> While using 'data=journal' and other things should reduce the chance of
> needing a fsck, it makes me worried.

Can you send me a copy of dumpe2fs and the output of e2fsck -fn?  Yes,
e2fsprogs is running a bit behind the ext4 kernel at the moment due to
me being really busy, combined with the focus of transitioning
e2fsprogs to use git and getting a large number of changes to mainline
after the 2.6.22 merge window opened.

Also can you tell me what set of patches you used against 2.6.22.1?
Was it just the e4defrag and mballoc patches? 

This is the first report I've had that there were issues with the
e2fsprogs 1.39-tyt3 (which I've always said was for developers only),
but I'll look into it and see what I can do.

I do know that a last minute change we made to the extent format just
before the 2.6.23 push to allow 2**15 length extents is not reflected
in the 1.39-tyt3 e2fsprogs.  But the description of the errors you
reported don't sound like that would be the issue.  (And that change
would't show up in real life without some additional patches to
relocate the block group metadata that are definitely not yet in
mainline.)

						- Ted
