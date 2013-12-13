From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4 v3] fiemap: add EXTENT_DATA_COMPRESSED flag
Date: Fri, 13 Dec 2013 03:06:08 -0800
Message-ID: <20131213110608.GC14884@infradead.org>
References: <cover.1386778302.git.dsterba@suse.cz>
 <4f8d5dc5b51a43efaf16c39398c23a6276e40a30.1386778303.git.dsterba@suse.cz>
 <20131212232443.GL31386@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Sterba <dsterba@suse.cz>, linux-fsdevel@vger.kernel.org,
	adilger@dilger.ca, linux-nilfs@vger.kernel.org, mfasheh@suse.com,
	xfs@oss.sgi.com, hch@infradead.org, linux-btrfs@vger.kernel.org,
	viro@zeniv.linux.org.uk, linux-ext4@vger.kernel.org,
	ocfs2-devel@oss.oracle.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131212232443.GL31386@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Dec 13, 2013 at 10:24:43AM +1100, Dave Chinner wrote:
> I'd prefer to just see the new physical length field always filled
> out, regardless of whether it is a compressed extent or not. In
> terms of backwards compatibility to userspace, it makes no
> difference because the value of reserved/unused fields is undefined
> by the API. Yes, the implementation zeros them, but there's nothing
> in the documentation that says "reserved fields must be zero".
> Hence I think we should just set it for every extent.
> 
> >From the point of view of the kernel API (fiemap_fill_next_extent),
> passing the physical extent size in the "len" parameter for normal
> extents, then passing 0 for the "physical length" makes absolutely
> no sense.

I tend to agree, but the additional complication here is that this is
a change to an existing API.  We'd need another HAVE_PHYS_LEN flag for
non-compressed extents so that userspace can rely on it.  Given that
it's only useful for that case I think the userspace API introduced
is the best we can get.

I think however that we should always pass the phys_len argument in the
kernel API just to make it less confusing.

