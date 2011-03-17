From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [PATCH] ext4: critical info format fix in
 __ext4_grp_locked_error
Date: Wed, 16 Mar 2011 19:08:33 -0700
Message-ID: <20110317020833.GA2344@kroah.com>
References: <1300326991-22794-1-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>,
	stable@kernel.org
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:54531 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714Ab1CQCHp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Mar 2011 22:07:45 -0400
Content-Disposition: inline
In-Reply-To: <1300326991-22794-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 17, 2011 at 09:56:31AM +0800, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> When we do performence-testing on ext4 filesystem, we observe a warning like this:
> 
> "[ 1684.113205] EXT4-fs error (device sda7): ext4_mb_generate_buddy:718: group 259825901 blocks in bitmap, 26057 in gd"
> 
> indeed, it should be
> 
> "group 2598, 25901 blocks in bitmap, 26057 in gd"
> 
> Reviewed-by: Coly Li <bosong.ly@taobao.com>
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> ---

<formletter>

This is not how you get a patch applied to the stable tree.  Please read
Documentation/stable_kernel_rules.txt for how to properly do this.

thanks,

greg k-h

</formletter>
