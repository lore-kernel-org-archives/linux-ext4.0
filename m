From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [3/4] libext2fs: Provide prototype for ext2fs_symlink()
Date: Thu, 28 Feb 2013 20:13:27 -0500
Message-ID: <20130301011327.GD18134@thunk.org>
References: <1361807708-15871-4-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50670 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab3CABNo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Feb 2013 20:13:44 -0500
Content-Disposition: inline
In-Reply-To: <1361807708-15871-4-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 25, 2013 at 05:55:07AM -0000, Jan Kara wrote:
> New function ext2fs_symlink() doesn't have a prototype in ext2fs.h and
> thus debugfs compilation gives warning:
> 
> debugfs.c:2219:2: warning: implicit declaration of function 'ext2fs_symlink'
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
