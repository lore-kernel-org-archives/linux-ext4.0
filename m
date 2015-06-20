From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tests: skip large filesystem tests on MacOS
Date: Fri, 19 Jun 2015 21:31:43 -0400
Message-ID: <20150620013143.GA29480@thunk.org>
References: <1432334358-6035-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46024 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535AbbFTBbr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Jun 2015 21:31:47 -0400
Content-Disposition: inline
In-Reply-To: <1432334358-6035-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 22, 2015 at 04:39:18PM -0600, Andreas Dilger wrote:
> Skip tests that create large filesystem on MacOS, since HFS doesn't
> have sparse file support and this causes testing to be uninterruptible
> for minutes while mke2fs is writing to some large non-zero offset and
> filling up the test filesystem.  Since most testing is done on Linux
> this shouldn't cause a significant gap in testing coverage.
> 
> Tests skipped are d_dumpe2fs_group_only, m_bigjournal, m_hugefile,
> t_iexpand_full, t_iexpand_mcsum, and t_uninit_bg_rm.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Applied, thanks.

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
