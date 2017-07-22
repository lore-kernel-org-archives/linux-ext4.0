From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix dir_nlink behaviour
Date: Sat, 22 Jul 2017 12:49:45 -0400
Message-ID: <20170722164945.77z7bmk3rxbfceym@thunk.org>
References: <1500677367-82142-1-git-send-email-adilger@dilger.ca>
 <59735561.9020305@partition-saving.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
        eggert@cs.ucla.edu
To: Damien Guibouret <damien.guibouret@partition-saving.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50804 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750872AbdGVQtw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 22 Jul 2017 12:49:52 -0400
Content-Disposition: inline
In-Reply-To: <59735561.9020305@partition-saving.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 22, 2017 at 03:38:41PM +0200, Damien Guibouret wrote:
> 
> If you look at vfs layer, vfs_mkdir does the check against max_links with >=
> and so if you reach the value, you will never be able to create a new
> directory even if nlink feature is present. Actually it is not a problem
> because ext4 does not set the s_max_links value in vfs (do not know why as
> ext2 set it perhaps because there is no limit if nlink is set?), but it
> could be some latent bug if someday somebody thinks it could be a good idea
> to set it.

We can't set s_max_links precisely because of the dir_nlinks feature.
So the fact that it is not set today is deliberate, and if someone
thought it was good idea, I and the other ext4 developers would NAK
it.

						- Ted
