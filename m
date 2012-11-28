From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] [PATCH 2/2] direct-io: handle handle O_(D)SYNC AIO
Date: Tue, 27 Nov 2012 16:26:56 -0800
Message-ID: <20121128002656.GC4321@blackbox.djwong.org>
References: <20121123075502.307482760@bombadil.infradead.org>
 <20121123075916.375908616@bombadil.infradead.org>
 <x49a9u3f276.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <x49a9u3f276.fsf@segfault.boston.devel.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 27, 2012 at 11:19:41AM -0500, Jeff Moyer wrote:
> Christoph Hellwig <hch@infradead.org> writes:
> 
> > Call generic_write_sync from the deferred I/O completion handler if
> > O_DSYNC is set for a write request.  Also make sure various callers
> > don't call generic_write_sync if the direct I/O code returns
> > -EIOCBQUEUED.
> >
> > Note: this currently breaks ext4 due to it's convoluted unwritten
> > extent conversion code.  I've tried to understand it and as far
> > as I can see it's a workaround for the fact that ext4 marks page
> > writeback as completed before converting unwritten extents.
> > Ext4 should follow xfs on this and only mark writeback as completed
> > when it really is and at that point can remove the big hairy mess to
> > force unwritten extent conversions from fsync, truncate and a few other
> > places.
> 
> Well, I've tested the xfs bits, and there are no regressions.  I won't
> bother testing ext4 until a full solution is in place.  Jan, is this
> something you have the time for and/or interest in doing?

I tested the raw block device use case and it seems to be ok too.

cc'ing the ext4 list, since this affects ext4 pretty heavily.

--D
> 
> Cheers,
> Jeff
