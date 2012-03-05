From: Jan Kara <jack@suse.cz>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Mon, 5 Mar 2012 14:10:53 +0100
Message-ID: <20120305131053.GH6643@quack.suse.cz>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
 <E15A491F-62E2-4518-939F-07B3AB4C3E65@mit.edu>
 <20120301143859.GX5054@shiny>
 <CADDYkjQ8jgWUo7=eAeMjve0iRmVZMcrjjbqnvPq0SchE5W9Fqg@mail.gmail.com>
 <20120302140038.GD5054@shiny>
 <CADDYkjT8apYQpdZqr1gZKiHbm9xfTaLr=8GEJF0VKF9neHwgOg@mail.gmail.com>
 <20120302142651.GH5054@shiny>
 <20120302193215.GB22215@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120302193215.GB22215@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 02-03-12 14:32:15, Ted Tso wrote:
> On Fri, Mar 02, 2012 at 09:26:51AM -0500, Chris Mason wrote:
> It would be interesting to have a project where someone added
> fallocate() support into libelf, and then added some hueristics into
> ext4 so that if a file is fallocated to a precise size, or if the file
> is fully written and closed before writeback begins, that we use this
> to more efficiently pack the space used by the files by the block
> allocator.  This is a place where I would not be surprised that XFS
> has some better code to avoid accelerated file system aging, and where
> we could do better with ext4 with some development effort.
  AFAIK XFS people actually prefer that applications let them do their work
using delayed allocation and do not interfere with fallocate(2) calls. The
problem they have with fallocate(2) is that it forces you to allocate
blocks while with delayed allocation you can make the decision about
allocation later. So for small files which completely fit into pagecache
before they get pushed out by writeback, they can make better decisions
from delayed allocation. Just dumping my memory from some other thread...

							Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
