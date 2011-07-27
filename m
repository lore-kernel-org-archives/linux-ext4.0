From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix data corruption in inodes with journalled
 data
Date: Tue, 26 Jul 2011 21:27:38 -0400
Message-ID: <20110727012738.GC19851@thunk.org>
References: <1311381577-31406-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47372 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab1G0B1m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jul 2011 21:27:42 -0400
Content-Disposition: inline
In-Reply-To: <1311381577-31406-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 23, 2011 at 02:39:37AM +0200, Jan Kara wrote:
> When journalling data for an inode (either because it is a symlink or
> because the filesystem is mounted in data=journal mode), ext4_evict_inode()
> can discard unwritten data by calling truncate_inode_pages(). This is
> because we don't mark the buffer / page dirty when journalling data but only
> add the buffer to the running transaction and thus mm does not know there
> are still unwritten data.
> 
> Fix the problem by carefully tracking transaction containing inode's data,
> committing this transaction, and writing uncheckpointed buffers when inode
> should be reaped.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied to the ext4 tree.

					- Ted
