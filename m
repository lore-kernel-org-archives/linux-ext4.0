From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: ext4: fix metadata checksum calculation for the superblock
Date: Wed, 31 Oct 2012 20:22:49 -0700
Message-ID: <20121101032249.GH19591@blackbox.djwong.org>
References: <20121008024126.GC468@thunk.org>
 <20121101010521.893.qmail@science.horizon.com>
 <20121101011312.GG19591@blackbox.djwong.org>
 <20121101015015.GA28919@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: George Spelvin <linux@horizon.com>, linux-ext4@vger.kernel.org,
	tm@tao.ma
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19440 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186Ab2KADW4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Oct 2012 23:22:56 -0400
Content-Disposition: inline
In-Reply-To: <20121101015015.GA28919@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 31, 2012 at 09:50:15PM -0400, Theodore Ts'o wrote:
> On Wed, Oct 31, 2012 at 06:13:12PM -0700, Darrick J. Wong wrote:
> > > Author: Theodore Ts'o <tytso@mit.edu>
> > > Date: Sun Oct 7 22:18:56 2012 -0400
> > > Subject: ext4: fix metadata checksum calculation for the superblock
> 
> This one was cc'ed to stable@vger.kernel.org.  But when you said "I
> notice, that neither of thse have made it into 2.6.5", I assume you
> meant 3.5?  The last 3.5 kernel is 3.5.7, and Greg K-H isn't
> backporting fixes to 3.5.x any more.  (See http://www.kernel.org to
> see which kernels are marked "EOL"; those are the ones which are no
> longer getting updates.)
> 
> So that means it should eventually make it to the 3.4.x and 3.6.x
> kernels.

I thought he meant 3.6.5, but I haven't really been paying 3.6.x much attention.

> > > Author: Darrick J. Wong <darrick.wong@oracle.com>
> > > Date: Wed Oct 17 12:51:30 2012 -0700
> > > Subject: ext4: Don't verify checksums of dx non-leaf nodes during fallback linear scan
> 
> I missed this one because the subject line didn't have [PATCH] in it.
> (Darrick, it really helps if you use git format-patch / git
> send-email; you can use a message-id of the message you're replying to
> in the mail thread to chain the message to the thread.)
> 
> I would have eventually found it in patchwork, but even in patchwork
> the listing would have had a potentially misleading subject line,
> since it grabs the patch title from the subject line of the e-mail.

Oops, I guess I did forget the magic "[PATCH]".  Sorry about that.

> > <shrug> I was wondering too, but I figured Ted was probably busy dealing with
> > the corruption bug and such.
> > 
> > (Which itself doesn't seem to be in 3.6.x yet)
> 
> It isn't in 3.7-rc3 because I didn't see it before I sent the pull
> request to Linus....
> 
> At this point I'll just include it in the patches to be sent to Linus
> at the next merge window, mainly because I don't have the time to run
> a separate regression test run just for this patch, and it's only a
> cosmetic issue, right?

Yep.

--D
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
