From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [4/6] ext4: switch to using fscrypt_match_name()
Date: Sun, 30 Apr 2017 02:21:33 -0400
Message-ID: <20170430062133.4bdf5knrh6e72ist@thunk.org>
References: <20170424170013.85175-5-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fscrypt@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Gwendal Grignou <gwendal@chromium.org>, hashimoto@chromium.org,
        kinaba@chromium.org, Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33976 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161921AbdD3GVg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 30 Apr 2017 02:21:36 -0400
Content-Disposition: inline
In-Reply-To: <20170424170013.85175-5-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 24, 2017 at 10:00:11AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Switch ext4 directory searches to use the fscrypt_match_name() helper
> function.  There should be no functional change.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
