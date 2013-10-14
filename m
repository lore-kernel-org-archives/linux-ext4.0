From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3 V4] debugfs.c: the max length of debugfs argument is
 too short
Date: Sun, 13 Oct 2013 22:49:32 -0400
Message-ID: <20131014024932.GC9609@thunk.org>
References: <1377498124-25842-1-git-send-email-liezhi.yang@windriver.com>
 <1377498124-25842-2-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, dvhart@linux.intel.com,
	darrick.wong@oracle.com
To: Robert Yang <liezhi.yang@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45664 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587Ab3JNCtf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Oct 2013 22:49:35 -0400
Content-Disposition: inline
In-Reply-To: <1377498124-25842-2-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 26, 2013 at 02:22:02PM +0800, Robert Yang wrote:
> The max length of debugfs argument is 256 which is too short, the
> arguments are two paths, the PATH_MAX is 4096 according to
> /usr/include/linux/limits.h, so use BUFSIZ (which is 8192 on Linux
> systems), that's also what the ss library uses.
> 
> Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
> Acked-by: Darren Hart <dvhart@linux.intel.com>

Applied, thanks.

					- Ted
