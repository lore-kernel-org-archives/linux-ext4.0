From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 04/25] libext2fs: write_journal_inode should check
 iterate return value
Date: Thu, 11 Sep 2014 12:43:35 -0400
Message-ID: <20140911164335.GL26178@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140908231202.25904.82920.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51453 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154AbaIKQng (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 12:43:36 -0400
Content-Disposition: inline
In-Reply-To: <20140908231202.25904.82920.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2014 at 04:12:02PM -0700, Darrick J. Wong wrote:
> When creating a journal inode, check the return value from
> block_iterate3() because otherwise we fail to capture errors such as
> being unable to allocate an extent tree block, which leads to e2fsck
> creating broken journals.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
