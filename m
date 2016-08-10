From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] debugfs: use labs() for absolute value of a long
Date: Wed, 10 Aug 2016 17:52:53 -0400
Message-ID: <20160810215253.GC10523@thunk.org>
References: <1470775451-69146-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42274 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932125AbcHJVwz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Aug 2016 17:52:55 -0400
Content-Disposition: inline
In-Reply-To: <1470775451-69146-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 09, 2016 at 02:44:11PM -0600, Andreas Dilger wrote:
> Use labs() instead of abs() for calculated value of a long int
> to quiet warning from LLVM.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

I'm not sure what version of e2fsprogs you're using for your base, but
this was fixed in commit 82e48fb1637: "Fix various clang and gcc -Wall
warnings" --- and this commit is in 1.43.  Are you using an old
pre-1.43 branch, possibly?

					- Ted
