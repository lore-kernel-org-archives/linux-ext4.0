From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: save goal group and offset in struct
 ext4_allocation_context.ac_g_ex
Date: Tue, 29 Jul 2014 09:58:19 -0400
Message-ID: <20140729135819.GA2256@thunk.org>
References: <1406108861-2581-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@dilger.ca, lczerner@redhat.com
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34403 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697AbaG2N6c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jul 2014 09:58:32 -0400
Content-Disposition: inline
In-Reply-To: <1406108861-2581-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 23, 2014 at 05:47:41PM +0800, Xiaoguang Wang wrote:
> In ext4_mb_normalize_request(), if ac_g_ex.fe_logical is adjacent to the closest logical
> allocated block to the left or (ac_g_ex.fe_logical+len) adjacent to the closest logical
> allocated block to the right, we'll attach EXT4_MB_HINT_TRY_GOAL flag taking the physical
> block (ext4_allocation_request.lleft+1) or (ext4_allocation_request.pright-len) as a goal,
> and put this information in ext4_allocation_context.ac_f_ex.
> 
> But look at the ext4_mb_find_by_goal(), indeed it use ac_g_ex to look up, so this is wrong,
> we should save goal group and offset in struct ext4_allocation_context.ac_g_ex.
> 
> Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>

Nice catch!

Thanks, applied.

					- Ted
