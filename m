From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: tests: remove unused temporary files for MMP tests
Date: Tue, 14 Aug 2012 11:34:05 -0400
Message-ID: <20120814153405.GA24577@thunk.org>
References: <1344457296-27609-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44655 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524Ab2HNPeK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Aug 2012 11:34:10 -0400
Content-Disposition: inline
In-Reply-To: <1344457296-27609-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 08, 2012 at 10:21:36AM -0000, Andreas Dilger wrote:
> The MMP tests need to be run on a real disk instead of tmpfs, since
> the MMP block access is using O_DIRECT.  As such, they create their
> own test files in the local testing directory instead of using the
> temporary file created in /tmp by the test_one script.  Delete the
> tempfs file before clobbering TMPFILE, otherwise it will leave the
> unused file in /tmp after the test is completed.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

						- Ted
