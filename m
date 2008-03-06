From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] JBD ordered mode rewrite
Date: Thu, 6 Mar 2008 15:53:01 -0800
Message-ID: <20080306155301.52034da0.akpm@linux-foundation.org>
References: <20080306174209.GA14193@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756459AbYCFXxG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Mar 2008 18:53:06 -0500
In-Reply-To: <20080306174209.GA14193@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 6 Mar 2008 18:42:09 +0100
Jan Kara <jack@suse.cz> wrote:

>   Below is my rewrite of ordered mode in JBD. Now we don't have a list of
> data buffers that need syncing on transaction commit but a list of inodes
> that need writeout during commit. This brings all sorts of advantages such
> as possibility to get rid of journal heads and buffer heads for data
> buffers in ordered mode, better ordering of writes on transaction commit,
> simplification of some JBD code, no more anonymous pages when truncate of
> data being committed happens. The patch has survived some light testing
> but it still has some potential of eating your data so beware :) I've run
> dbench to see whether we didn't decrease performance by different handling
> of truncate and the throughput I'm getting on my machine is the same (OK,
> is lower by 0.5%) if I disable the code in truncate waiting for commit to
> finish... Also the throughput of dbench is about 2% better with my patch
> than with current JBD.
>   Any comments or testing most welcome.

Thanks for plugging away with this.

Please change your patch preparation tools to always always include a
diffstat, OK?

 fs/buffer.c               |    3 
 fs/ext3/ialloc.c          |    1 
 fs/ext3/inode.c           |  118 +++++++++---------
 fs/ext3/super.c           |    2 
 fs/jbd/checkpoint.c       |    1 
 fs/jbd/commit.c           |  257 +++++++++++++----------------------------
 fs/jbd/journal.c          |   45 +++++++
 fs/jbd/transaction.c      |  288 +++++++++++-----------------------------------
 fs/mpage.c                |    5 
 include/linux/ext3_fs.h   |    1 
 include/linux/ext3_fs_i.h |    1 
 include/linux/jbd.h       |   70 +++++++----
 include/linux/writeback.h |    2 
 13 files changed, 326 insertions(+), 468 deletions(-)

Would it make sense to turn this patch into a patch series sometime?
