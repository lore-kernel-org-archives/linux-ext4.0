From: tytso@mit.edu
Subject: Re: ext2 and directory indexing
Date: Mon, 7 Jun 2010 08:56:34 -0400
Message-ID: <20100607125634.GB13440@thunk.org>
References: <AANLkTimPsiqmWPXYXmP6fODEJaS4GrU2y5nzhN9U5Cj3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Evgeniy Ivanov <lolkaantimat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:54075 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474Ab0FGM4h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Jun 2010 08:56:37 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTimPsiqmWPXYXmP6fODEJaS4GrU2y5nzhN9U5Cj3@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 06, 2010 at 03:29:56PM +0400, Evgeniy Ivanov wrote:
> Hello,
> 
> I'm a bit confused by indexing and ext2. It looks like there is no
> hash code in ext2, but ext2_fs.h has EXT2_INDEX_FL (most confusing),
> EXT2_FEATURE_COMPAT_DIR_INDEX and some other HTree things, but
> EXT2_INDEX_FL and EXT2_FEATURE_COMPAT_DIR_INDEX  are not used
> anywhere.

It's there, but in ext2 it was called EXT2_BTREE_FL (same bit
position, different name), since we originally planned to implement it
using a BTREE.  We ultimately implemented directory indexing by
storing the tree information inside what looks like deleted directory
entries to ext2, but since we don't rebalance the trees on deletion,
they're technically not b-trees.  We also hash the keys before storing
them in the tree, which is why you'll sometimes see references to
"hash tree", or "htree".

> I have ext2 partition created with mkfs.ext2 and when I check this
> partition e2fsck converts some directories to the indexed format and
> sets EXT2_INDEX_FL/EXT3_INDEX_FL. But since I failed grep any usage of
> EXT2_INDEX_FL in fs/ext2 that code doesn't reset EXT2_INDEX_FL (some
> time ago I was suggested to make my ext2 implementation to reset this
> flag which looks correct for ext3, but not ext2). Is it expected
> behavior of e2fsck?

Yes, it's expected.  The fact that e2fsck is complaining and
converting directories back to be indexed is because you didn't follow
my advice.  :-)  Sorry for the EXT2_INDEX_FL vs. EXT2_BTREE_FL
confusion; it's something that I suppose we should clean up, but my
advice would have prevented e2fsck from complaining about corrupted
directory and re-indexing the directories.

I'm curious BTW --- for what operating system are you implementing
this ext2 implementation?

					- Ted
