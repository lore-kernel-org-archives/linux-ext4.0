From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Fix off-by-in in loop termination in
 ext4_find_unwritten_pgoff()
Date: Sat, 20 May 2017 00:15:34 -0400
Message-ID: <20170520041534.25req27q6epii3rr@thunk.org>
References: <20170518104942.14588-1-jack@suse.cz>
 <20170518104942.14588-3-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45074 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750940AbdETEPi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 20 May 2017 00:15:38 -0400
Content-Disposition: inline
In-Reply-To: <20170518104942.14588-3-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 18, 2017 at 12:49:42PM +0200, Jan Kara wrote:
> There is an off-by-one error in loop termination conditions in
> ext4_find_unwritten_pgoff() since 'end' may index a page beyond end of
> desired range if 'endoff' is page aligned. It doesn't have any visible
> effects but still it is good to fix it.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
