From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 03/21] libext2fs: check EA value offset
Date: Sun, 10 Aug 2014 18:21:31 -0400
Message-ID: <20140810222131.GO15431@thunk.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
 <20140805010517.2611.2402.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53439 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbaHJWVd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Aug 2014 18:21:33 -0400
Content-Disposition: inline
In-Reply-To: <20140805010517.2611.2402.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 04, 2014 at 06:05:17PM -0700, Darrick J. Wong wrote:
> Perform a little more sanity checking of EA value offsets so that we
> don't crash while trying to load things from the filesystem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thank.

					- Ted
