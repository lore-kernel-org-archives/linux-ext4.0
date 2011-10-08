From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Remove the obsolete broken
 EXT4_IOC32_WAIT_FOR_READONLY.
Date: Sat, 8 Oct 2011 15:57:24 -0400
Message-ID: <20111008195724.GI7948@thunk.org>
References: <1318001428-3108-1-git-send-email-tm@tao.ma>
 <1318001428-3108-2-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53830 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab1JHT5X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 15:57:23 -0400
Content-Disposition: inline
In-Reply-To: <1318001428-3108-2-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 07, 2011 at 11:30:27PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> There are no user of EXT4_IOC32_WAIT_FOR_READONLY and also it is
> broken. No one set the set_ro_timer, no one wake up us and our
> state is set to TASK_INTERRUPTIBLE not RUNNING. So remove it.
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Applied, thanks.  I adjusted the commit description a little and
removed the #define for EXT4_IOC_WAIT_FOR_READONLY which you missed in
your patch.

						- Ted
