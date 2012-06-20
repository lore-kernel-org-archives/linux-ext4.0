From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
Date: Wed, 20 Jun 2012 05:01:17 -0400
Message-ID: <20120620090117.GA26764@infradead.org>
References: <alpine.LFD.2.00.1206190816440.2241@dhcp-1-248.brq.redhat.com>
 <20120619131649.GA6811@redhat.com>
 <alpine.LFD.2.00.1206191519320.21961@dhcp-1-248.brq.redhat.com>
 <20120619133041.GB6811@redhat.com>
 <4FE0840F.2050704@shiftmail.org>
 <20120619144413.GA7225@redhat.com>
 <20120619184858.GA8841@redhat.com>
 <20120619200631.GL25389@dastard>
 <20120619202130.GF22805@thunk.org>
 <20120619203938.GM25389@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Mike Snitzer <snitzer@redhat.com>,
	xfs@oss.sgi.com, device-mapper development <dm-devel@redhat.com>,
	Spelic <spelic@shiftmail.org>,
	Luk???? Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44494
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754670Ab2FTJBX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Jun 2012 05:01:23 -0400
Content-Disposition: inline
In-Reply-To: <20120619203938.GM25389@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 20, 2012 at 06:39:38AM +1000, Dave Chinner wrote:
> Exactly - XFS transactions are fine grained, checkpoints are coarse.
> We don't merge extents freed in fine grained transactions inside
> checkpoints. We probably could, but, well, it's complex to do in XFS
> and merging adjacent requests is something the block layer is
> supposed to do....

Last time I checked it actually tries to do that for discard requests,
but then badly falls flat (=oopses).  That's the reason why the XFS
transaction commit code still uses the highly suboptimal synchronous
blkdev_issue_discard instead of the async variant I wrote when designing
the code.

Another "issue" with the XFS discard pattern and the current block
layer implementation is that XFS frees a lot of small metadata like
inode clusters and btree blocks and discards them as well.  If those
simply fill one of the vectors in a range ATA TRIM command and/or a
queueable command that's not much of an issue, but with the current
combination of non-queueable, non-vetored TRIM that's a fairly nasty
pattern.

So until the block layer is sorted out I can not recommend actually
using -o dicard.  I planned to sort out the block layer issues ASAP
when writing that code, but other things have kept me busy every since.

