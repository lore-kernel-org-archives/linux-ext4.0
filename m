From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Q] ext3 mkfs: zeroing journal blocks
Date: Mon, 11 May 2009 15:35:14 -0400
Message-ID: <20090511193514.GF21518@mit.edu>
References: <71a0d6ff0905110803t1a6b34ccq91d5494f95fe1f34@mail.gmail.com> <4A086763.9090907@redhat.com> <20090511182050.GA3209@webber.adilger.int> <4A087202.4010601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	Alexander Shishkin <alexander.shishckin@gmail.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:53372 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850AbZEKTfR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 May 2009 15:35:17 -0400
Content-Disposition: inline
In-Reply-To: <4A087202.4010601@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 11, 2009 at 01:44:18PM -0500, Eric Sandeen wrote:
> Andreas Dilger wrote:
> 
> > The reason that the journal is zeroed is because there is some chance
> > that old (valid at the time) transaction headers and commit blocks might
> > be in the journal and could accidentally be "recovered" and cause bad
> > corruption of the filesystem.
> 
> But I guess the question is, why isn't a normal internal log zeroed?
> 
> If I'm reading it right only external logs get this treatment, and I
> think that's what generated the original question from Alexander.

Internal journals are indeed cleared.  Check out write_journal_inode()
in lib/ext2fs/mkjournal.c, which calls ext2fs_block_iterate() passing
in the callback function mkjournal_proc(), which calls
ext2fs_zero_blocks().

						- Ted
