From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] only restart e2fsck once for inodes in uninit range
Date: Thu, 28 May 2009 07:57:42 -0400
Message-ID: <20090528115742.GK26625@mit.edu>
References: <20090528063949.GE3218@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57103 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000AbZE1L54 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 May 2009 07:57:56 -0400
Content-Disposition: inline
In-Reply-To: <20090528063949.GE3218@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 28, 2009 at 12:39:49AM -0600, Andreas Dilger wrote:
> Restart e2fsck only once in case of multiple inodes in uninit range.
> Display correct inode number during BG_INO_UNINIT and INOREF_IN_USED errors.
> 
> Signed-off-by: Kalpak Shah <kalpak.shah@sun.com>
> Signed-off-by: Andreas Dilger <adilger@sun.com>

Applied, thanks.

					- Ted
