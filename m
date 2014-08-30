From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove a duplicate call in ext4_init_new_dir()
Date: Fri, 29 Aug 2014 23:23:36 -0400
Message-ID: <20140830032336.GA8974@thunk.org>
References: <1407856709-18612-1-git-send-email-wangshilong1991@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56707 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbaH3DXk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Aug 2014 23:23:40 -0400
Content-Disposition: inline
In-Reply-To: <1407856709-18612-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 12, 2014 at 11:18:29PM +0800, Wang Shilong wrote:
> From: Wang Shilong <wshilong@ddn.com>
> 
> ext4_journal_get_write_access() has just been called in ext4_append()
> calling it again here is duplicated.
> 
> Signed-off-by: Wang Shilong <wshilong@ddn.com>

Thanks, applied.

					- Ted
