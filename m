From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: ext4_da_convert_inline_data_to_extent drop locked
 page after error
Date: Wed, 3 Dec 2014 09:31:20 -0500
Message-ID: <20141203143120.GW13618@thunk.org>
References: <1417530500-9958-1-git-send-email-dmonakhov@openvz.org>
 <20141202235913.GJ13618@thunk.org>
 <877fy9du0z.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37118 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbaLCObX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2014 09:31:23 -0500
Content-Disposition: inline
In-Reply-To: <877fy9du0z.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 03, 2014 at 11:20:12AM +0300, Dmitry Monakhov wrote:
> I use xfstest-bld. So our test environment should be equals.
> Unfortunately this is is not 100% reproducible, that is why I've missed
> that bug on first test-run. Even more yesterday I've scheduled inline_data tests
> to run for a whole night and it is deadlocked again in almost the same
> place :)

I've tried running that specific test several multiple times and I
wasn't ableto see the failure.  One potential difference from the
default configuration is that I use a configured LVM volume instead of
a flat file for the test files (i.e., I use /dev/heap/scratch instead
of a file named "vdc", for example).  It could be that this is
sufficiently timing sensitive that I don't see the problem because the
race window is pretty narrow.

OK, thanks for sending the updated patch.

						- Ted
