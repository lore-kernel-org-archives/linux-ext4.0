From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: do not reference pa_inode from group_pa
Date: Fri, 10 Feb 2012 20:10:50 -0500
Message-ID: <20120211011050.GA10370@thunk.org>
References: <20120208033950.GA20491@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "stable@kernel.org" <stable@kernel.org>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38873 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491Ab2BKBK4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Feb 2012 20:10:56 -0500
Content-Disposition: inline
In-Reply-To: <20120208033950.GA20491@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 08, 2012 at 11:39:50AM +0800, Wu Fengguang wrote:
> commit 60e07cf515e541ea3e13b888d273c9b19a2ad9dd upstream.
> 
> From: Yongqiang Yang <xiaoqiangnk@gmail.com>
> 
> pa_inode in group_pa is set NULL in ext4_mb_new_group_pa, so
> pa_inode should be not referenced.
> 
> Reported-by: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

I agree this should go into the stable kernel; it was an oversight
that I didn't add a cc: stable@vger.kernel.org

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

							- Ted
