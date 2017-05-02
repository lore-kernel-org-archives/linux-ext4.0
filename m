From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH -v2] ext4: avoid unnecessary transaction stalls during
 writeback
Date: Tue, 2 May 2017 14:10:44 +0200
Message-ID: <20170502121044.GG13916@quack2.suse.cz>
References: <20170430220101.trrgiaphp756kxw4@thunk.org>
 <20170430223053.20025-1-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36573 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750884AbdEBMKr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 2 May 2017 08:10:47 -0400
Content-Disposition: inline
In-Reply-To: <20170430223053.20025-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 30-04-17 18:30:53, Ted Tso wrote:
> From: Jan Kara <jack@suse.cz>
> 
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
> one process doing sequential writes to a small files and frequently
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
> [ Modified so we use an explicit do_map flag instead of relying on
>   io_end not being allocated, the since io_end->inode is needed for I/O
>   error handling. -- tytso ]

Yeah, thanks for finding the problem and fixing it up! The updated patch
looks good. It is actually relatively easy to fix the original approach so
that we don't have to allocate ioend unnecessarily (we just fetch the inode
pointer on error through bio_vec->bv_page->mapping->host) but I'll do that
separately on top of this change.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
