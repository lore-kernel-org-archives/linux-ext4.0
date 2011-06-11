From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext2fs: fix ext2fs_warn_bitmap32() return warning
Date: Sat, 11 Jun 2011 11:33:26 -0400
Message-ID: <20110611153326.GF11207@thunk.org>
References: <1307686290-11008-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40943 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758582Ab1FKPd2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Jun 2011 11:33:28 -0400
Content-Disposition: inline
In-Reply-To: <1307686290-11008-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 10, 2011 at 12:11:30AM -0600, Andreas Dilger wrote:
> This was reported as "control reaches end of non-void function",
> but comparing to other similar functions it should be a void
> function.  Since it is only declared in the "private" ext2fsP.h
> header, it should be OK to change the function prototype.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

Applied to the next branch, thanks.

						- Ted
