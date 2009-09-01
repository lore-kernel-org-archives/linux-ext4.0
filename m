From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4 writepages is making tiny bios?
Date: Tue, 1 Sep 2009 16:57:44 -0400
Message-ID: <20090901205744.GE6996@mit.edu>
References: <20090901184450.GB7885@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:38218 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbZIAU5n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Sep 2009 16:57:43 -0400
Content-Disposition: inline
In-Reply-To: <20090901184450.GB7885@think>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 01, 2009 at 02:44:50PM -0400, Chris Mason wrote:
> I've been doing some benchmark runs to speed up btrfs and look at Jens'
> new writeback work.  One thing that really surprised me is that ext4
> seems to be making 4k bios pretty much all the time.

Yeah, thanks for pointing that out.  As you pointed out, we're doing
95% of the work to create big bios, so we can allocate blocks
contiguosly for each file.  But then, at the very end, in
fs/ext4/inode.c:mpage_da_submit_io(), we end up calling
ext4_writepage() for each page in the extent.

For the case of data=journal, we need to do that, since all of the I/O
requests need to get chopped up into buffer heads and then submitted
through the jbd layer.  But in the other journal modes, we should be
able to issue a bio directly.  It probably doesn't make that much
difference to the ext4's performance (since the elevator will coalesce
the writes), but all that extra work is burning lot of CPU, and fixing
that would be a Good Thing.  (More CPU for the application to do, you
know, Real Work.  :-)

> This graph shows the difference:
> 
> http://oss.oracle.com/~mason/seekwatcher/trace-buffered.png

Wow, I'm surprised how seeky XFS was in these graphs compared to ext4
and btrfs.  I wonder what was going on.

Thanks for pointing that out.  I'll have to add that to do our "To do"
list for ext4.

							- Ted
