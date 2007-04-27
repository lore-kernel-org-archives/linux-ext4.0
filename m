From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS is under heavy write load (massive starvation)
Date: Fri, 27 Apr 2007 13:31:30 -0600
Message-ID: <20070427193130.GD5967@schatzie.adilger.int>
References: <1177660767.6567.41.camel@Homer.simpson.net> <20070427013350.d0d7ac38.akpm@linux-foundation.org> <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com> <alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marat Buharov <marat.buharov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Galbraith <efault@gmx.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Alex Tomas <alex@clusterfs.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:47614 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757154AbXD0Tbd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Apr 2007 15:31:33 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Apr 27, 2007  08:30 -0700, Linus Torvalds wrote:
> On a good filesystem, when you do "fsync()" on a file, nothing at all 
> happens to any other files. On ext3, it seems to sync the global journal, 
> which means that just about *everything* that writes even a single byte 
> (well, at least anything journalled, which would be all the normal 
> directory ops etc) to disk will just *stop* dead cold!
> 
> It's horrid. And it really is ext3, not "fsync()".
> 
> I used to run reiserfs, and it had its problems, but this was the 
> "feature" of ext3 that I've disliked most. If you run a MUA with local 
> mail, it will do fsync's for most things, and things really hickup if you 
> are doing some other writes at the same time. In contrast, with reiser, if 
> you did a big untar or some other big write, if somebody fsync'ed a small 
> file, it wasn't even a blip on the radar - the fsync would sync just that 
> small thing.

It's true that this is a "feature" of ext3 with data=ordered (the default),
but I suspect the same thing is now true in reiserfs too.  The reason is
that if a journal commit doesn't flush the data as well then a crash will
result in garbage (from old deleted files) being visible in the newly
allocated file.  People used to complain about this with reiserfs all the
time having corrupt data in new files after a crash, which is why I believe
it was fixed.

There definitely are some problems with the ext3 journal commit though.
If the journal is full it will cause the whole journal to checkpoint out
to the filesystem synchronously even if just space for a small transaction
is needed.  That is doubly bad if you have a very large journal.  I believe
Alex has a patch to have it checkpoint much smaller chunks to the fs.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
