From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 14/21] e2fsck: clear extents and inline_data flags from
 fifo/socket/device inodes
Date: Sun, 10 Aug 2014 18:41:32 -0400
Message-ID: <20140810224132.GZ15431@thunk.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
 <20140805010629.2611.91726.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53510 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbaHJWle (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Aug 2014 18:41:34 -0400
Content-Disposition: inline
In-Reply-To: <20140805010629.2611.91726.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 04, 2014 at 06:06:29PM -0700, Darrick J. Wong wrote:
> Since fifo, socket, and device inodes cannot have inline data or
> extents, strip off these flags if we find them.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
