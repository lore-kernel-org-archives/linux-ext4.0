From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 21/31] libext2fs: Be more thorough in searching a range
 of blocks for a cluster
Date: Tue, 8 Oct 2013 12:09:37 -0400
Message-ID: <20131008160937.GJ17896@thunk.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012856.28415.77322.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43714 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab3JHQJ7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Oct 2013 12:09:59 -0400
Content-Disposition: inline
In-Reply-To: <20131001012856.28415.77322.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 30, 2013 at 06:28:56PM -0700, Darrick J. Wong wrote:
> implied_cluster_alloc() is written such that if the the user passes in a
> logical block that is the zeroth block in a logical cluster (lblk %
> cluster_ratio == 0), then it will assume that there is no physical cluster
> mapped to any other part of the logical cluster.
> 
> This is not true if we happen to be allocating logical blocks in reverse order.
> Therefore, search the whole cluster, except for the lblk that we passed in.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
