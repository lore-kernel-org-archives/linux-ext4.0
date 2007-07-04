From: Valerie Henson <val@nmt.edu>
Subject: Re: fallocate support for bitmap-based files
Date: Wed, 4 Jul 2007 17:11:27 -0600
Message-ID: <20070704231127.GA3854@rainbow>
References: <20070629130120.ec0d1c75.akpm@linux-foundation.org> <20070629205525.GD32178@thunk.org> <20070629143818.9f4ac7d7.akpm@linux-foundation.org> <4685829D.2020401@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@clusterfs.com>,
	Sreenivasa Busam <sreenivasac@google.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>
To: Mike Waychison <mikew@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhost.nmt.edu ([129.138.4.52]:49095 "EHLO mailhost.nmt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841AbXGDXq2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jul 2007 19:46:28 -0400
Content-Disposition: inline
In-Reply-To: <4685829D.2020401@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 29, 2007 at 06:07:25PM -0400, Mike Waychison wrote:
> 
> Relying on (a tweaked) reservations code is also somewhat limitting at 
> this stage given that reservations are lost on close(fd).  Unless we 
> change the lifetime of the reservations (maybe for the lifetime of the 
> in-core inode?), crank up the reservation sizes and deal with the 
> overcommit issues, I can't think of any better way at this time to deal 
> with the problem.

While I never ever intended the ext3-to-ext2 reservations port to be
used :), I think you can make some fairly minor tweaks to it and get
something that works for your use case.  Move the reservation drop to
iput() and turn up your inode cache size, or store it in a tree when
the inode is closed and go look for it again when it's reopened.
Changing the reservation size seems fairly easy.  I'm not sure how the
overcommit issues affect your use case; any data you can share on
that?

In any case, storing the reservation data on-disk seems like not such
a great idea.  It adds complexity, disk traffic, and a new set of
checks for fsck.  I wouldn't want to incur that cost unless absolutely
necessary.

-VAL
