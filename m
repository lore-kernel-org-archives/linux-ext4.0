From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix comments in ext4_can_extents_be_merged()
Date: Thu, 2 Apr 2015 16:55:43 -0400
Message-ID: <20150402205543.GD450@thunk.org>
References: <1423048305-11335-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, darrick.wong@oracle.com
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47830 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbbDBUzs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Apr 2015 16:55:48 -0400
Content-Disposition: inline
In-Reply-To: <1423048305-11335-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 04, 2015 at 07:11:45PM +0800, Xiaoguang Wang wrote:
> Since commit 66369e0, we are allowed to merge unwritten extents,
> so here these comments are wrong, remove it.
> 
> Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>

Thanks, applied.

BTW, the commit ID was wrong; I've corrected it to be a9b8241594add.

						- Ted
						
