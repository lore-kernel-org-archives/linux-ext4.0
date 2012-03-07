From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] fadvise: add more flags to provide a hint for block
 allocation
Date: Wed, 7 Mar 2012 23:11:38 +1100
Message-ID: <20120307121138.GK3592@dastard>
References: <20120305125029.GA5121@gmail.com>
 <20120307005130.GH3592@dastard>
 <A2E616B7-79A5-4ECF-872F-A62ACA338C54@dilger.ca>
 <yq1k42xhulg.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <aedilger@gmail.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:3751 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757674Ab2CGMLm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Mar 2012 07:11:42 -0500
Content-Disposition: inline
In-Reply-To: <yq1k42xhulg.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 07, 2012 at 12:02:19AM -0500, Martin K. Petersen wrote:
> >>>>> "Andreas" == Andreas Dilger <aedilger@gmail.com> writes:
> 
> Andreas> This proposal definitely needs to have some clear explanation
> Andreas> of how the flags are intended to be used by applications, and
> Andreas> why they will help filesystems to improve allocation. 
> 
> This goes a bit deeper than just filesystem block allocation strategy.
> 
> With SMR drives lurking on the horizon it is becoming increasingly
> important for us to classify anticipated future access patterns as we
> send I/Os out to storage. We'll need something much smarter than just
> REQ_META for these devices. Tiered storage arrays and tiered flash also
> benefit from this information.

>From what I've seen of the proposed SMR device standards, we're
going to have to redesign filesystem allocation policies completely
to use anything other than a single emulated random read/write
region in a SMR drive. Filesystems are going to need to know about
the different regions and their attributes to determine how they can
allocate space and what type of write IO that can be directed to
such areas. e.g. a filesystem that overwrites metadata in place must
use a random RW region for all it's metadata - there is no other
choice. And for regions that are append only, they cannot have their
space reused until the entire region has had all active data moved
out of it first.

>From that perspective, I don't see fadvise as the best interface for
this - per-file access pattern/allocation policy information needs
to be kept persistent in the filesystem. Indeed, there is no end of
different allocation policies a filesystem could define, so I don't
think that iterating them in fadvise() is a good thing to do. I'm
not sure that fallocate() is even the right place for this, though
it is a much better match for such extensions because it is for
persistent changes to file allocation ranges.

> There's lots of work going on in the standards space in this department
> right now and I was hoping we could spend some time discussing the
> current proposals in one of the plenary sessions at LSF. Ideally we'd
> tie fadvise() and any filesystem internal knowledge into appropriate
> storage hints at the bottom of the stack.

I didn't see much in way of scope for hints at the bottom of the
stack for SMR devices - once the filesystem has allocated space in
the region for the given access type, there is no additional
information that needs to be supplied by the storage stack. I
suspect the same is true for tiered storage....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
