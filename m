From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: release discard bio after sending discard commands
Date: Sat, 5 Aug 2017 13:13:55 -0400
Message-ID: <20170805171355.psfk5uvnen5gkcho@thunk.org>
References: <CGME20170803012120epcas2p1dddb2f7e1ee7b26172142ec40246a09f@epcas2p1.samsung.com>
 <1501723296-21336-1-git-send-email-daeho.jeong@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40736 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751340AbdHERN7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 5 Aug 2017 13:13:59 -0400
Content-Disposition: inline
In-Reply-To: <1501723296-21336-1-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 03, 2017 at 10:21:36AM +0900, Daeho Jeong wrote:
> We've changed the discard command handling into parallel manner.
> But, in this change, I forgot decreasing the usage count of the bio
> which was used to send discard request. I'm sorry about that.
> 
> Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Fixes: a015434480dc ("ext4: send parallel discards on commit
> completions")

Thanks, applied.

					- Ted
