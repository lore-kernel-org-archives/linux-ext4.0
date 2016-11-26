From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fscrypto: remove unneeded Kconfig dependencies
Date: Sat, 26 Nov 2016 15:10:56 -0500
Message-ID: <20161126201056.yxuuzbl4vdrnme64@thunk.org>
References: <1477340226-144248-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, jaegeuk@kernel.org,
        richard@nod.at
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57910 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752431AbcKZULE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 26 Nov 2016 15:11:04 -0500
Content-Disposition: inline
In-Reply-To: <1477340226-144248-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 24, 2016 at 01:17:06PM -0700, Eric Biggers wrote:
> SHA256 and ENCRYPTED_KEYS are not needed.  CTR shouldn't be needed
> either, but I left it for now because it was intentionally added by
> commit 71dea01ea2ed ("ext4 crypto: require CONFIG_CRYPTO_CTR if ext4
> encryption is enabled").  So it sounds like there may be a dependency
> problem elsewhere, which I have not been able to identify specifically,
> that must be solved before CTR can be removed.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied, thanks.

				- Ted
