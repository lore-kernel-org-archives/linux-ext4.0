From: Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH] ext4: add noorlov parameter to avoid spreading of directory inodes
Date: Wed, 2 Oct 2013 11:31:01 -0400
Message-ID: <20131002153101.GE4353@kvack.org>
References: <20131001160817.GA2295@kvack.org> <20131002144759.GB32181@quack.suse.cz> <524C3574.7020106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kanga.kvack.org ([205.233.56.17]:55877 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab3JBPbC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Oct 2013 11:31:02 -0400
Content-Disposition: inline
In-Reply-To: <524C3574.7020106@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 02, 2013 at 10:02:12AM -0500, Eric Sandeen wrote:
> I'm right with you on thinking a mount option should be a last resort.
> 
> One thing I'm curious about - what changed from ext3 to ext4?  I thought
> both defaulted to orlov and the same type of allocation behavior, more
> or less.  I guess one change is that the "oldalloc" mount
> option went away.

> (if it does come back, it should probably mirror what we had before,
> which was "oldalloc" not "noorlov" right?)

The behaviour I'm looking for is not exactly the same as the orlov
allocator or the old allocator, but something that packs files as
closely together as possible.  Half of this can be achieved with
fallocate(), but reducing the spreading of directory inodes can only be
accomplished with changes to the filesystem itself.  The only reason
we're using multiple subdirectories is because of contention issues with
i_mutex (our application has to either fsync() the directory or mount
with dirsync to maintain consistency) during file creation and unlink().

		-ben
-- 
"Thought is the essence of where you are now."
