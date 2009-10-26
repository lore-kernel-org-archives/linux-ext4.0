From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] debugfs: open with EXT2_FLAG_64BITS
Date: Mon, 26 Oct 2009 01:15:55 -0400
Message-ID: <20091026051555.GA13941@mit.edu>
References: <4AAA6A44.90902@redhat.com> <4ACE48BC.7010505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:38024 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbZJZFPv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Oct 2009 01:15:51 -0400
Content-Disposition: inline
In-Reply-To: <4ACE48BC.7010505@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 08, 2009 at 03:17:00PM -0500, Eric Sandeen wrote:
> Eric Sandeen wrote:
> > Pointing debugfs from the pu branch at a large filesystem is
> > still failing with:
> > 
> >  Filesystem too large to use legacy bitmaps while reading block bitmap
> > 
> > We need to open with EXT2_FLAG_64BITS; I'm not sure if this
> > should be a switch based on the size of the fs or not?
> > 
> > But in any case the below gets things moving enough to
> > use debugfs on a large filesystem.
> 
> ping?

I've added this patch to the pu branch.  I've also updated the pu
branch so it's up to date with the latest maint branch.  I also found
some missing conversions of ext2fs_group_{first,last}_block() to
ext2fs_group_{first,last}_block2().  

I also cleaned up a number of patches which I'm confident enough are
clean enough that I've fast forwarded the next branch to include them.

There are now only 16 patches left that are unique to the pu branch,
down from 57 patches initially (and many of the patches are smaller as
they were refactored).

						- Ted
