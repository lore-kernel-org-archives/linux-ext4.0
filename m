From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] debugfs: fix icheck finding blocks used for xattrs
Date: Sat, 11 Jun 2011 11:31:01 -0400
Message-ID: <20110611153101.GE11207@thunk.org>
References: <1307685770-6099-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52305 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758582Ab1FKPbH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Jun 2011 11:31:07 -0400
Content-Disposition: inline
In-Reply-To: <1307685770-6099-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 10, 2011 at 12:02:50AM -0600, Andreas Dilger wrote:
> This was an "uninitialized variable" warning, but it turns out to be
> a real bug.  Without this change, it is not possible to use "icheck"
> to find blocks that are used for the i_file_acl (xattr) block.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

Applied to the next branch, thanks.

						- Ted
