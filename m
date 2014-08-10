From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 19/21] e2fsck: be more careful in assuming inline_data
 inodes are directories
Date: Sun, 10 Aug 2014 18:49:56 -0400
Message-ID: <20140810224956.GE15431@thunk.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
 <20140805010702.2611.4375.stgit@birch.djwong.org>
 <20140808162258.GA11191@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53545 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbaHJWt7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Aug 2014 18:49:59 -0400
Content-Disposition: inline
In-Reply-To: <20140808162258.GA11191@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 08, 2014 at 09:22:58AM -0700, Darrick J. Wong wrote:
> If a file is marked inline_data but its i_size isn't a multiple of
> four, it probably isn't an inline directory, because directory entries
> have sizes that are multiples of four.
> 
> v2: Don't add unnecessary variables.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
