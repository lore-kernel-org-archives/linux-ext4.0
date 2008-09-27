From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC][PATCH 0/12]ext4: online defrag (ver 0.95)
Date: Sat, 27 Sep 2008 10:49:24 -0400
Message-ID: <20080927144924.GA11669@mit.edu>
References: <48DDE025.2090207@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:58608 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751711AbYI0Ot2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Sep 2008 10:49:28 -0400
Content-Disposition: inline
In-Reply-To: <48DDE025.2090207@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 27, 2008 at 04:26:29PM +0900, Akira Fujita wrote:
> Summary of patches:
> * The followings are new ext4 online defrag patches and they consist
>   of ioctl unit except 1-4.  Because the EXT4_IOC_DEFRAG is too big to review,
>   I divided it into 4 patches.

It would make it *much* easier to review the first four patches if you
did the following:

*) Refector the patches so that low-level functions are first.  Right
   now it's a little hard to review the patches because in a number of
   cases the documentation is in a different patch than the one where
   "return 0;" is replaced with the actual code.

*) In many cases, there is extraneous code in the patch which is not
   described in the commit comments.  For example, in [PATCH 3/12]
   there is a large amount of extent manipulation code that has
   nothing to do with "read and write file data with memory page".  In
   fact, from inspection it looked like there was more extent
   manipulation code than code that was responsible for reading and
   writing the data blocks.

*) It would be much better if extent-related functions are moved to
   the extent.c file, instead of taking low-level extent.c functions
   and making them to be non-static.  (Similarly, if there are
   functions that are more about block allocation, it's better for
   them to go into mballoc.c, instead of putting everything in
   defrag.c).  The idea is to make the code more readable by having
   the correct abstractions, ideally that could be useful for more
   than just defragging --- for example, the code for making sure we
   merge adjacent extents could also be useful when we write into a
   middle of a sparse file.  If it turns out we have code in extent.c
   that does that, let's only have one function, appropriately
   abstracted, that does that, instead of one version for normal use,
   and one version which is tweaked just for defrag.c's specific
   requirements.

*) Could we have at least a few lines description of what the function
   does, instead of just a one-liner and "this function returns 0 on
   success, or an error on failure".  That would be very helpful.
   Many thanks!!

						- Ted
