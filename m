From: tytso@mit.edu
Subject: Re: ext2/ext3 different block_sizes/i_size/e2fsck question
Date: Wed, 24 Mar 2010 21:55:03 -0400
Message-ID: <20100325015503.GJ2159@thunk.org>
References: <e1e08eb01003241227p35e84777q622996b861009ecb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Evgeniy Ivanov <lolkaantimat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:39352 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab0CYBzq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Mar 2010 21:55:46 -0400
Content-Disposition: inline
In-Reply-To: <e1e08eb01003241227p35e84777q622996b861009ecb@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 24, 2010 at 10:27:24PM +0300, Evgeniy Ivanov wrote:
> 
> Sorry for bothering list with my ext2 questions.
> I got into trouble with my ext2 implementation and filesystem with
> 1024 block size. Sometimes when I write files they're written
> correctly (md5sum is the same as original, i_size is correct either),
> but e2fsck changes i_size to another values (which breaks files). E.g.
> 67445000->67446784 or 67445248->67446784. I see that new sizes are
> numbers of multiples of 1024.
> Strange thing is that I can't reproduce this problem with 2048 and
> 4096 block sizes. I thought the problem was in trash in unused part of
> last block (actually it is zeroed), but then it would be reproduceable
> in fs with another block size.

E2fsck will adjust i_size if it is smaller than the number of blocks
than you have allocated.  So in the case of 67445000->67446784, your
file probably had 65866 1k blocks, and since 67445000 is less than
(655865*1024)+1, e2fsck assumed that your i_size was wrong, and so it
asked for permission to fix it.

Put another way, if you have 2 blocks in 1k file, and i_size is 1024,
it clearly must be wrong.  If it's 1025, maybe we're only using 1 byte
in the last block; but if i_size is less than or equal to 1024, then
why was the 2nd block allocated in the file in the first place?

    	    	      		       - Ted
