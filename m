From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: issue WARN_ON_ONCE() if page gets truncated in
 ext4_write_[da_]begin()
Date: Sun, 17 May 2015 13:51:18 -0400
Message-ID: <20150517175118.GI4489@thunk.org>
References: <1430990243-8568-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41290 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbbEQRvU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 May 2015 13:51:20 -0400
Content-Disposition: inline
In-Reply-To: <1430990243-8568-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 07, 2015 at 05:17:23PM +0800, Xiaoguang Wang wrote:
> In ext4_write_[da_]begin(), when we get a page successfully by calling
> grab_cache_page_write_begin(), then unless this page is truncated by
> ext4_truncate_failed_write(), which is called when ext4_write_[da_]begin()
> run into some errors, otherwise I think this page won't be truncated by
> other kernel path because we're holding i_mutex.
> 
> In this patch, if page is truncated by ext4_truncate_failed_write(), then
> we just put it and call grab_cache_page_write_begin() again to get a new
> page, then this check 'if (page->mapping != mapping)' won't be necessary.
> We can remove this check, but according to Jan Kara's suggestion, we issue
> WARN_ON_ONCE() here if page is truncated, that means something is wrong.
> (Thanks to Jan Kara for his help)

It would be helpful if the commit description explained why this
change is a benefit.  There's a very detailed explanation about why
it's safe, but why do we need to release the page only to try again to
grab it by jumping to retry_grab instead of retry_journal?  What
problem are you trying to solve?

Thanks, regards,

					- Ted
