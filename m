From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix data corruption for mmap writes
Date: Fri, 26 May 2017 19:02:54 -0400
Message-ID: <20170526230254.rcogrq2dolk7uqfk@thunk.org>
References: <20170525114622.1543-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Michael Zimmer <michael@swarm64.com>,
        stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42944 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1948814AbdEZXC6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 26 May 2017 19:02:58 -0400
Content-Disposition: inline
In-Reply-To: <20170525114622.1543-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 25, 2017 at 01:46:22PM +0200, Jan Kara wrote:
> mpage_submit_page() can race with another process growing i_size and
> writing data via mmap to the written-back page. As mpage_submit_page()
> samples i_size too early, it may happen that ext4_bio_write_page()
> zeroes out too large tail of the page and thus corrupts user data.
> 
> Fix the problem by sampling i_size only after the page has been
> write-protected in page tables by clear_page_dirty_for_io() call.
> 
> Reported-by: Michael Zimmer <michael@swarm64.com>
> CC: stable@vger.kernel.org
> Fixes: cb20d5188366f04d96d2e07b1240cc92170ade40
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
