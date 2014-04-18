From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/5] ext4: No need to truncate pagecache twice in
 collapse range
Date: Fri, 18 Apr 2014 10:49:01 -0400
Message-ID: <20140418144901.GD19131@thunk.org>
References: <1397673182-5326-1-git-send-email-lczerner@redhat.com>
 <1397673182-5326-3-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linkinjeon@gmail.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48237 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbaDROtD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Apr 2014 10:49:03 -0400
Content-Disposition: inline
In-Reply-To: <1397673182-5326-3-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 16, 2014 at 08:33:00PM +0200, Lukas Czerner wrote:
> We're already calling truncate_pagecache_range() before we attempt to
> do any actual job so there is not need to truncate pagecache once more
> using truncate_setsize() after we're finished.
> 
> Remove truncate_setsize() and replace it just with i_size_write() note
> that we're holding appropriate locks.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Applied, with truncate_pagecache_range() changed to be
truncate_pagecache() in the commit description.

Thanks!!

					- Ted
