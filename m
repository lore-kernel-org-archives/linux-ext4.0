From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: use strlcpy() instead of strncpy()
Date: Tue, 9 Jan 2018 15:20:03 -0500
Message-ID: <20180109202003.GC5389@thunk.org>
References: <1515488319-23779-1-git-send-email-wangxiongfeng2@huawei.com>
 <20180109100655.bdbnsrvhceaimaxh@quack2.suse.cz>
 <eae3c8fd-d778-fa65-4609-5159a1a3b405@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, arnd@arndb.de
To: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55832 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752381AbeAIUUJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 9 Jan 2018 15:20:09 -0500
Content-Disposition: inline
In-Reply-To: <eae3c8fd-d778-fa65-4609-5159a1a3b405@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 09, 2018 at 07:14:36PM +0800, Xiongfeng Wang wrote:
> 
> Sorry, I didn't notice how s_last_error_func is used before.
> We do waste one character if we use strlcpy() instead of strncpy().
> We can't use memcpy() either. But I can't  figure out a better way to avoid
> this warning.

Compain to the GCC developers?   Create scripts that filter out crap?

What's important is code correctness, not eliminating warnings,
especially if the warnings are bogus.  Sacrificing code performance or
correctness just for the sake of silencing warnings is just silly....

About all I'm willing to do here is to take a patch which adds a
comment saying, "ignore bogus GCC warning on this line".

						- Ted
