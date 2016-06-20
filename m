From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: wake up j_wait_done_commit before commit callback
Date: Mon, 20 Jun 2016 16:45:09 +0200
Message-ID: <20160620144509.GF6882@quack2.suse.cz>
References: <1466048728-4325-1-git-send-email-wangshilong1991@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49709 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755465AbcFTPFA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jun 2016 11:05:00 -0400
Content-Disposition: inline
In-Reply-To: <1466048728-4325-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 16-06-16 12:45:28, Wang Shilong wrote:
> From: Wang Shilong <wshilong@ddn.com>
> 
> Lustre register some callbacks in ext4 to keep data consistency,
> we see millons callbacks possibility on MDS for metadata operations.
> 
> If there are many commit callbacks which might take some cpu
> time, we can mark commit done before we call commit callback.
> this can relax some thread waiting for commit finished, for example
> transaction throttle in end transaction.
> 
> Signed-off-by: Wang Shilong <wshilong@ddn.com>

This is wrong - the commit callbacks will mark blocks free in bitmaps and
ext4_should_retry_alloc() relies on the fact that once commit is reported
as completed, all blocks freed in the committed transaction are really free
in the bitmaps. This patch breaks the assumption. And Ted's optimization,
which is BTW buggy, doesn't change anything on that...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
