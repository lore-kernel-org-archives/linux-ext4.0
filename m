From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: misc: quiet llvm build warnings
Date: Wed, 30 Aug 2017 01:57:26 -0400
Message-ID: <20170830055726.luyavt77vmxuimfm@thunk.org>
References: <1503724481-84704-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39698 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750758AbdH3F53 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 30 Aug 2017 01:57:29 -0400
Content-Disposition: inline
In-Reply-To: <1503724481-84704-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 25, 2017 at 11:14:41PM -0600, Andreas Dilger wrote:
> Quiet some relatively harmless build warnings:
> 
> mkquota.c:527:15: warning: format specifies type 'long' but the
> 	argument has type 'qsize_t' (aka 'long long') [-Wformat]
> 		dq->dq_id, dq->dq_dqb.dqb_curspace,
> 			   ^~~~~~~~~~~~~~~~~~~~~~~
> 
> tune2fs.c:928:18: warning: '&&' within '||' [-Wlogical-op-parentheses]
> 	if (pass == 1 && (inode->i_flags & EXT4_EA_INODE_FL) ||
> 	    ~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ~~
> tune2fs.c:928:18: place parentheses around '&&' to silence warning
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

The mkquota.c is already fixed on the maint branch, but I've applied
the tune2fs fix to the master/next branch.

Thanks,

					- Ted
