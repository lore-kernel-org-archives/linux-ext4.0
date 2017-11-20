From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2] iomap: report collisions between directio and
 buffered writes to userspace
Date: Mon, 20 Nov 2017 08:18:29 -0800
Message-ID: <20171120161829.GA25991@bombadil.infradead.org>
References: <20171117193925.GM5119@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs <linux-xfs@vger.kernel.org>, Ilya Dryomov <idryomov@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        holger@applied-asynchrony.com,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171117193925.GM5119@magnolia>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Nov 17, 2017 at 11:39:25AM -0800, Darrick J. Wong wrote:
> If two programs simultaneously try to write to the same part of a file
> via direct IO and buffered IO, there's a chance that the post-diowrite
> pagecache invalidation will fail on the dirty page.  When this happens,
> the dio write succeeded, which means that the page cache is no longer
> coherent with the disk!

This seems like a good opportunity to talk about what I've been working
on for solving this problem.  The XArray is going to introduce a set
of entries which can be stored to locations in the page cache that I'm
calling 'wait entries'.

When starting direct IO, the page cache will insert a wait entry in each
of the indices covered by the I/O (and do the usual invalidation dance).
At the end of direct IO, it will remove the wait entry and wake up any
threads waiting on those entries.

During lookup, any thread which encounters a wait entry (pagefaults,
buffered reads, buffered writes) will sleep on the indicated wait queue.

I don't know what a direct IO thread should do when encountering a wait
entry.  Fail the I/O?  Sleep like any other lookup would?  Go ahead and
issue the I/O anyway?  (uhm, I see a lot of problems with implementing
that third option.)

I'm currently planning on using 256 'wait entries', one for each
PAGE_WAIT_TABLE_SIZE, and sharing those wait queue heads.  Maybe that's
overengineering the solution.

Anyway, I need to get the basics of the XArray finished off before I do
this, but it'd be great if somebody pointed out why this doesn't work
before I implement it.
