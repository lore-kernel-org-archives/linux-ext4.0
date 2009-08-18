From: Theodore Tso <tytso@mit.edu>
Subject: Re: fsck infinite loop on corrupt ext4 file system
Date: Tue, 18 Aug 2009 13:03:31 -0400
Message-ID: <20090818170331.GE28560@mit.edu>
References: <1250294105.6221.24.camel@bobble.smo.corp.google.com> <1250557822.23227.9.camel@bobble.smo.corp.google.com> <20090818160155.GC28560@mit.edu> <1250613069.10195.12.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:48335 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755638AbZHRRDe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Aug 2009 13:03:34 -0400
Content-Disposition: inline
In-Reply-To: <1250613069.10195.12.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 18, 2009 at 09:31:09AM -0700, Frank Mayhar wrote:
> 
> Will do.  I wasn't able to keep a copy of the corrupted image but I
> should be able to do _something_ with your patch.  Thanks!
> 

OK, I was hoping you had a test case handy.  I'll try to generate one,
so I can check the changes into git.  I had left things unchecked in
just in case I had missed something that might get picked up assuming
you still had a corrupted image to try testing the patch out against.

> > In addition, e2fsck tries very hard not to destroy data, and so there
> > is the question of what to do if there are data blocks located where
> > the inode table "should" be.
> 
> I would think that that case would be even more rare than the one we're
> dealing with here.  In fact outside of a resize operation I can't think
> of how it might happen.

With ext3 and ext4 prior to 2.6.30 (when we added the block validity
check code), it was actually pretty easy for this to happen, actually
--- all it would take is a corrupted block allocation bitmap.  With
the latest ext4 code, I grant it's pretty unlikely to happen.

It still can happen, if the both the block group descriptors get
corrupted, such that the block allocation bitmap block points to a
mostly zero-filled block, and the inode table pointer for a block
group is also corrupted to some place random.  If this doesn't get
noticed for some period of time while blocks are allocated, and then
later, e2fsck recovers by reading the backup block group descriptors,
this failure mode could very much happen.  It does require multiple
simultaneous failures, though, so it's not likely, but over hundreds
of thousands or millions of deployed Linux systems, Murphy's Law has a
way of catching up with us.  :-/

Something we *could* do to further reduce the chances would be to
compare the primary and backup group descriptors, either at
mount-time, or in e2fsck.  This would add an extra level of paranoia,
although the people who are trying to do 5 second boots with HDD's
would probably complain about the extra seeks that we'd be introducing
as a result.

							- Ted
