From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 03/34] misc: zero s_jnl_blocks when adding journal online
 or removing external journal
Date: Thu, 18 Sep 2014 21:45:47 -0400
Message-ID: <20140919014547.GF26995@thunk.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
 <20140913221132.13646.78435.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, thomas_reardon@hotmail.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36697 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbaISBpu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Sep 2014 21:45:50 -0400
Content-Disposition: inline
In-Reply-To: <20140913221132.13646.78435.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 13, 2014 at 03:11:32PM -0700, Darrick J. Wong wrote:
> Erase s_jnl_blocks when removing an external journal, or adding an
> internal journal online.  We can't add the backup for the internal
> journal because we have no good way to get the indirect block or ETB
> addresses, so the best we can do is hope that the user runs e2fsck,
> which will correct that.  We are motivated to erase during external
> journal removal to state emphatically that there's no journal.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reported-by: thomas_reardon@hotmail.com

Applied, thanks.

					- Ted
