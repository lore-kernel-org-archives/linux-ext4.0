From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: remove redundant goto tag "repeat"
Date: Mon, 11 Jul 2011 11:45:32 -0400
Message-ID: <20110711154532.GL28763@thunk.org>
References: <1309421014-6148-1-git-send-email-sanbai@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45037 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab1GKPpg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jul 2011 11:45:36 -0400
Content-Disposition: inline
In-Reply-To: <1309421014-6148-1-git-send-email-sanbai@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 30, 2011 at 04:03:33PM +0800, Robin Dong wrote:
> If eh->eh_entries is smaller than eh->eh_max, the routine will
> go to the "repeat" and then go to "has_space" directlly ,
> since argument "depth" and "eh" are not even changed.
> 
> Therefore, goto "has_space" directly and remove redundant "repeat" tag.
> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>

Thanks, added to the ext4 tree.

					- Ted
