From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3 V4] contrib/populate-extfs.sh: use debugfs to
 populate extX fs
Date: Sun, 13 Oct 2013 22:50:12 -0400
Message-ID: <20131014025012.GE9609@thunk.org>
References: <1377498124-25842-1-git-send-email-liezhi.yang@windriver.com>
 <1377498124-25842-4-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, dvhart@linux.intel.com,
	darrick.wong@oracle.com
To: Robert Yang <liezhi.yang@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45676 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655Ab3JNCuO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Oct 2013 22:50:14 -0400
Content-Disposition: inline
In-Reply-To: <1377498124-25842-4-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 26, 2013 at 02:22:04PM +0800, Robert Yang wrote:
> This script uses debugfs command to populate the ext2/3/4 filesystem
> from a given directory, it is a little similar to genext2fs, but this
> one fully supports ext3 and ext4.
> 
> Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
> Acked-by: Darren Hart <dvhart@linux.intel.com>

Applied, thanks.

					- Ted
