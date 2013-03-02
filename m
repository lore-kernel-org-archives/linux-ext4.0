From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix a warning from sparse check for ext4_dir_llseek
Date: Sat, 2 Mar 2013 17:25:01 -0500
Message-ID: <20130302222501.GE22941@thunk.org>
References: <1361264926-8908-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50963 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab3CBWZG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Mar 2013 17:25:06 -0500
Content-Disposition: inline
In-Reply-To: <1361264926-8908-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 19, 2013 at 05:08:46PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> ext4_dir_llseek is only used as a callback function, and no one calls
> it directly.  So make it as a static function in order to remove a
> warning message from sparse check.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Thanks, applied.

					- Ted
