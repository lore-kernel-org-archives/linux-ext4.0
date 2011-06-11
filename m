From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] misc: fix compile warnings on OSX
Date: Sat, 11 Jun 2011 11:50:35 -0400
Message-ID: <20110611155035.GH11207@thunk.org>
References: <1307689164-11902-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45730 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758690Ab1FKPui (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Jun 2011 11:50:38 -0400
Content-Disposition: inline
In-Reply-To: <1307689164-11902-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 10, 2011 at 12:59:24AM -0600, Andreas Dilger wrote:
> The BLKFLSBUF and FDFLUSH ioctls are Linux specific, and do not
> really have anything to do with __GNUC__ (which is also used on
> OS/X and Solaris).  Only print these warnings on Linux systems.
> 
> statfs64() is deprecated on OSX and generates a deliberate warning.
> Fix some other warnings that show up on OSX builds.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

Applied to the next tree, thanks.

					- Ted
