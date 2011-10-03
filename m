From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v4] crc32c: Implement CRC32c with slicing-by-8 algorithm
Date: Mon, 3 Oct 2011 08:36:46 -0700
Message-ID: <20111003153634.GA12447@tux1.beaverton.ibm.com>
References: <20110930192956.4176.29905.stgit@elm3c44.beaverton.ibm.com> <OF54094699.6F5CF2B6-ONC125791C.004C901C-C125791C.004D1A61@transmode.se>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Mingming Cao <cmm@us.ibm.com>,
	David Miller <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Bob Pearson <rpearson@systemfabricworks.com>,
	Theodore Tso <tytso@mit.edu>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56387 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab1JCQso (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Oct 2011 12:48:44 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 3 Oct 2011 12:45:29 -0400
Content-Disposition: inline
In-Reply-To: <OF54094699.6F5CF2B6-ONC125791C.004C901C-C125791C.004D1A61@transmode.se>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 01, 2011 at 04:02:10PM +0200, Joakim Tjernlund wrote:
> 
> "Darrick J. Wong" <djwong@us.ibm.com> wrote on 2011/09/30 21:29:56:
> >
> > The existing CRC32c implementation uses Sarwate's algorithm to calculate the
> > code one byte at a time.  Using a slicing-by-8 algorithm adapted from Bob
> > Pearson, we can process buffers 8 bytes at a time, for a substantial increase
> > in performance.
> >
> > The motivation for this patchset is that I am working on adding full metadata
> > checksumming to ext4 and jbd2.  As far as performance impact of adding
> > checksumming goes, I see nearly no change with a standard mail server ffsb
> > simulation.  On a test that involves only metadata operations (file creation
> > and deletion, and fallocate/truncate), I see a drop of about 50 pcercent with
> > the current kernel crc32c implementation; this improves to a drop of about 20
> > percent with the enclosed crc32c code.
> >
> > When metadata is usually a small fraction of total IO, this new implementation
> > doesn't help much because metadata is usually a small fraction of total IO.
> > However, when we are doing IO that is almost all metadata (such as rm -rf'ing a
> > tree), then this patch speeds up the operation substantially.
> >
> > Given that iscsi, sctp, and btrfs also use crc32c, this patchset should improve
> > their speed as well.  I have some preliminary results[1] that show the
> > difference in various crc algorithms that I've come across: the "crc32c-by8-le"
> > column is the new algorithm in the patch; the "crc32c" column is the current
> > crc32c kernel implementation; and the "crc32-kern-le" column is the current
> > crc32 kernel implementation, which is similar to the results one gets for
> > CONFIG_CRC32C_SLICEBY4=y.  As you can see, the new implementation runs at
> > nearly 4x the speed of the current implementation; even the slimmer slice-by-4
> > implementation is generally 2-3x faster.
> >
> > However, the implementation allows the kernel builder to select from a variety
> > of space-speed tradeoffs, should my results not hold true on a particular
> > class of system.
> >
> > v2: Use the crypto testmgr api for self-test.
> > v3: Get rid of the -be version, which had no users.
> > v4: Allow kernel builder a choice of speed vs. space optimization.
> >
> > [1]http://djwong.org/docs/ext4_metadata_checksums.html
> > (cached copy of the ext4 wiki)
> >
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> 
> This is based on an old version of Bobs slice by 8 that has lots duplication and
> hard to maintain.

Are you referring to "[PATCH v6 05/10] crc32-misc-cleanup.diff" from 8/31?  I
haven't seen that one, so I'll go comb the internet.  Thank you for the
pointer, I'll update my patch.

> Start from Bobs latest patches and add crc32c to lib/crc32.c

If I did that, how should I handle patching in the hardware accelerated version
on Intel systems?  That switcheroo ability seems to have been Herbert Xu's
motivation for moving crc32c into crypto/ in the first place:

"libcrc32c: Move implementation to crypto crc32c

"This patch swaps the role of libcrc32c and crc32c.  Previously
the implementation was in libcrc32c and crc32c was a wrapper.
Now the code is in crc32c and libcrc32c just calls the crypto
layer.

"The reason for the change is to tap into the algorithm selection
capability of the crypto API so that optimised implementations
such as the one utilising Intel's CRC32C instruction can be
used where available."

> Also, for crc32c I think you only need slice by 4 and slice by 8

Yes.  The lookup table option is only for people with extremely small systems,
and the per-bit option is usable only for debugging.  They could go away if
anyone's really offended by them. :)

--D
> 
>  Jocke
> 

