From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH, RFC] ext4: Fix use of write barrier in commit logic
Date: Tue, 20 May 2008 16:23:10 +0100
Message-ID: <20080520152310.GG16676__34854.5180088424$1211297177$gmane$org@shareable.org>
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org> <87ej7zcrqv.fsf@basil.nowhere.org> <200805190926.41970.chris.mason@oracle.com> <20080519144654.GC15035@mit.edu> <20080520025112.GN15035@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, lin
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:38139 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934059AbYETPYJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 May 2008 11:24:09 -0400
Content-Disposition: inline
In-Reply-To: <20080520025112.GN15035@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> As I mentioned earlier, adding blkdev_issue_flush() to ext[34]/fsync.c
> is I believe not necessary.  We should be doing the right thing in the
> commit.c file.  In the future, if we want some extra bonus points, in
> the case where writes have taken place to the inode, but no metadata
> operations have taken place (the common case when a database is
> writing to a pre-existing tablespace), it would be nice if fsync()
> could notice this case, force out the datablocks the old-fashioned way
> without forcing an journal commit, and then calling
> blkdev_issue_flush().  That should give us some nice performance wins
> for database workloads; unfortunately it probably won't do us any good
> on mailserver workloads.

Last time I looked, the database write + fsync case did not result in
a journal commit in some cases, and therefore no blkdev_issue_flush().
The problem was one of correctness.  Has this been fixed?

A database had no way to issue a hard disk barrier in these cases
without doing weird stuff like forcing metadata changes prior to fsync
(e.g. toggling permissions bits), which causes an intolerable two disk
seeks per fsync.  That is _way_ expensive.

There is also no way in ext3 to _just_ fdatasync() (no metadata even
if it has changed), with disk barrier/flush.

Imho a good place to call blkdev_issue_flush() is in the VFS, after
it's written all the data blocks, unless the filesystem has a better
override.  That would work with most filesystems automatically.
Request queue optimisations may trivially remove redundant flushes.

-- Jamie
