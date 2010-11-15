From: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] jbd2: avoid the concurrent data writeback
Date: Mon, 15 Nov 2010 13:54:20 +0800
Message-ID: <20101115055420.GA21785@localhost>
References: <1289827533-2576-1-git-send-email-feng.tang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: "Tang, Feng" <feng.tang@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9848 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab0KOFyW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Nov 2010 00:54:22 -0500
Content-Disposition: inline
In-Reply-To: <1289827533-2576-1-git-send-email-feng.tang@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[add CC to mailing lists]

Tang,

Good catch!

On Mon, Nov 15, 2010 at 09:25:33PM +0800, Tang, Feng wrote:
> When dd a big file to an ext4 partition, it is very likely to happen
> that both the background flush thread and kjounald try to do data
> writeback for it, and ext4_witepage may be called 100, 000 times by
> journal_submit_inode_data_buffers() without really writing one page
> back (skipped), as those pages haven't had disk blocks allocated yet.

The above changelog could show a bit more details (to help me
understand it :).

Does it happen frequently and hence has measurable overheads?

Is it safe to skip the inode? Another alternative is to wait for it:
with inode_wait_for_writeback(inode).

> This could be find by a simple test case with ftrace:
> $ sync;
> $ echo 40960 > buffer_size_kb;echo 1 > events/writeback/enable;echo 1 > events/jbd2/enable;echo 1 > events/ext4/enable;
> $ dd if=/dev/zero of=/home/test/1g.bin bs=1M count=1024;sync;
> $ cat trace > /home/test/jbd2_ext4_1g_dd.log
> 
> This patch will check if the inode is under data syncing, if yes then
> don't start the writeback from kjournald
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  fs/jbd2/commit.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index f3ad159..8a1978d 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -181,6 +181,14 @@ static int journal_submit_inode_data_buffers(struct address_space *mapping)
>  		.range_end = i_size_read(mapping->host),
>  	};
>  
> +	spin_lock(&inode_lock);
> +	/* If this inode is under data syncing, then just quit */

Comments should go above the whole code block. And the above comment
does not really say anything. Say something *why* code like this
rather than *what* the code is doing. 

> +	if (mapping->host->i_state & I_SYNC) {
> +		spin_unlock(&inode_lock);
> +		return 0;
> +	}
> +	spin_unlock(&inode_lock);
> +
>  	ret = generic_writepages(mapping, &wbc);
>  	return ret;
>  }

Thanks,
Fengguang
