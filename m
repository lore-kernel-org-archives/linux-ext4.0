From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: readahead patches
Date: Tue, 28 Feb 2017 10:40:39 -0500
Message-ID: <20170228154039.svqp7spwlvsthifa@thunk.org>
References: <DA5A81CB-4FF8-43C7-AC18-9B3A8F6DEE5B@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44042 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751441AbdB1QGc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 28 Feb 2017 11:06:32 -0500
Content-Disposition: inline
In-Reply-To: <DA5A81CB-4FF8-43C7-AC18-9B3A8F6DEE5B@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 26, 2017 at 10:01:45PM +0300, Alexey Lyashkov wrote:
> Hi Theodore,
> 
> May i ask you to review an Artem patches against ext4 and e2fsprogs submitted with subject 
> [PATCH] ext4: preload block group descriptors and [PATCH] libext2fs: readahead for meta_bg ?
> 
> These patches dramatically decrease a mount / openfs time. 300T
> volume with meta_bg enabled have a mount() over 300s and debugfs -c
> -R stat was executed over 600s without these patches. With these
> patches mount time decreased to 20s, and debugfs to 12s.

They're on my todo list.  At the moment I'm focusing on bug fixes more
than I am patches that would go into the next merge window, but I have
noted those patches, will look at them once I have a chance.

Cheers,

						- Ted
