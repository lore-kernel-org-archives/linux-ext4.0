Return-Path: <SRS0=7ScE=O4=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from dmz-mailsec-scanner-3.mit.edu ([18.9.25.14]:52714 "EHLO
        dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726614AbeLSAQM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 18 Dec 2018 19:16:12 -0500
Date: Tue, 18 Dec 2018 19:16:03 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Victor Hsieh <victorhsieh@google.com>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 01/12] fs-verity: add a documentation file
Message-ID: <20181219001603.GD25775@mit.edu>
References: <20181101225230.88058-1-ebiggers@kernel.org>
 <20181101225230.88058-2-ebiggers@kernel.org>
 <20181212091406.GA31723@infradead.org>
 <20181212202609.GA193967@gmail.com>
 <20181213202249.GA3797@infradead.org>
 <20181214044802.GA681@sol.localdomain>
 <20181217200039.GD8111@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181217200039.GD8111@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 17, 2018 at 12:00:39PM -0800, Darrick J. Wong wrote:
> FWIW, if I were (hypothetically) working on an xfs implementation, I
> likely would have settled on passing a reference to a merkle tree
> through a (fd, length) pair, because that allows us plenty of options
> on the back end:
> 
> b) we could remap the tree into a new inode fork for merkle trees, or
> a) remap it as posteof blocks like ext4/f2fs does, or
> c) remap the blocks into the attribute fork as an (unusually large)
> extended attribute value.

Sure, but what would be the benefit of doing different things on the
back end?  I think this is a really more of a philophical objection
than anything else.  With both fsverity and fscrypt, well over 95% of
the implementation is shared between ext4 and f2fs.  And from a
cryptographic design, that's something I consider a feature, not a
bug.  Cryptographic code is subtle in very different ways compared to
file system code.  So it's a good thing to having it done once and
audited by crypto specialists, as opposed to having each file system
doing it differently / independently.

> If the merkle_fd isn't on the same filesystem as the fd we could at
> least use generic_copy_file_range (i.e. page cache copying) to land the
> merkle tree wherever we want.
> 
> Granted, it's not like we can't do any of those three things given the
> current interface.  I gather most of the grumbling has to do with
> feeling like we're associating the on-disk format to the ioctl interface
> too closely?

Right, the current interface makes it somewhat more awkward to do
these other things --- but the question is *why* would you want to in
the first place?  Why add the extra complexity?  I'm a big believer of
the KISS principle, and if there was a reason why a file system would
want to store the Merkle tree somewhere else, we could talk about it,
but I see only downside, and no upside.

      	       		     	- Ted
