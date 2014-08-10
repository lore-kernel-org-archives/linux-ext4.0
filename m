From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 08/21] libext2fs: fix memory leak when failing to iterate
 inline_data directory
Date: Sun, 10 Aug 2014 18:32:32 -0400
Message-ID: <20140810223232.GT15431@thunk.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
 <20140805010549.2611.73733.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53474 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbaHJWce (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Aug 2014 18:32:34 -0400
Content-Disposition: inline
In-Reply-To: <20140805010549.2611.73733.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 04, 2014 at 06:05:49PM -0700, Darrick J. Wong wrote:
> The xattr_get method returns to us a pointer to a buffer containing
> the EA value.  If for some reason we decide to fail out of iterating
> the EA part of an inline-data directory, we must free the buffer that
> xattr_get passed to us (via inline_data_ea_get).
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
