From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] ext4: Do not unnecessarily allocate buffer in
 recently_deleted()
Date: Thu, 24 Aug 2017 11:57:17 -0400
Message-ID: <20170824155716.evcftr54z6a3vldg@thunk.org>
References: <20170820115209.56957-1-wshilong@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50562 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751840AbdHXP5T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 24 Aug 2017 11:57:19 -0400
Content-Disposition: inline
In-Reply-To: <20170820115209.56957-1-wshilong@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 20, 2017 at 07:52:09PM +0800, Wang Shilong wrote:
> From: Jan Kara <jack@suse.cz>
> 
> From: Jan Kara <jack@suse.cz>
> 
> In recently_deleted() function we want to check whether inode is still
> cached in buffer cache. Use sb_find_get_block() for that instead of
> sb_getblk() to avoid unnecessary allocation of bdev page and buffer
> heads.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
