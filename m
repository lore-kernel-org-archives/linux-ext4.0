From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] [PATCH 3/3] Recursive mtime for ext3
Date: Tue, 6 Nov 2007 14:40:12 -0500
Message-ID: <20071106194012.GE12857@thunk.org>
References: <20071106171537.GD23689@duck.suse.cz> <20071106171945.GG23689@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:46254 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586AbXKFTlD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Nov 2007 14:41:03 -0500
Content-Disposition: inline
In-Reply-To: <20071106171945.GG23689@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 06, 2007 at 06:19:45PM +0100, Jan Kara wrote:
> Intended use case is that application which wants to watch any
> modification in a subtree scans the subtree and sets flags for all
> inodes there. Next time, it just needs to recurse in directories
> having rtime newer than the start of the previous scan. There it can
> handle modifications and set the flag again. It is up to application
> to watch out for hardlinked files. It can e.g.  build their list and
> check their mtime separately (when a hardlink to a file is created
> its inode is modified and rtimes properly updated and thus any
> application has an effective way of finding new hardlinked files).

Umm, yuck.

What if more than one application wants to use this facility?

The application is using a global per-inode flag that is written out
to disk.  So sweeping the entire subtree and setting this flag will
involve a lot of disk i/o; as does setting a mod-time, since it could
potentially require a large number of inode updates, and then the
application needs to sweep through the subtree and reset the flags
(resulting in more disk i/o).  The performance would seem to me to be
really pessimal.  

In addition, after you crash, there might not be any application
waiting to watch modifications in that subtree, and yet the flags
would still be set so the system would still be paying the performance
penalties of needing to propagate modtimes until all of the flags
disappear --- and for a large subtree, that might not be for a long,
long time.

So if the goal is some kind of modification notification system that
watches a subtree efficiently, avoiding some of the deficiencies of
inotify and dnotify, the interface doesn't seem to be the right way to
go about things.  The fact that only one application at a time can use
this interface, even if you ignore the issues of hard links and the
performance problems and the lack of cleanup after a reboot, seems in
my mind to just be a irreparable fatal flaw to this particular scheme.

Regards,

						- Ted
