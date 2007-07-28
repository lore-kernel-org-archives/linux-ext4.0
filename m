From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] basic delayed allocation in VFS
Date: Sat, 28 Jul 2007 20:56:05 +0100
Message-ID: <20070728195605.GC5952@infradead.org>
References: <46A8628D.6070103@clusterfs.com> <46A87858.40005@garzik.org> <46A878FC.5040600@clusterfs.com> <46A88DFD.7030609@garzik.org> <46A8A294.2070106@clusterfs.com> <20070727050714.GS12413810@sgi.com> <46A9A41C.7080104@clusterfs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>, Jeff Garzik <jeff@garzik.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <46A9A41C.7080104@clusterfs.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 27, 2007 at 11:51:56AM +0400, Alex Tomas wrote:
> >Secondly, apart from delalloc, XFS cannot use the generic code paths
> >for writeback because unwritten extent conversion also requires
> >custom I/O completion handlers. Given that __mpage_writepage() only
> >calls ->writepage when it is confused, XFS simply cannot use this
> >API.
> 
> this doesn't mean fs/mpage.c should go, right?

mpage.c read side is fine for every block based filesystem I know.
mpage.c write side is fine for every simple (non-delalloc, non-unwritten
extent, etc) filesystem.  So it surely shouldn't go.

> I didn't say "generic", see Subject: :)

then it shouldn't be in generic code.

