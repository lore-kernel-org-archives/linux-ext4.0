From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] mke2fs: indicate bigalloc feature explicity when
 cluster-size is enabled
Date: Mon, 14 Jan 2013 15:28:00 -0500
Message-ID: <20130114202800.GA8049@thunk.org>
References: <1358068095-9034-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43325 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758692Ab3ANU2F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jan 2013 15:28:05 -0500
Content-Disposition: inline
In-Reply-To: <1358068095-9034-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 13, 2013 at 05:08:13PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> When cluster-size is enabled without bigalloc feature, mke2fs will ignore this
> argument silently.  But user might think bigalloc feature has been enabled
> unless they use 'stats' command to check it in debugfs.  So now we ask user
> to set bigalloc feature explicity when cluster-size is enabled.  This can
> make sure that users understand what they are doing because bigalloc might
> impact the performance for some workloads.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Thanks, applied.

						- Ted
