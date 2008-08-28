From: Theodore Tso <tytso@mit.edu>
Subject: Re: Do we need dump for ext4?
Date: Thu, 28 Aug 2008 14:48:04 -0400
Message-ID: <20080828184804.GN26987@mit.edu>
References: <48B6BD02.3080307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Ric Wheeler <rwheeler@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:41570 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751882AbYH1SsI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2008 14:48:08 -0400
Content-Disposition: inline
In-Reply-To: <48B6BD02.3080307@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 28, 2008 at 09:58:10AM -0500, Eric Sandeen wrote:
> I was talking to Ric about dump benchmarks, and he was of the impression
> that dump may not be used that often anymore, at least in the
> enterprise.

Many people don't use the dump/restore any more program any more,
that's definitely true.  Whether people use backups (as opposed to
large amounts of RAID) in the enterprise is a different question.  I'm
not so sure about the second question.

So a couple of comments.  First, it's probably not fair to use
different backup programs for the different filesystems.  We probably
want to do one set of comparisons where we use tar for all three.
(Note: not all backup/dump programs are doing the right things with
xattr's, so we're not necessarily comparing programs with completely
identical functionality.)

Secondly, it really wouldn't be hard to update dump/restore for ext4.
It uses libext2fs, so the real problem is that it is explicitly
checking the feature flags.  Removing those checks may be all that is
necessary, given that ext2_block_iterate() still works for
extent-based files.  I just noted BTW that the dump/restore doesn't
seem to be TOTALLY abandoned.  It was last updated in 2006, true, but
there is support for backing up and restoring extended attributes and
ACL's.  I wonder if they broke format compatibility with BSD 4.4
format dump/restore backups when they did it --- and if anyone would
still cares.  :-)

Finally, I suspect most of the problem with using tar is the HTREE
dirent sorting problem.  If we modify tar to sort the directory
entries before emitting the files, and then use that tar across all
the filesystems, I suspect the results would be much more better for
ext3 and ext4.

						- Ted
