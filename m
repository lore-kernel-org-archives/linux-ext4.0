Return-Path: <SRS0=EV/E=O6=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from dmz-mailsec-scanner-7.mit.edu ([18.7.68.36]:42676 "EHLO
        dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725845AbeLUPrX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 21 Dec 2018 10:47:23 -0500
Date: Fri, 21 Dec 2018 10:47:14 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Victor Hsieh <victorhsieh@google.com>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 01/12] fs-verity: add a documentation file
Message-ID: <20181221154714.GA26547@mit.edu>
References: <20181219071420.GC2628@infradead.org>
 <20181219021953.GD31274@dastard>
 <20181219193005.GB6889@mit.edu>
 <20181219213552.GO6311@dastard>
 <20181220220158.GC2360@mit.edu>
 <20181221070447.GA21687@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181221070447.GA21687@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 20, 2018 at 11:04:47PM -0800, Christoph Hellwig wrote:
> Ted, I think you know yourself this isn't true.  Whenever we added
> useful interface to one of the major file systems we had other pick
> it up, and that is a good thing because the last thing we need is
> fragmentation of interfaces.  And even if that wasn't the case I don't
> think we should take short cuts, because even if an interface was just
> for a file system or two it still needs to be properly desgined.

This is why I think the interface argument is totally bogus.

If you're OK with Darrick's suggested interface, where you pass in a
file descriptor, offset and length --- that's just a superset of the
current interface, except where the file descriptor is in the file
which is going to be protected using fs-verity.  So there's if you're
OK with that interface, we can add that interface later, and it's
really no big deal; it certainly doesn't add any extra complexity for
XFS --- assuming that XFS even gets around to adding support for
fs-verity.

Adding that extra complexity is not necessary for the current users of
the interface, and as I've said multiple times before, there's no
*value* in allowing the Merkle tree to be passed in via some arbitrary
file descriptor, which might even be on a separate fhile system, as
opposed in the file which is about to be protected using fs-verity.

Linus --- we're going round and round, and I don't think this is
really a technical dispute at this point, but rather an aesthetics
one.  Will you be willing to accept my pull request for a feature
which is being shippped on millions of Android phones, has been out
for review for months, and for which, if we *really* need to add
uselessly complicated interface later, we can do that?  It's always
been the case for internal Kernel interfaces not to add code "just in
case" it's useful, but rather when a user turns up.  I argue we should
be doing the same thing for user-space visible interfaces.

Regards,

						- Ted
