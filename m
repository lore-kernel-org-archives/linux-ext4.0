From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Use truncate_pagecache() in collapse range
Date: Fri, 18 Apr 2014 10:21:53 -0400
Message-ID: <20140418142153.GA31794@thunk.org>
References: <002101cf5ac76d97bf048c73d0samsung.com>
 <1397820124-16885-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, namjae.jeon@samsung.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48180 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098AbaDROV5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Apr 2014 10:21:57 -0400
Content-Disposition: inline
In-Reply-To: <1397820124-16885-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 18, 2014 at 01:22:04PM +0200, Lukas Czerner wrote:
> We should be using truncate_pagecache() instead of
> truncate_pagecache_range() in the collapse range because we're
> truncating page cache from offset to the end of file.
> truncate_pagecache() also get rid of the private COWed pages from the
> range because we're going to shift the end of the file.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted
