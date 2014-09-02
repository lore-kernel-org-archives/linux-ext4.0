From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: enable block_validity by default
Date: Mon, 1 Sep 2014 22:02:24 -0400
Message-ID: <20140902020224.GP8974@thunk.org>
References: <20140809042610.2441.6868.stgit@birch.djwong.org>
 <20140809042630.2441.34661.stgit@birch.djwong.org>
 <20140824224721.GG6236@thunk.org>
 <20140825155218.GA22645@birch.djwong.org>
 <20140825163632.GC22645@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59976 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbaIBCC0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Sep 2014 22:02:26 -0400
Content-Disposition: inline
In-Reply-To: <20140825163632.GC22645@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 25, 2014 at 09:36:32AM -0700, Darrick J. Wong wrote:
> Enable by default the block_validity feature, which checks for
> collisions between newly allocated blocks and critical system
> metadata.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
