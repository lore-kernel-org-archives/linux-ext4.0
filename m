From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, resend] ext4: remove timebomb in ext4_decode_extra_time()
Date: Thu, 24 Aug 2017 14:10:44 -0400
Message-ID: <20170824181044.ooqdyuaz4uhy3anm@thunk.org>
References: <20170821081115.2722-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51244 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752640AbdHXSKr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 24 Aug 2017 14:10:47 -0400
Content-Disposition: inline
In-Reply-To: <20170821081115.2722-1-hch@lst.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 21, 2017 at 10:11:15AM +0200, Christoph Hellwig wrote:
> Changing behavior based on the version code is a timebomb waiting to
> happen, and not easily bisectable.  Drop it and leave any removal
> to explicit developer action. (And I don't think file system
> should _ever_ remove backwards compatibility that has no explicit
> flag, but I'll leave that to the ext4 folks).
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
