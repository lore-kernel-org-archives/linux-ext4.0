From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] debugfs: fix range mode of freei
Date: Wed, 4 Dec 2013 21:55:46 -0500
Message-ID: <20131205025546.GB11653@thunk.org>
References: <1386116071-4592-1-git-send-email-solo@primarydata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lev Solomonov <solo@primarydata.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36678 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756533Ab3LECzt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Dec 2013 21:55:49 -0500
Content-Disposition: inline
In-Reply-To: <1386116071-4592-1-git-send-email-solo@primarydata.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 04, 2013 at 02:14:31AM +0200, Lev Solomonov wrote:
> commit 2ae5d1fdb82b31bf270c4699c59a087c846db2f0 was supposed to teach
> 'seti' and 'freei' to act on a range of consecutive inodes. apparently
> only 'seti' has learned: 'freei' doesn't advance the ino, repeatedly
> acting on the same one instead.
> 
> Signed-off-by: Lev Solomonov <solo@primarydata.com>

Applied, thanks.

					- Ted
