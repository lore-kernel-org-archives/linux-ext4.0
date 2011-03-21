From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add FITRIM to compat_ioctl.
Date: Sun, 20 Mar 2011 23:18:15 -0400
Message-ID: <20110321031815.GG4135@thunk.org>
References: <1299139117-4336-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36955 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab1CUDSU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Mar 2011 23:18:20 -0400
Content-Disposition: inline
In-Reply-To: <1299139117-4336-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 03, 2011 at 03:58:37PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> FITRIM isn't added in compat_ioctl. So a 32 bit program can't be executed
> in a 64 bit platform. Add it in the compat_ioctl.
> 
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Thanks, added to the ext4 patch queue.

					- Ted
