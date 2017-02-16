From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] debugfs: with ls -l, include space between size and date
Date: Thu, 16 Feb 2017 11:31:22 -0500
Message-ID: <20170216163122.vtoh7annc5bijn6v@thunk.org>
References: <20170213000140.14250-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39344 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932358AbdBPQb3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 16 Feb 2017 11:31:29 -0500
Content-Disposition: inline
In-Reply-To: <20170213000140.14250-1-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 12, 2017 at 04:01:40PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Before:
>      11   40700 (2)      0      0   1228812-Feb-2017 12:51 lost+found
> 
> After:
>      11   40700 (2)      0      0   12288 12-Feb-2017 12:51 lost+found
> 
> Fixes: 68a1de3df340 ("debugfs: pretty print encrypted filenames in the ls command")
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

							- Ted
