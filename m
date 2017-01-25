From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] mke2fs: enable large directroy support
Date: Wed, 25 Jan 2017 15:31:21 -0500
Message-ID: <20170125203121.s2o4cskgmruvjnrt@thunk.org>
References: <CAO3qy=F_CxQQ0bUtOm5CZbE0QQ78vyviMStOgg8nryUZZymung@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Artem Blagodarenko <artem.blagodarenko@seagate.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52554 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751555AbdAYUb0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 25 Jan 2017 15:31:26 -0500
Content-Disposition: inline
In-Reply-To: <CAO3qy=F_CxQQ0bUtOm5CZbE0QQ78vyviMStOgg8nryUZZymung@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 24, 2017 at 07:34:13PM +0300, Artem Blagodarenko wrote:
> The INCOMPAT_LARGEDIR feature allows larger directories to
> be created, both with directory sizes over 2GB and and a
> maximum htree depth of 3 instead of the current limit of 2.
> These features are needed in order to exceed the currently
> limit of approximately 10M entries in a single directory.
> 
> debugfs, e2fsck, ext2fs, mke2fs and tune2fs support is
> added.
> 
> Signed-off-by: Alexey Lyashkov <alexey.lyashkov@seagate.com>
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>

Where are the kernel-side changes for this feature?

And could you *please* use git send-email's --chain-reply-to option,
or set the sendemail.chainReplyTo in your git config.  (Or if you're
not using git send-email, send the e-mail using that format).

It makes it much easier to figure out which patch goes with which
other patch in a patch series, especially when you start sending
revised versions of the patches.

					- Ted
