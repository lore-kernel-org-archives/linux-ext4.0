From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix mmap data corruption in nodelalloc mode when
 blocksize < pagesize
Date: Thu, 12 Feb 2015 23:01:33 -0500
Message-ID: <20150213040133.GC2268@thunk.org>
References: <1423185183-3032-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39375 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbbBMEBj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Feb 2015 23:01:39 -0500
Content-Disposition: inline
In-Reply-To: <1423185183-3032-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 06, 2015 at 09:13:03AM +0800, Xiaoguang Wang wrote:
> Since commit 90a8020 and d6320cb, Jan Kara has fixed this issue partially.
> This mmap data corruption still exists in nodelalloc mode, fix this.
> 
> Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
> Reviewed-by:   Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
