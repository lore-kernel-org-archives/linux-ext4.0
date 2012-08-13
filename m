From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [2/2] ext4: remove unused function argument 'order' in
 mb_find_extent()
Date: Mon, 13 Aug 2012 10:01:22 -0400
Message-ID: <20120813140122.GB13521@thunk.org>
References: <1334298657-20408-2-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44398 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144Ab2HMOBX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Aug 2012 10:01:23 -0400
Content-Disposition: inline
In-Reply-To: <1334298657-20408-2-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 12, 2012 at 08:30:57PM -0000, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> All the routines call mb_find_extent are setting argument 'order' to 0 just like:
> 
> 	mb_find_extent(e4b, 0, ex.fe_start, ex.fe_len, &ex);
> 
> therefore the useless argument should be removed.
> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>

Applied, thanks.

					- Ted
