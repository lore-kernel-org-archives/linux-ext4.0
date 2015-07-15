From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/3] Remove ext3 filesystem driver
Date: Wed, 15 Jul 2015 19:23:46 -0400
Message-ID: <20150715232346.GD18400@thunk.org>
References: <1436955987-7305-1-git-send-email-jack@suse.com>
 <20150715141836.GA18400@thunk.org>
 <55A676BF.8020903@infradead.org>
 <55A67790.80802@infradead.org>
 <55A6780E.2040702@redhat.com>
 <55A67A57.8010502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>, Jan Kara <jack@suse.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jens Axboe <axboe@kernel.dk>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55A67A57.8010502@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 15, 2015 at 11:20:55AM -0400, Austin S Hemmelgarn wrote:
> 
> There really isn't much of a clear distinction between ext3 and ext4 (at
> least from an end user standpoint), other than the fact that there are some
> options that only the ext4 driver understands (like extent based
> allocation).

Yeah, the main reason why we did the ext3 -> ext4 fork was that adding
64-bit numbers required major surgery, and we didn't want to break a
lot of production users who were using ext3.  But from a file system
format perspective, ext2, ext3, and ext4 are the same logical file
system.  There are just multiple different implementations, which all
support slightly different sets of file system features:

   * Linux's ext2
   * Linux's ext3
   * Linux's ext4
   * Hurd's ext2
   * *BSD's ext2
   * Grub's ext2/3/4

The last three implementations are in fact independent ones created
from scratch.   :-)

Fortunately we use the same file system support code, e2fsprogs, for
all of them, which is good since it has a very extensive set of
regression test sets for our fsck program, and we've continued adding
to it as we add new file system features.

					- Ted
