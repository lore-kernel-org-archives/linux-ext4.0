From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] Don't report uninit extents past EOF invalid
Date: Mon, 9 Sep 2013 10:53:41 -0400
Message-ID: <20130909145341.GI6059@thunk.org>
References: <20130814183007.GB2602@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57041 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434Ab3IIOxo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Sep 2013 10:53:44 -0400
Content-Disposition: inline
In-Reply-To: <20130814183007.GB2602@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 14, 2013 at 02:30:07PM -0400, Eric Whitney wrote:
> Commit d3f32c2db8 introduced a regression that caused e2fsck failures
> in xfstests generic 013, 070, 083, 091, and 263.  Uninitialized
> extents created by fallocate() at the end of file with the
> FALLOC_FL_KEEP_SIZE flag were identified as invalid.  However,
> because the file size is not increased when FALLOC_FL_KEEP_SIZE is
> used, uninitialized extents can correctly contain blocks located past
> the end of file.
> 
> Fix this by filtering out possible invalid extents if they are
> uninitialized and extend past the block containing the end of file.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Applied, thanks.

					- Ted
