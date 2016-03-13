From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fix compile error while opening the macro DOUBLE_CHECK
Date: Sun, 13 Mar 2016 17:19:30 -0400
Message-ID: <20160313211930.GF29218@thunk.org>
References: <1448960309-27346-1-git-send-email-zhangaihua1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: zhangaihua1@huawei.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38882 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932122AbcCMVTf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Mar 2016 17:19:35 -0400
Content-Disposition: inline
In-Reply-To: <1448960309-27346-1-git-send-email-zhangaihua1@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 01, 2015 at 04:58:29PM +0800, zhangaihua1@huawei.com wrote:
> From: Aihua Zhang <zhangaihua1@huawei.com>
> 
> the error is:
>     fs/ext4/mballoc.c:475:43: error: 'struct ext4_group_info' has
> no member named 'bb_bitmap'.
>     so, the definition of macro DOUBLE_CHECK should before
> 'struct ext4_group_info', I fixed it, and I moved the macro
> AGGRESSIVE_CHECK together, because I think they shoule be together.
> 
> Signed-off-by: Aihua Zhang <zhangaihua1@huawei.com>

Applied, thanks.  Apologies for the delay.

							- Ted
