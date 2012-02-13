From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] jbd2: use KMEM_CACHE instead of kmem_cache_create
Date: Mon, 13 Feb 2012 17:10:43 -0500
Message-ID: <20120213221043.GD21641@thunk.org>
References: <1321183291-4589-1-git-send-email-xiaoqiangnk@gmail.com>
 <1321183291-4589-3-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36553 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757186Ab2BMWKo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Feb 2012 17:10:44 -0500
Content-Disposition: inline
In-Reply-To: <1321183291-4589-3-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 13, 2011 at 07:21:31PM +0800, Yongqiang Yang wrote:
> This patch lets jbd2 use KMEM_CACHE instead of kmem_cache_create.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Thanks, applied.

					- Ted
