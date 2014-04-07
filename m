From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Note the error in ext4_end_bio()
Date: Mon, 7 Apr 2014 10:41:11 -0400
Message-ID: <20140407144111.GB8855@thunk.org>
References: <20140402143507.GA27299@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51109 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945AbaDGOlP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Apr 2014 10:41:15 -0400
Content-Disposition: inline
In-Reply-To: <20140402143507.GA27299@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 02, 2014 at 10:35:07AM -0400, Matthew Wilcox wrote:
> 
> ext4_end_bio() currently throws away the error that it receives.  Chances
> are this is part of a spate of errors, one of which will end up getting
> the error returned to userspace somehow, but we shouldn't take that risk.
> Also print out the errno to aid in debug.
> 
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>

Thanks, applied.

						- Ted
