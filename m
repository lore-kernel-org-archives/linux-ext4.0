From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add support for multiple mount protection
Date: Sun, 22 May 2011 22:19:51 -0400
Message-ID: <20110523021951.GI10009@thunk.org>
References: <20110502081119.GA12403@granier.hd.free.fr>
 <1304328996-14582-1-git-send-email-johann@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@whamcloud.com>
To: Johann Lombardi <johann@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50626 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665Ab1EWCTz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 May 2011 22:19:55 -0400
Content-Disposition: inline
In-Reply-To: <1304328996-14582-1-git-send-email-johann@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 02, 2011 at 11:36:36AM +0200, Johann Lombardi wrote:
> Prevent an ext4 filesystem from being mounted multiple times.
> A sequence number is stored on disk and is periodically updated (every 5
> seconds by default) by a mounted filesystem.
> At mount time, we now wait for s_mmp_update_interval seconds to make sure
> that the MMP sequence does not change.
> In case of failure, the nodename, bdevname and the time at which the MMP
> block was last updated is displayed.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
> Signed-off-by: Johann Lombardi <johann@whamcloud.com>

Added to the ext4 tree, thanks.

					- Ted
