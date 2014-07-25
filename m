From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 21/24] e2fsck: clear uninit flag on directory extents
Date: Fri, 25 Jul 2014 09:00:02 -0400
Message-ID: <20140725130002.GM1865@thunk.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225521.31374.49277.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56358 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbaGYNAE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2014 09:00:04 -0400
Content-Disposition: inline
In-Reply-To: <20140718225521.31374.49277.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2014 at 03:55:21PM -0700, Darrick J. Wong wrote:
> Directories can't have uninitialized extents, so offer to clear the
> uninit flag when we find this situation.  The actual directory blocks
> will be checked in pass 2 and 3 regardless of the uninit flag.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

							- Ted
