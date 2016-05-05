From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 0/2] ext4: Improve parallel I/O performance on NVDIMM
Date: Thu, 5 May 2016 07:19:32 -0700
Message-ID: <20160505141932.GA29221@infradead.org>
References: <1461947276-25988-1-git-send-email-Waiman.Long@hpe.com>
 <57238DFC.6010108@hpe.com>
 <20160501172854.GA19601@infradead.org>
 <20160505015730.GC26977@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Waiman Long <waiman.long@hpe.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@linux.intel.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51561 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbcEEOTf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 May 2016 10:19:35 -0400
Content-Disposition: inline
In-Reply-To: <20160505015730.GC26977@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 05, 2016 at 11:57:30AM +1000, Dave Chinner wrote:
> We did this intentionally. DAX IO needs to have the same parallel
> write semantics of direct IO, because otherwise a single writer
> prevents any IO concurrency and that's a bigger problem for DAX that
> traditional storage due to the access speed and bandwidth available.

But this is secondard - even buffered I/O would benefit from not
having the global lock.  The difference is that Posix requires exclusive
writers, and we can't just break those semantics because we're sitting
on whizz bang fancy backend storage.

