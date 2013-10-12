From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 29/31] e2fsck: Enable extents on all 64bit filesystems
Date: Fri, 11 Oct 2013 21:19:29 -0400
Message-ID: <20131012011929.GC22656@thunk.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012952.28415.20120.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45062 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828Ab3JLBTc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Oct 2013 21:19:32 -0400
Content-Disposition: inline
In-Reply-To: <20131001012952.28415.20120.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 30, 2013 at 06:29:52PM -0700, Darrick J. Wong wrote:
> Since it's impossible to address all blocks of a 64bit filesystem without
> extents, have e2fsck turn on the feature if it finds (64bit && !extents).
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
