From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix overhead calculation in bigalloc filesystem
 (Re: ... )
Date: Fri, 22 Feb 2013 10:20:42 -0500
Message-ID: <20130222152042.GA19264@thunk.org>
References: <1361433665-16880-1-git-send-email-lczerner@redhat.com>
 <20130221121545.GA30821@gmail.com>
 <alpine.LFD.2.00.1302211335390.19354@localhost>
 <alpine.LFD.2.00.1302211346240.19354@localhost>
 <alpine.LFD.2.00.1302211351090.19354@localhost>
 <20130221134943.GA3818@gmail.com>
 <alpine.LFD.2.00.1302211553060.14141@localhost>
 <20130222030327.GB3421@gmail.com>
 <20130222040544.GA13667@thunk.org>
 <20130222131811.GA22069@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49446 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756597Ab3BVPUq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Feb 2013 10:20:46 -0500
Content-Disposition: inline
In-Reply-To: <20130222131811.GA22069@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 22, 2013 at 09:18:12PM +0800, Zheng Liu wrote:
> > If there was a mode that I'd be tempted to get rid of, it would be the
> > combined data=ordered/data=writeback modes.  The main reason why we
> > keep it is because of a concern of buggy applications that depend on
> > the implied fsync() of data=ordered mode at each commit.  However,
> > ext4 has been around for long enough that I think most of the buggy
> > applications have been fixed by now.  And of course, those buggy
> > applications will lose in the same way when they are using btrfs and
> > xfs.  Something to consider....
> 
> IMHO, the application shouldn't depend on a kernel feature.  So maybe it
> is time to highlight this buggy usage.

Oh, agreed.  The question is how many people want us to keep the ext3
semantics to support those buggy applications.  To the extent that
distros are considering using ext4 to support ext3 file systems, there
might be a desire to maintain (as closely as possible) ext3 semantics,
even those that support buggy applications.  The primary problem is
that the when comes down to application developers versus file system
developers, the application developers vastly outnumber us.   :-)

> Just one minor comment below.  Otherwise the patch looks good to me, and
> it can pass in xfstests with 'data=ordered' and 'data=writeback'.

I hadn't bothered testing it yet because I'm focused on testing
and cleaning up the set of patches for the merge window --- and this
change is clearly for the next merge window.  Thanks for testing it!

> >  	trace_ext4_ordered_write_end(inode, pos, len, copied);
> 
> Here this function needs to be renamed with trace_ext4_write_end().

Yes, agreed.

I also need to get rid of trace_ext4_writeback_write_end() in
include/trace/events/ext4.h.

The other thing that needs to be done --- probably in a separate
commit, just to make things easier to review for correctness, is now
that we've folded ext4_writeback_write_end() and ext4_ordered_write_end()
into a single function, we now have a single user of
ext4_generic_write_end(), so we can now fold ext4_generic_write_end()
into ext4_write_end().

						- Ted
