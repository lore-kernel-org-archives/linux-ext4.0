From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ext4: Avoid unnecessary transaction stalls during
 writeback
Date: Sat, 29 Apr 2017 20:47:43 -0400
Message-ID: <20170430004743.rjwkzuwoyzewxj27@thunk.org>
References: <20170411135418.9638-1-jack@suse.cz>
 <20170411135418.9638-4-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33344 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1427093AbdD3Arq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 29 Apr 2017 20:47:46 -0400
Content-Disposition: inline
In-Reply-To: <20170411135418.9638-4-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 11, 2017 at 03:54:18PM +0200, Jan Kara wrote:
> Currently ext4_writepages() submits all pages with transaction started.
> When no page needs block allocation or extent conversion we can submit
> all dirty pages in the inode while holding a single transaction handle
> and when device is congested this can take significant amount of time.
> Thus ext4_writepages() can block transaction commits for extended
> periods of time.
> 
> Take for example a simple benchmark simulating PostgreSQL database
> (pgioperf in mmtest). The benchmark runs 16 processes doing random reads
> from a huge file, one process doing random writes to the huge file, and
> one process doing sequential writes to a small writes and frequently
> running fsync. With unpatched kernel transaction commits take on average
> ~18s with standard deviation of ~41s, top 5 commit times are:
> 
> 274.466639s, 126.467347s, 86.992429s, 34.351563s, 31.517653s.
> 
> After this patch transaction commits take on average 0.1s with standard
> deviation of 0.15s, top 5 commit times are:
> 
> 0.563792s, 0.519980s, 0.509841s, 0.471700s, 0.469899s
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Great work!   Many thanks.

Apologies for the late application; April has been crazy busy.  I'm
kicking off a full regression test, but it looks good.

	      	   	      	    	- Ted
