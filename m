From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: get rid of the duplicate code on ext4_fill_super
Date: Thu, 8 Nov 2012 12:14:17 -0500
Message-ID: <20121108171417.GC19977@thunk.org>
References: <508E30F8.3090606@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Zhao Hongjiang <zhaohongjiang37@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60113 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756680Ab2KHWVE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2012 17:21:04 -0500
Content-Disposition: inline
In-Reply-To: <508E30F8.3090606@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 29, 2012 at 03:32:08PM +0800, Zhao Hongjiang wrote:
> From: Zhao Hongjiang <zhaohongjiang@huawei.com>
> 
> Clean the duplicate code on ext4_fill_super cause the bellow
> also have it.
> 
> Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>

Applied, thanks!

I used the commit description:

     ext4: get rid of redundant code in ext4_fill_super()

     	       	      		     	- Ted
