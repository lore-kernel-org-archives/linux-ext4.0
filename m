From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 02/34] e2fsck: fix sliding the directory block down on
 bigalloc
Date: Thu, 18 Sep 2014 21:45:37 -0400
Message-ID: <20140919014537.GE26995@thunk.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
 <20140913221125.13646.11024.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36689 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbaISBpj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Sep 2014 21:45:39 -0400
Content-Disposition: inline
In-Reply-To: <20140913221125.13646.11024.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 13, 2014 at 03:11:25PM -0700, Darrick J. Wong wrote:
> If we find a hole in a directory on a bigalloc filesystem, we need to
> obey the cluster alignment rules when collapsing the gap to avoid
> later complaints.
> 
> Specifically, the calculation of the new logical cluster number was
> incorrect, and we need to ensure that the logical cluster alignment
> respects the physical cluster alignment, since we've concluded that
> the extent's logical block number is wrong.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
