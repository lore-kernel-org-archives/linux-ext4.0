From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext2fs: don't use O_DIRECT if not available
Date: Sat, 11 Jun 2011 11:50:52 -0400
Message-ID: <20110611155052.GI11207@thunk.org>
References: <1307690130-12227-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45733 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758690Ab1FKPuy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Jun 2011 11:50:54 -0400
Content-Disposition: inline
In-Reply-To: <1307690130-12227-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 10, 2011 at 01:15:30AM -0600, Andreas Dilger wrote:
> O_DIRECT is not defined on OSX.  Since direct IO is only a new
> optimization and not needed for correct functionality, disable
> it if O_DIRECT is unavailable.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

Applied to the next branch, thanks.

					- Ted
