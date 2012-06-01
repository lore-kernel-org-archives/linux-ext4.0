From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: use kmem_cache_zalloc wrapper instead of flag
Date: Fri, 1 Jun 2012 00:13:44 -0400
Message-ID: <20120601041344.GF7897@thunk.org>
References: <1337606388-19105-1-git-send-email-gaowanlong@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46894 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab2FAENr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Jun 2012 00:13:47 -0400
Content-Disposition: inline
In-Reply-To: <1337606388-19105-1-git-send-email-gaowanlong@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 21, 2012 at 09:19:48PM +0800, Wanlong Gao wrote:
> Use kmem_cache_zalloc wrapper instead of flag __GFP_ZERO.
> 
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>

Applied, thanks.

					- Ted
