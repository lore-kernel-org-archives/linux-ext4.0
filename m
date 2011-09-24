From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] tune2fs: kill external journal if device not found
Date: Sat, 24 Sep 2011 14:49:38 -0400
Message-ID: <20110924184938.GE2779@thunk.org>
References: <1316821124-7461-1-git-send-email-adilger@whamcloud.com>
 <1316821124-7461-2-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48276 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab1IXStl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Sep 2011 14:49:41 -0400
Content-Disposition: inline
In-Reply-To: <1316821124-7461-2-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 23, 2011 at 05:38:42PM -0600, Andreas Dilger wrote:
> Continue to remove the external journal device even if the device
> cannot be found.
> 
> Add a test to verify that the journal device/UUID are actually removed
> from the superblock.  It isn't possible to use a real journal device
> for testing without loopback devices and such (it must be a block device)
> and this would invite complexity and failures in the regression test.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

Applied, although the test name was renamed to t_ext_jnl_rm, since
it's testing tune2fs and not e2undofs.

					- Ted
