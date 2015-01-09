From: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: ext4 wrote extents on ext2 fs?
Date: Sat, 10 Jan 2015 00:38:35 +0100
Message-ID: <1420846715.9731.1.camel@sipsolutions.net>
References: <1420841908.7511.1.camel@sipsolutions.net>
	 <20150109233009.GB31554@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49411 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855AbbAIXii (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Jan 2015 18:38:38 -0500
In-Reply-To: <20150109233009.GB31554@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2015-01-09 at 18:30 -0500, Theodore Ts'o wrote:

> What I suspect happened is that some kind of garbage --- perhaps
> simply a single 4k block of 0xFF's --- got written into the inode
> table.  This would trigger this sort of complaint from e2fsck.

Ok, makes sense. It's a USB flash drive, so perhaps it just messed up
with its FTL and showed a deleted block in place of the real one.

> > Perhaps this is just a consequence of check ordering though - maybe if
> > the inode flags get corrupted then the EXTENTS flag is just the first
> > one that will be tested in the e2fsck code?
> 
> Yes, this is one of the first things that e2fsck 1.42.x would test
> for.

Thanks for the confirmation.

Thanks,
johannes

