From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC] basic delayed allocation in VFS
Date: Fri, 27 Jul 2007 11:51:56 +0400
Message-ID: <46A9A41C.7080104@clusterfs.com>
References: <46A8628D.6070103@clusterfs.com> <46A87858.40005@garzik.org> <46A878FC.5040600@clusterfs.com> <46A88DFD.7030609@garzik.org> <46A8A294.2070106@clusterfs.com> <20070727050714.GS12413810@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Garzik <jeff@garzik.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
To: David Chinner <dgc@sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.chehov.net ([80.71.245.247]:52436 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760272AbXG0HwW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Jul 2007 03:52:22 -0400
In-Reply-To: <20070727050714.GS12413810@sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

David Chinner wrote:
> Using a new API for new functionality is a bad thing?

if existing API can be used ...

> No, it doesn't provide the same functionality.
> 
> Firstly, XFS attaches a different I/O completion to delalloc writes
> to allow us to update the file size when the write is beyond the
> current on disk EOF. This code cannot do that as all it does is
> allocation and present "normal looking" buffers to the generic code
> path.

good point, I was going to take care of it in a separate patch
to support data=ordered.

> Secondly, apart from delalloc, XFS cannot use the generic code paths
> for writeback because unwritten extent conversion also requires
> custom I/O completion handlers. Given that __mpage_writepage() only
> calls ->writepage when it is confused, XFS simply cannot use this
> API.

this doesn't mean fs/mpage.c should go, right?

> Also, looking at the way mpage_da_map_blocks() is done - if we have
> an 128MB delalloc extent - ext4 will allocate that will allocate it
> in one go, right? What happens if we then crash after only writing a
> few megabytes of that extent? stale data exposure? XFS can allocate
> multiple gigabytes in a single get_blocks call so even if ext4 can't
> do this, it's a problem for XFS.....

what happens if IO to 2nd MB is completed, while IO to 1st MB is not
(probably sitting in queue) ? do you update on-disk size in this case?
how do you track this?

> So without the ability to attach specific I/O completions to bios
> or support for unwritten extents directly in __mpage_writepage,
> there is no way XFS can use this "generic" delayed allocation code.

I didn't say "generic", see Subject: :)

thanks, Alex
