From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: regression in 4.5-rc5 - generic/324 failure
Date: Wed, 9 Mar 2016 18:19:49 -0500
Message-ID: <20160309231949.GC3949@thunk.org>
References: <20160309221746.GA1763@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, guaneryu@gmail.com
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53512 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965087AbcCIXTv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Mar 2016 18:19:51 -0500
Content-Disposition: inline
In-Reply-To: <20160309221746.GA1763@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 09, 2016 at 05:17:46PM -0500, Eric Whitney wrote:
> I'm seeing generic/324 fail consistently when run with xfstest-bld's test
> appliance in the 1k block size test case on x86_64.  This happened first on my
> 4.5-rc5 regression run, and it repeated on -rc6 and -rc7.
> 
> Reverting a commit introduced in 4.5-rc5 inhibits the failure:
> "ext4: don't read blocks from disk after extents being swapped" (bcff24887d00)

Yeah, sorry, I didn't recognize the failure you described on the
phone.  This has been fixed in the ext4 dev tree:

commit 87f9a031af48defee9f34c6aaf06d6f1988c244d
Author: Eryu Guan <guaneryu@gmail.com>
Date:   Sun Feb 21 18:38:44 2016 -0500

    ext4: iterate over buffer heads correctly in move_extent_per_page()
    
    In commit bcff24887d00 ("ext4: don't read blocks from disk after extents
    being swapped") bh is not updated correctly in the for loop and wrong
    data has been written to disk. generic/324 catches this on sub-page
    block size ext4.
    
    Fixes: bcff24887d00 ("ext4: don't read blocks from disk after extentsbeing swapped")
    Signed-off-by: Eryu Guan <guaneryu@gmail.com>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>
    Cc: stable@vger.kernel.org

I should have realized this was a 4.5 regression that should have been
pushed to Linus directly.  It's awfully late, and I'm not sure there's
going to be a -rc8, but I'll see if I can get this to Linus this cycle
or not.

						- Ted
