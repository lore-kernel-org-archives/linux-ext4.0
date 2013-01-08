From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: check extents feature when bigalloc feature is
 enabled
Date: Tue, 8 Jan 2013 10:36:01 -0500
Message-ID: <20130108153601.GE27837@thunk.org>
References: <1357475117-5095-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42333 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756659Ab3AHPgG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jan 2013 10:36:06 -0500
Content-Disposition: inline
In-Reply-To: <1357475117-5095-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 06, 2013 at 08:25:17PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> When bigalloc feature is enabled in mkfs, extents feature also needs to be
> enabled.  But now when bigalloc feature is enabled without extents feature,
> users will not get any warning messages until they try to mount this file
> system.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Thanks, applied.

					- Ted
