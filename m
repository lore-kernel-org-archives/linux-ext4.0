From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Do not normalize request from fallocate
Date: Sat, 23 Mar 2013 20:11:43 -0400
Message-ID: <20130324001143.GB4000@thunk.org>
References: <1363881045-21673-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, gharm@google.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55348 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab3CXALt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Mar 2013 20:11:49 -0400
Content-Disposition: inline
In-Reply-To: <1363881045-21673-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 21, 2013 at 04:50:45PM +0100, Lukas Czerner wrote:
> 
> Commit 3c6fe77017bc6ce489f231c35fed3220b6691836 mentioned that
> large fallocate requests were not physically contiguous. However it is
> important to see why that is the case. Because the request is so big the
> allocator will try to find free group to allocate from skipping block
> groups which are used, which is fine. However it will only allocate
> extents of 2^15-1 block (limitation of uninitialized extent size)
> which will leave one block in each block group free which will make the
> extent tree physically non-contiguous, however _only_ by one block which
> is perfectly fine.

Well, it's actually really unfortunate.  The file ends up being more
fragmented, and from an alignment point of view it's really horrid.
For a RAID array with a power of 2 stripe size, or a flash device with
a power of 2 erase block size, the result is actually quite
spectacularly bad:

File size of 1 is 1073741824 (262144 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..   32766:     458752..    491518:  32767:             unwritten
   1:    32767..   65533:     491520..    524286:  32767:     491519: unwritten
   2:    65534..   98300:     589824..    622590:  32767:     524287: unwritten
   3:    98301..  131067:     622592..    655358:  32767:     622591: unwritten
   4:   131068..  163834:     655360..    688126:  32767:     655359: unwritten
   5:   163835..  196601:     688128..    720894:  32767:     688127: unwritten
   6:   196602..  229368:     720896..    753662:  32767:     720895: unwritten
   7:   229369..  262135:     753664..    786430:  32767:     753663: unwritten
   8:   262136..  262143:     786432..    786439:      8:     786431: unwritten,eof
1: 9 extents found

That being said, what we were doing before was quite bad, and you're
quite right about your analysis here:

> This will never happen when we normalize the request because for some
> reason (maybe bug) it will be normalized to much smaller request (2048
> blocks) and those extents will then be merged together not leaving any
> free block in between - hence physically contiguous. However the fact
> that we're splitting huge requests into ton of smaller ones and then
> merging extents together is very _very_ bad for fallocate performance.
> 
> The situation is even worst since with commit
> ec22ba8edb507395c95fbc617eea26a6b2d98797 we no longer merge
> uninitialized extents so we end up with absolutely _huge_ extent tree
> for bigger fallocate requests which is also bad for performance but not
> only when fallocate itself, but even when working with the file
> later on.

Without this patch, we currently do this for the same 1g file:

Filesystem type is: ef53
File size of 2 is 1073741824 (262144 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..    2047:     305152..    307199:   2048:             unwritten
   1:     2048..    4095:     307200..    309247:   2048:             unwritten
   	  	       .....
 106:   217088..  219135:     522240..    524287:   2048:             unwritten
 107:   219136..  221183:     591872..    593919:   2048:     524288: unwritten
 108:   221184..  223231:     593920..    595967:   2048:             unwritten
 		       .....
 127:   260096..  262143:     632832..    634879:   2048:             unwritten,eof
2: 2 extents found

So I agree that what we're doing is poor, but the question is, can we
do something which is better that either of these two results?

That is, can we improve mballoc so that we keep an fallocated gigabyte
file as physically contiguous as possible, while using an optimal
number of on-disk extents?   i.e., 9 extents of length 32767.

Failing that, can we create 20 extents of length 16384 or so?

	      	     	       	       	  	 - Ted
