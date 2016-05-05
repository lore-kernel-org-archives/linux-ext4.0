From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 0/2] ext4: Improve parallel I/O performance on NVDIMM
Date: Thu, 5 May 2016 11:57:30 +1000
Message-ID: <20160505015730.GC26977@dastard>
References: <1461947276-25988-1-git-send-email-Waiman.Long@hpe.com>
 <57238DFC.6010108@hpe.com>
 <20160501172854.GA19601@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Waiman Long <waiman.long@hpe.com>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@linux.intel.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:33311 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751311AbcEEB6M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 May 2016 21:58:12 -0400
Content-Disposition: inline
In-Reply-To: <20160501172854.GA19601@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 01, 2016 at 10:28:54AM -0700, Christoph Hellwig wrote:
> On Fri, Apr 29, 2016 at 12:38:20PM -0400, Waiman Long wrote:
> > From my testing, it looked like that parallel overwrites to the same file in
> > an ext4 filesystem on DAX can happen in parallel even if their range
> > overlaps. It was mainly because the code will drop the i_mutex before the
> > write. That means the overlapped blocks can get garbage. I think this is a
> > problem, but I am not expert in the ext4 filesystem to say for sure. I would
> > like to know your thought on that.
> 
> That's another issue with dax I/O pretending to be direct I/O..  Because
> it isn't we'll need to synchronize it like buffered I/O and not like
> direct I/O in all file systems.

We did this intentionally. DAX IO needs to have the same parallel
write semantics of direct IO, because otherwise a single writer
prevents any IO concurrency and that's a bigger problem for DAX that
traditional storage due to the access speed and bandwidth available.

This was always intended to be fixed by the introduction of proper
range locking for IO, not by reverting to total exclusion for write
IOs.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
