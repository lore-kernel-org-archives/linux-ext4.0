From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] mke2fs: add test for large journal with lazy init
Date: Sat, 11 Jun 2011 12:21:53 -0400
Message-ID: <20110611162153.GM11207@thunk.org>
References: <1307700019-4551-1-git-send-email-adilger@whamcloud.com>
 <1307700019-4551-3-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55650 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884Ab1FKQVz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Jun 2011 12:21:55 -0400
Content-Disposition: inline
In-Reply-To: <1307700019-4551-3-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 10, 2011 at 04:00:19AM -0600, Andreas Dilger wrote:
> Add test for internal journal over 4GB in size, using the
> lazy_journal_init and lazy_itable_init features.  Otherwise
> the filesystem metadata would be too large to reliably run on
> test systems, and take too long to create/check the filesystem.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

Added to the "next" branch, thanks.

					- Ted
