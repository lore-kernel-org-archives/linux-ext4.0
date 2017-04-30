From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [3/6] fscrypt: introduce helper function for filename matching
Date: Sun, 30 Apr 2017 02:20:44 -0400
Message-ID: <20170430062044.ot34sdj7p4kc2x2a@thunk.org>
References: <20170424170013.85175-4-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fscrypt@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Gwendal Grignou <gwendal@chromium.org>, hashimoto@chromium.org,
        kinaba@chromium.org, Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33954 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1165770AbdD3GUr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 30 Apr 2017 02:20:47 -0400
Content-Disposition: inline
In-Reply-To: <20170424170013.85175-4-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 24, 2017 at 10:00:10AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Introduce a helper function fscrypt_match_name() which tests whether a
> fscrypt_name matches a directory entry.  Also clean up the magic numbers
> and document things properly.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
