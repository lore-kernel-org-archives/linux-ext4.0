From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
Date: Fri, 27 Apr 2007 15:18:37 -0700
Message-ID: <20070427151837.f1439639.akpm@linux-foundation.org>
References: <1177660767.6567.41.camel@Homer.simpson.net>
	<20070427013350.d0d7ac38.akpm@linux-foundation.org>
	<698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>
	<alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org>
	<20070427193130.GD5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Marat Buharov <marat.buharov@gmail.com>,
	Mike Galbraith <efault@gmx.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Alex Tomas <alex@clusterfs.com>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752937AbXD0WTQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Apr 2007 18:19:16 -0400
In-Reply-To: <20070427193130.GD5967@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 27 Apr 2007 13:31:30 -0600
Andreas Dilger <adilger@clusterfs.com> wrote:

> On Apr 27, 2007  08:30 -0700, Linus Torvalds wrote:
> > On a good filesystem, when you do "fsync()" on a file, nothing at all 
> > happens to any other files. On ext3, it seems to sync the global journal, 
> > which means that just about *everything* that writes even a single byte 
> > (well, at least anything journalled, which would be all the normal 
> > directory ops etc) to disk will just *stop* dead cold!
> > 
> > It's horrid. And it really is ext3, not "fsync()".
> > 
> > I used to run reiserfs, and it had its problems, but this was the 
> > "feature" of ext3 that I've disliked most. If you run a MUA with local 
> > mail, it will do fsync's for most things, and things really hickup if you 
> > are doing some other writes at the same time. In contrast, with reiser, if 
> > you did a big untar or some other big write, if somebody fsync'ed a small 
> > file, it wasn't even a blip on the radar - the fsync would sync just that 
> > small thing.
> 
> It's true that this is a "feature" of ext3 with data=ordered (the default),
> but I suspect the same thing is now true in reiserfs too.  The reason is
> that if a journal commit doesn't flush the data as well then a crash will
> result in garbage (from old deleted files) being visible in the newly
> allocated file.  People used to complain about this with reiserfs all the
> time having corrupt data in new files after a crash, which is why I believe
> it was fixed.

People still complain about hey-my-files-are-all-full-of-zeroes on XFS.

> There definitely are some problems with the ext3 journal commit though.
> If the journal is full it will cause the whole journal to checkpoint out
> to the filesystem synchronously even if just space for a small transaction
> is needed.  That is doubly bad if you have a very large journal.  I believe
> Alex has a patch to have it checkpoint much smaller chunks to the fs.
> 

We can make great improvements here, and I've (twice) previously decribed
how: hoist the entire ordered-mode data handling out of ext3, and out of
the buffer_head layer and move it up into the VFS pagecache layer. 
Basically, do ordered-data with a commit-time inode walk, calling
do_sync_mapping_range().

Do it in the VFS.  Make reiserfs use it, remove reiserfs ordered-mode too. 
Make XFS use it, fix the hey-my-files-are-all-full-of-zeroes problem there.

And guess what?  We can then partly fix _this_ problem too.  If we're
running a commit on behalf of fsync(inode1) and we come across an inode2
which doesn't have any block allocation metadata in this commit, we don't
need to sync inode2's pages.

Weep.  It's times like this when I want to escape all this patch-wrangling
nonsense and go do some real stuff.
