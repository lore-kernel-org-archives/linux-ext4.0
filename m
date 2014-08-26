From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] jbd2: fix infinite loop when recovering corrupt
 journal blocks
Date: Mon, 25 Aug 2014 22:44:12 -0400
Message-ID: <20140826024412.GF11317@thunk.org>
References: <20140815204346.16444.14064.stgit@birch.djwong.org>
 <20140815204352.16444.79311.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48956 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbaHZCoT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Aug 2014 22:44:19 -0400
Content-Disposition: inline
In-Reply-To: <20140815204352.16444.79311.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 15, 2014 at 01:43:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When recovering the journal, don't fall into an infinite loop if we
> encounter a corrupt journal block.  Instead, just skip the block and
> return an error, which fails the mount and thus forces the user to run
> a full filesystem fsck.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
