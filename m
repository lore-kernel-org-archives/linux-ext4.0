From: Theodore Tso <tytso@mit.edu>
Subject: Re: Initial results of FLEX_BG feature.
Date: Wed, 11 Jul 2007 18:09:46 -0400
Message-ID: <20070711220945.GG19456@thunk.org>
References: <20070710112307.34c2ba5c@rx8> <20070711041213.GH6417@schatzie.adilger.int> <20070711003004.531c9307@naruto>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38957 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932224AbXGKWJu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jul 2007 18:09:50 -0400
Content-Disposition: inline
In-Reply-To: <20070711003004.531c9307@naruto>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 11, 2007 at 12:30:04AM -0500, Jose R. Santos wrote:
> > i think in the spirit of the original META_BG option, Ted had wanted to
> > put all the bitmaps from EXT4_DESC_PER_BLOCK groups somewhere within the
> > metagroup.  It would also be interesting to see if moving ALL of the
> > group metadata to a single location in the filesystem makes a bit difference.
> > If not, then we may as well keep it spread out for safety.

My original intention was that META_BG would place the bitmaps and
inode tables at the beginning of each metagroup by default, but that
the constraints about where to put the bitmaps and inode tables would
be completely relaxed from the point of view of requirements by the
kernel and e2fsck.  Unfortunately while I had patches which removed
the constraints checking, they never made it into mainline of either
the kernel or e2fsprogs, sigh.

						- Ted
