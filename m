From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] E2fsprogs/filefrag: fix filefrag regression
Date: Sat, 28 Jul 2012 17:34:31 -0400
Message-ID: <20120728213431.GF659@thunk.org>
References: <1339663486-5417-1-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41839 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab2G1Vee (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Jul 2012 17:34:34 -0400
Content-Disposition: inline
In-Reply-To: <1339663486-5417-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 14, 2012 at 04:44:46PM +0800, Liu Bo wrote:
> filefrag has several bugs
> ...
> All of these bugs come from the fact that we've made a mistake on calculating
> total extents:
> o   we set 1 as default for 'total extents', and this will report 1 extent found
>     even when we don't get any extent from fiemap.
> o   if our first extent does not start from 0(logical addr), total extents will
>     be one more than what it should be.
> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>

Thanks, applied.

						- Ted
