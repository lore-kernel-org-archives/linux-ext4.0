From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix up a undefined error in ext4_free_blocks
Date: Mon, 21 Nov 2011 12:10:17 -0500
Message-ID: <20111121171017.GE14568@thunk.org>
References: <1321160521-12129-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45309 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993Ab1KURKU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Nov 2011 12:10:20 -0500
Content-Disposition: inline
In-Reply-To: <1321160521-12129-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 13, 2011 at 01:02:01PM +0800, Yongqiang Yang wrote:
> sbi is not defined, so let ext4_free_blocks use
> EXT4_SB(sb) instead.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Thanks, applied.

					- Ted
