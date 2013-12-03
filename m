From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: tests: check backing filesystem can handle large file
Date: Tue, 3 Dec 2013 00:12:54 -0500
Message-ID: <20131203051254.GA11792@thunk.org>
References: <1383806104-26239-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35886 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab3LCFM4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Dec 2013 00:12:56 -0500
Content-Disposition: inline
In-Reply-To: <1383806104-26239-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 06, 2013 at 11:35:04PM -0700, Andreas Dilger wrote:
> The new resize tests create 2TB test files, but tmpfs in kernels
> before 3.1 have a max file size of 256GB.  Ext3 may also have
> a size limit for smaller blocksize filesystems.
> 
> Fix the resize_test script to verify that $TMPFILE can be resized
> to the final test size, and if that fails try creating the file on
> the local filesystem instead of in $TMPDIR.  If that cannot hold
> the large filesystem, skip the test.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>
> Tested-by: Zheng Liu <wenqing.lz@taobao.com>

Thanks, applied.

					- Ted
