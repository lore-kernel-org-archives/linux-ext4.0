From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH-v4 1/7] vfs: split update_time() into update_time() and
 write_time()
Date: Mon, 1 Dec 2014 18:18:54 +0100
Message-ID: <20141201171854.GH12140@twin.jikos.cz>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
 <1416997437-26092-2-git-send-email-tytso@mit.edu>
 <20141126192328.GA20436@infradead.org>
 <20141127144116.GA14091@thunk.org>
 <20141127153315.GC14091@thunk.org>
 <20141127164952.GA1622@infradead.org>
 <20141127202731.GG14091@thunk.org>
 <20141201092810.GA5538@infradead.org>
 <20141201150450.GA3337@thunk.org>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
	XFS Developers <xfs@oss.sgi.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141201150450.GA3337@thunk.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Dec 01, 2014 at 10:04:50AM -0500, Theodore Ts'o wrote:
> On Mon, Dec 01, 2014 at 01:28:10AM -0800, Christoph Hellwig wrote:
> > 
> > The ->is_readonly method seems like a clear winner to me, I'm all for
> > adding it, and thus suggested moving it first in the series.
> 
> It's a real winner for me as well, but the reason why I dropped it is
> because if btrfs() has to keep its ->update_time function, we wouldn't
> actually have a user for is_readonly().  I suppose we could have
> update_time() call ->is_readonly() and then ->update_time() if they
> exist, but it only seemed to add an extra call and a bit of extra
> overhead without really simplifying things for btrfs.

We would use is_readonly in order to remove some extra checks from btrfs
(setxattr, removexattr, possibly setsize).

> If there were other users of ->is_readonly, then it would make sense,
> but it seemed better to move into a separate code refactoring series.

Yeah it would be better addressed separately as it's not the point of
lazytime patchset and only turned out to be a good idea during the
iterations.
