From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fscrypt: correct collision claim for digested names
Date: Thu, 4 May 2017 10:55:16 -0400
Message-ID: <20170504145516.7vwyb3f44iz7njly@thunk.org>
References: <20170501184332.37532-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fscrypt@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Gwendal Grignou <gwendal@chromium.org>, hashimoto@chromium.org,
        kinaba@chromium.org, Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47470 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752691AbdEDOzb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 4 May 2017 10:55:31 -0400
Content-Disposition: inline
In-Reply-To: <20170501184332.37532-1-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 01, 2017 at 11:43:32AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> As I noted on the mailing list, it's easier than I originally thought to
> create intentional collisions in the digested names.  Unfortunately it's
> not too easy to solve this, so for now just fix the comment to not lie.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied, thanks.

					- Ted
