From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix a syntax error in ext4_ext_insert_extent
Date: Tue, 1 Nov 2011 18:57:59 -0400
Message-ID: <20111101225759.GI32161@thunk.org>
References: <1320119200-21741-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43907 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865Ab1KAW57 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Nov 2011 18:57:59 -0400
Content-Disposition: inline
In-Reply-To: <1320119200-21741-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 01, 2011 at 11:46:40AM +0800, Yongqiang Yang wrote:
> This patch fixes a syntax error which omits a comma. Besides this,
> logical block number is unsigend 32 bits, so printk should use %u
> instead %d.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Thanks, applied.

					- Ted
