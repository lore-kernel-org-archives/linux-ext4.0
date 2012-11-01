From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: fix metadata checksum calculation for the superblock
Date: Wed, 31 Oct 2012 21:50:15 -0400
Message-ID: <20121101015015.GA28919@thunk.org>
References: <20121008024126.GC468@thunk.org>
 <20121101010521.893.qmail@science.horizon.com>
 <20121101011312.GG19591@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: George Spelvin <linux@horizon.com>, linux-ext4@vger.kernel.org,
	tm@tao.ma
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58724 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756572Ab2KABuV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Oct 2012 21:50:21 -0400
Content-Disposition: inline
In-Reply-To: <20121101011312.GG19591@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 31, 2012 at 06:13:12PM -0700, Darrick J. Wong wrote:
> > Author: Theodore Ts'o <tytso@mit.edu>
> > Date: Sun Oct 7 22:18:56 2012 -0400
> > Subject: ext4: fix metadata checksum calculation for the superblock

This one was cc'ed to stable@vger.kernel.org.  But when you said "I
notice, that neither of thse have made it into 2.6.5", I assume you
meant 3.5?  The last 3.5 kernel is 3.5.7, and Greg K-H isn't
backporting fixes to 3.5.x any more.  (See http://www.kernel.org to
see which kernels are marked "EOL"; those are the ones which are no
longer getting updates.)

So that means it should eventually make it to the 3.4.x and 3.6.x
kernels.

> > Author: Darrick J. Wong <darrick.wong@oracle.com>
> > Date: Wed Oct 17 12:51:30 2012 -0700
> > Subject: ext4: Don't verify checksums of dx non-leaf nodes during fallback linear scan

I missed this one because the subject line didn't have [PATCH] in it.
(Darrick, it really helps if you use git format-patch / git
send-email; you can use a message-id of the message you're replying to
in the mail thread to chain the message to the thread.)

I would have eventually found it in patchwork, but even in patchwork
the listing would have had a potentially misleading subject line,
since it grabs the patch title from the subject line of the e-mail.

> <shrug> I was wondering too, but I figured Ted was probably busy dealing with
> the corruption bug and such.
> 
> (Which itself doesn't seem to be in 3.6.x yet)

It isn't in 3.7-rc3 because I didn't see it before I sent the pull
request to Linus....

At this point I'll just include it in the patches to be sent to Linus
at the next merge window, mainly because I don't have the time to run
a separate regression test run just for this patch, and it's only a
cosmetic issue, right?

						- Ted
