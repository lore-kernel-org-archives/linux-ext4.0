From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Thu, 7 Apr 2011 08:59:23 +1000
Message-ID: <20110406225922.GI31057@dastard>
References: <20110216145627.GB5592@quack.suse.cz>
 <4D5C9B1B.2050304@jp.fujitsu.com>
 <20110217104552.GD4947@quack.suse.cz>
 <20110328170628.ffe314fb.toshi.okajima@jp.fujitsu.com>
 <20110331234050.GD2904@dastard>
 <20110401140856.GA5311@quack.suse.cz>
 <20110406054005.GD31057@dastard>
 <20110406061856.GC23285@quack.suse.cz>
 <20110406112135.GE31057@dastard>
 <20110406134428.GA17705@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:59468 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752813Ab1DFW7h (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Apr 2011 18:59:37 -0400
Content-Disposition: inline
In-Reply-To: <20110406134428.GA17705@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 06, 2011 at 09:44:28AM -0400, Christoph Hellwig wrote:
> On Wed, Apr 06, 2011 at 09:21:35PM +1000, Dave Chinner wrote:
> > Sure, but the question must be asked - why is ext3/4 even starting a
> > transaction on a clean filesystem during sync? A frozen filesystem,
> > by definition, is a clean filesytem, and therefore sync calls of any
> > kind should not be trying to write to the FS or start transactions.
> > XFS does this just fine, so I'd consider such behaviour on a frozen
> > filesystem a bug in ext3/4...
> 
> XFS does have one special case for this.  When writing the dummy log
> record at the end of the freeze process we use _xfs_alloc_trans to
> bypass the frozen filesystem check as we have to write out this record
> when the filesystem already is frozen.  But that's after the main
> sync with its normal transactions.

Right, that is a special case in the _freeze process_ (i.e. before
we've declared the FS frozen), not a normal operation on a frozen
filesystem.

If you want to list exceptions (i.e. where we explicitly avoid
writes to frozen fs), look for xfs_fs_writeable(), which stops
various write operations from proceeding when the fs is either
frozen, read-only or shut down.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
