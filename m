From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/35] e2fuzz: fuzz harder
Date: Mon, 20 Apr 2015 21:47:53 -0400
Message-ID: <20150421014753.GB3238@thunk.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023406.25243.9589.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49117 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbbDUBry (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2015 21:47:54 -0400
Content-Disposition: inline
In-Reply-To: <20150402023406.25243.9589.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 01, 2015 at 07:34:06PM -0700, Darrick J. Wong wrote:
> Once we've "fixed" the filesystem, try mounting and modifying it to see
> if we can break the kernel.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
