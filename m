From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext2fs: fix undeclared posix_memalign() warning
Date: Sat, 11 Jun 2011 11:05:14 -0400
Message-ID: <20110611150514.GC11207@thunk.org>
References: <1307683036-4564-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53863 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758551Ab1FKPFR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Jun 2011 11:05:17 -0400
Content-Disposition: inline
In-Reply-To: <1307683036-4564-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 09, 2011 at 11:17:16PM -0600, Andreas Dilger wrote:
> Older distros do not define posix_memalign() by default in the
> headers.  If ext2fs.h is included early in the headers, it is
> possible to "#define _XOPEN_SOURCE 600" so that the stdlib.h
> header will define it, but if ext2fs.h is included after stdlib.h
> there is no posix_memalign() declaration.
> 
> Add a posix_memalign() declaration if stdlib.h didn't do it.  This
> is a bit of a hack for GNU headers, but it works on Linux and OS/X
> without problems.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

Applied into the next branch, thanks.

						- Ted
