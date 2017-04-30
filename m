From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [6/6] ext4: clean up ext4_match() and callers
Date: Sun, 30 Apr 2017 02:22:06 -0400
Message-ID: <20170430062206.o2mi4r4pwe6dq3wt@thunk.org>
References: <20170424170013.85175-7-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fscrypt@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Gwendal Grignou <gwendal@chromium.org>, hashimoto@chromium.org,
        kinaba@chromium.org, Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34020 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161921AbdD3GWK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 30 Apr 2017 02:22:10 -0400
Content-Disposition: inline
In-Reply-To: <20170424170013.85175-7-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 24, 2017 at 10:00:13AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When ext4 encryption was originally merged, we were encrypting the
> user-specified filename in ext4_match(), introducing a lot of additional
> complexity into ext4_match() and its callers.  This has since been
> changed to encrypt the filename earlier, so we can remove the gunk
> that's no longer needed.  This more or less reverts ext4_search_dir()
> and ext4_find_dest_de() to the way they were in the v4.0 kernel.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

						- Ted
