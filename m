From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 11/24] e2fsck: free ctx->fs, not fs, at the end of fsck
Date: Thu, 24 Jul 2014 21:14:09 -0400
Message-ID: <20140725011409.GB1865@thunk.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225335.31374.76938.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55567 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbaGYBOM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jul 2014 21:14:12 -0400
Content-Disposition: inline
In-Reply-To: <20140718225335.31374.76938.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2014 at 03:53:35PM -0700, Darrick J. Wong wrote:
> When we call ext2fs_close_free at the end of main(), we need to supply
> the address of ctx->fs, because the subsequent e2fsck_free_context
> call will try to access ctx->fs (which is now set to a freed block) to
> see if it should free the directory block list.  This is clearly not
> desirable, so fix the problem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
