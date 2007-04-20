From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs - e2fsck pass1c does extra work if root dir has shared blocks
Date: Fri, 20 Apr 2007 08:14:57 -0400
Message-ID: <20070420121457.GA18529@thunk.org>
References: <Pine.LNX.4.61.0704101344050.29750@webb> <Pine.LNX.4.61.0704101538020.31519@webb>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jim Garlick <garlick@llnl.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:57421 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766666AbXDTMPF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Apr 2007 08:15:05 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0704101538020.31519@webb>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Apr 10, 2007 at 03:39:56PM -0700, Jim Garlick wrote:
> 
> Another small bug I think: if the root directory contains shared 
> blocks, e2fsck pass1c search_dirent_proc() will be looking for 
> one more containing directory than it will ever find, and thus 
> loses an opportunity to terminate early.
> 
> Signed-off-by: Jim Garlick <garlick@llnl.gov>

Thanks, applied.

					- Ted
