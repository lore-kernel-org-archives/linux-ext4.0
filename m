From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: Fix and simplify s_dirt handling
Date: Fri, 1 May 2009 09:45:06 -0400
Message-ID: <20090501134506.GB7681@mit.edu>
References: <1241152637-11986-1-git-send-email-tytso@mit.edu> <1241152637-11986-2-git-send-email-tytso@mit.edu> <20090501070255.GA2107@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43404 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757617AbZEANpI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 May 2009 09:45:08 -0400
Content-Disposition: inline
In-Reply-To: <20090501070255.GA2107@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 01, 2009 at 03:02:55AM -0400, Christoph Hellwig wrote:
> On Fri, May 01, 2009 at 12:37:16AM -0400, Theodore Ts'o wrote:
> > The s_dirt flag wasn't completely handled correctly, but it didn't
> > really matter when journalling was enabled.  It turns out that when
> > ext4 runs without a journal, we don't clear s_dirt in places where we
> > should have, with the result that the high-level write_super()
> > function was writing the superblock when it wasn't necessary.
> > 
> > So we fix this by making ext4_commit_super() clear the s_dirt flag,
> > and removing many of the other places where s_dirt is manipulated.
> > When journalling is enabled, the s_dirt flag might be left set more
> > often, but s_dirt really doesn't matter when journalling is enabled.
> 
> Btw, you might want to move all s_dirt setting into a wrapper, so that
> it never gets set for journal mode.  That way we can avoid superflous
> calls into the filesystem in that default mode.

I thought about doing this, but currently the VFS core checks for the
presence for the write_super method function before it checks for
s_dirt, so it didn't seem to matter much whether or not s_dirt was set
if the filesystem doesn't have a NULL write_super function.

       		  	       	      - Ted
