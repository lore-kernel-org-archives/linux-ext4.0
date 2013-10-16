From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: clarify inode ratio in man page
Date: Tue, 15 Oct 2013 23:38:47 -0400
Message-ID: <20131016033847.GF28823@thunk.org>
References: <1381156782-31422-1-git-send-email-psusi@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46675 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874Ab3JPDit (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Oct 2013 23:38:49 -0400
Content-Disposition: inline
In-Reply-To: <1381156782-31422-1-git-send-email-psusi@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 07, 2013 at 10:39:42AM -0400, Phillip Susi wrote:
> The man page still said it was not possible to change the number
> of inodes on a filesystem after creating it.  You actually can
> by resizing the fs, so clarify this language a bit.

You didn't include a signed-off-by, but this was a simple enough
documentation-only change that I've used by discretion to accept it.

Cheers,

					- Ted
