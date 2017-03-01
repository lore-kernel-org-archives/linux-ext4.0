From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: readahead for meta_bg
Date: Wed, 1 Mar 2017 15:05:26 -0500
Message-ID: <20170301200525.glbundivrfmmopli@thunk.org>
References: <1487585025-16654-1-git-send-email-artem.blagodarenko@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        alexey.lyashkov@gmail.com
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47154 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751157AbdCAUha (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 1 Mar 2017 15:37:30 -0500
Content-Disposition: inline
In-Reply-To: <1487585025-16654-1-git-send-email-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 20, 2017 at 01:03:45PM +0300, Artem Blagodarenko wrote:
> From: Alexey Lyashkov <alexey.lyashkov@seagate.com>
> 
> There are ~37k of random IOs with meta_bg option on 300T target.
> Debugfs requires 20 minutes to be started. Enabling readahead for
> group blocks metadata save time dramatically. Only 12s to start.
> 
> Signed-off-by: Alexey Lyashkov <alexey.lyashkov@seagate.com>

Applied, thanks!

					- Ted
