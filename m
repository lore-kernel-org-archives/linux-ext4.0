From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/5] ext4: fix trim length underflow with small trim
 length.
Date: Mon, 11 Jul 2011 00:06:45 -0400
Message-ID: <20110711040645.GE28763@thunk.org>
References: <4E0DE63A.7030103@tao.ma>
 <1309534076-2784-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55470 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab1GKEGu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jul 2011 00:06:50 -0400
Content-Disposition: inline
In-Reply-To: <1309534076-2784-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 01, 2011 at 11:27:52PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In 0f0a25b, we adjust 'len' with s_first_data_block - start, but
> it could underflow in case blocksize=1K, fstrim_range.len=512 and
> fstrim_range.start = 0. In this case, when we run the code:
> len -= first_data_blk - start; len will be underflow to -1ULL.
> In the end, although we are safe that last_group check later will limit
> the trim to the whole volume, but that isn't what the user really want.
> 
> So this patch fix it. It also adds the check for 'start' like ext3 so that
> we can break immediately if the start is invalid.
> 
> Cc: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Added to the ext4 tree, thanks.

							- Ted
