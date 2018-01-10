From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix a race in the ext4 shutdown path.
Date: Wed, 10 Jan 2018 00:14:03 -0500
Message-ID: <20180110051403.GF5809@thunk.org>
References: <20180109225257.93785-1-harshads@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: harshads <harshads@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57558 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751362AbeAJFOF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 10 Jan 2018 00:14:05 -0500
Content-Disposition: inline
In-Reply-To: <20180109225257.93785-1-harshads@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 09, 2018 at 02:52:57PM -0800, harshads wrote:
> This patch fixes a race between the shutdown path and bio completion
> handling. In the ext4 direct io path with async io, after submitting a
> bio to the block layer, if journal starting fails,
> ext4_direct_IO_write() would bail out pretending that the IO
> failed. The caller would have had no way of knowing whether or not the
> IO was successfully submitted. So instead, we return -EIOCBQUEUED in
> this case. Now, the caller knows that the IO was submitted.  The bio
> completion handler takes care of the error.
> 
> Tested: Ran the shutdown xfstest test 461 in loop for over 2 hours across
> 4 machines resulting in over 400 runs. Verified that the race didn't
> occur. Usually the race was seen in about 20-30 iterations.
> 
> Signed-off-by: Harshad Shirwadkar <harshads@google.com>

Thanks, applied.

					- Ted
