From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: Document stripe_width, not stripe-width
Date: Sun, 17 Jul 2011 23:14:06 -0400
Message-ID: <20110718031406.GA14869@thunk.org>
References: <1309366060-25985-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35013 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab1GRDOJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Jul 2011 23:14:09 -0400
Content-Disposition: inline
In-Reply-To: <1309366060-25985-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 29, 2011 at 10:47:40AM -0600, Andreas Dilger wrote:
> For consistency with other multi-word options, document the extended
> option stripe_width instead of stripe-width.  This also avoids the
> complexity of parsing options that have an embedded '-'.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

Added to the e2fsprogs tree, thanks.

							- Ted
