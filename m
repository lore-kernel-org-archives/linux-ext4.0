From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: don't set root dir UID/GID automatically
Date: Sat, 15 Jun 2013 21:49:12 -0400
Message-ID: <20130616014912.GC19200@thunk.org>
References: <1371007922-20423-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58299 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786Ab3FPBtP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Jun 2013 21:49:15 -0400
Content-Disposition: inline
In-Reply-To: <1371007922-20423-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 11, 2013 at 09:32:02PM -0600, Andreas Dilger wrote:
> Don't change the root directory's UID/GID automatically just because
> mke2fs was run as a non-root user.  This can be confusing for users,
> and is not flexible for non-root installation tools that need to
> create a filesystem with different ownership from the current user.
> 
> Add the "-E root_owner[=uid:gid]" option to mke2fs so that the user
> and group can be explicitly specified for the root directory.  If
> the "=uid:gid" argument is not specified, the current UID and GID
> are extracted from the running process, as was done in the past.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

					- Ted
