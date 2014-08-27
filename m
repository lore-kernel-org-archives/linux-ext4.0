From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 10/27] e2fsck: fix infinite loop when recovering corrupt
 journal blocks
Date: Tue, 26 Aug 2014 23:45:23 -0400
Message-ID: <20140827034523.GU11317@thunk.org>
References: <20140816234550.11171.61585.stgit@birch.djwong.org>
 <20140816234655.11171.49022.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51081 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472AbaH0Dp0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Aug 2014 23:45:26 -0400
Content-Disposition: inline
In-Reply-To: <20140816234655.11171.49022.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 16, 2014 at 04:46:55PM -0700, Darrick J. Wong wrote:
> When recovering the journal, don't fall into an infinite loop if we
> encounter a corrupt journal block.  Instead, just skip the block and
> proceed with the full filesystem fsck.
> 
> The test case for this will be "j_corrupt_journal_block" further on
> in the patch series.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
