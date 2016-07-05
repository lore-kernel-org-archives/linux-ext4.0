From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: mbcache: fix to detect failure of register_shrinker
Date: Tue, 5 Jul 2016 16:16:25 -0400
Message-ID: <20160705201625.GA18568@thunk.org>
References: <1463411798-2597-1-git-send-email-chao@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, viro@zeniv.linux.org.uk, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Chao Yu <yuchao0@huawei.com>
To: Chao Yu <chao@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41566 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbcGEUQe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Jul 2016 16:16:34 -0400
Content-Disposition: inline
In-Reply-To: <1463411798-2597-1-git-send-email-chao@kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 16, 2016 at 11:16:38PM +0800, Chao Yu wrote:
> From: Chao Yu <yuchao0@huawei.com>
> 
> register_shrinker in mb_cache_create may fail due to no memory. This
> patch fixes to do the check of return value of register_shrinker and
> handle the error case, otherwise mb_cache_create may return with no
> error, but losing the inner shrinker.
> 
> Signed-off-by: Chao Yu <yuchao0@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Applied, thanks.  (Apologies for the delay; this patch slipped through
the cracks.)

					- Ted
