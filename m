From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] contrib: print missing '-p' argument in fallocate.c
Date: Thu, 24 Jan 2013 23:28:25 -0500
Message-ID: <20130125042825.GI28908@thunk.org>
References: <1359085459-15711-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45404 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892Ab3AYE22 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jan 2013 23:28:28 -0500
Content-Disposition: inline
In-Reply-To: <1359085459-15711-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 25, 2013 at 11:44:19AM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> In fallocate.c it has supported hole punching, but '-p' argument does
> not be printed in usage.  So fix it to let the user know it.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Thanks, applied.

					- Ted
