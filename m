From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: guarantee already started handles to successfully
 finish while ro remounting
Date: Thu, 5 May 2016 15:45:11 +0200
Message-ID: <20160505134511.GH1970@quack2.suse.cz>
References: <1462150237-20701-1-git-send-email-daeho.jeong@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	Kitae Lee <kitae87.lee@samsung.com>
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51395 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471AbcEENpP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 May 2016 09:45:15 -0400
Content-Disposition: inline
In-Reply-To: <1462150237-20701-1-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 02-05-16 09:50:37, Daeho Jeong wrote:
> We check whether a new handle can be started through
> ext4_journal_check_start() and the function refuses to start the handle
> when the filesystem is mounted with read-only. But now, when we remount
> the filesystem with read-only option, already started handles are
> allowed to be written on disk, but the subsequent metadata modification
> using the handles are refused by ext4_journal_check_start().
> 
> As an example, in ext4_evict_inode(), i_size can be set to 0 using
> a successfully started handle, but, when we remount the filesystem
> with read-only option at that time, the subsequent ext4_truncate()
> will be failed and the filesystem integrity will be damaged.
> 
> Therefore, we need to permit the metadata modification using already
> started handles to be proceeded, even if s_flags of the filesystem is
> set to MS_RDONLY.
> 
> Kitae found the problem and suggested the solution.

So can you share a reproducer for this issue? Because my initial thinking
is that checks during remount should fail the remount with EBUSY if there
is any modification outstanding... If they don't we have a racy remount and
fs-freezing code, which is a bug.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
