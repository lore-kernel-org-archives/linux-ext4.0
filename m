From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] basic delayed allocation in VFS
Date: Mon, 30 Jul 2007 10:29:09 +1000
Message-ID: <20070730002909.GY12413810@sgi.com>
References: <46A8628D.6070103@clusterfs.com> <46A87858.40005@garzik.org> <46A878FC.5040600@clusterfs.com> <46A88DFD.7030609@garzik.org> <46A8A294.2070106@clusterfs.com> <20070727050714.GS12413810@sgi.com> <46A9A41C.7080104@clusterfs.com> <20070729091807.GF31489@sgi.com> <46AC8370.8050308@clusterfs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>, Jeff Garzik <jeff@garzik.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40700 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965563AbXG3A30 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 29 Jul 2007 20:29:26 -0400
Content-Disposition: inline
In-Reply-To: <46AC8370.8050308@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Jul 29, 2007 at 04:09:20PM +0400, Alex Tomas wrote:
> David Chinner wrote:
> >On Fri, Jul 27, 2007 at 11:51:56AM +0400, Alex Tomas wrote:
> >But this is really irrelevant - the issue at hand is what we want
> >for VFS level delalloc support. IMO, that mechanism needs to support
> >both XFS and ext4, and I'd prefer if it doesn't perpetuate the
> >bufferhead abuses of the past (i.e. define an iomap structure
> >instead of overloading bufferheads yet again).
> 
> I'm not sure I understand very well.

->get_blocks abuses bufferheads to provide an offset/length/state
mapping. That's all it needs. That what the iomap structure is used
for. It's smaller than a bufferhead, it's descriptive of it's use
and you don't get it confused with the other 10 ways bufferheads
are used and abused.

> where would you track uptodate, dirty and other states then?
> do you propose to separate block states from block mapping?

No. They still get tracked in the bufferheads attached to the page.
That's what bufferheads were originally intended for(*).

Cheers,

Dave.

(*) I recently proposed a separate block map tree for this rather
than using buffer heads for this because of the memory footprint of
N bufferheads per page on contiguous mappings. That's future work,
not something we really need to consider here. Chris Mason's extent
map tree patches are a start on this concept.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
