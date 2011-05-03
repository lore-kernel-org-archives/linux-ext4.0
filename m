From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Fix deadlock in ext4_symlink() in ENOSPC
 conditions
Date: Tue, 3 May 2011 11:18:19 -0400
Message-ID: <20110503151819.GD6462@thunk.org>
References: <1304112285-23477-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36862 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725Ab1ECPSV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 May 2011 11:18:21 -0400
Content-Disposition: inline
In-Reply-To: <1304112285-23477-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 29, 2011 at 11:24:45PM +0200, Jan Kara wrote:
> ext4_symlink() cannot call __page_symlink() with transaction open.
> __page_symlink() calls ext4_write_begin() which can wait for
> transaction commit if we are running out of space thus causing a
> deadlock. Also error recovery in ext4_truncate_failed_write() does
> not count with the transaction being already started (although I'm
> not aware of any particular deadlock here).
> 
> Fix the problem by stopping a transaction before calling __page_symlink()
> (we have to be careful and put inode to orphan list so that it gets deleted
> in case of crash) and starting another one after __page_symlink() returns
> for addition of symlink into a directory.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, added to the ext4 tree.

					- Ted
