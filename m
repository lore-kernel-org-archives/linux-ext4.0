From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] tune2fs: warn if the filesystem journal is dirty
Date: Mon, 30 Nov 2015 12:14:45 -0500
Message-ID: <20151130171445.GE4316@thunk.org>
References: <1448410059-3691-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jim Garlick <garlick@llnl.gov>,
	Andreas Dilger <andreas.dilger@intel.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57947 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbbK3ROs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Nov 2015 12:14:48 -0500
Content-Disposition: inline
In-Reply-To: <1448410059-3691-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 24, 2015 at 05:07:39PM -0700, Andreas Dilger wrote:
> From: Jim Garlick <garlick@llnl.gov>
> 
> Running tune2fs on a filesystem with an unrecovered journal can
> cause the tune2fs settings changes in the superblock to be reverted
> when the journal is replayed if it contains an uncommitted copy of
> the superblock.  Print a warning if this is detected so that the
> user isn't surprised if it happens.
> 
> Signed-off-by: Jim Garlick <garlick@llnl.gov>
> 
> Updated message printed to include steps to replay journal.
> 
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>

Applied, thanks.

						- Ted
