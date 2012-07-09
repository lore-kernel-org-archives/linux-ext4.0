From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [v2] ext4: change a comment on fs/ext4/extents.c
Date: Mon, 9 Jul 2012 10:21:20 -0400
Message-ID: <20120709142120.GA5589@thunk.org>
References: <4fe32049.28d5440a.3265.ffffb61a@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Liu Haibo <haiboliu6@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38008 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab2GIOVW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jul 2012 10:21:22 -0400
Content-Disposition: inline
In-Reply-To: <4fe32049.28d5440a.3265.ffffb61a@mx.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 21, 2012 at 03:23:14AM -0000, Liu Haibo wrote:
> From: HaiboLiu <HaiboLiu6@gmail.com>
> 
> In this patch, ext4_ext_try_to_merge has been change to merge 
> an extent both left and right. So we need to update the comment
> in here.
> 
> v1->v2: update the subject and the patch comment.
> 
> Signed-off-by: HaiboLiu <HaiboLiu6@gmail.com>

Applied, thanks.

BTW, in the future, it's better to put the v1-v2 log after the "---"
separator.

					- Ted
