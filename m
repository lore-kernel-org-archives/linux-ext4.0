From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: xfstest-bld generic/018 fails due to e4defrag issue
Date: Wed, 9 Apr 2014 18:03:20 -0400
Message-ID: <20140409220320.GC15303@thunk.org>
References: <CAGW2f1F1sL+if9zejgB92j0YDRjswvB3LG_dBR+pK3Yj4aQfHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
To: jon ernst <jonernst07@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52242 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933705AbaDIWDY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Apr 2014 18:03:24 -0400
Content-Disposition: inline
In-Reply-To: <CAGW2f1F1sL+if9zejgB92j0YDRjswvB3LG_dBR+pK3Yj4aQfHQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 09, 2014 at 01:37:04AM -0400, jon ernst wrote:
> running latest xfstest-bld with latest ext4 kernel "dev"
> branch(ad6599ab3a).I always get generic/018 failed.
> Then I took closer look and found out this issue.

That's a renamed tested; it was previously shared/218.  It's a test
which is known to fail for ext4, since its idea of how a defrag
program should work is slightly different from how e4defrag works:

shared/218 7s ...   [20:48:32] [20:48:39] - output mismatch (see /results/results-4k/shared/218.out.bad)
    --- tests/shared/218.out   2014-04-01 18:46:39.000000000 +0000
    +++ /results/results-4k/shared/218.out.bad		     2014-04-03 20:48:39.795694518 +0000
    @@ -10,7 +10,7 @@
     After: 1
     Write backwards sync, but contiguous - should defrag to 1 extent
     Before: 10
    -After: 1
    +After: 10
     Write backwards sync leaving holes - defrag should do nothing
     Before: 16
    ...
    (Run 'diff -u tests/shared/218.out /results/results-4k/shared/218.out.bad'  to see the entire diff)

What you are seeing is something very different, though.

> Even though the file does exist. e4defrag complains about:
> 
> (this output comes from kvm guest machine)
> > e4defrag -v /vdf/testfile
> Can't get super block info: Success
> "/vdf/testfile"
> 
> Is this a known issue or something I did wrong.

Unfortunately, e4defrag has horrible error handling, so we can't see
the error code properly, so we can't see why it's failing, but this is
from an attempt to open the file system to get some low-level
information.

How is /etc/mtab set up on your test machine?  It looks like it failed
to find block device for the file system in question.

   	      	     	     	  	 - Ted
