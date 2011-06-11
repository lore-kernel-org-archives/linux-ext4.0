From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext2fs: fix error handling in ext2fs_add_dir_block
Date: Sat, 11 Jun 2011 11:55:11 -0400
Message-ID: <20110611155511.GJ11207@thunk.org>
References: <1307691187-12854-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57253 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757955Ab1FKPzO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Jun 2011 11:55:14 -0400
Content-Disposition: inline
In-Reply-To: <1307691187-12854-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 10, 2011 at 01:33:07AM -0600, Andreas Dilger wrote:
> In ext2fs_add_dir_block() the dblist allocation size was changed to
> grow as the number of items in the dblist increases.  However, the
> error handling in case of allocation failure wasn't changed to match.
> 
> Fix the error case to revert to the old allocation size on failure.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

Added to the maint branch, thanks!

						- Ted
