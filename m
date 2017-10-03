From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Use symbolic constants for well-known pow 2 sizes
Date: Tue, 3 Oct 2017 12:17:14 -0400
Message-ID: <20171003161714.w6axjxymb45mwno5@thunk.org>
References: <20171003070000.GA5162@lvzheng-thinkpad>
 <26a209c0-384f-9646-9700-adb48c83eac3@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Lv <lv.zheng.2015@gmail.com>, linux-ext4@vger.kernel.org
To: Nikolay Borisov <nborisov@suse.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58698 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751124AbdJCQRR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 3 Oct 2017 12:17:17 -0400
Content-Disposition: inline
In-Reply-To: <26a209c0-384f-9646-9700-adb48c83eac3@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 03, 2017 at 12:31:45PM +0300, Nikolay Borisov wrote:
> 
> 
> On  3.10.2017 10:00, Zheng Lv wrote:
> >> No functional changes, just makes the code a bit more readable. Also fix 1
> >> trailing whitespace
> > 
> > I don't think so.
> > 
> > AFAIK, SZ_16 is just 16, not (16 * 1024). XXX * 1024 should be replaced with
> > SZ_XXXk rather than SZ_XXX.
> 
> True, I meant kilobytes and not bytes, so my bad. THe patch is buggy
> will redo it and resend. Thanks for spotting it.

The symbolic constants don't also seem to add much in terms of
readability, at least to my view....

				- Ted
