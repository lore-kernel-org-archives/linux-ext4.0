From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Automatically enable journal_async_commit on
	ext4 file systems
Date: Fri, 11 Sep 2009 09:13:32 -0400
Message-ID: <20090911131332.GD20710@mit.edu>
References: <1252189963-23868-1-git-send-email-tytso@mit.edu> <1252189963-23868-2-git-send-email-tytso@mit.edu> <4AA59A82.9090502@gmail.com> <20090908044541.GF22901@mit.edu> <4AA6450B.9040001@redhat.com> <20090911024505.GA9363@mit.edu> <4AAA2F6F.3080903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51163 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbZIKNOG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Sep 2009 09:14:06 -0400
Content-Disposition: inline
In-Reply-To: <4AAA2F6F.3080903@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 11, 2009 at 07:07:27AM -0400, Ric Wheeler wrote:
> I still think that we changing from a situation in which the drive state 
> with regards to our transactions is almost always consistent to one in 
> which we will often not be consistent.
>
> More or less, moving from tight control of the persistent state on the 
> platter to a situation in which, after power failure, we will more often 
> see a bad transaction.  The checksum will catch those conditions, but 
> catching and repairing is not the same as avoiding the need to repair in 
> the first place :)

We won't need to repair anything.  We still have a barrier before we
allow the filesystem to proceed with writing back buffers or
allocating blocks that aren't safe to be be written back or allocated
until after the commit.

So if the checksum doesn't match, we simply discard the last commit,
and the filesystem will be in a consistent state.  This case is
analogous to what happens if we didn't have enough time to write the
journal blocks plus the commit blocks before the crash.  By removing
the barrier before the commit block, it's possible for the commit
block to be written before the rest of the journal blocks, but we can
treat this case the same way that we treat a missing commit block ---
we simply throw away the last transaction.


The problems that I've worried about in the past is what happens if we
have a checksum failure on some commit block *other* than the last
commit block in the journal.  In that case, we *will* need to do a
full file system check and repair, and it is a toss up whether we are
better off ignoring the checksum failure, and replaying all of the
journal transaction, and hope that the checksum failure is caused by a
corrupted data block that will be later overwritten by a later
transaction, or whether we abort the journal replay immediately and
not replay the later transactions.  Currently we do the latter, but
the problem is that since we have already started reusing blocks that
might have been deleted in previous transactions, and some of the
buffes pinned by previous transactions have already been written out,
the file system will be in trouble.  This is where adding per-block
checksums into the journal descriptor blocks might allow us to do a
better job of recovering from failures in the journal.

*However*, this is problem is totally orthogonal to the async commit.
In the case of the last transaction, where some journal blocks were
written out before the commit block was written out, it is safe to
throw away the last transaction and consider it simply a "not
committed transaction".

> The key is really how can we measure the impact of this in a realistic 
> way. How many fsck's are needed after a power fail? Chris's directory 
> corruption test?

So the test should be that there should be *zero* file system
corruptions caused by a power failure.  (Unless the power fail induces
a hardware error, of course; if the stress caused by the power drop
causes a head crash, nothing we can do about that in software!)  The
async commit patch should be that safe.  If we can confirm that, then
the case for making it be the default mount option should be a
no-brainer.

       	      	     	     	       - Ted
