From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Far too long mount time
Date: Thu, 16 Aug 2012 15:57:34 -0400
Message-ID: <20120816195734.GD31346@thunk.org>
References: <CAAnFQG_O051svcCZftDefebVEds+P1zAceteh=B18HOqmoqitg@mail.gmail.com>
 <CAAnFQG9esXovsAYkCS5Lw5JGpc5dW2PLccvYjN7NvaHLQDqGmA@mail.gmail.com>
 <0F24AF1B-39C9-4300-862B-B9E84A21E34C@dilger.ca>
 <1345126608.22142.59.camel@cwalton-XPS-8300>
 <20120816144219.GB29410@thunk.org>
 <20120816185337.GB31346@thunk.org>
 <502D48B9.4000907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Calvin Walton <calvin.walton@kepstin.ca>,
	Andreas Dilger <adilger@dilger.ca>,
	Javier Marcet <jmarcet@gmail.com>,
	Linux Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	jpiszcz@lucidpixels.com
To: Eric Sandeen <esandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45104 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932536Ab2HPT5j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Aug 2012 15:57:39 -0400
Content-Disposition: inline
In-Reply-To: <502D48B9.4000907@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 16, 2012 at 02:23:37PM -0500, Eric Sandeen wrote:
> 
> And mkfs with bigalloc will do that, right?

Not yet.

We also need to make sure s_overhead_clusters gets updated after a
resize operation, but I wanted to get a fix for non-bigalloc file
systems out there as soon as possible.

> So when does all of the code after the short-circuit ever run?

Until we get ths rest of the code fixed up, it will needed for all
bigalloc file systems.  The one saving grace is that bigalloc file
systems will have fewer block groups, so the O(n**2) won't be as bad
--- but it is something we really should fix.

					- Ted
