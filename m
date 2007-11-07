From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] [PATCH 3/3] Recursive mtime for ext3
Date: Wed, 7 Nov 2007 15:54:10 +0100
Message-ID: <20071107145410.GE22214@duck.suse.cz>
References: <20071106171537.GD23689@duck.suse.cz> <20071106171945.GG23689@duck.suse.cz> <20071106180100.GJ8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Al Viro <viro@ftp.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:44172 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759158AbXKGOyL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Nov 2007 09:54:11 -0500
Content-Disposition: inline
In-Reply-To: <20071106180100.GJ8181@ftp.linux.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 06-11-07 18:01:00, Al Viro wrote:
> On Tue, Nov 06, 2007 at 06:19:45PM +0100, Jan Kara wrote:
> > Implement recursive mtime (rtime) feature for ext3. The feature works as
> > follows: In each directory we keep a flag EXT3_RTIME_FL (modifiable by a user)
> > whether rtime should be updated. In case a directory or a file in it is
> > modified and when the flag is set, directory's rtime is updated, the flag is
> > cleared, and we move to the parent. If the flag is set there, we clear it,
> > update rtime and continue upwards upto the root of the filesystem. In case a
> > regular file or symlink is modified, we pick arbitrary of its parents (actually
> > the one that happens to be at the head of i_dentry list) and start the rtime
> > update algorith there.
> 
> *ewwww*
> 
> Nothing like undeterministic behaviour, is there?
  Oh yes, there is :) But I tried to argue it does not really matter -
application would have to handle hardlinks in a special way but I find that
acceptable given how rare they are...

> > Intended use case is that application which wants to watch any modification in
> > a subtree scans the subtree and sets flags for all inodes there. Next time, it
> > just needs to recurse in directories having rtime newer than the start of the
> > previous scan. There it can handle modifications and set the flag again. It is
> > up to application to watch out for hardlinked files. It can e.g.  build their
> > list and check their mtime separately (when a hardlink to a file is created its
> > inode is modified and rtimes properly updated and thus any application has an
> > effective way of finding new hardlinked files).
> 
> You know, you can do that with aush^H^Hdit right now...
  Interesting idea, no I have not thought about this. I guess you mean
watching all the VFS modification events and then do the checking and propagation
from user space... My first feeling is that the performance penalty would be
considerably higher (currently I am at 1% performance penalty for quite
pessimistic test case) but in case the current patch would be considered
unacceptable, I can try how large the penalty would be. Thanks for
suggestion.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
