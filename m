From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Init timer earlier to avoid a kernel panic in
 __save_error_info.
Date: Tue, 5 Apr 2011 19:58:11 -0400
Message-ID: <20110405235811.GK2832@thunk.org>
References: <1301371872-7097-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sliedes@cc.hut.fi
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43593 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab1DEX6P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Apr 2011 19:58:15 -0400
Content-Disposition: inline
In-Reply-To: <1301371872-7097-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 29, 2011 at 12:11:12PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> During mount, when we fail to open journal inode or root inode, the
> __save_error_info will mod_timer. But actually s_err_report isn't
> initialized yet and the kernel oops. The detailed information can
> be found https://bugzilla.kernel.org/show_bug.cgi?id=32082.
> 
> The best way is to check whether the timer s_err_report is initialized
> or not. But it seems that in include/linux/timer.h, we can't find a
> good function to check the status of this timer, so this patch just
> move the initializtion of s_err_report earlier so that we can avoid
> the kernel panic. The corresponding del_timer is also added in the
> error path.
> 
> Reported-by: Sami Liedes <sliedes@cc.hut.fi>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Thanks, I've added this patch to the ext4 patch queue.

	     	   	      	     - Ted
