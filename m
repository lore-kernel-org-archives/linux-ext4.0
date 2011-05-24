From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add support for multiple mount protection
Date: Tue, 24 May 2011 17:47:14 -0400
Message-ID: <20110524214714.GG26055@thunk.org>
References: <1305333485-17140-1-git-send-email-johann@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@whamcloud.com>
To: Johann Lombardi <johann@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58590 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757582Ab1EXVrQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 May 2011 17:47:16 -0400
Content-Disposition: inline
In-Reply-To: <1305333485-17140-1-git-send-email-johann@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 13, 2011 at 05:38:05PM -0700, Johann Lombardi wrote:
> Prevent an ext4 filesystem from being mounted multiple times.
> A sequence number is stored on disk and is periodically updated (every 5
> seconds by default) by a mounted filesystem.
> At mount time, we now wait for s_mmp_update_interval seconds to make sure
> that the MMP sequence does not change.
> In case of failure, the nodename, bdevname and the time at which the MMP
> block was last updated is displayed.
> Move all mmp code to a dedicated file (mmp.c).
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
> Signed-off-by: Johann Lombardi <johann@whamcloud.com>

Oops, I see I pulled the wrong (older) version of this patch into my
dev tree.  I've corrected this and pulled in this version.  Thanks!!

    	   		       	   	       - Ted
