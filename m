From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2freefrag utility
Date: Fri, 24 Jul 2009 18:32:01 -0400
Message-ID: <20090724223201.GA6832@mit.edu>
References: <20090721001750.GD4231@webber.adilger.int> <20090722074352.GA21869@mit.edu> <4A67EE3F.4090909@redhat.com> <20090723170759.GB4231@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52883 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbZGXWdN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Jul 2009 18:33:13 -0400
Content-Disposition: inline
In-Reply-To: <20090723170759.GB4231@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 23, 2009 at 11:07:59AM -0600, Andreas Dilger wrote:
> 
> I like the printing of the total blocks in each section and the
> percent of blocks...  Attached is an incremental patch that adds
> the same to e2freefrag.

Thanks, applied.

One question --- right now the chunksize (as specified by -c) only
affects these lines printed by e2freefrag, right?

Chunksize: 1048576 bytes (256 blocks)
Total chunks: 71681
Free chunks: 21657 (30.2%)

They are a little confusing since "chunk" as used here is different
from "chunk" used in the next part of the output:

Min free chunk: 4 KB 
Max free chunk: 568232 KB
Avg free chunk: 188 KB

How useful is it to print the "total chunks / free chunks" in the
general case?  I'm guessing this relates to Lutsre's chunking and
chunksize?  Would it make sense to only print the "Chunksize / Total
chunks / Free Chunks" if a chunksize is specified explicitly via the
-c option, and to do a s/chunk/extent/ in the next part of the output,
i.e.:

Min free extent: 4 KB 
Max free extent: 568232 KB
Avg free extent size: 188 KB

							- Ted
