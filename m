From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/34] e2fsck: offer to clear overlapping extents
Date: Thu, 18 Sep 2014 21:45:27 -0400
Message-ID: <20140919014527.GD26995@thunk.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
 <20140913221119.13646.11019.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36684 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbaISBpc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Sep 2014 21:45:32 -0400
Content-Disposition: inline
In-Reply-To: <20140913221119.13646.11019.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 13, 2014 at 03:11:19PM -0700, Darrick J. Wong wrote:
> If in the course of iterating extents we find that an otherwise
> valid-seeming second extent maps the same logical blocks as a
> previously examined first extent, offer to clear the duplicate
> mapping.
> 
> The test for this is already in f_extents.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
