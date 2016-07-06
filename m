From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/4] ext4: Fix deadlock during page writeback
Date: Wed, 6 Jul 2016 09:04:29 +0200
Message-ID: <20160706070429.GA14067@quack2.suse.cz>
References: <1466073736-30447-2-git-send-email-jack@suse.cz>
 <20160630150548.GC2028@thunk.org>
 <20160701090950.GB22922@quack2.suse.cz>
 <20160701165339.GB6075@thunk.org>
 <20160701174041.GA30040@quack2.suse.cz>
 <20160701212634.GA14277@thunk.org>
 <20160704140012.GG5200@quack2.suse.cz>
 <20160704152043.GA15193@thunk.org>
 <20160704154709.GA12022@quack2.suse.cz>
 <20160705024330.GB15193@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Eryu Guan <eguan@redhat.com>, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160705024330.GB15193@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 04-07-16 22:43:30, Ted Tso wrote:
> On Mon, Jul 04, 2016 at 05:47:09PM +0200, Jan Kara wrote:
> > > Good point that the block device is plugged.  Ultimately I suspect the
> > > way to fix the scalability problem will be move to dioread nolock as
> > > the default, and use separate transaction to map the blocks using the
> > > uninitialized flags, and then do a separate transaction to convert
> > > them afterwards.
> > 
> > This is what already happens currently - we only reserve a handle for
> > conversion during writeback but that reservation fluently moves between
> > running transactions until a point where the reserved handle is started -
> > then the handle is pinned to the currently running transaction - and this
> > happens only in the completion handler after IO is completed.
> 
> Yes, but dioread_nolock only works with block size == page size.  What
> we need to do is to make it work for all block sizes, then make
> dioread_nolock the default, and then remove the old direct I/O write
> path....

Yes, I completely agree.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
