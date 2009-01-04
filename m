From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, RFC] Use WRITE_SYNC in __block_write_full_page() if
 WBC_SYNC_ALL
Date: Sun, 4 Jan 2009 14:23:03 -0800
Message-ID: <20090104142303.98762f81.akpm@linux-foundation.org>
References: <E1LJatq-00061O-0e@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-mm@vger.kernel.org, linux-ext4@vger.kernel.org,
	Arjan van de Ven <arjan@infradead.org>,
	Jens Axboe <jens.axboe@oracle.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285AbZADWYB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Jan 2009 17:24:01 -0500
In-Reply-To: <E1LJatq-00061O-0e@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 04 Jan 2009 16:52:46 -0500 "Theodore Ts'o" <tytso@mit.edu> wrote:

> If wbc.sync_mode is WBC_SYNC_ALL, then in the page writeback paths we
> will be waiting for the write to complete.  So the I/O should be
> submitted via submit_bh() with WRITE_SYNC so the block layer should
> properly prioritize the I/O.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: linux-mm@vger.kernel.org
> ---
> 
> Following up with an e-mail thread started by Arjan two months ago,
> (subject: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority), I have
> a patch, just sent to linux-ext4@vger.kernel.org, which fixes the jbd2
> layer to submit journal writes via submit_bh() with WRITE_SYNC.
> Hopefully this might be enough of a priority boost so we don't have to
> force a higher I/O priority level via a buffer_head flag.  However,
> while looking through the code paths, in ordered data mode, we end up
> flushing data pages via the page writeback paths on a per-inode basis,
> and I noticed that even though we are passing in
> wbc.sync_mode=WBC_SYNC_ALL, __block_write_full_page() is using
> submit_bh(WRITE, bh) instead of submit_bh(WRITE_SYNC).

But this is all the wrong way to fix the problem, isn't it?

The problem is that at one particular point, the current transaction
blocks callers behind the committing transaction's IO completion.

Did anyone look at fixing that?  ISTR concluding that a data copy and
shadow-bh arrangement might be needed.
