From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 07/54] libext2fs: fix tdb.c mmap leak
Date: Tue, 27 Jan 2015 11:09:37 -0500
Message-ID: <20150127160937.GG2453@thunk.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
 <20150127073618.13308.18272.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35324 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbbA0QJi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2015 11:09:38 -0500
Content-Disposition: inline
In-Reply-To: <20150127073618.13308.18272.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 26, 2015 at 11:36:18PM -0800, Darrick J. Wong wrote:
> When undoing an expansion of an mmap'd database while cancelling a
> transaction, the tdb code prematurely decreases the variable that
> tracks the file size, which leads to a region leak during the
> subsequent unmap.  Fix this by maintaining a separate counter for the
> region size.
> 
> (This is probably unnecessary since e2undo was the only user of tdb
> transactions, but I suppose we could be proactive.)
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
