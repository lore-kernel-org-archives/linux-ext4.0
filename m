From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/5] ext4: speed up group trim with the right free
 block count.
Date: Mon, 11 Jul 2011 00:06:58 -0400
Message-ID: <20110711040658.GF28763@thunk.org>
References: <4E0DE63A.7030103@tao.ma>
 <1309534076-2784-1-git-send-email-tm@tao.ma>
 <1309534076-2784-2-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55474 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab1GKEHB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jul 2011 00:07:01 -0400
Content-Disposition: inline
In-Reply-To: <1309534076-2784-2-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 01, 2011 at 11:27:53PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> When we trim some free blocks in a group of ext4, we should
> calculate the free blocks properly and check whether there are
> enough freed blocks left for us to trim. Current solution will
> only calculate free spaces if they are large for a trim which
> isn't appropriate.
> 
> Let us see a small example:
> a group has 1.5M free which are 300k, 300k, 300k, 300k, 300k.
> And minblocks is 1M. With current solution, we have to iterate
> the whole group since these 300k will never be subtracted from
> 1.5M. But actually we should exit after we find the first 2
> free spaces since the left 3 chunks only sum up to 900K if we
> subtract the first 600K although they can't be trimed.
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Added to the ext4 tree, thanks.

					- Ted
