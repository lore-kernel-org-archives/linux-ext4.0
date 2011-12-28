From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/5] ext4: allocate delalloc blocks before changing
 journal mode
Date: Wed, 28 Dec 2011 12:14:24 -0500
Message-ID: <20111228171424.GA12370@thunk.org>
References: <1321344474-14707-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42194 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812Ab1L1ROi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Dec 2011 12:14:38 -0500
Content-Disposition: inline
In-Reply-To: <1321344474-14707-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 15, 2011 at 04:07:50PM +0800, Yongqiang Yang wrote:
> delalloc blocks should be allocated before changing journal mode,
> otherwise they can not be allocated and even more truncate on
> delalloc blocks could triggre BUG by flushing delalloc buffers.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Applied, thanks.

					- Ted
