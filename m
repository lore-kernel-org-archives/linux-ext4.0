From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: let ext4_ext_rm_leaf work with EXT_DEBUG defined
Date: Tue, 1 Nov 2011 19:00:05 -0400
Message-ID: <20111101230005.GJ32161@thunk.org>
References: <1320117866-16571-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dmonakhov@openvz.org, linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43911 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057Ab1KAXAH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Nov 2011 19:00:07 -0400
Content-Disposition: inline
In-Reply-To: <1320117866-16571-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 01, 2011 at 11:24:26AM +0800, Yongqiang Yang wrote:
> Var block is removed by commit 750c9c47, so ex_ee_block is used
> instead.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Thanks, applied.

						- Ted
