From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: allow checking on mounted root fs (v2)
Date: Thu, 31 May 2012 17:35:51 -0400
Message-ID: <20120531213551.GA7897@thunk.org>
References: <1338403182-2253-1-git-send-email-adilger@whamcloud.com>
 <1338418504-3408-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46838 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733Ab2EaVf7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 May 2012 17:35:59 -0400
Content-Disposition: inline
In-Reply-To: <1338418504-3408-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 30, 2012 at 04:55:04PM -0600, Andreas Dilger wrote:
> Commit 732e26b98e5c79a4298dbe341f43b54b354bb241 added checks to
> prevent e2fsck from being run in filesystem-modifying mode against
> a mounted or otherwise busy device, due to several bug reports of
> users doing this even with the verbose warnings in check_mount().
> 
> However, it also prevented e2fsck from checking a mounted root
> filesystem, which will prevent the node from booting.  Once again
> allow e2fsck to run against the mounted root filesystem if it is
> also mounted read-only at the time.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

Thanks, applied.

						- Ted
