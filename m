From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Recovery after mkfs.ext4 on a ext4
Date: Mon, 23 Jun 2014 08:37:58 -0400
Message-ID: <20140623123758.GA14887@thunk.org>
References: <539D555E.3050707@scarlet.be>
 <20140615132026.GC2180@thunk.org>
 <539E019C.6060600@scarlet.be>
 <20140615214403.GA1420@thunk.org>
 <53A7C4A1.4000603@scarlet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Killian De Volder <killian.de.volder@scarlet.be>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53022 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529AbaFWMiC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jun 2014 08:38:02 -0400
Content-Disposition: inline
In-Reply-To: <53A7C4A1.4000603@scarlet.be>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 23, 2014 at 08:09:37AM +0200, Killian De Volder wrote:
> It's still checking due to the high amount of ram it's using.
> However if I start a parallel check with -nf if find other errors the one with the high memory usage hasn't found yet ?

No, definitely not that!  Running two e2fsck's in parallel will do far
more harm than good.

> Should I start a new one, or is this not advised ?
> As sometimes I think it's bad inodes causing artificial usage of memory.

What part of the e2fsck run are you in?  If you are in passes
1b/1c/1d, then one of the things you can do is to analyze the log
output to date, and individually investigate the inodes that were
reported as bad using debugfs.  You could then backup what was worth
backuping up out of those inodes, and then use the debugfs "clri"
command to zap the bad inode.  I have done that to reduce the number
of bad inodes to make e2fsck pass 1b, 1c, and 1d run faster.  But I've
never done it on a really huge file system, and it may not be worth
the effort.

What I'd probably do instead is to edit e2fsck to skip pass 1b, 1c,
and 1d, and then hope for the best.  The file system will still be
corrupted, and there is the chance that you will do some damage in the
later passes because you skipped passes 1b/c/d, but if the goal is to
get the file system in a state where you can safely mount it
read-only, that would probably be your best bet.

						- Ted
