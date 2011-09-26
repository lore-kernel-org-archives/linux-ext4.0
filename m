From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] tune2fs: kill external journal if device not found
Date: Mon, 26 Sep 2011 13:59:10 -0400
Message-ID: <20110926175910.GA3282@thunk.org>
References: <1316821124-7461-1-git-send-email-adilger@whamcloud.com>
 <1316821124-7461-2-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50830 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246Ab1IZR7N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Sep 2011 13:59:13 -0400
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

I've taken care of it this time, but please don't include whitespace
changes in patches.  It makes it a lot harder to review them in
e-mail.   Thanks!!

						- Ted
