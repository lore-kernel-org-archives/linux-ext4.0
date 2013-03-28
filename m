From: Zach Brown <zab@redhat.com>
Subject: Re: [PATCH 1/2] ext4: Return proper offset for '..' if inline_data
 enabled.
Date: Thu, 28 Mar 2013 11:33:32 -0700
Message-ID: <20130328183332.GE16651@lenny.home.zabbo.net>
References: <1364466899-5599-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab3C1Sdf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Mar 2013 14:33:35 -0400
Content-Disposition: inline
In-Reply-To: <1364466899-5599-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 28, 2013 at 06:34:58PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> Zach reported a problem that if inline data is enabled, we don't
> tell the difference between the offset of '.' and '..'. And a
> getdents will fail if the user only want to get '.'.
> 
> This patch adds a new offset EXT4_INLINE_DOTDOT_OFFSET which
> indicates the offset of inline "..", and now 0 is for the "."
> and EXT4_INLINE_DOTDOT_OFFSET is for "..".

Yeah, this fixes the problem.  I confirmed that my little test that got
a single dirent from getdents() now properly sees . and .. and exits
rather than spinning.

Tested-by: Zach Brown <zab@redhat.com>

>  
> +			if (filp->f_pos == EXT4_INLINE_DOTDOT_OFFSET) {
>  				error = filldir(dirent, "..", 2, 0, parent_ino,
>  						DT_DIR);
>  				if (error)
> -- 
> 1.7.0.4

Though I think you should change the fourth argument (offset) of the
second flildir() from 0 to EXT4_INLINE_DOTDOT_OFFSET.

- z
