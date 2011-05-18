From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Don't warn about mnt_count after the first mount
 of a new mkfsed volume.
Date: Wed, 18 May 2011 13:33:17 -0400
Message-ID: <20110518173317.GG29368@thunk.org>
References: <1305557603-4596-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:32865 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933344Ab1ERRdU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2011 13:33:20 -0400
Content-Disposition: inline
In-Reply-To: <1305557603-4596-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 16, 2011 at 10:53:23PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> Currently, if we mkfs a new ext4 volume and mount it for the first time,
> we will get the warning in the message like
> warning: maximal mount count reached, running e2fsck is recommended
> 
> It is really misleading. So change the check so that it wouldn't warn in that case.
> 
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Added to the ext4 tree, thanks!

						- Ted
