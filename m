From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tests: don't leave temporary files at end of test
Date: Sun, 15 Oct 2017 16:22:45 -0400
Message-ID: <20171015202245.xl7zbk6cf3duiaqx@thunk.org>
References: <1507675192-70000-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49076 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751337AbdJOUWr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 15 Oct 2017 16:22:47 -0400
Content-Disposition: inline
In-Reply-To: <1507675192-70000-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 10, 2017 at 04:39:52PM -0600, Andreas Dilger wrote:
> Don't leave temp files around after test has completed successfully.
> Some test scripts were creating their own temporary files, and in
> some cases test_one was skipping a test completely (e.g. slow) after
> the temp file had been created.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.  I fixed up two more tests (d_inline_dump and
f_mke2fs_baddisk) which could leave behind a temp file if the tests
are skipped in a separate commit.

						- Ted
