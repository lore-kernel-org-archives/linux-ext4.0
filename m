From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: make problem comments match error messages
Date: Fri, 17 Feb 2017 12:58:11 -0500
Message-ID: <20170217175811.wp4qmdgei67diitr@thunk.org>
References: <1486797876-4390-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38394 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934365AbdBQSgb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 17 Feb 2017 13:36:31 -0500
Content-Disposition: inline
In-Reply-To: <1486797876-4390-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 11, 2017 at 12:24:36AM -0700, Andreas Dilger wrote:
> Since the @x compression obscures e2fsck problem error messages
> from being found by normal searching, make the comment for each
> error match the actual error message so that they can be found
> more easily.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Applied, thanks.

						- Ted
