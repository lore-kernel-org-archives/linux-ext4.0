From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] mke2fs: skip zeroing journal blocks
Date: Sat, 11 Jun 2011 12:21:40 -0400
Message-ID: <20110611162139.GL11207@thunk.org>
References: <1307700019-4551-1-git-send-email-adilger@whamcloud.com>
 <1307700019-4551-2-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55648 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955Ab1FKQVm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Jun 2011 12:21:42 -0400
Content-Disposition: inline
In-Reply-To: <1307700019-4551-2-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 10, 2011 at 04:00:18AM -0600, Andreas Dilger wrote:
> Add the ability to skip zeroing journal blocks on disk.  This can
> significantly speed up mke2fs with large journals.  At worst the
> uninitialized journal is only a very short-term risk (if at all),
> because the journal will be overwritten on any new filesystem as
> soon as any significant amount of data is written to disk, and
> the new journal TID would need to match the offset/TID of an old
> commit block still left on disk.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

Added to the next branch, thanks.

						- Ted
