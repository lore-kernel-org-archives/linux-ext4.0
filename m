From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] e2fsck: regression tests for INCOMPAT_MMP feature
Date: Sat, 24 Sep 2011 14:51:55 -0400
Message-ID: <20110924185155.GG2779@thunk.org>
References: <1316821124-7461-1-git-send-email-adilger@whamcloud.com>
 <1316821124-7461-4-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48283 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078Ab1IXSwB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Sep 2011 14:52:01 -0400
Content-Disposition: inline
In-Reply-To: <1316821124-7461-4-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 23, 2011 at 05:38:44PM -0600, Andreas Dilger wrote:
> Add tests for the MMP feature - creating a filesystem with mke2fs
> and MMP enabled, enable/disable MMP with tune2fs, disabling the
> e2fsck MMP flag with tune2fs after a failed e2fsck, and e2fsck
> checking and fixing a corrupt MMP block.
> 
> The MMP tests need to be run from a real disk, not tmpfs, because
> tmpfs doesn't support O_DIRECT reads, which MMP uses to ensure
> that reads from the MMP block are not filled from the page cache.
> Using a local disk does not slow down the tests noticably, since
> they wait to detect if the MMP block is being modified.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

Applied, although I needed to refrob the test names.  The first
character denotes not the test is for:

*) f_* tests are for e2fsck
*) m_* tests are for tune2fs
*) u_* tests are for e2undofs

This allows someone to test mke2fs by running the command:

	(cd tests; ./test_script m)

						- Ted
