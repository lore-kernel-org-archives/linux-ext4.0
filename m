From: tytso@mit.edu
Subject: Re: [PATCH 6/6] ext4: remove unused #include <linux/version.h>
Date: Mon, 14 Dec 2009 09:26:06 -0500
Message-ID: <20091214142606.GA8905@thunk.org>
References: <1260713198-1652-1-git-send-email-weiyi.huang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Huang Weiyi <weiyi.huang@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41624 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757424AbZLNO0K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Dec 2009 09:26:10 -0500
Content-Disposition: inline
In-Reply-To: <1260713198-1652-1-git-send-email-weiyi.huang@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 13, 2009 at 10:06:38PM +0800, Huang Weiyi wrote:
> Remove unused #include <linux/version.h>('s) in
>   fs/ext4/block_validity.c
> 
> Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
> ---
>  fs/ext4/block_validity.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)

I was a tiny bit confused about why the subject line was 6/6; I assume
there were other related patches for different subsystems for patches
1-5?

I noticed that there was also an unused version.h #include'd in
fs/ext4/mballoc.h which I also removed at the same time.

Applied to the ext4 patch queue, thanks.

						- Ted
