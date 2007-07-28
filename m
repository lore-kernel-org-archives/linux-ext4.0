From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] basic delayed allocation in VFS
Date: Sat, 28 Jul 2007 20:53:30 +0100
Message-ID: <20070728195330.GB5952@infradead.org>
References: <46A8628D.6070103@clusterfs.com> <46A87858.40005@garzik.org> <46A878FC.5040600@clusterfs.com> <46A88DFD.7030609@garzik.org> <46A8A294.2070106@clusterfs.com> <20070727050714.GS12413810@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, Jeff Garzik <jeff@garzik.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
To: David Chinner <dgc@sgi.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070727050714.GS12413810@sgi.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 27, 2007 at 03:07:14PM +1000, David Chinner wrote:
> > It duplicates fs/mpage.c in bio building and introduces new generic API
> > (iomap, map_blocks_t, etc).
> 
> Using a new API for new functionality is a bad thing?

Depends on wht you do.  This patch is just a quickhack to shoe-horn
delalloc support into ext4.  Introducing a new abstraction is overkill.
If we really want an overhaul of the writeback path that's extent-aware,
and efficient for delalloc and unwritten extents introducing a proper
iomap-like data structure would make sense.  That beeing said I personally
hate the ubffer_head abuse for bmap data that we have in various places
as it's utterly confusing and wasting stack space, but that's a different
discussion.

