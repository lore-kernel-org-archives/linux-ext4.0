From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] misc: fix compile warnings on master branch
Date: Tue, 27 May 2014 13:14:51 -0400
Message-ID: <20140527171450.GG1158@thunk.org>
References: <1400627062-74327-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35258 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbaE0ROx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 May 2014 13:14:53 -0400
Content-Disposition: inline
In-Reply-To: <1400627062-74327-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 20, 2014 at 05:04:22PM -0600, Andreas Dilger wrote:
> Fix compile warnings found on the master branch when using LLVM.
> 
> - Add missing format string when using the libintl _() macro
> - include <limits.h> header to get PATH_MAX definition
> - fix format vs. variable mismatches
> - add header block for create_inode.c file
> - remove use of bzero(), use ext2fs_get_memzero() instead
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

					- Ted
