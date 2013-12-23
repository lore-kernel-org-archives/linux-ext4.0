From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tests: delete temporary resize test files
Date: Mon, 23 Dec 2013 16:02:31 -0500
Message-ID: <20131223210231.GA11299@thunk.org>
References: <1387261599-24122-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42878 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab3LWVOz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Dec 2013 16:14:55 -0500
Content-Disposition: inline
In-Reply-To: <1387261599-24122-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 16, 2013 at 11:26:39PM -0700, Andreas Dilger wrote:
> Since commit 5ad07acad if $TMP cannot hold large test filesystems
> for resize testing the resize_test creates temporary test files
> in the local working directory.  Since it overrides TMPFILE locally
> the calling program does not delete the generated file correctly.
> 
> Delete the large $TMPFILE within resize_test if it passes, but leave
> it for debugging if the test failed.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

					- Ted
